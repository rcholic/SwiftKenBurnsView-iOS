//
//  PanZoomViewController.swift
//  CS6475FinalProject
//
//  Created by Guoliang Wang on 7/14/16.
//  Copyright © 2016 iParroting. All rights reserved.
//

import UIKit
import Toucan

class PanZoomViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    let originalImage = UIImage(named: "image3.jpg")
    
    var originalWidth: CGFloat!
    var originalHeight: CGFloat!
    
    let zoomFactor = 1.5
    let moveX = -50
    let moveY = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func zoomPic(sender: AnyObject) {
        originalWidth = originalImage?.size.width
        originalHeight = originalImage?.size.height
        print("from zoomPic, width: \(originalWidth), height: \(originalHeight)")
        
        let resizedImage = Toucan.Resize.resizeImage(originalImage!, size: CGSize(width: Double(originalWidth) * zoomFactor, height: Double(originalHeight) * zoomFactor), fitMode: .Crop)
        
        imageView.image = resizedImage
    }
    
    
    @IBAction func movePic(sender: AnyObject) {
        originalWidth = originalImage?.size.width
        originalHeight = originalImage?.size.height
        print("from movePic, width: \(originalWidth), height: \(originalHeight)")
        // zoom out the image to its original size
        let zoomOutImage = Toucan.Resize.resizeImage(originalImage!, size: CGSize(width: Double(originalWidth) / zoomFactor, height: Double(originalHeight) / zoomFactor), fitMode: .Clip)
        imageView.image = zoomOutImage
    }
    
}
