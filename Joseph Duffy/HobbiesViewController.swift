//
//  HobbiesViewController.swift
//  Joseph Duffy
//
//  Created by Joseph Duffy on 25/04/2015.
//  Copyright (c) 2015 Yetii Ltd. All rights reserved.
//

import UIKit

class HobbiesViewController: SectionViewController {
    @IBOutlet weak var musicImageView: UIImageView!
    @IBOutlet weak var musicImageViewCaption: UILabel!
    @IBOutlet weak var musicTextField: UITextView!

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.setViews([
            self.musicImageView,
            self.musicImageViewCaption
            ], toExclusionZoneOfTextView: self.musicTextField)

        self.view.layoutSubviews()
    }
}
