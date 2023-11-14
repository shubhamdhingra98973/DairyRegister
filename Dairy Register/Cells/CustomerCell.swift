//
//  CustomerCell.swift
//  Dairy Register
//
//  Created by Shubham Dhingra on 27/08/23.
//

import UIKit

class CustomerCell: UITableViewCell {

    @IBOutlet weak var lblCustomerName : UILabel!
    @IBOutlet weak var lblMilkMecord : UILabel!
    @IBOutlet weak var lblBalanceAdvanceInfo : UILabel!
    @IBOutlet weak var lblFinalAmount : UILabel!
    @IBOutlet weak var btnShowBill : UIButton!
    @IBOutlet weak var btnPrintBill : UIButton!
    @IBOutlet weak var isPackingImage : UIImageView!
    @IBOutlet weak var outerView : UIView!

    
    
    var customerData : Any? {
        didSet {
            configure()
        }
    }
    
    func configure(){
        if let data = customerData as? [String :Any] {
            
            //Name and SNo
            if  let SNo = data[CustomerDataKeys.SNo.value] as? String,  let customerName = data[CustomerDataKeys.CustomerName.value] as? String {
                lblCustomerName?.text = "(\(SNo))  \(customerName)"
            }
            
            if let isPackingMilk = data[CustomerDataKeys.isPackingMilk.value] as? String {
                isPackingImage.image = UIImage(named : isPackingMilk == kYes ?  "ic_yes" : "ic_no")
            } else {
                isPackingImage.image = nil
            }
            
            var milkInfo = NSMutableAttributedString()
            if let buffaloMilk = data[CustomerDataKeys.TotalBuffaloMilk.value] as? String {
                milkInfo = Utility.shared.createAttributedString(str1: "\(BillConstants.buffalo.value): ", attr1: [.font : UIFont.systemFont(ofSize: 14 , weight: .regular)], rangeAttr1: nil, str2: "\(buffaloMilk) Ltr", attr2: [.font :UIFont.systemFont(ofSize: 14 , weight: .bold)], rangeAttr2: nil)
//                milkInfo = "Buffalo: \(buffaloMilk) Ltr"
                milkInfo.append(Utility.shared.createAttributedString(str1: " (\(BillManager.shared.getBuffaloMilkRate(data: data)))", attr1: [.font : UIFont.systemFont(ofSize: 10 , weight: .regular)], rangeAttr1: nil, str2: "", attr2: nil, rangeAttr2: nil))
            }
            
            if let cowMilk =  data[CustomerDataKeys.TotalCowMilk.value] as? String {
                milkInfo.append(Utility.shared.createAttributedString(str1: "          \(BillConstants.cow.value): ", attr1: [.font : UIFont.systemFont(ofSize: 14 , weight: .regular)], rangeAttr1: nil, str2: "\(cowMilk) Ltr", attr2: [.font :UIFont.systemFont(ofSize: 14 , weight: .bold)], rangeAttr2: nil))
                milkInfo.append(Utility.shared.createAttributedString(str1: " (\(BillManager.shared.getCowMilkRate(data: data)))", attr1: [.font : UIFont.systemFont(ofSize: 10 , weight: .regular)], rangeAttr1: nil, str2: "", attr2: nil, rangeAttr2: nil))
            }
            
            lblMilkMecord?.attributedText = milkInfo
            
            var isBalanceOrAdvance : Bool = false
            if let balance = data[CustomerDataKeys.Balance.value] as? String {
                if (balance != "0") {
                    isBalanceOrAdvance = true
                    lblBalanceAdvanceInfo?.attributedText = Utility.shared.createAttributedString(str1: "\(CustomerDataKeys.Balance.value)(+): ", attr1: [.font : UIFont.systemFont(ofSize: 14 , weight: .regular)], rangeAttr1: nil, str2: "\(BillConstants.rupees.value) \(balance)", attr2: [.font :UIFont.systemFont(ofSize: 14 , weight: .bold)], rangeAttr2: nil)
                }
            }
            
            if let advance  = data[CustomerDataKeys.Advance.value] as? String {
                if (advance != "0") {
                    isBalanceOrAdvance = true
                    lblBalanceAdvanceInfo?.attributedText = Utility.shared.createAttributedString(str1: "\(CustomerDataKeys.Advance.value)(-): ", attr1: [.font : UIFont.systemFont(ofSize: 14 , weight: .regular)], rangeAttr1: nil, str2: "\(BillConstants.rupees.value) \(advance)", attr2: [.font :UIFont.systemFont(ofSize: 14 , weight: .bold)], rangeAttr2: nil)
                }
            }
            
           
            if !(isBalanceOrAdvance) {
                lblBalanceAdvanceInfo?.attributedText = Utility.shared.createAttributedString(str1: "\(CustomerDataKeys.Balance.value): ", attr1: [.font : UIFont.systemFont(ofSize: 14 , weight: .regular)], rangeAttr1: nil, str2: "--", attr2: [.font :UIFont.systemFont(ofSize: 14 , weight: .bold)], rangeAttr2: nil)
            }
            
            let CowMilkTotalAmount = BillManager.shared.calculateTotalCowMilkAmount(data: data)
            let BuffaloMilkTotalAmount =  BillManager.shared.calculateTotalBuffaloMilkAmount(data: data)
            let totalMonthlyAmount = CowMilkTotalAmount + BuffaloMilkTotalAmount
            let finalPayableAmount = BillManager.shared.getFinalPayableAmount(data: data, totalMontlyAmount: totalMonthlyAmount)
            
            lblFinalAmount?.attributedText = Utility.shared.createAttributedString(str1: "\(CustomerDataKeys.FinalAmt.value): ", attr1: [.font : UIFont.systemFont(ofSize: 14 , weight: .regular)], rangeAttr1: nil, str2: "\(BillConstants.rupees.value) \(finalPayableAmount)", attr2: [.font :UIFont.systemFont(ofSize: 14 , weight: .bold)], rangeAttr2: nil)

        }
        
    
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func configureUI() {
        outerView.dropShadow(offset:  CGSize(width: 1, height: 2), radius: 3, color: UIColor(red: 0.302, green: 0.373, blue: 0.408, alpha: 1), opacity: 0.5)
        outerView.layer.cornerRadius = 8
        outerView.layer.masksToBounds = false
    }
}
