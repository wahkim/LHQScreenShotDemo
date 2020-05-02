//
//  UIImage+Extension.h
//  LHQScreenShotsDemo
//
//  Created by hq.Lin on 2020/5/2.
//  Copyright © 2020 hq.Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Extension)

/**
 *  拼接图片 由上至下
 *
 *  @param imagesArray 图片数组
 */
+ (UIImage *)verticalImageFromArray:(NSArray *)imagesArray;

/**
 *  获取全部图片拼接后size(由上至下)
 *
 *  @param imagesArray 图片数组
 */
+ (CGSize)verticalAppendedTotalImageSizeFromImagesArray:(NSArray *)imagesArray;

@end

NS_ASSUME_NONNULL_END
