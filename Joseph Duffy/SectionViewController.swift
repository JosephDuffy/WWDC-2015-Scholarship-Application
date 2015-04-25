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

    @IBOutlet var textViews: [UITextView]?

    var movementArrayButtons =  [UIButton]()
    
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

                if let textViews = self.textViews {
                    for textView in textViews {
                        textView.textColor = textColor
                    }
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

    override func viewDidLoad() {
        super.viewDidLoad()

        if let textViews = self.textViews {
            for textView in textViews {
                let textContainerInset = textView.textContainerInset
//                textView.textContainerInset = UIEdgeInsets(top: textContainerInset.top, left: -4, bottom: textContainerInset.bottom, right: -4)
//                textView.textContainerInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
                textView.textContainerInset = UIEdgeInsetsZero

                let contentInset = textView.contentInset
//                textView.contentInset = UIEdgeInsets(top: contentInset.top, left: 0, bottom: contentInset.bottom, right: 0)
//                textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                textView.contentInset = UIEdgeInsetsZero

                textView.textContainer.lineBreakMode = NSLineBreakMode.ByWordWrapping

//                textView.lin
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

        self.view.layoutSubviews()
    }

    func setViews(views: [UIView], toExclusionZoneOfTextView textView: UITextView) {
        if let scrollView = self.scrollView {
            var exclusionPaths = [UIBezierPath]()

            for view in views {
                let exclusionRect = scrollView.convertRect(view.frame, toView: textView)
                let exclusionPath = UIBezierPath(rect: exclusionRect)
                exclusionPaths.append(exclusionPath)
            }

            textView.textContainer.exclusionPaths = exclusionPaths

            self.updateFrameForTextView(textView)
        }
    }

    private var heightConstraintForTextView: [UITextView : NSLayoutConstraint] = [:]

    func updateFrameForTextView(textView: UITextView) {
        //        textView.setNeedsLayout()
        //        textView.layoutIfNeeded()

//        println("==== Setting container size =====")
//        println("Container size: \(textView.textContainer.size)")
//        println("Frame: \(textView.frame)")

        //        var textViewFrame = textView.frame
        //        textViewFrame.size.height = max(textView.frame.size.height, textView.textContainer.size.height) + textView.contentInset.top + textView.contentInset.bottom
        //        textView.frame = textViewFrame

        textView.textContainer.size = CGSize(width: textView.textContainer.size.width, height: CGFloat.max)

        //        textView.setNeedsLayout()
        //        textView.layoutIfNeeded()

        if let layoutManager = textView.textContainer.layoutManager {
//            layoutManager.glyphRangeForTextContainer(textView.textContainer)
            let sillyExtraConstant: CGFloat = 10

            let contentInset = textView.contentInset
            let textContainerInset = textView.textContainerInset

            let height = layoutManager.usedRectForTextContainer(textView.textContainer).size.height + textView.contentInset.top + textView.contentInset.bottom + sillyExtraConstant
            let height2 = textView.frame.size.height + textView.contentInset.top + textView.contentInset.bottom + sillyExtraConstant
            let height3 = max(layoutManager.usedRectForTextContainer(textView.textContainer).size.height, textView.frame.size.height) + textView.contentInset.top + textView.contentInset.bottom + sillyExtraConstant
            let height4 = layoutManager.usedRectForTextContainer(textView.textContainer).size.height + contentInset.top + textContainerInset.top + contentInset.bottom + textContainerInset.bottom
//            println("Height: \(height); height 2: \(height2); height 3: \(height3); height4: \(height4)")

//            println("Calced height: \(height)")

            let constraintToReturn: NSLayoutConstraint

            if let heightLayoutConstraint = self.heightConstraintForTextView[textView] {
                heightLayoutConstraint.constant = height4
            } else {
                let constraint = NSLayoutConstraint(item: textView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: height4)
                textView.addConstraint(constraint)

                self.heightConstraintForTextView[textView] = constraint
            }

            textView.sizeToFit()

            //            textView.setNeedsLayout()
            //            textView.layoutIfNeeded()
            //
            //            textView.setNeedsUpdateConstraints()
            //            textView.updateConstraintsIfNeeded()
            //
            //            textView.setNeedsLayout()
            //            textView.layoutIfNeeded()
            
//            println("Frame after: \(textView.frame)")
//            println("==== Finished Setting container size =====")
        }
    }

}
