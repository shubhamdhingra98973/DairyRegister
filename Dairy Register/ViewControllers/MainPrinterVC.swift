//
//  ViewController.swift
//  Dairy Register
//
//  Created by Shubham Dhingra on 23/08/23.
//

import UIKit
import CoreXLSX


class MainPrinterVC : UIViewController {
    var test:WifiManager!
    var test2:WifiManager!
    var isConnectedGlobal:Bool=false
    
    
    @IBOutlet weak var lblText : UILabel!
    @IBOutlet weak var imageView : UIImageView!
    @IBOutlet weak var btnShowSingleBill : UIButton!
    @IBOutlet weak var btnPrintSingleBill : UIButton!
    @IBOutlet weak var btnPrintAllReceipts : UIButton!
    @IBOutlet weak var btnLoadExcelData : UIButton!
    @IBOutlet weak var btnPrintBlankReceipts : UIButton!
    @IBOutlet weak var btnShowCustomerList : UIButton!
    
    var customerDataArray = [[String : Any]]() {
        didSet {
           updateActivateUI()
        }
    }
    
    func updateActivateUI() {
        btnShowSingleBill?.isHidden = customerDataArray.count == 0
        btnPrintSingleBill?.isHidden = customerDataArray.count == 0
        btnPrintAllReceipts?.isHidden = customerDataArray.count == 0

        if (customerDataArray.count > 0) {
            let customerNamesList = customerDataArray.map{customerRecord in
                if let customerName = customerRecord["CustomerName"] as? String {
                    return customerName
                }
                return ""
            }
            UDKeys.CustomerNamesList.save(customerNamesList)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateActivateUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //        test.disConnectPrinter();
    }
    
    @IBAction func btnShowSingleBillAct(_ sender: Any) {
        let image =  BillCreation.shared.getBill(self.customerDataArray[0])
        imageView.image = image
    }
    
    @IBAction func btnLoadExcelData(_ sender: Any) {
        downloadExcelSheet()
    }
    
    @IBAction func btnPrintBlankReceipt(_ sender: Any) {
        
    }
    
    @IBAction func btnGenerateCustomerBill(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyBoard.instantiateViewController(withIdentifier: "CustomerBillFormVC") as? CustomerBillFormVC else {
            return
        }
        viewController.customerNamesList = UserDefaultManager.getCustomerNamesList()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func ConnectPrinter(){
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
        //        let queue2 = DispatchQueue(label: "com.receipt.printer2", qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
        //        queue2.async {
        //            var isConnected:Bool;
        //            self.test2=WifiManager.share(0,threadID: "com.receipt.printer2");
        //            isConnected=self.test2.connectWifiPrinter("192.168.3.88", port: 9100);
        //            if(isConnected){
        //                print("connect printer2 succeessfully\n");
        //                self.test2.startMonitor();
        //            }else{
        //                print("connect printer2 failed\n");
        //            }
        //        }
    }
    //To monitor the status of the machine, you need to enable the no-lost order function in advance
    @IBAction func btnPrintAllReceiptsAct(_ sender: Any) {
        for (index , records) in self.customerDataArray.enumerated() {
            
            if(!self.isConnectedGlobal){
                ConnectPrinter();
            }
            sleep(2);
            dataToBePrint(customerData: records, copies: self.customerDataArray.count , recordIndex: index)
        }
    }
    
    @IBAction func btnShowCustomerRecord(_ sender: Any) {
        openCustomerList()
    }
    
   func  openCustomerList() {
       let storyBoard = UIStoryboard(name: "Main", bundle: nil)
       guard let viewController = storyBoard.instantiateViewController(withIdentifier: "CustomerListVC") as? CustomerListVC else {
           return
       }
       if let customerRecordList =  UDKeys.CustomerRecordList.fetch() as? [[String :Any]] {
           viewController.customersRecordList = customerRecordList
       }
       self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func dataToBePrint(customerData : [String : Any] , copies : Int , recordIndex : Int) {
        let str:String="Page_"+String(recordIndex);
        if(self.isConnectedGlobal){
            let queue = DispatchQueue(label: "com.receipt.printer1", qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
            queue.async {
                var printSucceed:Bool;
                var image = UIImage()
                //printSucceed = self.test.sendData(toPrinter:Data("hello priner\n".utf8));
                if let createdImage = BillCreation.shared.getBill(customerData) {
                    
                    print("Congrats !! we have image now")
                    image = createdImage
                } else {
                    print("Not getting any image")
                    return
                }
                //                let image=UIImage(named: "test.jpeg");
                var imgData:Data=Data();
                imgData.append(PosCommand.printRasteBmp(withM: RasterNolmorWH, andImage: image, andType: Dithering));
                printSucceed=self.test.sendReceipt(toPrinter: imgData);
                //printSucceed=self.test.sendReceipt(toPrinter: Data("hello priner\n".utf8));
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

extension UIImage {
    func withColor(_ color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        // 1
        let drawRect = CGRect(x: 0,y: 0,width: size.width,height: size.height)
        // 2
        color.setFill()
        UIRectFill(drawRect)
        // 3
        draw(in: drawRect, blendMode: .destinationIn, alpha: 1)
        
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage!
    }
}

extension CGFloat {
    func setTopMargin(value : CGFloat) -> CGFloat {
        let newValue = self + value
        return newValue
    }
}



extension MainPrinterVC {
    func downloadExcelSheet() {
        guard let excelFilePath = Bundle.main.path(forResource: "Customer_Milk_Record_sheet", ofType: "xlsx") else {
            print("not able to access file .....")
            return
        }
        do {
            if let file = try XLSXFile(filepath: excelFilePath) {
                    try parseExcelData(file: file)
            }
        } catch {
            print("Error: \(error)")
        }
    }
    
    //Example Column name :- A B C D E F G.....
    func getColumnName(worksheet : Worksheet ,  columnName : String , sharedStrings : SharedStrings) -> String {
        if  let firstColumnOfParticularRow = worksheet.cells(atColumns: [ColumnReference(columnName)!]).first {
            if (firstColumnOfParticularRow.type == .sharedString) {
                return firstColumnOfParticularRow.stringValue(sharedStrings) ?? ""
            }
        }
        return ""
    }
    
    func parseExcelData(file: XLSXFile) throws {
        print("Load file :",file);
        do {
            var jsonArray: [[String: Any]] = []
            for wbk in try file.parseWorkbooks() {
                for (name, path) in try file.parseWorksheetPathsAndNames(workbook: wbk) {
                    if let worksheetName = name {
                        print("This worksheet has a name: \(worksheetName)")
                    }
                    
                    let worksheet = try file.parseWorksheet(at: path)
                    guard let sharedStrings = try file.parseSharedStrings() else {
                        return
                    }
                      let allColumns = worksheet.cells(atColumns: [ColumnReference("D")!])
                        let columnCStrings = worksheet.cells(atColumns: [ColumnReference("B")!]).compactMap({ cell in
                            if (cell.type == .sharedString) {
                                return cell.stringValue(sharedStrings)
                            }
                            return nil
                        })
                    for(index,row) in (worksheet.data?.rows ?? []).enumerated() {
                        if (index > 0) {
                            var rowData: [String: Any] = [:]
                            for c in row.cells {
//                                print("Cell :",c)
//                                print("Row :",c.reference.column.value)
//                                print("Column :",c.reference.column)
                                let columnName = getColumnName(worksheet: worksheet, columnName: c.reference.column.value, sharedStrings: sharedStrings)
//                                print("ColumnName :",getColumnName(worksheet: worksheet, columnName: c.reference.column.value, sharedStrings: sharedStrings))
                                if let cellValue = c.stringValue(sharedStrings) {
                                    rowData[columnName] = cellValue
                                }
                            }
                            if (rowData.count > 0) {
                                print("\(index) : \(rowData)")
                                jsonArray.append(rowData)
                            }
                        }
                        
                    }
                    customerDataArray = jsonArray
                    
                    /***
                     Uncomment below Code to use it for get Excel Data in JSON FORMAT
                     ***/
                    
                }
            }
        }
        catch {
            print("Error parsing worksheet: \(error)")
        }
        
    }
}
