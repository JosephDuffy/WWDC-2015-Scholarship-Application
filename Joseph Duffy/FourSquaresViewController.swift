//
//  FourSquaresViewController.swift
//  Joseph Duffy
//
//  Created by Joseph Duffy on 21/04/2015.
//  Copyright (c) 2015 Yetii Ltd. All rights reserved.
//

import UIKit

class FourSquaresViewController: AppSectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.appId = "982796319"
        self.websiteURL = NSURL(string: "https://foursquaresapp.com")
    }
}
