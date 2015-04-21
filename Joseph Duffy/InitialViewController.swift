//
//  InitialViewController.swift
//  Joseph Duffy
//
//  Created by Joseph Duffy on 20/04/2015.
//  Copyright (c) 2015 Yetii Ltd. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func topLeftButtonTapped() {
        self.performSegueWithIdentifier("showSegment", sender: self)
    }

    @IBAction func middleLeftButtonTapped() {
    }

    @IBAction func returnToIntro(segue: UIStoryboardSegue) {
        println("You're back in the room")
    }
    

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let containerViewContoller = segue.destinationViewController as? ContainerViewController {
//            containerViewContoller.initialSection = NSIndexPath(forRow: 1, inSection: 1)
        }
    }

}
