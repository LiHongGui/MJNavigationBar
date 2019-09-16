//
//  MJNavigationBar.h
//  iDai
//
//  Created by 李宏贵 on 2019/8/15.
//  Copyright © 2019 李宏贵. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJNavigationHeight : UIView
/**
 *statusBarStyleColor
 */
+(void)statusBarStyleColor:(UIColor *)statusColor;
/**
 *导航栏高度
 */
+ (CGFloat)mj_setNavBarHeight;
/**
 *状态栏高度
 */
+ (CGFloat)mj_setStatusHeight;
/**
 *tabBar栏高度
 */
+ (CGFloat)mj_setTabBarHeight;
/**
 *screenWidth
 */
+ (CGFloat)mj_setScreenWidth;
/**
 *screenHeight
 */
+ (CGFloat)mj_setScreenHeight;

@end

NS_ASSUME_NONNULL_END
