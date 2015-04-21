//
//  ContainerViewController.swift
//  Joseph Duffy
//
//  Created by Joseph Duffy on 20/04/2015.
//  Copyright (c) 2015 Yetii Ltd. All rights reserved.
//

import UIKit
import CoreMotion

class ContainerViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var scollView: SectionedScrollView!
    var initialIndex: Int?

    private var viewControllers: [UIViewController]?

    // Movement via the accelerometer
    private var motionManager: CMMotionManager?
    private var startingAcceleration: CMAcceleration?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let storyboard = self.storyboard {
            var viewControllers = [UIViewController]()
            var views = [UIView]()

            for section in AppSection.allAppSections {
                let rootViewController = storyboard.instantiateViewControllerWithIdentifier("SectionRootViewController") as! UINavigationController
                let contentViewController = rootViewController.viewControllers.first as! UIViewController

                contentViewController.title = section.name
                contentViewController.view.backgroundColor = section.mainColor

                viewControllers.append(rootViewController)
                views.append(rootViewController.view)
                self.addChildViewController(rootViewController)
            }

            self.viewControllers = viewControllers

            self.scollView.initialIndex = self.initialIndex
            self.scollView.setup(views)
            self.scollView.delegate = self

            self.scollView.minimumZoomScale = 0.5

            UIApplication.sharedApplication().statusBarHidden = true
        }
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            return Int(UIInterfaceOrientationMask.LandscapeLeft.rawValue | UIInterfaceOrientationMask.LandscapeRight.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.Portrait.rawValue)
        }
    }

    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        println("Updating scroll view")
        self.scollView.needsLayout = true
        self.scollView.setNeedsLayout()
        self.scollView.layoutIfNeeded()
    }

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        println("Updating scroll view")
        self.scollView.needsLayout = true
        self.scollView.setNeedsLayout()
        self.scollView.layoutIfNeeded()
    }

    private func accelerometerGotNewData(data: CMAccelerometerData!, error: NSError!) {
        let acceleration = data.acceleration

        let xPercentMoved = acceleration.x * 100
        println("x %: \(xPercentMoved)")

        self.scollView.moveHorizontally(xPercentMoved)
    }

    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        println("Viewbeing drag")

        self.motionManager?.stopAccelerometerUpdates()
    }

    // MARK: Zooming

    private var performedSegue = false
    func scrollViewDidZoom(scrollView: UIScrollView) {


//        println("Zoomed: \(scrollView.zoomScale)")
        if !self.performedSegue {
            if scrollView.zoomScale < 0.4 {
                println("Popping")
                // Reset the delegate so the scroll view doesn't capture self and
                // try and continue sending delegate calls
                scrollView.delegate = nil
                self.performedSegue = true
                self.performSegueWithIdentifier("returnToIntro", sender: self)
            }
        }
    }

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return scollView.subviews.first as? UIView
    }

    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView!, atScale scale: CGFloat) {
        println("Ended zooming")
        if scale > 0.6 {
            scrollView.setZoomScale(1, animated: true)
        } else {
            scrollView.delegate = nil
            self.performedSegue = true
            self.performSegueWithIdentifier("returnToIntro", sender: self)
        }
    }

    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        println("Did end: \(decelerate)")

        if !decelerate {
            self.motionManager?.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: self.accelerometerGotNewData)
        }
    }

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        println("Did end decelerating")

        println((self.scollView.subviews.first as? UIView)?.frame)
        println((self.scollView.subviews.first as? UIView)?.bounds)

        self.updateScrollViewCenter()

        self.motionManager?.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: self.accelerometerGotNewData)
    }

    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        println("Did end scrolling")

        println((self.scollView.subviews.first as? UIView)?.frame)
        println((self.scollView.subviews.first as? UIView)?.bounds)

        self.updateScrollViewCenter()

        self.motionManager?.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: self.accelerometerGotNewData)
    }

    private func updateScrollViewCenter() {
        if let subview = self.scollView.subviews.first as? UIView {
            let pointX = scollView.center.x + scollView.contentOffset.x
            let pointY = scollView.center.y + scollView.contentOffset.y

            let anchorPoint = CGPoint(x: scollView.frame.height / pointX, y: scollView.frame.width / pointY)
//            subview.layer.anchorPoint = anchorPoint

            let pinchedCenter = CGPoint(x: scollView.center.x + scollView.contentOffset.x, y: scollView.center.y + scollView.contentOffset.y)
//            println(pinchedCenter)
//            subview.layer.anchorPoint = pinchedCenter
//            subview.center = pinchedCenter

            //            let bounds = scrollView.bounds
            //            let contentSize = scrollView.contentSize
            //
            //            let offsetX = max((bounds.size.width - contentSize.width) * 0.5, 0.0)
            //            let offsetY = max((bounds.size.height - contentSize.height) * 0.5, 0.0)
            //
            //            subview.center = CGPoint(x: contentSize.width * 0.5 + offsetX, y: contentSize.height * 0.5 + offsetY)
        }
    }

    deinit {
        self.motionManager?.stopAccelerometerUpdates()
    }

}
