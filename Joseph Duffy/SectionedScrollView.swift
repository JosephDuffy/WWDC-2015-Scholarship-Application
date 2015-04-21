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

//    func setup(sectionViewControllers: [UIViewController]) {
//        self.pagingEnabled = true
//        self.bounces = false
//        self.showsHorizontalScrollIndicator = false
//        self.showsVerticalScrollIndicator = false
//
//        self.addSubview(self.containerView)
//
//        self.sectionViewControllers = sectionViewControllers
//        self.delegate = self
//
//        self.setNeedsLayout()
//        self.layoutIfNeeded()
//    }

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
//        if let sectionViewControllers = self.sectionViewControllers where self.needsLayout {
            let isLandscape = UIDevice.currentDevice().orientation.isLandscape

            let frameWidth = CGRectGetWidth(self.frame)
            let frameHeight = CGRectGetHeight(self.frame)

            println("Landscape: \(isLandscape)")

            if sectionViews.count > 2 && isLandscape {
                self.rows = 3
            } else if sectionViews.count > 1 {
                self.rows = 2
            } else if sectionViews.count > 0 {
                self.rows = 1
            } else {
                self.rows = 0
            }

            if isLandscape {
                self.columns = Int(ceil(Double(sectionViews.count) / 3.0))
            } else {
                self.columns = Int(ceil(Double(sectionViews.count) / 2.0))
            }

            println("Rows: \(self.rows)")
            println("Columns: \(self.columns)")

            let size = CGSize(width: frameWidth * CGFloat(self.rows), height: frameHeight * CGFloat(self.columns))
            self.containerView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
            self.contentSize = size

            println("Size: \(size)")

            for (index, sectionView) in enumerate(sectionViews) {
                let xMultiplier: CGFloat = CGFloat(index % self.rows)
                let yMultiplier: CGFloat = CGFloat(floor(Double(index) / Double(self.rows)))

                let sectionViewFrame = CGRect(x: frameWidth * xMultiplier, y: frameHeight * yMultiplier, width: self.frame.size.width, height: self.frame.size.height)
                sectionView.frame = sectionViewFrame

                self.containerView.addSubview(sectionView)
            }

            if let initialIndex = self.initialIndex {
                let offset = self.offsetForIndex(initialIndex)
                println("Offset: \(offset)")

                self.contentOffset = offset
            }

            self.needsLayout = false
        }
    }

    func offsetForIndex(index: Int) -> CGPoint {
        let frameWidth = CGRectGetWidth(self.frame)
        let frameHeight = CGRectGetHeight(self.frame)

        println("Index: \(index)")
        println(self.frame)

        let indexAsDouble = Double(index)

        return CGPoint(x: frameWidth * CGFloat(index % self.rows), y: frameHeight * CGFloat(floor(Double(index) / Double(self.rows))))
    }

//    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
//        return self
//    }

}
