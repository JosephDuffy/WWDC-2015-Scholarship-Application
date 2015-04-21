//
//  BlurStoryboardSegue.swift
//  Joseph Duffy
//
//  Created by Joseph Duffy on 20/04/2015.
//  Copyright (c) 2015 Yetii Ltd. All rights reserved.
//

import UIKit

class BlurStoryboardSegue: UIStoryboardSegue {
    override func perform() {
        var firstVCView = destinationViewController.view as UIView!
        var thirdVCView = sourceViewController.view as UIView!

        thirdVCView.frame = firstVCView.frame

        // Get a snapshot of both views
        UIGraphicsBeginImageContextWithOptions(firstVCView.frame.size, false, 0)
        firstVCView.drawViewHierarchyInRect(firstVCView.bounds, afterScreenUpdates: true)
        let firstViewImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        UIGraphicsBeginImageContextWithOptions(thirdVCView.frame.size, false, 0)
        thirdVCView.drawViewHierarchyInRect(thirdVCView.bounds, afterScreenUpdates: true)
        let thirdViewImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        let firstViewImageView = UIImageView(image: firstViewImage)
        firstViewImageView.frame = firstVCView.frame

        // Animate the current view to become blurred
        let gaussianBlurFilter = CIFilter(name: "CIGaussianBlur")
        gaussianBlurFilter.setValue(firstViewImage.CIImage, forKey: kCIInputImageKey)
        gaussianBlurFilter.setValue(NSNumber(float: 0.0), forKey: "inputRadius")

        let firstViewBlurInAnimation = CABasicAnimation()
        firstViewBlurInAnimation.keyPath = "filters.blur.inputRadius"
        firstViewBlurInAnimation.fromValue = NSNumber(float: 0.0)
        firstViewBlurInAnimation.toValue = NSNumber(float: 10.0)
        firstViewBlurInAnimation.duration = 5

        firstViewImageView.layer.filters = [gaussianBlurFilter]
        firstViewImageView.layer.addAnimation(firstViewBlurInAnimation, forKey: "blurAnimation")

        let screenHeight = UIScreen.mainScreen().bounds.size.height

        firstVCView.frame = CGRectOffset(firstVCView.frame, 0.0, screenHeight)
        firstVCView.transform = CGAffineTransformScale(firstVCView.transform, 0.001, 0.001)

        let window = UIApplication.sharedApplication().keyWindow
        window?.insertSubview(firstVCView, aboveSubview: thirdVCView)

        UIView.animateWithDuration(0.5, animations: { () -> Void in

            thirdVCView.transform = CGAffineTransformScale(thirdVCView.transform, 0.001, 0.001)
            thirdVCView.frame = CGRectOffset(thirdVCView.frame, 0.0, -screenHeight)

            firstVCView.transform = CGAffineTransformIdentity
            firstVCView.frame = CGRectOffset(firstVCView.frame, 0.0, -screenHeight)

            }) { (Finished) -> Void in
                
                self.sourceViewController.dismissViewControllerAnimated(false, completion: nil)
        }
    }
}
