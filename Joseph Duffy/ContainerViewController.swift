//
//  ContainerViewController.swift
//  Joseph Duffy
//
//  Created by Joseph Duffy on 20/04/2015.
//  Copyright (c) 2015 Yetii Ltd. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var scollView: UIScrollView!
    private(set) var containerView: UIView!

    var indexToShow: Int?
    // The index of the section to be shown when the next layout pass completes
    private(set) var sectionIndexToShow: Int?
    private(set) var sectionViewControllerToShow: UIViewController?

    private var sectionViewControllers: [UIViewController]?
    var sectionsNeedResizing = false

    var currentIndex: Int {
        get {
            let dimensions = self.scollView.getDimensions()

            let column = Int(round(self.scollView.contentOffset.x / dimensions.width))
            let row = Int(round(self.scollView.contentOffset.y / dimensions.height))

            return (row * self.columns) + column
        }
    }
    private(set) var columns = 0
    private(set) var rows = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        if let storyboard = self.storyboard {
            self.containerView = UIView()
            self.scollView.addSubview(self.containerView)

            var viewControllers = [UIViewController]()
            var views = [UIView]()

            for section in AppSection.allAppSections {
                let storyboardId = section.roorViewControllerStoryboardId
                let rootViewController = storyboard.instantiateViewControllerWithIdentifier(storyboardId) as! UINavigationController
                let contentViewController = rootViewController.viewControllers.first as! SectionViewController

                contentViewController.section = section

                self.addChildViewController(rootViewController)

                self.containerView.addSubview(rootViewController.view)

                viewControllers.append(rootViewController)
//                views.append(rootViewController.view)
            }

            self.sectionViewControllers = viewControllers

//            self.scollView.setup(views)
            self.sectionIndexToShow = self.indexToShow
            self.sectionsNeedResizing = true
            self.scollView.delegate = self

            self.scollView.pagingEnabled = true
            self.scollView.showsHorizontalScrollIndicator = false
            self.scollView.showsVerticalScrollIndicator = false

            var minScale = min(self.view.frame.size.width / self.view.frame.size.height, self.view.frame.size.height / self.view.frame.size.width)
            if minScale > 0.5 {
                minScale = 1 - minScale
            }

            // Calculate rows and columns
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
            self.view.layoutSubviews()

            self.scollView.minimumZoomScale = 0.4

            UIApplication.sharedApplication().statusBarHidden = true
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if let sectionViewControllerToShow = self.sectionViewControllerToShow {
            if let navigationBar = (sectionViewControllerToShow as? UINavigationController)?.navigationBar {
                UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, navigationBar)
            }
            self.sectionViewControllerToShow = nil
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let sectionViewControllers = self.sectionViewControllers where self.sectionsNeedResizing {
            println("Laying out subviews")

            let dimensions = self.scollView.getDimensions()

            if sectionViewControllers.count > 2 && dimensions.isLandscape {
                self.columns = 3
            } else if sectionViewControllers.count > 1 {
                self.columns = 2
            } else if sectionViewControllers.count > 0 {
                self.columns = 1
            } else {
                self.columns = 0
            }

            if dimensions.isLandscape {
                self.rows = Int(ceil(Double(sectionViewControllers.count) / 3.0))
            } else {
                self.rows = Int(ceil(Double(sectionViewControllers.count) / 2.0))
            }

            let size = CGSize(width: dimensions.width * CGFloat(self.columns), height: dimensions.height * CGFloat(self.rows))
            self.containerView.frame = CGRect(origin: CGPointZero, size: size)
            self.scollView.contentSize = size

            for (index, sectionViewController) in enumerate(sectionViewControllers) {
                let sectionView = sectionViewController.view
                let xMultiplier = index % self.columns
                let yMultiplier = Int(floor(Double(index) / Double(self.columns)))

                let sectionViewFrame = CGRect(x: dimensions.width * CGFloat(xMultiplier), y: dimensions.height * CGFloat(yMultiplier), width: dimensions.width, height: dimensions.height)
                sectionView.frame = sectionViewFrame

                let changeSectionButtonThickness: CGFloat = 30
                let changeSectionButtonSizeMultiplier: CGFloat = 0.6

                if xMultiplier > 0 {
                    let button = UIButton()
                    button.setTranslatesAutoresizingMaskIntoConstraints(false)
                    button.addTarget(self, action: "moveOneSectionLeft", forControlEvents: .TouchUpInside)

                    sectionView.addSubview(button)
                    sectionView.addConstraints([
                        NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: sectionView, attribute: .Left, multiplier: 1, constant: 0),
                        NSLayoutConstraint(item: button, attribute: .CenterY, relatedBy: .Equal, toItem: sectionView, attribute: .CenterY, multiplier: 1, constant: 0),
                        NSLayoutConstraint(item: button, attribute: .Height, relatedBy: .Equal, toItem: sectionView, attribute: .Height, multiplier: changeSectionButtonSizeMultiplier, constant: 0),
                        NSLayoutConstraint(item: button, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: changeSectionButtonThickness)
                        ])
                    sectionView.bringSubviewToFront(button)
                }

                if xMultiplier < (self.columns - 1) {
                    let button = UIButton()
                    button.setTranslatesAutoresizingMaskIntoConstraints(false)
                    button.addTarget(self, action: "moveOneSectionRight", forControlEvents: .TouchUpInside)

                    sectionView.addSubview(button)
                    sectionView.addConstraints([
                        NSLayoutConstraint(item: button, attribute: .Right, relatedBy: .Equal, toItem: sectionView, attribute: .Right, multiplier: 1, constant: 0),
                        NSLayoutConstraint(item: button, attribute: .CenterY, relatedBy: .Equal, toItem: sectionView, attribute: .CenterY, multiplier: 1, constant: 0),
                        NSLayoutConstraint(item: button, attribute: .Height, relatedBy: .Equal, toItem: sectionView, attribute: .Height, multiplier: changeSectionButtonSizeMultiplier, constant: 0),
                        NSLayoutConstraint(item: button, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: changeSectionButtonThickness)
                        ])
                    sectionView.bringSubviewToFront(button)
                }

                if yMultiplier < (self.rows - 1) {
                    let button = UIButton()
                    button.setTranslatesAutoresizingMaskIntoConstraints(false)
                    button.addTarget(self, action: "moveOneSectionDown", forControlEvents: .TouchUpInside)

                    sectionView.addSubview(button)
                    sectionView.addConstraints([
                        NSLayoutConstraint(item: button, attribute: .Bottom, relatedBy: .Equal, toItem: sectionView, attribute: .Bottom, multiplier: 1, constant: 0),
                        NSLayoutConstraint(item: button, attribute: .CenterX, relatedBy: .Equal, toItem: sectionView, attribute: .CenterX, multiplier: 1, constant: 0),
                        NSLayoutConstraint(item: button, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: changeSectionButtonThickness),
                        NSLayoutConstraint(item: button, attribute: .Width, relatedBy: .Equal, toItem: sectionView, attribute: .Width, multiplier: changeSectionButtonSizeMultiplier, constant: 0)
                        ])
                }

                if yMultiplier > 0 {
                    let button = UIButton()
                    button.setTranslatesAutoresizingMaskIntoConstraints(false)
                    button.addTarget(self, action: "moveOneSectionUp", forControlEvents: .TouchUpInside)

                    sectionView.addSubview(button)
                    sectionView.addConstraints([
                        NSLayoutConstraint(item: button, attribute: .Top, relatedBy: .Equal, toItem: sectionView, attribute: .Top, multiplier: 1, constant: 0),
                        NSLayoutConstraint(item: button, attribute: .CenterX, relatedBy: .Equal, toItem: sectionView, attribute: .CenterX, multiplier: 1, constant: 0),
                        NSLayoutConstraint(item: button, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: changeSectionButtonThickness),
                        NSLayoutConstraint(item: button, attribute: .Width, relatedBy: .Equal, toItem: sectionView, attribute: .Width, multiplier: changeSectionButtonSizeMultiplier, constant: 0)
                        ])
                    sectionView.bringSubviewToFront(button)
                }
            }

            if let sectionIndexToShow = self.sectionIndexToShow {
                self.scollView.contentOffset = self.offsetForIndex(sectionIndexToShow)
                self.sectionIndexToShow = nil
                if sectionViewControllers.count > sectionIndexToShow {
                    self.sectionViewControllerToShow = sectionViewControllers[sectionIndexToShow]
                }
            } else if self.scollView.contentOffset.x % dimensions.width != 0 || self.scollView.contentOffset.y % dimensions.height != 0 {
                println("Offset was incorrect")
                let correctContentOffset = self.offsetForIndex(self.currentIndex)
                self.scollView.contentOffset = correctContentOffset
            }

            self.sectionsNeedResizing = false

            self.view.layoutSubviews()
        }
    }

    func moveOneSectionLeft() {
        var contentOffset = self.scollView.contentOffset
        contentOffset.x -= self.scollView.getDimensions().width
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.scollView.contentOffset = contentOffset
        })
    }

    func moveOneSectionUp() {
        var contentOffset = self.scollView.contentOffset
        contentOffset.y -= self.scollView.getDimensions().height
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.scollView.contentOffset = contentOffset
        })
    }

    func moveOneSectionRight() {
        var contentOffset = self.scollView.contentOffset
        contentOffset.x += self.scollView.getDimensions().width
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.scollView.contentOffset = contentOffset
        })
    }

    func moveOneSectionDown() {
        var contentOffset = self.scollView.contentOffset
        contentOffset.y += self.scollView.getDimensions().height
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.scollView.contentOffset = contentOffset
        })
    }
    
    func offsetForIndex(index: Int) -> CGPoint {
        if self.columns > 0 && self.rows > 0 {
            let dimensions = self.scollView.getDimensions()
            let indexAsDouble = Double(index)

            return CGPoint(x: dimensions.width * CGFloat(index % self.columns), y: dimensions.height * CGFloat(floor(Double(index) / Double(self.columns))))
        } else {
            println("Tried to get offset with no columns or no rows")
            return CGPointZero
        }
    }


