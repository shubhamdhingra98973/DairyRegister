//
//  CustomerBillFormVC.swift
//  Dairy Register
//
//  Created by Shubham Dhingra on 30/08/23.
//

import UIKit
import DropDown

class CustomerBillFormVC: UIViewController {
    
    @IBOutlet weak var txtSelectCustomer : UITextField!
    @IBOutlet weak var txtEnterCustomer : UITextField!
    @IBOutlet weak var btnSelectCustomer : UIButton!
    @IBOutlet weak var txtSerialNo : UITextField!
    @IBOutlet weak var txtBuffaloMilk : UITextField!
    @IBOutlet weak var txtCowMilk : UITextField!
    @IBOutlet weak var txtBalance : UITextField!
    @IBOutlet weak var txtAdvance : UITextField!
    @IBOutlet weak var generateBill : UIButton!
    @IBOutlet weak var btnBuffaloRate66 : UIButton!
    @IBOutlet weak var btnBuffaloRate62 : UIButton!
    @IBOutlet weak var btnCowRate66 : UIButton!
    @IBOutlet weak var btnCowRate62: UIButton!
    @IBOutlet weak var tableView : UITableView!
    
    var customerNamesList = [String]()
    var selectBuffaloRate = String()
    var selectCowRate = String()
    var selectedMonth : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDropDown()
        rateSelectForBuffaloMilk(tag: 0)
        rateSelectForCowMilk(tag: 1)
        addToolBar()
        NotificationCenter.default.addObserver(self, selector: #selector(CustomerBillFormVC.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CustomerBillFormVC.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    func configureDropDown() {
        DropDown.appearance().textColor = UIColor.black
        DropDown.appearance().selectedTextColor = UIColor.white
       
        DropDown.appearance().textFont = UIFont.systemFont(ofSize: 18, weight: .bold)
//        DropDown.appearance().backgroundColor = UIColor.lightGray
        DropDown.appearance().selectionBackgroundColor = UIColor.systemGreen
    }
    
    @IBAction func btnBackAct(_ sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnOpenDropDownAct(_ sender : UIButton) {
        if (customerNamesList.count != 0) {
            openDropDown()
        } else {
            Utility.shared.makeToast("No Customer List Found Please load data")
        }
    }
    
    @IBAction func btnGenerateBillAct(_ sender : UIButton) {
        
        if (validateForm()) {
            
            let milkRecord : [String : Any] = ["SNo.": "\(/txtSerialNo?.text?.trim())", "CustomerName": "\(/getCustomerName())", "TotalCowMilk": getTotalCowMilk() , "NormalMilkRate": "\(selectCowRate)", "TotalBuffaloMilk": getTotalBuffaloMilk(), "Advance": getAdvanceValue(), "PackingMilkRate": "\(selectBuffaloRate)", "Month": "\(selectedMonth ?? Utility.shared.getCurrentMonth())", "isPackingMilk": "\(isPackingMilk())", "Balance": getBalanceValue()]
            print(milkRecord)
            generateBill(milkRecord)
        }
    }
    
    func getAdvanceValue() -> String {
        if (/txtAdvance?.text?.trim().count > 0) {
            return txtAdvance?.text?.trim() ?? "0"
        }
        return  "0"
    }
    
    func getBalanceValue() -> String {
        if (/txtBalance?.text?.trim().count > 0) {
            return txtBalance?.text?.trim() ?? "0"
        }
        return  "0"
    }
    
    func getTotalCowMilk() -> String {
        if (/txtCowMilk?.text?.trim().count > 0) {
            return txtCowMilk?.text?.trim() ?? "0"
        }
        return  "0"
    }
    
    func getTotalBuffaloMilk() -> String {
        if (/txtBuffaloMilk?.text?.trim().count > 0) {
            return txtBuffaloMilk?.text?.trim() ?? "0"
        }
        return  "0"
    }
    
    func getCustomerName() -> String?{
        if (txtSelectCustomer?.text?.trim().count != 0) {
            return txtSelectCustomer?.text?.trim()
        }
        return  txtEnterCustomer?.text?.trim()
    }
    
    
    func isPackingMilk() -> String {
        if (selectBuffaloRate == "66") {
            return "Yes"
        }
        return "No"
    }
    
    
    
    func validateForm() -> Bool{
        if (txtSerialNo?.text?.trim().count == 0) {
            Utility.shared.makeToast("Enter Serial No")
            return false
        }
        
        if (txtSelectCustomer?.text?.trim().count == 0 && txtEnterCustomer?.text?.trim().count == 0) {
            Utility.shared.makeToast("Select or Enter Customer Name")
            return false
        }
        
        if (txtBuffaloMilk?.text?.trim().count == 0 && txtCowMilk?.text?.trim().count == 0) {
            Utility.shared.makeToast("Please Enter Milk Record and select rate")
            return false
        }
        return true
    }
    @IBAction func btnResetAct(_ sender : UIButton) {
        rateSelectForBuffaloMilk(tag: 0)
        rateSelectForCowMilk(tag: 1)
        txtSerialNo?.text = nil
        txtBalance?.text = nil
        txtAdvance?.text = nil
        txtCowMilk?.text = nil
        txtBuffaloMilk?.text = nil
        txtSelectCustomer?.text = nil
        txtEnterCustomer?.text = nil
        self.view.endEditing(true)
        Utility.shared.makeToast("Form has been cleared now")
    }
    
    @IBAction func btnClearFilterAct(_ sender : UIButton) {
        txtSelectCustomer?.text = nil
    }
    
    @IBAction func btnBuffaloRateSelectAct(_ sender : UIButton) {
        rateSelectForBuffaloMilk(tag : sender.tag)
    }
    
    @IBAction func btnCowRateSelectAct(_ sender : UIButton) {
        rateSelectForCowMilk(tag : sender.tag)
    }
    
    func rateSelectForBuffaloMilk(tag : Int) {
        btnBuffaloRate66?.backgroundColor = tag == 0 ? UIColor.systemGreen : UIColor.white
        btnBuffaloRate62?.backgroundColor = tag == 0 ? UIColor.white : UIColor.systemGreen
        btnBuffaloRate66?.setTitleColor(tag == 0 ? UIColor.white : UIColor.systemGreen, for: .normal)
        btnBuffaloRate62?.setTitleColor(tag == 0 ? UIColor.systemGreen : UIColor.white, for: .normal)
        selectBuffaloRate = tag == 0 ? "66" : "62"
    }
    
    func rateSelectForCowMilk(tag : Int) {
        btnCowRate66?.backgroundColor = tag == 0 ? UIColor.systemGreen : UIColor.white
        btnCowRate62?.backgroundColor = tag == 0 ? UIColor.white : UIColor.systemGreen
        btnCowRate66?.setTitleColor(tag == 0 ? UIColor.white : UIColor.systemGreen, for: .normal)
        btnCowRate62?.setTitleColor(tag == 0 ? UIColor.systemGreen : UIColor.white, for: .normal)
        selectCowRate = tag == 0 ? "66" : "62"
    }
}

extension CustomerBillFormVC {
    
