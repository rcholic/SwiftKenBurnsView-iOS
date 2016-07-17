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
    var layerAnimation: CATransition?
    
    var imageArray: [UIImage] = []
    var pointsTapped: [CGPoint] = []
    var isAnimationRunning: Bool = false
    let resizeFactor: CGFloat = 1.2 // make the loaded image bigger than its original size for scanning effect
    
    var imagesArr: [UIImage?] = []
    var curImageIndex = 0 // index in the imagesArr
    var timer = NSTimer()
    
    var curImage: UIImage? {
        didSet {
            // remove the previous view
            if self.contentView.subviews.count > 0 {
                let oldImageView = self.contentView.subviews[0] as! UIImageView
                oldImageView.removeFromSuperview()
            }
            
            imageView = UIImageView()
            imageView.image = curImage
            contentView.addSubview(imageView)
            
            let imageLayer = CALayer()
            imageLayer.contents = curImage?.CGImage
            imageLayer.anchorPoint = CGPointMake(0, 0)
            let optimal = self.getImageAndMoveInfo()
            imageLayer.bounds = CGRectMake(0, 0, optimal.optimumWidth, optimal.optimumHeight)
            imageLayer.position = CGPointMake(0, 0)
            
            layerAnimation = CATransition()
            layerAnimation!.duration = 1
            layerAnimation!.type = kCATransitionFade
            
            imageLayer.addAnimation(layerAnimation!, forKey: nil)
            imageView.layer.addSublayer(imageLayer)
        }
    }
    
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
//        imageView.image = UIImage(named: "image3.jpg")

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
    
    @objc private func nextImageView(sender: AnyObject?) {
        guard let img = imagesArr[curImageIndex % imagesArr.count] else { return }
        self.curImage = img
        performAnimation(0)
        print("animation return for curImageIndex: \(curImageIndex)")
        curImageIndex += 1 // increment
    }
    
    func stopAnimation() {
        isAnimationRunning = false
        pointsTapped.removeAll()
        self.layer.removeAllAnimations()
    }
    
    func startAnimation() {
        guard self.pointsTapped.count > 0 && (curImage != nil || imagesArr.count == 0) else {
            stopAnimation()
            return
        }
        isAnimationRunning = !isAnimationRunning
//        if isAnimationRunning {
//            print("starting animation now")
//            
//            performAnimation(0)
//        }
        if isAnimationRunning {
            print("starting animation now")
            timer = NSTimer.scheduledTimerWithTimeInterval(6, target: self, selector: #selector(self.nextImageView(_:)), userInfo: nil, repeats: true)
            
//            performAnimation(0)
        } else {
            timer.invalidate() // cancel timer
        }
        
    }
    
    func performAnimation(pointIndex: Int) {
        guard curImage != nil else {
            return
        }
        let maxMoveXY = getImageAndMoveInfo()
        
        let rotationAngle = (arc4random() % 9) / 100
        let zoomInX: CGFloat = 1.50
        let zoomInY: CGFloat = 1.50

        let curPoint = pointsTapped[pointIndex]
        let lastPoint: CGPoint = pointIndex == 0 ? CGPointZero : pointsTapped[pointIndex-1]
        var moveX = -maxMoveXY.maxMoveX // curPoint.x - lastPoint.x
        let isXNegative = moveX.isNegative()
        moveX = abs(moveX) > maxMoveXY.maxMoveX ? maxMoveXY.maxMoveX : moveX  // prevent image overfloat
        
        if isXNegative && !moveX.isNegative() {
            moveX = -moveX
        }
        
        var moveY = -maxMoveXY.maxMoveY // curPoint.y - lastPoint.y
        let isYnegative = moveY.isNegative()
        moveY = abs(moveY) > maxMoveXY.maxMoveY ? maxMoveXY.maxMoveY : moveY // prevent image overfloat
        if isYnegative && !moveY.isNegative() {
            moveY = -moveY
        }
        print("moveX: \(moveX),moveY: \(moveY); maxMoveX: \(maxMoveXY.maxMoveX), maxMoveY: \(maxMoveXY.maxMoveY)")
        
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
        
        let possibleFinishes: [CGAffineTransform] = [zoomIn, allTransform] // zoomIn, rotateMove, allTransform
        let finishXForm = possibleFinishes[Int(arc4random_uniform(UInt32(possibleFinishes.count)))]
        
        imageView.transform = startXForm
        /*
        UIView.animateWithDuration(3.0, animations: {
            self.imageView.transform = finishXForm
            }) { _ in
                
                print("finished animation for point index: \(pointIndex)")
                if pointIndex < self.pointsTapped.count-1 {
                    self.performAnimation(pointIndex+1)
                }
        }
        */
        
        UIView.animateWithDuration(4, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.imageView.transform = finishXForm
            }) { _ in
                
                print("finished animation for point index: \(pointIndex)")
                if pointIndex < self.pointsTapped.count-1 {
                    self.performAnimation(pointIndex+1)
                } else {
                    print("animation done with current image for all points")
                }
        }
        
    } // performAnimation
    
    private func isLandscape() -> Bool {
        return UIDevice.currentDevice().orientation == .LandscapeLeft || UIDevice.currentDevice().orientation == .LandscapeRight
    }
    
    /**
     Get image and motion information
     @ param maxMoveX: maximum distance the image can be translated along X axis
     @ param maxMoveY: maximum distance the image can be translated along Y axis
     @ params optimumWidth, and optimumHeight: the image resized for showing int he image view (resized bigger)
     
     - returns: Tuple with keys as indicated in the paranthesis
     */
    private func getImageAndMoveInfo() -> (maxMoveX: CGFloat, maxMoveY: CGFloat, optimumWidth: CGFloat, optimumHeight: CGFloat) {
        let frameWid = isLandscape() ? self.bounds.size.width : self.bounds.size.height
        let frameHgt = isLandscape() ? self.bounds.size.height : self.bounds.size.width
        
        let widthRatio = frameWid / (self.curImage?.size.width)!
        let heightRatio = frameHgt / (self.curImage?.size.height)!
        
        let resizeRatio = widthRatio > heightRatio ? widthRatio : heightRatio
        let width = curImage!.size.width * resizeRatio * resizeFactor
        let height = curImage!.size.height * resizeRatio * resizeFactor
        // imageView.frame = CGRectMake(<#T##x: CGFloat##CGFloat#>, <#T##y: CGFloat##CGFloat#>, <#T##width: CGFloat##CGFloat#>, <#T##height: CGFloat##CGFloat#>)
        
        let maxMoveX: CGFloat = width - frameWid
        let maxMoveY: CGFloat = height - frameHgt
        
        return (maxMoveX, maxMoveY, width, height)
    }
}

extension CGFloat {
    func isNegative() -> Bool {
        return self < 0.0
    }
}
