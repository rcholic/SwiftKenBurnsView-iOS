//
//  UIImage+Rotate.h
//  CS6475FinalProject
//
//  Created by Wang, Tony (NIH/NCI) [C] on 7/12/16.
//  Copyright © 2016 iParroting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Rotate)

//faster, alters the exif flag but doesn't change the pixel data
- (UIImage*)rotateExifToOrientation:(UIImageOrientation)orientation;


//slower, rotates the actual pixel matrix
- (UIImage*)rotateBitmapToOrientation:(UIImageOrientation)orientation;

- (UIImage*)rotateToImageOrientation;

@end