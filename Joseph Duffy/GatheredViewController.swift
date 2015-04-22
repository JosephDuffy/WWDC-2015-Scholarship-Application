//
//  GatheredViewController.swift
//  Joseph Duffy
//
//  Created by Joseph Duffy on 21/04/2015.
//  Copyright (c) 2015 Yetii Ltd. All rights reserved.
//

import UIKit
import StoreKit

class GatheredViewController: AppSectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.appId = "929726748"
        self.websiteURL = NSURL(string: "https://gatheredapp.com")
    }
}
