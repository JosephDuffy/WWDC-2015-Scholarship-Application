//
//  HomeCollectionViewController.swift
//  Joseph Duffy
//
//  Created by Joseph Duffy on 15/04/2015.
//  Copyright (c) 2015 Yetii Ltd. All rights reserved.
//

import UIKit

let reuseIdentifier = "Cell"

class HomeCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    struct ImageViewCurveFunctionToApply {
        weak var imageView: UIImageView?
        let function: ImageViewCurveFunction

        init(imageView: UIImageView, function: ImageViewCurveFunction) {
            self.imageView = imageView
            self.function = function
        }
    }

    private var imageViewCurveFunctions: [ImageViewCurveFunctionToApply] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.accessibilityLabel = "Joseph Duffy Home"

        UIApplication.sharedApplication().statusBarHidden = true
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    // MARK: - Navigation

    @IBAction func returnToIntro(segue: UIStoryboardSegue) {
        println("You're back in the room")

        // The device could have rotate since the view was last shown, so
        // invalidate the layout to cause the section's sizes to be correct
        self.collectionView?.collectionViewLayout.invalidateLayout()
    }

//    override func supportedInterfaceOrientations() -> Int {
//        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
//            return Int(UIInterfaceOrientationMask.LandscapeLeft.rawValue | UIInterfaceOrientationMask.LandscapeRight.rawValue)
//        } else {
//            return Int(UIInterfaceOrientationMask.Portrait.rawValue)
//        }
//    }

    // MARK: - Navigation

    private var selectedIndexPath: NSIndexPath?

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let containerViewContoller = segue.destinationViewController as? ContainerViewController {
            containerViewContoller.indexToShow = self.selectedIndexPath?.row
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return 6
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! HomeCollectionViewCell
    
        if let section = AppSection(rawValue: indexPath.row) {
            cell.sectionTitleLabel.text = section.name
            cell.backgroundColor = section.mainColor
            
            let homeIcon = section.homeIcon
            cell.imageView.image = homeIcon.image
            if let imageViewCurveFunction = homeIcon.imageViewCurveFunction {
                let imageViewCurveFunctionToApply = ImageViewCurveFunctionToApply(imageView: cell.imageView, function: imageViewCurveFunction)
                self.imageViewCurveFunctions.append(imageViewCurveFunctionToApply)
            }

            if let textColor = section.textColor {
                cell.sectionTitleLabel.textColor = textColor
            }
        }
    
        return cell
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let dimensions = self.view.getDimensions()
        let numberOfColumns: CGFloat = dimensions.isLandscape ? 3 : 2
        let numberOfRows: CGFloat = dimensions.isLandscape ? 2 : 3

        return CGSize(width: dimensions.width / numberOfColumns, height: dimensions.height / numberOfRows)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let cell = self.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as? HomeCollectionViewCell {
            self.selectedIndexPath = indexPath
            self.performSegueWithIdentifier("showSegment", sender: cell.imageView)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        for (index, imageViewCurveFunctionToApply) in enumerate(self.imageViewCurveFunctions) {
            if let imageView = imageViewCurveFunctionToApply.imageView {
                imageViewCurveFunctionToApply.function(imageView)
            } else {
                self.imageViewCurveFunctions.removeAtIndex(index)
            }
        }
    }

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)

        self.collectionView?.collectionViewLayout.invalidateLayout()
    }

    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        super.willRotateToInterfaceOrientation(toInterfaceOrientation, duration: duration)

        self.collectionView?.collectionViewLayout.invalidateLayout()
    }

}
