//
//  UIDevice+isiOS8OrAbove.swift
//  Joseph Duffy
//
//  Created by Joseph Duffy on 26/04/2015.
//  Copyright (c) 2015 Yetii Ltd. All rights reserved.
//

import UIKit

extension UIDevice {
    var isiOS8OrAbove: Bool {
        get {
            return (self.systemVersion as NSString).floatValue >= 8.0
        }
    }
}