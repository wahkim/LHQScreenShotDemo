//
//  UITableView+Screenshot.h
//  LHQScreenShotsDemo
//
//  Created by hq.Lin on 2020/5/2.
//  Copyright © 2020 hq.Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (Screenshot)

/**
 *  tableView 全部内容截图
 */
- (UIImage *)tableViewContentSizeSnapshot;

/**
 *  截图
 *
 *  @param shotView 需截图view
 */
- (UIImage *)screenShotWithShotView:(UIView *)shotView;

@end

NS_ASSUME_NONNULL_END
