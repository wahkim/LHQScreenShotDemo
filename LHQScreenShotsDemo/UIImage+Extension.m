//
//  UIImage+Extension.m
//  LHQScreenShotsDemo
//
//  Created by hq.Lin on 2020/5/2.
//  Copyright © 2020 hq.Lin. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

+ (UIImage *)verticalImageFromArray:(NSArray *)imagesArray
{
    UIImage *image = nil;
    CGSize totalImageSize = [self verticalAppendedTotalImageSizeFromImagesArray:imagesArray];
    UIGraphicsBeginImageContextWithOptions(totalImageSize, NO, 0.f);

    int imageOffset = 0;
    for (UIImage *img in imagesArray) {
        [img drawAtPoint:CGPointMake(0, imageOffset)];
        imageOffset += img.size.height;
    }
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (CGSize)verticalAppendedTotalImageSizeFromImagesArray:(NSArray *)imagesArray
{
    CGSize totalSize = CGSizeZero;
    for (UIImage *img in imagesArray) {
        CGSize imgSize = [img size];
        totalSize.height += imgSize.height;
        totalSize.width = MAX(totalSize.width, imgSize.width);
    }
    return totalSize;
}

@end
