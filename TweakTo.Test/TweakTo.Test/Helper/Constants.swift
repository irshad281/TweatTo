//
//  Constants.swift
//  TweakTo.Test
//
//  Created by Irshad Ahmed on 11/03/21.
//

import Foundation
import UIKit
import Network

let appDelegate               =  UIApplication.shared.delegate as! AppDelegate
let viewContext               =  appDelegate.persistentContainer.viewContext



let screen_width              =  UIScreen.main.bounds.width
let screen_height             =  UIScreen.main.bounds.height



let monitor = NWPathMonitor(requiredInterfaceType: .wifi)
