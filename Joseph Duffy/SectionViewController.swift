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
    @IBOutlet var labels: [UILabel]?

    /// Any buttons that are part of the section's main content.
    /// Theses buttons will have their text colour changed based on the section
    @IBOutlet var buttons: [UIButton]?

    @IBOutlet var textViews: [UITextView]?

    var movementArrayButtons =  [UIButton]()
    
    var section: AppSection! {
        didSet {
            self.title = self.section.name
            self.view.backgroundColor = self.section.mainColor

            if let textColor = section.textColor {
                if let labels = self.labels {
                    for label in labels {
                        label.textColor = textColor
                    }
                }

                if let textViews = self.textViews {
                    for textView in textViews {
                        textView.textColor = textColor
                    }
                }
            }

            if let barTextColor = section.navigationBarTextColor {
                self.navigationController?.navigationBar.titleTextAttributes = [
                    NSForegroundColorAttributeName: barTextColor
                ]
            }

            if let barTintColor = section.barTintColor {
                self.navigationController?.navigationBar.barTintColor = barTintColor
            }

            if let tintColor = section.tintColor {
                self.navigationController?.navigationBar.tintColor = tintColor

                if let buttons = self.buttons {
                    for button in buttons {
                        button.tintColor = tintColor
                    }
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let textViews = self.textViews {
            for textView in textViews {
                let textContainerInset = textView.textContainerInset
                textView.textContainerInset = UIEdgeInsets(top: 0, left: textContainerInset.left, bottom: 0, right: textContainerInset.right)
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

    /**
    Calculates and sets the exclusion paths of the given UITextView to exclude the given
    views. This meathod is fairly dumb, and assumes the all the views are directly below each other
    and of the same width. This is because, in this application, this method is used to setup the 
    exclusion of an image and its caption from a single text view.
    
    This method will then call the updateFrameForTextView: method, ensuring that the height
    of the supplied UITextView is correct after the exclusion paths have been set
    
    :param: views An array of views to calculate the exclusion paths from
    :param: textView The UITextView that the exclusion paths should be applied to
    */
    func setViews(views: [UIView], toExclusionZoneOfTextView textView: UITextView) {
        if let scrollView = self.scrollView {
            var exclusionPaths = [UIBezierPath]()
            var minWidth: CGFloat?

            for view in views {
                var exclusionRect = scrollView.convertRect(view.frame, toView: textView)
                if let minWidth = minWidth {
                    if exclusionRect.size.width < minWidth {
                        exclusionRect.size.width = minWidth
                    }
                }

                minWidth = exclusionRect.size.width
                let exclusionPath = UIBezierPath(rect: exclusionRect)
                exclusionPaths.append(exclusionPath)
            }

            textView.textContainer.exclusionPaths = exclusionPaths

            self.updateFrameForTextView(textView)
        }
    }

    /// The NSLayoutContstraints to ensure the heights of the UITextViews are correct
    /// These should only be set and updated within the updateFrameForTextView: method
    private var heightConstraintForTextView: [UITextView : NSLayoutConstraint] = [:]

    func updateFrameForTextView(textView: UITextView) {
        if let layoutManager = textView.textContainer.layoutManager {
            textView.textContainer.size = CGSize(width: textView.textContainer.size.width, height: CGFloat.max)

            let contentInset = textView.contentInset
            let textContainerInset = textView.textContainerInset

            let height = layoutManager.usedRectForTextContainer(textView.textContainer).size.height + contentInset.top + textContainerInset.top + contentInset.bottom + textContainerInset.bottom

            let constraintToReturn: NSLayoutConstraint

            if let heightLayoutConstraint = self.heightConstraintForTextView[textView] {
                heightLayoutConstraint.constant = height
            } else {
                let constraint = NSLayoutConstraint(item: textView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: height)
                textView.addConstraint(constraint)

                self.heightConstraintForTextView[textView] = constraint
            }
        }
    }

}
