//
//  KenBurnViewController.swift
//  CS6475FinalProject
//
//  Created by Guoliang Wang on 7/12/16.
//  Copyright © 2016 iParroting. All rights reserved.
//

import UIKit

class KenBurnViewController: UIViewController {

    @IBOutlet weak var gwKBenViewContainer: GWStillImageMotionView!
    @IBOutlet weak var controlButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        gwKBenViewContainer.fillSuperview()
 //       gwKBenViewContainer.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
    }
    
    @IBAction func toggleAnimation(sender: AnyObject) {
        // TODO: toggle icon
        gwKBenViewContainer.startAnimation()
    }
    

}
