//
//  UIView+Dimensions.swift
//  Joseph Duffy
//
//  Created by Joseph Duffy on 22/04/2015.
//  Copyright (c) 2015 Yetii Ltd. All rights reserved.
//

import UIKit

struct UIViewDimensions {
    let width: CGFloat
    let height: CGFloat
    let isLandscape: Bool
}

extension UIView {
    func getDimensions() -> UIViewDimensions {
        let landscape: Bool
        let viewWidth: CGFloat
        let viewHeight: CGFloat

        if self.window == nil && UIApplication.sharedApplication().statusBarOrientation.isLandscape && (UIDevice.currentDevice().systemVersion as NSString).floatValue < 8 {
            // Have to swap width/height
            println("Getting dimensions without a window")
            landscape = true
            viewWidth = CGRectGetHeight(self.frame)
            viewHeight = CGRectGetWidth(self.frame)
        } else {
            viewWidth = CGRectGetWidth(self.bounds)
            viewHeight = CGRectGetHeight(self.bounds)
            landscape = viewWidth > viewHeight
        }

        return UIViewDimensions(width: viewWidth, height: viewHeight, isLandscape: landscape)
    }
}