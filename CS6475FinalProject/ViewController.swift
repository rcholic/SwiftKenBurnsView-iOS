//
//  ViewController.swift
//  CS6475FinalProject
//
//  Created by Guoliang Wang on 7/11/16.
//  Copyright © 2016 iParroting. All rights reserved.
//

import UIKit

import GPUImage
import Surge

typealias imageInfoObject = (pixels: [UInt8]?, width: Int, height: Int)

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var selectedImage: UIImage? = nil
    var images: [UIImage] = []
    
    let imagePickerController = UIImagePickerController()
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = UIModalPresentationStyle.FullScreen
        
        setupUI()
        compute()
    }
    
    @IBAction func chooseImage(sender: AnyObject) {
    //    presentViewController(sourceActionSheet, animated: true, completion: nil)
        
    //    popoverController.presentPopoverFromRect(self.view.bounds, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Up, animated: true)
        presentImagePickerOfType(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    
    @IBAction func applyFilter1(sender: AnyObject) {
        print("applying filter 1")
//        let imageInfo = pixelValuesFromImage(self.selectedImage)
//        // print("pixels: \(imageInfo.pixels)")
//        print("imageInfo.width and height: \(imageInfo.width), \(imageInfo.height)")
        // CVWrapper.processImageWithOpenCV(self.selectedImage)
        let imageArr = CVWrapper.readImage(self.selectedImage)
        
        print("imageArr.size: \(imageArr.count), \(imageArr[0].count)")
    }
    
    @IBAction func applyFilter2(sender: AnyObject) {
        print("applying filter 2")
        guard images.count >= 2 else { return }
        
        CVWrapper.processWithArray(images)
    }
    
    private func setupUI() {
        imagePickerController.delegate = self
    }
    
    private func presentImagePickerOfType(sourceType:UIImagePickerControllerSourceType) {
       // imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    func pixelValuesFromImage(image: UIImage?) -> imageInfoObject {
        
        var width = 0
        var height = 0
        
        guard let image = image else {
            return imageInfoObject(pixels: nil, width: width, height: height)
        }
        
        let imageRef = image.CGImage
        width = CGImageGetWidth(imageRef)
        height = CGImageGetHeight(imageRef)
        
        let bytesPerPixel = 1
        // let bytesPerPixel = 3
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8
        let totalBytes = width * height * bytesPerPixel
        
        let colorSpace = CGColorSpaceCreateDeviceGray()
        // let colorSpace = CGColorSpaceCreateDeviceRGB()
        var pixelValues = [UInt8](count: totalBytes, repeatedValue: 0)
        
        let contextRef = CGBitmapContextCreate(&pixelValues, width, height, bitsPerComponent, bytesPerRow, colorSpace, 0)
        CGContextDrawImage(contextRef, CGRectMake(0.0, 0.0, CGFloat(width), CGFloat(height)), imageRef)
        
        return imageInfoObject(pixels: pixelValues, width: width, height: height)
    }
    
    
    
    func compute() {
        let m1 = Surge.Matrix([
            [1.0, 2.0, 3.0],
            [3.0, 0.0, 5.0],
            [3.0, 2.5, 8.0],
            ])
        
        let m2 = Surge.Matrix([
            [1.0, 2.0, 3.0],
            [3.0, 0.0, 5.0],
            [3.0, 2.5, 8.0],
            ])
        
        let product = Surge.mul(m1, y: m2)
        print("product of matrices: \(product)")
    }
}

extension ViewController {
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imageView.image = image
        selectedImage = image
        images.append(image)
        print("image: \(image)")
        dismissViewControllerAnimated(true, completion: nil)
    }
    
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
//        print("info: \(info)")
//        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            print("image: \(image)")
//            self.imageView.image = image
//            // selectedImage = image
//        }
//        
//        dismissViewControllerAnimated(true, completion: nil)
//    }
}

