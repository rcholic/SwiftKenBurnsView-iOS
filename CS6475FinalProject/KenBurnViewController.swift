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
        gwKBenViewContainer.curImage = UIImage(named: "image3.jpg") // change the image here!
        let image1 = UIImage(named: "image2.jpg")
        let image2 = UIImage(named: "image3.jpg")
        let imagesArr: [UIImage?] = [image1, image2]
        gwKBenViewContainer.imagesArr = imagesArr
        gwKBenViewContainer.curImage = imagesArr.first!
    }
    
    @IBAction func toggleAnimation(sender: AnyObject) {
        // TODO: toggle icon
        gwKBenViewContainer.startAnimation()
    }
    

}
