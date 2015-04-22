//
//  AccessibilitySectionViewController.swift
//  Joseph Duffy
//
//  Created by Joseph Duffy on 22/04/2015.
//  Copyright (c) 2015 Yetii Ltd. All rights reserved.
//

import UIKit

class AccessibilitySectionViewController: SectionViewController {
   
    @IBAction func viewDynamicControlsOnGitHubButtonTapped() {
        if let url = NSURL(string: "https://github.com/YetiiNet/DynamicControls") {
            UIApplication.sharedApplication().openURL(url)
        }
    }

    @IBAction func viewEYMSTimetableExampleButtonTapped() {
        if let url = NSURL(string: "http://www.eyms.co.uk/bus-services/timetable/x46-x47") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
}
