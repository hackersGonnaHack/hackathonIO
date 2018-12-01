//
//  ViewController.swift
//  ibmApp
//
//  Created by Simge Helvaci on 28.11.2018.
//  Copyright © 2018 Simge Helvaci. All rights reserved.
//

import UIKit
import WebKit
import Alamofire
import KeychainSwift

class ViewController: UIViewController,WKNavigationDelegate {
  
    @IBOutlet weak var batteryLabel: UILabel!
    @IBOutlet weak var mileageLabel: UILabel!
    @IBOutlet weak var fuelLevelLabel: UILabel!
    @IBOutlet weak var tirePressureLabel: UILabel!
    @IBOutlet weak var wheelRPMsLabel: UILabel!
    @IBOutlet weak var lockFrontLeftLabel: UILabel!
    @IBOutlet weak var lockFrontRightLabel: UILabel!
    @IBOutlet weak var lockRearLeftLabel: UILabel!
    @IBOutlet weak var lockRearRightLabel: UILabel!
    @IBOutlet weak var isOpenFrontLeftLabel: UILabel!
    @IBOutlet weak var isOpenFrontRightLabel: UILabel!
    @IBOutlet weak var isOpenRearLeftLabel: UILabel!
    @IBOutlet weak var isOpenRearRightLabel: UILabel!
    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var lngLabel: UILabel!
    @IBOutlet weak var localWeatherLabel: UILabel!
    @IBOutlet weak var headingLabel: UILabel!

  
    var dictResp:NSDictionary = NSDictionary()


    var urls = [String]()
    var webView: WKWebView!
    var code = ""
    let keyChain = KeychainSwift()
    
    var batteryLevelInfo:String!
    var fuelLevelInfo:String!
    var tirePressure:String!
    var mileageInfo:String!
    var wheelRPMsInfo:String!
    var lockFrontLeftInfo:String!
    var lockFrontRightInfo:String!
    var lockRearLeftInfo:String!
    var lockRearRightInfo:String!
    var isOpenFrontLeftInfo:String!
    var isOpenFrontRightInfo:String!
    var isOpenRearLeftInfo:String!
    var isOpenRearRightInfo:String!
    var latInfo:String!
    var lngInfo:String!
    var localWeatherInfo:String!
    var headingInfo:String!
    var bRec:Bool = true
    @IBAction func degisLo(_ sender: UIButton)
    {   
        bRec = !bRec
        if bRec {
            sender.setImage(UIImage(named: "lock"), for: .normal)
        } else {
            sender.setImage(UIImage(named: "unlock"), for: .normal)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let apiStr = "https://api.secure.mercedes-benz.com/oidc10/auth/oauth/v2/authorize?response_type=code&client_id=1880dea4-642b-4f11-9803-dafb428a8ae1&redirect_uri=https://s3.us-east-2.amazonaws.com/mercedes-marsters-bucket/index.html&scope=mb:user:pool:reader%20mb:vehicle:status:general"
        // loading URL :
        let url = URL(string: apiStr)
        let request = URLRequest(url: url!)
        // init and load request in webview.
        webView = WKWebView(frame: self.view.frame)
        webView.navigationDelegate = self
        
        webView.load(request)
        
        
        
        self.view.addSubview(webView)
        self.view.sendSubviewToBack(webView)
        
        getInfo(type: "Additional Info",url2: "https://api.mercedes-benz.com/experimental/connectedvehicle/v1/vehicles/")
        // getInfo(type: "Tire",url2: "https://api.mercedes-benz.com/experimental/connectedvehicle/v1/vehicles/")
    }

    
    
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Start to load")
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish to load")
        print(webView.url!)
        urls.append("\(webView.url!)")
        print(urls)
        
        for (index, element) in urls.enumerated()
        {
            if element.range(of:"amazonaws") != nil {
                print("exists")
                
                if let index = element.endIndex(of: "code=") {
                    let substring = element[index...]
                    code = String(substring)
                    exchangeAuth(urlString: code)
                    print(code)  // "ab\n"
                    print(code.toBase64())
                }
                print("TOKEN = \(code)")
                self.webView.isHidden = true
            }
        }
    }
    
    
    func getInfo(type:String,url2:String)
    {
        let carID:String = "DB4D2536FE75E7CF5F"
      
       
        let url:String = url2 + carID + "/tires"
            
    
        let method: HTTPMethod = .get
        
        let headers:HTTPHeaders = ["accept":"application/json","authorization":"Bearer "+"\(keyChain.get("access_token") ?? "bos")"]
        print("GET ADDITIONAL INFO")
        print(url)
        print(headers)
        print(keyChain.get("access_token"))
        var response = alamoRequest(requestURL: url, method: method,headers: headers)
        for (key, value) in self.dictResp {
           
            switch type {
            case "Additional Info":
                    if String(describing: key) == "colorname"
                    {
                        print("colorname3 = \(value)")
                    }
                    if String(describing: key) == "fueltype"
                    {
                        print("fueltype3 = \(value)")
                    }
                    if String(describing: key) == "modelyear"
                    {
                        print("modelyear3 = \(value)")
                    }
                    if String(describing: key) == "numberofdoors"
                    {
                        print("numberofdoors3 = \(value)")
                    }
                    if String(describing: key) == "numberofseats"
                    {
                        print("numberofseats3 = \(value)")
                    }
                    if String(describing: key) == "salesdesignation"
                    {
                        print("salesdesignation3 = \(value)")
                    }
                    else {
                        break
                        
                    }
            case "Tire":
                print("hi")
            
            default:
                print("Invalid Tpe")
            }
       
           
            
        }

        
        
    }
    
