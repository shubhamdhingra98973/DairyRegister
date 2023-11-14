//
//  TableViewDataSource.swift
//  Hushbunny
//
//  Created by Shubham Dhingra on 07/05/22.
//

import Foundation
import UIKit

typealias  ListCellConfigureBlock = (_ cell : Any , _ item : Any? , _ indexpath: IndexPath?) -> ()
typealias  DidSelectedRow = (_ indexPath : IndexPath , _ cell : Any) -> ()
typealias ViewForHeaderInSection = (_ section : Int) -> UIView?
typealias ViewForFooterInSection = (_ section : Int) -> UIView?
typealias ScrollViewListener = (_ scrollView : UIScrollView) -> ()

let kCustomerCell = "CustomerCell"


class CustomTableViewDataSource : NSObject  {
    
    var items : Array<Any>?
    var cellIdentifier : String?
    var tableView  : UITableView?
    var tableViewRowHeight : CGFloat = 44.0
    var configureCellBlock : ListCellConfigureBlock?
    var aRowSelectedListener : DidSelectedRow?
    var viewforHeaderInSection : ViewForHeaderInSection?
    var viewforFooterInSection : ViewForFooterInSection?
    
    var headerHeight : CGFloat?
    var tblfooterHeight : CGFloat?
    
    init (items : Array<Any>? , height : CGFloat , tableView : UITableView? , cellIdentifier : String?) {
        self.items = items
        self.tableView = tableView
        self.tableViewRowHeight = height
        self.cellIdentifier = cellIdentifier
    }
    
    
    override init() {
        super.init()
    }
}

extension CustomTableViewDataSource : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let identifier = cellIdentifier else{
            fatalError("Cell identifier not provided")
        }
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: identifier , for: indexPath) as UITableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        if let block = self.configureCellBlock {
            block(cell , self.items?[indexPath.row] , indexPath as IndexPath?)
        }
        return cell
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let block = self.aRowSelectedListener, case let cell as Any = tableView.cellForRow(at: indexPath){
            block(indexPath , cell)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return /self.items?.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableViewRowHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return self.tableViewRowHeight
        //        if cellIdentifier == R.reuseIdentifier.ordersDetailCell.identifier {
        //            return CGFloat(/self.items?.count * 120)
        //        }
        //        return 100
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let block = viewforHeaderInSection else { return nil }
        return block(section)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let block = viewforFooterInSection else { return nil }
        return block(section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return headerHeight ?? 0.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return tblfooterHeight ?? 0.0
    }
    //
    //    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //        if let block = scrollViewListener {
    //            block(scrollView)
    //        }
    //    }
    
}
