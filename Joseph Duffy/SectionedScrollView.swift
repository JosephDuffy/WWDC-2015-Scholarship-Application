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
            self.sectionsNeedResizing = true
        }
    }

    var sectionsNeedResizing = false

    var currentIndex: Int {
        get {
            let dimensions = self.getDimensions()

            let column = Int(round(self.contentOffset.x / dimensions.width))
            let row = Int(round(self.contentOffset.y / dimensions.height))

            return (row * self.columns) + column
        }
    }
    private(set) var columns = 0
    private(set) var rows = 0

    let containerView = UIView()

    func setup(sectionViews: [UIView]) {
        self.pagingEnabled = true
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false

        self.addSubview(self.containerView)
        for sectionView in sectionViews {
            self.containerView.addSubview(sectionView)
        }

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
        super.layoutSubviews()

//        println("Layout subviews")

        if let sectionViews = self.sectionViews where self.sectionsNeedResizing {
            println("Laying out subviews")

            let dimensions = self.getDimensions()

            if sectionViews.count > 2 && dimensions.isLandscape {
                self.columns = 3
            } else if sectionViews.count > 1 {
                self.columns = 2
            } else if sectionViews.count > 0 {
                self.columns = 1
            } else {
                self.columns = 0
            }

            if dimensions.isLandscape {
                self.rows = Int(ceil(Double(sectionViews.count) / 3.0))
            } else {
                self.rows = Int(ceil(Double(sectionViews.count) / 2.0))
            }

            let size = CGSize(width: dimensions.width * CGFloat(self.columns), height: dimensions.height * CGFloat(self.rows))
            self.containerView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
            self.contentSize = size

            for (index, sectionView) in enumerate(sectionViews) {
                let xMultiplier: CGFloat = CGFloat(index % self.columns)
                let yMultiplier: CGFloat = CGFloat(floor(Double(index) / Double(self.columns)))

                let sectionViewFrame = CGRect(x: dimensions.width * xMultiplier, y: dimensions.height * yMultiplier, width: dimensions.width, height: dimensions.height)
                sectionView.frame = sectionViewFrame
            }

            if self.contentOffset.x % dimensions.width != 0 || self.contentOffset.y % dimensions.height != 0 {
                println("Offset was incorrect")
                let correctContentOffset = self.offsetForIndex(self.currentIndex)
                self.contentOffset = correctContentOffset
            }

            self.sectionsNeedResizing = false
        }
    }

    func offsetForIndex(index: Int) -> CGPoint {
        let dimensions = self.getDimensions()

        let indexAsDouble = Double(index)

        return CGPoint(x: dimensions.width * CGFloat(index % self.columns), y: dimensions.height * CGFloat(floor(Double(index) / Double(self.columns))))
    }

}
