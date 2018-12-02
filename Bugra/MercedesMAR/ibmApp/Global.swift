//
//  Global.swift
//  ibmApp
//
//  Created by Buğra Altuğ on 2.12.2018.
//  Copyright © 2018 Simge Helvaci. All rights reserved.
//

import Foundation
import KeychainSwift
import UIKit

class Global: UIViewController {
    
    struct GlobalVariable
    {
        let keyChain = KeychainSwift()
        var names = [String]()
        var infos = [String]()
    }
}
