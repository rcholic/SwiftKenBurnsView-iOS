//
//  CVWrapper.h
//  CS6475FinalProject
//
//  Created by Wang, Tony (NIH/NCI) [C] on 7/12/16.
//  Copyright © 2016 iParroting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CVWrapper : NSObject

+ (UIImage*) processImageWithOpenCV: (UIImage*) inputImage;

+ (UIImage*) processWithOpenCVImage1:(UIImage*)inputImage1 image2:(UIImage*)inputImage2;

+ (UIImage*) processWithArray:(NSArray*)imageArray;


@end
