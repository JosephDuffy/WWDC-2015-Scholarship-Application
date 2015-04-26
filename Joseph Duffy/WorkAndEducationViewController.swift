//
//  WorkAndEducationViewController.swift
//  Joseph Duffy
//
//  Created by Joseph Duffy on 22/04/2015.
//  Copyright (c) 2015 Yetii Ltd. All rights reserved.
//

import UIKit

class WorkAndEducationViewController: SectionViewController {
    @IBOutlet weak var clever4TextView: UITextView!
    @IBOutlet weak var clever4ImageView: UIImageView!
    @IBOutlet weak var clever4ImageViewCaption: UILabel!
   
    @IBOutlet weak var yetiiTextView: UITextView!
    @IBOutlet weak var yetiiImageView: UIImageView!
    @IBOutlet weak var yetiiImageViewCaption: UILabel!

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.setViews([
            self.clever4ImageView,
            self.clever4ImageViewCaption
            ], toExclusionZoneOfTextView: self.clever4TextView)

        self.setViews([
            self.yetiiImageView,
            self.yetiiImageViewCaption
            ], toExclusionZoneOfTextView: self.yetiiTextView)

        if !UIDevice.currentDevice().isiOS8OrAbove {
            self.view.layoutSubviews()
        }
    }
}