    func openDropDown() {
        let dropDown = DropDown()
        dropDown.anchorView = view  // UIView or UIBarButtonItem
        dropDown.dataSource = customerNamesList
        dropDown.direction = .bottom
        if isValidNumber(string: /txtSerialNo?.text?.trim()) {
            if let intSerialNo = Int(/txtSerialNo?.text?.trim()) {
                if (intSerialNo < customerNamesList.count) {
                    dropDown.selectRow(at: intSerialNo - 1)
                }
            }
        }
        dropDown.bottomOffset = CGPoint(x: 10, y:150)
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            txtSelectCustomer.text = item
            dropDown.hide()
        }
        dropDown.show()
    }
    
    func isValidNumber(string: String) -> Bool {
        return Int(string) != nil
    }
}

//Bill Related Functions

extension CustomerBillFormVC {
    func generateBill(_ record  : [String : Any]) {
        let customerMonthlyBill = BillCreation.shared.getBill(record)
        let status =  UserDefaultManager.updateCustomerRecordList(name: /getCustomerName(), customerRecord: record)
        if (status) {
            Utility.shared.makeToast("Bill Saved in the record")
            customerNamesList = UDKeys.CustomerNamesList.fetch() as? [String] ?? []
        }
        showBill(customerMonthlyBill)
    }
    
    func showBill(_ customerMonthlyBill : UIImage?) {
        if let image = customerMonthlyBill {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            guard let viewController = storyBoard.instantiateViewController(withIdentifier: "BillViewerVC") as? BillViewerVC else {
                return
            }
            viewController.imageParam = image
            self.navigationController?.present(viewController, animated: true)
        }
    }
}

extension CustomerBillFormVC {
    
    func addToolBar() {
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        //toolBar.tintColor = UIColor(red: 76 / 255, green: 217 / 255, blue: 100 / 255, alpha: 1)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePressed))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        self.txtBuffaloMilk?.inputAccessoryView = toolBar
        self.txtCowMilk?.inputAccessoryView = toolBar
        self.txtAdvance?.inputAccessoryView = toolBar
        self.txtBalance?.inputAccessoryView = toolBar
        self.txtEnterCustomer?.inputAccessoryView = toolBar
        self.txtSerialNo?.inputAccessoryView = toolBar
        
    }
    
    @objc func donePressed() {
        self.view.endEditing(true)
    }
    
    @objc func cancelPressed() {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    @objc func keyboardWillHide(_ notification:Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
}
