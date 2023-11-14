//
//  CustomerListVC.swift
//  Dairy Register
//
//  Created by Shubham Dhingra on 27/08/23.
//

import UIKit
import DropDown

class CustomerListVC: UIViewController {

    @IBOutlet weak var txtSelectCustomer : UITextField!
    @IBOutlet weak var btnSelectCustomer : UIButton!
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var lblHeading : UILabel!
    
    var customersRecordList = [[String : Any]]()
    var customerNamesList = [String]()
    var isFirstTime : Bool = true
    
    //MARK: tableDataSource
    var tableViewDataSource : CustomTableViewDataSource?{
        didSet{
            tableView?.dataSource = tableViewDataSource
            tableView?.delegate = tableViewDataSource
            
            tableView?.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        customersRecordList.sort(by: T##([String : Any], [String : Any]) throws -> Bool)
        customerNamesList = customersRecordList.map{customerRecord in
            if let customerName = customerRecord["CustomerName"] as? String {
                return customerName
            }
            return ""
        }
        
        customersRecordList.sort { (dict1, dict2) -> Bool in
            if let value1 = dict1["SNo."] as? String, let value2 = dict2["SNo."] as? String {
                return Int(value1) ?? 0 < Int(value2) ?? 0
            }
            return false
        }
        
        if (customersRecordList.count > 0) {
            lblHeading?.text =  "Customer Record (\(customersRecordList.count)) Month : \(Utility.shared.getCurrentMonth())"
            self.reloadTable()
        }
    }
    
    @IBAction func btnBackAct(_ sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnOpenDropDownAct(_ sender : UIButton) {
        openDropDown()
    }
    
    @IBAction func btnClearFilterAct(_ sender : UIButton) {
        txtSelectCustomer?.text = nil
    }
}

extension CustomerListVC {
    
    func openDropDown() {
        let dropDown = DropDown()
        dropDown.anchorView = view  // UIView or UIBarButtonItem
        dropDown.dataSource = customerNamesList
        dropDown.direction = .bottom
//        dropDown.width = 200
        dropDown.bottomOffset = CGPoint(x: 10, y:150)

        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            txtSelectCustomer.text = item
            dropDown.hide()
        }
        dropDown.show()
    }
}


extension CustomerListVC {
    
    func registerCellsXibs() {
            tableView?.register(UINib(nibName: kCustomerCell, bundle: nil), forCellReuseIdentifier: kCustomerCell)
    }
    
    func configureTableView() {
        
        tableViewDataSource =  CustomTableViewDataSource(items : self.customersRecordList , height: UITableView.automaticDimension, tableView: self.tableView , cellIdentifier: kCustomerCell)
        
        tableViewDataSource?.configureCellBlock = {(cell, item, indexpath) in
            
            if let cell = cell as? CustomerCell {
                cell.configureUI()
                cell.customerData = item
//                cell.editProfileListender = {
//                    if let item = item as? Kid {
//                        self.navigateToEditProfile(item : item)
//                    }
//
//                }
//                cell.viewProfileListener = {
//                    if let item = item as? Kid {
//                        self.openKidProfileController(kidObj: item)
//                        //                        self.openProfile(kidObj: item)
//                    }
//                }
            }
        }
        tableViewDataSource?.aRowSelectedListener = {(indexPath , cell) in
            self.didSelect(/indexPath.row)
        }
    }
    
    func didSelect(_ index : Int) {
        let customerRecord = self.customersRecordList[index]
            let customerMonthlyBill = BillCreation.shared.getBill(customerRecord)
            showBill(customerMonthlyBill)
    }
    
    func showBill(_ customerMonthlyBill : UIImage?) {
        if let image = customerMonthlyBill {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            guard let viewController = storyBoard.instantiateViewController(withIdentifier: "BillViewerVC") as? BillViewerVC else {
                return
            }
            print("Image :",image);
            viewController.imageParam = image
            self.navigationController?.present(viewController, animated: true)
        }
    }
    
    func reloadTable() {
        registerCellsXibs()
        if isFirstTime {
            isFirstTime = !isFirstTime
            configureTableView()
        }
        else {
            tableViewDataSource?.items = self.customersRecordList
            tableView?.reloadData()
        }
    }
}
