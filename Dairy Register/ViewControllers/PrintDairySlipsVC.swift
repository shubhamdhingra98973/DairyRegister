//
//  PrintDairySlipsVC.swift
//  Dairy Register
//
//  Created by Shubham Dhingra on 04/05/24.
//

import UIKit

class PrintDairySlipsVC: UIViewController {

    @IBAction func btnBackAct(_ sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //Morning Slip VIjayNagar
    @IBAction func btnPrintVijayNagarSlipsAct(_ sender : UIButton) {
        let generatedImage  = CreateDairySlips.shared.getSlipImage(slipHeight: 520, isPage1: true, customersListWithDailyMilk: CustomersListAreaWise.shared.vijayNagarCustomersListWithMilk(), slipDetail: ["area":DairySlipsContants.VijayNagar.value , "date": "" , "timeSlot" : DairySlipsContants.morning.value])
        showBill(generatedImage)
    }
    
    
    
    @IBAction func btnPrintKmlaNgrMornSlip(_ sender : UIButton) {
        if (sender.tag == 0) {
            let generatedImage  = CreateDairySlips.shared.getSlipImage(slipHeight: 620, isPage1: true, customersListWithDailyMilk: CustomersListAreaWise.shared.kamlaNagarMornCustomerListPage1(), slipDetail: ["area":DairySlipsContants.kamlaNagar.value , "date": "" , "timeSlot" : DairySlipsContants.morning.value])
            showBill(generatedImage)
        } 
        if (sender.tag == 1) {
            let generatedImage  = CreateDairySlips.shared.getSlipImage(slipHeight: 380, isPage1: false, customersListWithDailyMilk: CustomersListAreaWise.shared.kamlaNagarMornCustomerListPage2(), slipDetail: ["area":DairySlipsContants.kamlaNagar.value , "date": "" , "timeSlot" : DairySlipsContants.morning.value])
            showBill(generatedImage)
        }
       
    }
    
    @IBAction func btnPrintkaramyogiEvenSlip(_ sender : UIButton) {
        let generatedImage  = CreateDairySlips.shared.getSlipImage(slipHeight: 720, isPage1: true, customersListWithDailyMilk: CustomersListAreaWise.shared.karamyogiEvenCustomerList(), slipDetail: ["area":DairySlipsContants.Karamyogi.value , "date": "" , "timeSlot" : DairySlipsContants.evening.value])
        showBill(generatedImage)
    }
    
    @IBAction func btnKmlaNagarEvenSlip(_ sender : UIButton) {
        let generatedImage  = CreateDairySlips.shared.getSlipImage(slipHeight: 500, isPage1: true, customersListWithDailyMilk: CustomersListAreaWise.shared.kamlaNagarEvenCustList(), slipDetail: ["area":DairySlipsContants.kamlaNagar.value , "date": "" , "timeSlot" : DairySlipsContants.evening.value])
        showBill(generatedImage)
    }
    
    func showBill(_ dairySlips : UIImage?) {
        if let image = dairySlips {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            guard let viewController = storyBoard.instantiateViewController(withIdentifier: "BillViewerVC") as? BillViewerVC else {
                return
            }
            print("Image :",image);
            viewController.imageParam = image
            viewController.isDairySlip = true
            self.navigationController?.present(viewController, animated: true)
        }
    }
}