//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)

//        if self.scollView.zoomScale != 1 {
//            self.scollView.bounces = true
//            self.scollView.setZoomScale(1, animated: true)
//            self.scollView.bounces = false
//        }


//        self.scollView.setZoomScale(1, animated: false)
//
//        // Enable bounces so the zoom will go outside of the overall view
//        self.scollView.bounces = true
//        UIView.animateWithDuration(1, animations: { () -> Void in
//            self.scollView.setZoomScale(self.scollView.minimumZoomScale, animated: false)
//        }) { (com) -> Void in
//            if com {
//                UIView.animateWithDuration(1, animations: { () -> Void in
//                    self.scollView.setZoomScale(1, animated: false)
//                    }, completion: { (completed) -> Void in
//                        if completed {
//                            self.scollView.bounces = false
//                        }
//                })
//            }
//        }
//    }

    override func shouldAutorotate() -> Bool {
        return false
    }

//    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
//        super.willRotateToInterfaceOrientation(toInterfaceOrientation, duration: duration)
//
//        self.scollView.sectionsNeedResizing = true
//    }
//
//    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
//        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
//
//        self.scollView.sectionsNeedResizing = true
//    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

//    override func supportedInterfaceOrientations() -> Int {
//        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
//            return Int(UIInterfaceOrientationMask.LandscapeLeft.rawValue | UIInterfaceOrientationMask.LandscapeRight.rawValue)
//        } else {
//            return Int(UIInterfaceOrientationMask.Portrait.rawValue)
//        }
//    }

    // MARK: Zooming

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.containerView
    }

    private var performedSegue = false
    func scrollViewDidZoom(scrollView: UIScrollView) {
        if !self.performedSegue {
            if scrollView.zoomScale < scrollView.minimumZoomScale {
                self.performUnwindSegue()
            }
        }
    }

    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView!, atScale scale: CGFloat) {
        if scale < 1 {
            if scale > 0.6 {
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    scrollView.setZoomScale(1, animated: false)
                }, completion: { (finished) -> Void in
                    if finished {
                        let index = self.currentIndex
                        let correctContentOffset = self.offsetForIndex(index)

                        if !CGPointEqualToPoint(scrollView.contentOffset, correctContentOffset) {
                            println("Correcting from content offset \(scrollView.contentOffset) to \(correctContentOffset)")
                            scrollView.contentOffset = correctContentOffset
                        }
                    }
                })
            } else {
                self.performUnwindSegue()
            }
        }
    }

    private func performUnwindSegue() {
        // Reset the delegate so the scroll view doesn't capture self and
        // try and continue sending delegate calls
        self.scollView.delegate = nil
        self.performedSegue = true
        self.performSegueWithIdentifier("returnToIntro", sender: self)
    }

    override func accessibilityPerformMagicTap() -> Bool {
        self.performUnwindSegue()

        return true
    }

}
