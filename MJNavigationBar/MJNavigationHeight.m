//
//  MJNavigationBar.m
//  iDai
//
//  Created by 李宏贵 on 2019/8/15.
//  Copyright © 2019 李宏贵. All rights reserved.
//

#import "MJNavigationHeight.h"

@implementation MJNavigationHeight

+ (BOOL)isIphoneX {
    if ([UIApplication sharedApplication].statusBarFrame.size.height == 44) {
        return YES;
    }
    else {
        return NO;
    }
}
#pragma mark-statusBarStyle
+(void)statusBarStyleColor:(UIColor *)statusColor
{
    if (CGColorEqualToColor(statusColor.CGColor,[UIColor whiteColor].CGColor)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;    }else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
}
#pragma mark-导航栏高度
+ (CGFloat)mj_setNavBarHeight
{
    if ([self isIphoneX]) {
        return 88;
    }
    else {
        return 64;
    }
}
#pragma mark-状态栏高度
+ (CGFloat)mj_setStatusHeight
{
    return [UIApplication sharedApplication].statusBarFrame.size.height;
}
#pragma mark-导航栏高度
+ (CGFloat)mj_setTabBarHeight
{
    if ([self isIphoneX]) {
        return 83;
    }
    else {
        return 49;
    }
}
#pragma mark-screenWidth
+ (CGFloat)mj_setScreenWidth
{
    return [UIScreen mainScreen].bounds.size.width;
}

#pragma mark-screenHeight
+ (CGFloat)mj_setScreenHeight
{
    return [UIScreen mainScreen].bounds.size.height;
}


@end
