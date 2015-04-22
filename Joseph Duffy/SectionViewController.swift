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
    /// Any labels that are part of the section's main content.
    /// These labels will have their text colour changed based on the section
    @IBOutlet var labels: [UILabel]!

    /// Any buttons that are part of the section's main content.
    /// Theses buttons will have their text colour changed based on the section
    @IBOutlet var buttons: [UIButton]!
    
    var section: AppSection! {
        didSet {
            self.title = self.section.name
            self.view.backgroundColor = self.section.mainColor

            if let textColor = section.textColor {
                self.navigationController?.navigationBar.titleTextAttributes = [
                    NSForegroundColorAttributeName: textColor
                ]

                for label in self.labels {
                    label.textColor = textColor
                }
            }

            if let barTintColor = section.barTintColor {
                self.navigationController?.navigationBar.barTintColor = barTintColor
            }

            if let tintColor = section.tintColor {
                self.navigationController?.navigationBar.tintColor = tintColor

                for button in self.buttons {
                    button.tintColor = tintColor
                }
            }
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        self.scrollView?.flashScrollIndicators()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // This will ensure that all the labels have resized to fit their content correctly
        if let labels = self.labels {
            for label in labels {
                label.preferredMaxLayoutWidth = label.frame.size.width
                label.sizeToFit()
            }
        }
    }

}
