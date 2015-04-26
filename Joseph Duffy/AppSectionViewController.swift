//
//  AppSectionViewController.swift
//  Joseph Duffy
//
//  Created by Joseph Duffy on 21/04/2015.
//  Copyright (c) 2015 Yetii Ltd. All rights reserved.
//

import UIKit
import StoreKit

class AppSectionViewController: SectionViewController, SKStoreProductViewControllerDelegate {
    @IBOutlet weak var appIconImageView: UIImageView!

    var appId: String? {
        didSet {
            if self.appId != nil {
                let barButton = UIBarButtonItem(title: "App Store", style: .Bordered, target: self, action: "showStoreProductViewController")
                self.navigationItem.rightBarButtonItem = barButton
            } else {
                self.navigationItem.rightBarButtonItem = nil
            }
        }
    }

    // MARK:- Website opening

    var websiteURL: NSURL? {
        didSet {
            if self.appId != nil {
                let barButton = UIBarButtonItem(title: "Website", style: .Bordered, target: self, action: "openWebsite")
                self.navigationItem.leftBarButtonItem = barButton
            } else {
                self.navigationItem.leftBarButtonItem = nil
            }
        }
    }

    func openWebsite() {
        if let websiteURL = self.websiteURL {
            UIApplication.sharedApplication().openURL(websiteURL)
        }
    }

    private var storeProductViewController: SKStoreProductViewController?
    var storeProductTimeoutTimer: NSTimer?
    var storeProductLoadingCanceled = false
    private var viewInAppStoreBarButton: UIBarButtonItem?

    func showStoreProductViewController() {
        if let appId = self.appId {
            self.viewInAppStoreBarButton = self.navigationItem.rightBarButtonItem

            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
            activityIndicator.startAnimating()
            let activityIndicatorBarButton = UIBarButtonItem(customView: activityIndicator)
            self.navigationItem.rightBarButtonItem = activityIndicatorBarButton

            self.storeProductLoadingCanceled = false

            let productViewController = SKStoreProductViewController()
            self.storeProductViewController = productViewController

            productViewController.delegate = self
            productViewController.loadProductWithParameters([
                SKStoreProductParameterITunesItemIdentifier: appId
                ], completionBlock: { (result, error) -> Void in
                    if self.storeProductLoadingCanceled == false {
                        self.storeProductTimeoutTimer?.invalidate()
                        self.storeProductTimeoutTimer = nil

                        if let error = error {
                            println("Error loading store product view controller: \(error)")
                        } else {
                            println("Presenting")
                            self.presentViewController(productViewController, animated: true, completion: nil)
                        }

                        self.navigationItem.rightBarButtonItem = self.viewInAppStoreBarButton
                        self.viewInAppStoreBarButton = nil
                    }
            })
            self.storeProductTimeoutTimer?.invalidate()
            self.storeProductTimeoutTimer = nil
            self.storeProductTimeoutTimer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "timeOutStoreProductLoad:", userInfo: nil, repeats: false)
        }
    }

    func timeOutStoreProductLoad(timer: NSTimer) {
        self.storeProductTimeoutTimer?.invalidate()
        self.storeProductTimeoutTimer = nil
        self.storeProductViewController = nil
        self.storeProductLoadingCanceled = true

        self.navigationItem.rightBarButtonItem = self.viewInAppStoreBarButton
        self.viewInAppStoreBarButton = nil
    }

    func productViewControllerDidFinish(viewController: SKStoreProductViewController!) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            self.storeProductViewController = nil
        })
    }
}
