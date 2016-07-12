//
//  GWKenBurnsView.swift
//  CS6475FinalProject
//
//  Created by Guoliang Wang on 7/11/16.
//  Copyright © 2016 iParroting. All rights reserved.
//

// read UIImage as array: http://stackoverflow.com/questions/33768066/get-pixel-data-as-array-from-uiimage-cgimage-in-swift

/**
 Two dimensional arrays: 
 
 1. http://stackoverflow.com/questions/25127700/two-dimensional-array-in-swift
 
 */


import Foundation
import UIKit
import Surge
import GPUImage

public enum MotionMode {
    case UserInteraction
    case RandomMode
}

public protocol GWKenBurnsViewProtocol {
    var imagesArray: Array<Array<UInt8>> {get set}
   // var nextImgTimer: NSTimer {get set}
    var motionMode: MotionMode {get set}
    var duration: Float {get set}
}

public class GWKenBurnsView: GWKenBurnsViewProtocol {
    var image: UIImage
    public var imagesArray: Array<Array<UInt8>> = []
    // public var nextImgTimer: NSTimer
    public var motionMode: MotionMode = .RandomMode
    public var duration: Float = 0.0
    
    init(image: UIImage, motionMode: MotionMode, duration: Float) {
        self.image = image
        self.motionMode = motionMode
        self.duration = duration
    }
    
    
    
    
}