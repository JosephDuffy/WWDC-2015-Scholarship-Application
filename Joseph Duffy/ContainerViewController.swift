//
//  ContainerViewController.swift
//  Joseph Duffy
//
//  Created by Joseph Duffy on 20/04/2015.
//  Copyright (c) 2015 Yetii Ltd. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var scollView: SectionedScrollView!
    var initialIndex: Int?

    private var viewControllers: [UIViewController]?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let storyboard = self.storyboard {
            var viewControllers = [UIViewController]()
            var views = [UIView]()

            for section in AppSection.allAppSections {
                let storyboardId = section.roorViewControllerStoryboardId
                let rootViewController = storyboard.instantiateViewControllerWithIdentifier(storyboardId) as! UINavigationController
                let contentViewController = rootViewController.viewControllers.first as! SectionViewController

                contentViewController.section = section

                viewControllers.append(rootViewController)
                views.append(rootViewController.view)
                self.addChildViewController(rootViewController)
            }

            self.viewControllers = viewControllers

            self.scollView.initialIndex = self.initialIndex
            self.scollView.setup(views)
            self.scollView.delegate = self

            var minScale = min(self.view.frame.size.width / self.view.frame.size.height, self.view.frame.size.height / self.view.frame.size.width)
            if minScale > 0.5 {
                minScale = 1 - minScale
            }
            println("Min scale: \(minScale)")

            self.scollView.minimumZoomScale = 0.4
//            self.scollView.setZoomScale(0.5, animated: false)

            UIApplication.sharedApplication().statusBarHidden = true
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

//        if self.scollView.zoomScale != 1 {
//            self.scollView.bounces = true
//            self.scollView.setZoomScale(1, animated: true)
//            self.scollView.bounces = false
//        }
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

    // MARK: Zooming

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return scollView.subviews.first as? UIView
    }

    private var performedSegue = false
    func scrollViewDidZoom(scrollView: UIScrollView) {
        // Setting bounces to true allows for the "outside" of the scroll
        // view to be visible when zooming. When bounces is set to false and
        // the user zooms, it'll be restricted to the top and left sides
        scrollView.bounces = true

        if !self.performedSegue {
            if scrollView.zoomScale < scrollView.minimumZoomScale {
                self.performUnwindSegue()
            }
        }
    }

    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView!, atScale scale: CGFloat) {
        println("Ended zooming")
        if scale > 0.6 {
            scrollView.setZoomScale(1, animated: true)
            scrollView.bounces = false
        } else {
            self.performUnwindSegue()
        }
    }

    private func performUnwindSegue() {
        println("Popping")
        // Reset the delegate so the scroll view doesn't capture self and
        // try and continue sending delegate calls
        self.scollView.delegate = nil
        self.performedSegue = true
        self.performSegueWithIdentifier("returnToIntro", sender: self)
    }

}
