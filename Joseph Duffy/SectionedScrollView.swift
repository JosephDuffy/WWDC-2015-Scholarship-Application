//
//  SectionedScrollView.swift
//  Joseph Duffy
//
//  Created by Joseph Duffy on 20/04/2015.
//  Copyright (c) 2015 Yetii Ltd. All rights reserved.
//

import UIKit

class SectionedScrollView: UIScrollView, UIScrollViewDelegate {
    private(set) var sectionViews: [UIView]? {
        didSet {
            self.needsLayout = true
        }
    }
    private(set) var sectionViewControllers: [UIViewController]? {
        didSet {
            self.needsLayout = true
        }
    }
    var needsLayout = false
    var initialIndex: Int?
    private(set) var currentIndex = 0
    private(set) var columns = 0
    private(set) var rows = 0

    let containerView = UIView()

    func setup(sectionViews: [UIView]) {
        self.pagingEnabled = true
        self.bounces = false
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false

        self.addSubview(self.containerView)

        self.sectionViews = sectionViews
        self.delegate = self
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }

    private var movingHorizontally = false
    private var horizontalStartingX: CGFloat = 0

    func moveHorizontally(percent: Double) {
        let viewWidth = CGRectGetWidth(self.frame)
        let currentPage = floor(self.contentOffset.x / viewWidth)
        let pageOffset = currentPage * viewWidth

        if percent < 0 {
            // Move view to right
        } else if percent >= 0 {
            // Move view to left
            let multiplyer = CGFloat(percent/50)
            let extraOffset = multiplyer * viewWidth
            println("Moving to the left")
            var contentOffset = self.contentOffset

            if multiplyer <= 0.2 {
                // Reset
                println("Reseting")
                contentOffset.x = pageOffset
            } else if multiplyer <= 0.65 {
                contentOffset.x = pageOffset + extraOffset
            } else {
                println("Hit edge!")
                contentOffset.x = pageOffset + viewWidth
            }

            if contentOffset.x > viewWidth {
                contentOffset.x = viewWidth
            }

//            UIView.animateWithDuration(0.1, animations: { () -> Void in
                self.contentOffset = contentOffset
//            })
        }
    }

    override func layoutSubviews() {
        if let sectionViews = self.sectionViews where self.needsLayout {
            let isLandscape = UIApplication.sharedApplication().statusBarOrientation.isLandscape

            let frameWidth = CGRectGetWidth(self.frame)
            let frameHeight = CGRectGetHeight(self.frame)

            if sectionViews.count > 2 && isLandscape {
                self.columns = 3
            } else if sectionViews.count > 1 {
                self.columns = 2
            } else if sectionViews.count > 0 {
                self.columns = 1
            } else {
                self.columns = 0
            }

            if isLandscape {
                self.rows = Int(ceil(Double(sectionViews.count) / 3.0))
            } else {
                self.rows = Int(ceil(Double(sectionViews.count) / 2.0))
            }

            let size = CGSize(width: frameWidth * CGFloat(self.columns), height: frameHeight * CGFloat(self.rows))
            self.containerView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
            self.contentSize = size

            for (index, sectionView) in enumerate(sectionViews) {
                let xMultiplier: CGFloat = CGFloat(index % self.columns)
                let yMultiplier: CGFloat = CGFloat(floor(Double(index) / Double(self.columns)))

                let sectionViewFrame = CGRect(x: frameWidth * xMultiplier, y: frameHeight * yMultiplier, width: self.frame.size.width, height: self.frame.size.height)
                sectionView.frame = sectionViewFrame

                self.containerView.addSubview(sectionView)
            }

            if let initialIndex = self.initialIndex {
                let offset = self.offsetForIndex(initialIndex)
                self.contentOffset = offset

                // Enable bounces so the zoom will go outside of the overall view
//                self.bounces = true
//                self.bouncesZoom = false

//                self.setZoomScale(self.minimumZoomScale, animated: false)
//                println(self.contentOffset)
//                self.setZoomScale(1, animated: true)

//                self.transform = CGAffineTransformMakeScale(self.minimumZoomScale, self.minimumZoomScale)
//
//                UIView.animateWithDuration(1, animations: { () -> Void in
//                    self.transform = CGAffineTransformIdentity
//                })
            }

//            if self.zoomScale != 1 {
//                let zoomScale = self.zoomScale
//                self.setZoomScale(1, animated: false)
//                self.bounces = true
//
//                if let initialIndex = self.initialIndex {
//                    self.contentOffset = self.offsetForIndex(initialIndex)
//                }
//                println(self.contentOffset)
////                self.contentOffset = CGPoint(x: self.contentOffset.x - (frameWidth * zoomScale), y: self.contentOffset.y - (frameHeight * zoomScale))
////                println(self.contentOffset)
//                self.setZoomScale(zoomScale, animated: false)
//                self.setZoomScale(1, animated: true)
////                self.bounces = false
//            }

            self.needsLayout = false
        }
    }

    func offsetForIndex(index: Int) -> CGPoint {
        let frameWidth = CGRectGetWidth(self.frame)
        let frameHeight = CGRectGetHeight(self.frame)

        let indexAsDouble = Double(index)

        return CGPoint(x: frameWidth * CGFloat(index % self.columns), y: frameHeight * CGFloat(floor(Double(index) / Double(self.columns))))
    }

}
