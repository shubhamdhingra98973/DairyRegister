

//
//  BillViewerVC.swift
//  Dairy Register
//
//  Created by Shubham Dhingra on 27/08/23.
//

import UIKit

class BillViewerVC: UIViewController {
    
    @IBOutlet weak var imgView : UIImageView?
    @IBOutlet weak var btnCross : UIButton?
    @IBOutlet weak var bgView : UIView?
    @IBOutlet weak var printerInfo : UILabel!
    
    
    var imageParam : UIImage?
    var customerRecord = [String : Any]()
    var test:WifiManager!
    var isConnectedGlobal:Bool=false
    var isDairySlip : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = imageParam {
            imgView?.image = image
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        }
        setupGestureRecognizers()
    }
    @IBAction func btnCrossAct(_ sender : UIButton) {
        self.backPressed()
    }
    
    private func setupGestureRecognizers() {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeAction(swipe:)))
        leftSwipe.direction = .down
        self.bgView?.addGestureRecognizer(leftSwipe)
    }
    
    @objc func swipeAction(swipe: UISwipeGestureRecognizer) {
        self.backPressed()
    }
    
    
    func backPressed() {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnPrintBillsAct(_ sender: Any) {
        if(!self.isConnectedGlobal){
            ConnectPrinter();
        }
        sleep(2);
        dataToBePrint(bill: imageParam, copies: 1 , recordIndex: 1)
    }
    
    @IBAction func btnSaveImageAct(_ sender: Any) {
        if let param = imageParam {
            UIImageWriteToSavedPhotosAlbum(param, nil, nil, nil)
        }
    }
}

extension BillViewerVC {
    func ConnectPrinter() {
        let queue = DispatchQueue(label: "com.receipt.printer1", qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
        queue.async {
            var isConnected:Bool;
            self.test = WifiManager.share(0,threadID: "com.receipt.printer1");
            isConnected=self.test.connectWifiPrinter("192.168.29.222", port: 9100);
            //isConnected=self.test.connectWifiPrinter("192.168.3.22", port: 9100);
            self.isConnectedGlobal=isConnected;
            if(isConnected){
                print("connect printer1 succeessfully\n");
                self.test.startMonitor();
            }else{
                print("connect printer1 failed\n");
            }
        }
    }
    
    func dataToBePrint(bill : UIImage? , copies : Int , recordIndex : Int) {
        let str:String="Page_"+String(recordIndex);
        if(self.isConnectedGlobal){
            let queue = DispatchQueue(label: "com.receipt.printer1", qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
            queue.async {
                var printSucceed:Bool;
                var image = UIImage()
                //printSucceed = self.test.sendData(toPrinter:Data("hello priner\n".utf8));
                if let createdImage = bill {
                    
                    print("Congrats !! we have image now")
                    image = createdImage
                } else {
                    print("Not getting any image")
                    return
                }
              
                var imgData:Data=Data();
                imgData.append(PosCommand.printRasteBmp(withM: RasterNolmorWH, andImage: image, andType: Dithering));
                printSucceed=self.test.sendReceipt(toPrinter: imgData);
                if(printSucceed){
                    print(str+",printer1 succeessfully\n");
                }else{
                    print(str+",printer1 failed\n");
                    print(self.test.getPrinterStatus());
                }
                //Only machines with large boards can frequently disconnect and connect ports
                self.test.disConnectPrinter();
                self.isConnectedGlobal=false;
            }
        }else{
            print(str+",printer1 failed\n");
            print("printer offline or printer error");
        }
        if(copies>1){
            sleep(3);
            //When printing multiple tests on the same port continuously, you need to wait for the port to be disconnected, otherwise the connection will fail; printing with multiple ports does not increase the delay
        }
    }

}
