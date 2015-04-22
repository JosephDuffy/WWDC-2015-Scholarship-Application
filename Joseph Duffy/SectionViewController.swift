//
//  SectionViewController.swift
//  Joseph Duffy
//
//  Created by Joseph Duffy on 21/04/2015.
//  Copyright (c) 2015 Yetii Ltd. All rights reserved.
//

import UIKit

class SectionViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView?

    var section: AppSection! {
        didSet {
            self.title = self.section.name
            self.view.backgroundColor = self.section.mainColor

            if let textColor = section.textColor {
                self.navigationController?.navigationBar.titleTextAttributes = [
                    NSForegroundColorAttributeName: textColor
                ]
            }

            if let barTintColor = section.barTintColor {
                self.navigationController?.navigationBar.barTintColor = barTintColor
            }
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        self.scrollView?.flashScrollIndicators()
    }

}
