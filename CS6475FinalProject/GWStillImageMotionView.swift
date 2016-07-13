//
//  GWStillImageMotionView.swift
//  CS6475FinalProject
//
//  Created by Guoliang Wang on 7/12/16.
//  Copyright © 2016 iParroting. All rights reserved.
//

import UIKit

@IBDesignable class GWStillImageMotionView: UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var imageContainerView: UIImageView!
   // var imageView: UIImageView!
    var imageArray: [UIImage] = []
    var pointsTapped: [CGPoint] = []
    var isAnimationRunning: Bool = false
    
    init(imageArray: [UIImage]) {
        super.init(frame: CGRectNull)
        // self.imageArray = imageArray
        xibSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
   
    private func xibSetup() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: String(self.dynamicType), bundle: bundle)
      //  NSBundle.mainBundle().loadNibNamed(String(self.dynamicType), owner: self, options: nil)
        contentView = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        contentView.backgroundColor = UIColor.redColor()
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.FlexibleWidth, .FlexibleTopMargin]
        imageContainerView.autoresizingMask = [.FlexibleWidth, .FlexibleTopMargin]
        self.addSubview(contentView)
        
 
        
        /*
        imageView = UIImageView(frame: self.view.bounds) // fill the parent view container
        imageView.contentMode = .ScaleToFill
        imageView.autoresizingMask = [.FlexibleWidth, .FlexibleTopMargin]
        contentView(imageView)

//        imageView.frame = CGRectMake(0, 0, self.frame.width, self.frame.height)
//        imageView.clipsToBounds = true

        let image1 = UIImage(named: "image2.jpg")
        imageView.image = image1
        */
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let p = (touch?.locationInView(self))!
        print("touches began!, point: \(p))")
        if !pointsTapped.contains(p) {
            if pointsTapped.count == 10 {
                pointsTapped.removeFirst()
            }
            pointsTapped.append(p)
        }
    }
    
//    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        let touch = touches.first
//        let p = (touch?.locationInView(self))!
//        print("touches ended!, point: \(p))")
//    }
    
    
    func startAnimation() {
        isAnimationRunning = !isAnimationRunning
        if isAnimationRunning {
            print("starting animation now")
            
        }
    }
    
    
}
