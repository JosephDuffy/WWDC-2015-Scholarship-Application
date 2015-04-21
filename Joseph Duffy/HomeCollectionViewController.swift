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

    override func viewDidLoad() {
        super.viewDidLoad()

        self.accessibilityLabel = "Joseph Duffy Home"

        UIApplication.sharedApplication().statusBarHidden = true
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if let segue = segue as? ImageZoomStoryboardSegue, imageView = sender as? UIImageView {
//            segue.imageViewToPresentFrom = imageView
//        }
//    }

    @IBAction func returnToIntro(segue: UIStoryboardSegue) {
        println("You're back in the room")
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            return Int(UIInterfaceOrientationMask.LandscapeLeft.rawValue | UIInterfaceOrientationMask.LandscapeRight.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.Portrait.rawValue)
        }
    }


    // MARK: - Navigation

    private var selectedIndexPath: NSIndexPath?

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let containerViewContoller = segue.destinationViewController as? ContainerViewController {
            containerViewContoller.initialIndex = self.selectedIndexPath?.row

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
            cell.imageView.image = UIImage(named: "Music Icon")
        }
    
        return cell
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

        let isLandscape = UIDevice.currentDevice().orientation.isLandscape
        let numberOfColumns: CGFloat = isLandscape ? 3 : 2
        let numberOfRows: CGFloat = isLandscape ? 2 : 3

        let viewWidth = self.view.frame.size.width
        let viewHeight = self.view.frame.size.height

        return CGSize(width: floor(viewWidth / numberOfColumns), height: floor(viewHeight / numberOfRows))
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
            println(cell)
            println(cell.contentView)
            self.selectedIndexPath = indexPath
            self.performSegueWithIdentifier("showSegment", sender: cell.imageView)
        }
    }

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        self.collectionView?.collectionViewLayout.invalidateLayout()
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
