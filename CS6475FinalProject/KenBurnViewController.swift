//
//  KenBurnViewController.swift
//  CS6475FinalProject
//
//  Created by Guoliang Wang on 7/12/16.
//  Copyright © 2016 iParroting. All rights reserved.
//

import UIKit
import Kingfisher

class KenBurnViewController: UIViewController {

    @IBOutlet weak var gwKBenViewContainer: GWStillImageMotionView!
    @IBOutlet weak var controlButton: UIBarButtonItem!
    
    @IBOutlet weak var addImageBtn: UIBarButtonItem!
    
    let addImageController = UIAlertController(title: "Add Image from URL", message: "Load a remote image for Ken Burns Effect", preferredStyle: .Alert)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchImageAction = UIAlertAction(title: "Fetch Image", style: .Default) { (_) in
            let imageUrlTextField = self.addImageController.textFields![0] as UITextField
            
            self.fetchImageNow(imageUrlTextField.text)
        }
        fetchImageAction.enabled = false
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
        addImageController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Remote Image Url"
            
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue(), usingBlock: { (notification) in
                fetchImageAction.enabled = textField.text != ""
            })
        }
        
        addImageController.addAction(fetchImageAction)
        addImageController.addAction(cancelAction)
        
        
        gwKBenViewContainer.curImage = UIImage(named: "image3.jpg") // change the image here!
        let image1 = UIImage(named: "image1.jpg")
        let image2 = UIImage(named: "image2.jpg")
        let image3 = UIImage(named: "image3.jpg")
        let imagesArr: [UIImage?] = [image1, image2, image3]
        gwKBenViewContainer.imagesArr = imagesArr
        gwKBenViewContainer.curImage = imagesArr.first!
        
        
    }
    
    @IBAction func toggleAnimation(sender: AnyObject) {
        // TODO: toggle icon
        gwKBenViewContainer.startAnimation()
    }
    
    @IBAction func addImageFromUrl(sender: AnyObject) {
        presentViewController(addImageController, animated: true, completion: nil)
    }
//http://wallpapercave.com/wp/8Ustxyg.jpg
    // http://xy7millions.com/wp-content/uploads/2014/02/15-outer-space-wallpaper.jpg
    func fetchImageNow(imageUrl: String?) {
        print("imageUrl: \(imageUrl)")
        guard imageUrl != nil else { return }
        gwKBenViewContainer.imageView.kf_setImageWithURL(NSURL(string: imageUrl!)!,
                                                         placeholderImage: nil,
                                                         optionsInfo: nil,
                                                         progressBlock: { (receivedSize, totalSize) -> () in
                                                            print("Download Progress: \(receivedSize)/\(totalSize)")
            },
                                                         completionHandler: { (image, error, cacheType, imageURL) -> () in
                                                            print("Downloaded and set! \(image)")
                                                            let downloaded: UIImage = image! as UIImage
                                                            self.gwKBenViewContainer.imagesArr.append(downloaded)
                                                            self.gwKBenViewContainer.curImage = downloaded
                                                            
            }
        )
    }
    

}