    func getInfo(type: String) {
        
    }
    
    
    func alamoRequest(requestURL:String,method:HTTPMethod, headers:HTTPHeaders ) -> NSDictionary
    {
        var resp:NSDictionary = NSDictionary()
        Alamofire.request(requestURL, method: method, headers: headers).responseJSON
            {
                response in
                switch response.result
                {
                case .success(let JSON):
                    
                    let response = JSON as! NSDictionary
                    print(response)
                    //var colorName = resp.object(forKey: "colorname")!
                    self.dictResp = response
                    break
                case .failure(let error):
                    print("err")
                    print(response)
                    print(error)
                }
        }
        
        print("hellooo \(resp)")
        return resp
    }
    
    func exchangeAuth(urlString: String)
    {
        let clientIDSecret = "1880dea4-642b-4f11-9803-dafb428a8ae1:771a61f9-1af3-4aa2-a300-3b14af2d4a06"
        let encoded = clientIDSecret.toBase64()
        
        let headers: HTTPHeaders = ["authorization": "Basic \(encoded)","content-type":"application/x-www-form-urlencoded"]
        let parameters : Parameters = ["grant_type": "authorization_code","code":"\(urlString)","redirect_uri":"https://s3.us-east-2.amazonaws.com/mercedes-marsters-bucket/index.html"]
        print(parameters)
        let exchangeUrl = "https://api.secure.mercedes-benz.com/oidc10/auth/oauth/v2/token"
        
        Alamofire.request(exchangeUrl, method: .post, parameters: parameters, headers: headers).responseJSON {
            response in
            switch response.result {
            case .success(let JSON):
                print("RESPONSE")
                let response = JSON as! NSDictionary
                
                //example if there is an id
                let accessToken = response.object(forKey: "access_token")!
                let refreshToken = response.object(forKey: "refresh_token")!
                
                print(response)
                print(accessToken)
                
                let keyChain = KeychainSwift()
                keyChain.set("\(accessToken)", forKey: "access_token")
                keyChain.set("\(refreshToken)", forKey: "refresh_token")
               // self.getInfo(type: "Additional Info",url2: "https://api.mercedes-benz.com/experimental/connectedvehicle/v1/vehicles/DB4D2536FE75E7CF5F")
                self.getInfo(type: "Tire",url2: "https://api.mercedes-benz.com/experimental/connectedvehicle/v1/vehicles/")
                
                break
            case .failure(let error):
                
                print(error)
            }
        }
    }
    
    
    
    
    
    
    func getChargingInfo() -> String
    {
        batteryLabel.text = batteryLevelInfo
        return batteryLevelInfo
    }
    
    func getMileageInfo() -> String
    {
       mileageLabel.text = mileageInfo
        return mileageInfo
    }
    
    func getFuelLevelInfo() -> String
    {
        fuelLevelLabel.text = fuelLevelInfo
        return fuelLevelInfo
    }
    
    func getTirePressureInfo() -> String
    {
        
        tirePressureLabel.text = tirePressure
        return tirePressure
    }
    
    func getWheelRPMsInfo() -> String
    {
        wheelRPMsLabel.text = wheelRPMsInfo
        return wheelRPMsInfo
    }
    
    func getLatituteInfo() -> String
    {
        latLabel.text = latInfo
        return latInfo
    }
    
    func getLongitudeInfo() -> String
    {
        lngLabel.text = lngInfo
        return lngInfo
    }
    
    func getLocalWeatherInfo() -> String
    {
        localWeatherLabel.text = localWeatherInfo
        return localWeatherInfo
    }
    
    func getLockFrontLeftInfo() -> String
    {
        lockFrontLeftLabel.text = lockFrontLeftInfo
        return lockFrontLeftInfo
    }
    func getLockFrontRightInfo() -> String
    {
        lockFrontRightLabel.text = lockFrontRightInfo
        return lockFrontRightInfo
    }
    func getLockRearLeftInfo() -> String
    {
        lockRearLeftLabel.text = lockRearLeftInfo
        return lockRearLeftInfo
    }
    func getLockRearRightInfo() -> String
    {
        lockRearRightLabel.text = lockRearRightInfo
        return lockRearRightInfo
    }
    
    func getIsOpenFrontLeftInfo() -> String
    {
        isOpenFrontLeftLabel.text = isOpenFrontLeftInfo
        return isOpenFrontLeftInfo
    }
    func getIsOpenFrontRightInfo() -> String
    {
        isOpenFrontRightLabel.text = isOpenFrontRightInfo
        return isOpenFrontRightInfo
    }
    func getIsOpenRearLeftInfo() -> String
    {
        isOpenRearLeftLabel.text = isOpenRearLeftInfo
        return isOpenRearLeftInfo
    }
    func getIsOpenRearRightInfo() -> String
    {
        isOpenRearRightLabel.text = isOpenRearRightInfo
        return isOpenRearRightInfo
    }
    
}


extension String {
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }
    
    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
}
extension StringProtocol where Index == String.Index {
    func index(of string: Self, options: String.CompareOptions = []) -> Index? {
        return range(of: string, options: options)?.lowerBound
    }
    func endIndex(of string: Self, options: String.CompareOptions = []) -> Index? {
        return range(of: string, options: options)?.upperBound
    }
    func indexes(of string: Self, options: String.CompareOptions = []) -> [Index] {
        var result: [Index] = []
        var start = startIndex
        while start < endIndex,
            let range = self[start..<endIndex].range(of: string, options: options) {
                result.append(range.lowerBound)
                start = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
    func ranges(of string: Self, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var start = startIndex
        while start < endIndex,
            let range = self[start..<endIndex].range(of: string, options: options) {
                result.append(range)
                start = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
}
extension String {
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}
