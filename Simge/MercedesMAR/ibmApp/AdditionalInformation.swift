//
//  AdditionalInformation.swift
//  ibmApp
//
//  Created by Simge Helvaci on 1.12.2018.
//  Copyright © 2018 Simge Helvaci. All rights reserved.
//

import UIKit
import ObjectMapper


class SearchResponse: Mappable {
    
    var additionalInformations: [AdditionalInformation]?//movies
    var totalResults: String?
    var response: String!
    
    required init?(map: Map) {
        
    }
    
    // Sağ taraf api cevabında verilen isimler. Sol taraf bizim kendi yarattığımız class'ta değişkenlere verdiğimiz isimler. Sağ tarafı sol tarafa eşitleyerek yeni bir obje initialize ediyor.
    func mapping(map: Map) {
       additionalInformations <- map["Search"]
        totalResults <- map["totalResults"]
        response <- map["Response"]
    }
    
}
class AdditionalInformation: Mappable {

    var id: String?
    var licenseplate: String?
    var salesdesignation: String?
    var finorvin: String?
    var nickname: String?
    var modelyear: String?
    var colorname: String?
    var fueltype: String?
    var powerhp: String?
    var powerkw: String?
    var numberofdoors: String?
    var numberofseats: String?
    
    
    // Elimizle initialize etmek istediğimizde girmemiz gereken bilgiler.
    init(id: String, licenseplate: String, salesdesignation: String, finorvin: String,nickname: String, modelyear: String, colorname: String, fueltype: String,powerhp: String, powerkw: String, numberofdoors: String, numberofseats: String) {
        // Bir obje yaratırken elimizle girdiğimiz bilgilerin class variable'lara eşitlenmesi.
        self.id = id
        self.licenseplate = licenseplate
        self.salesdesignation = salesdesignation
        self.finorvin = finorvin
        self.nickname = nickname
        self.modelyear = modelyear
        self.colorname = colorname
        self.fueltype = fueltype
        self.powerhp = powerhp
        self.powerkw = powerkw
        self.numberofdoors = numberofdoors
        self.numberofseats = numberofseats
        
    }
    
    required init?(map: Map) {
        
    }
    

    func mapping(map: Map) {
        id <- map["id"]
        licenseplate <- map["licenseplate"]
        salesdesignation <- map["salesdesignation"]
        finorvin <- map["finorvin"]
        nickname <- map["nickname"]
        modelyear <- map["modelyear"]
        colorname <- map["colorname"]
        fueltype <- map["fueltype"]
        powerhp <- map["powerhp"]
        powerkw <- map["powerkw"]
        numberofdoors <- map["numberofdoors"]
        numberofseats <- map["numberofseats"]
    }
    
}
