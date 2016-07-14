//
//  GWStillImageMotionView.swift
//  CS6475FinalProject
//
//  Created by Guoliang Wang on 7/12/16.
//  Copyright © 2016 iParroting. All rights reserved.
//

import UIKit
import GPUImage

@IBDesignable class GWStillImageMotionView: UIView {

    @IBOutlet var contentView: UIView!
    
//    @IBOutlet weak var imageContainerView: UIImageView!
    var imageView: UIImageView!
    
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
        
        imageView = UIImageView()
        imageView.autoresizingMask = [.FlexibleWidth, .FlexibleTopMargin]
        imageView.contentMode = .ScaleToFill
        imageView.image = UIImage(named: "image3.jpg")
        
       // imageContainerView.autoresizingMask = [.FlexibleWidth, .FlexibleTopMargin]
        self.addSubview(contentView)
        
        contentView.addSubview(imageView)
        imageView.frame = self.bounds
        imageView.clipsToBounds = true
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
    
    func stopAnimation() {
        isAnimationRunning = false
        pointsTapped.removeAll()
        self.layer.removeAllAnimations()
    }
    
    func startAnimation() {
        isAnimationRunning = !isAnimationRunning
        if isAnimationRunning {
            print("starting animation now")
//            guard self.pointsTapped.count == 0 else {
//                stopAnimation()
//                return
//            }
            performAnimation(0)
        }
    }
    
    func performAnimation(pointIndex: Int) {
        let rotationAngle = (arc4random() % 9) / 100
        let zoomInX: CGFloat = 1.30
        let zoomInY: CGFloat = 1.30

        let curPoint = pointsTapped[pointIndex]
        let lastPoint: CGPoint = pointIndex == 0 ? CGPointZero : pointsTapped[pointIndex-1]
        var moveX = curPoint.x - lastPoint.x
        var moveY = curPoint.y - lastPoint.y
        
        // transformations:
        let rotate = CGAffineTransformMakeRotation(CGFloat(rotationAngle))
        let move2D = CGAffineTransformMakeTranslation(moveX, moveY)
        let rotateMove = CGAffineTransformConcat(rotate, move2D)
        let zoomIn = CGAffineTransformMakeScale(zoomInX, zoomInY)
        let allTransform = CGAffineTransformConcat(zoomIn, rotateMove)
        
        let zoomedTransform = allTransform
        let standardXForm = CGAffineTransformIdentity
        let startXForm = CGAffineTransformIdentity
        // let finishXForm = CGAffineTransformIdentity
        
        let possibleFinishes: [CGAffineTransform] = [zoomIn, allTransform]
        let finishXForm = possibleFinishes[Int(arc4random_uniform(UInt32(possibleFinishes.count)))]
        
        imageView.transform = startXForm
        UIView.animateWithDuration(2.0, animations: { 
            self.imageView.transform = finishXForm
            }) { _ in
                
                print("finished animation for point index: \(pointIndex)")
                if pointIndex < self.pointsTapped.count-1 {
                    self.performAnimation(pointIndex+1)
                }
        }
        
    }
    
    
}
