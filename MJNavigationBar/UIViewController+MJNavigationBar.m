//
//  UIViewController+MJNavigationBar.m
//  iDai
//
//  Created by 李宏贵 on 2019/8/15.
//  Copyright © 2019 李宏贵. All rights reserved.
//

#import "UIViewController+MJNavigationBar.h"
#import "YINMethodHook.h"

@implementation UIViewController (MJNavigationBar)
static char kWRIsLocalUsedKey;
static char kWRWhiteistKey;
static char kWRBlacklistKey;

+ (BOOL)isIphoneX {
    if ([UIApplication sharedApplication].statusBarFrame.size.height == 44) {
        return YES;
    }
    else {
        return NO;
    }
}
#pragma mark-导航栏高度
+ (CGFloat)mj_mj_setNavBarHeight
{
    if ([self isIphoneX]) {
        return 88;
    }
    else {
        return 64;
    }
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

+(void)load{
    
    [YINMethodHook instanceMethodExchangeOriginClass:self originMethod:@selector(viewWillAppear:) exchangeClass:self exchangeMethod:@selector(y_viewWillAppear:)];
    [YINMethodHook instanceMethodExchangeOriginClass:self originMethod:@selector(viewDidAppear:) exchangeClass:self exchangeMethod:@selector(y_viewDidAppear:)];
    [YINMethodHook instanceMethodExchangeOriginClass:self originMethod:@selector(viewDidLoad) exchangeClass:self exchangeMethod:@selector(y_viewDidLoad)];
}



- (void)y_viewDidLoad{
    
    if (![self isKindOfClass:[UINavigationController class]]&&self.navigationController) {
        __weak typeof(self)weak_self = self;
        [self.navigationController aspect_hookSelector:@selector(popViewControllerAnimated:) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> info){
            UIViewController *vc = ((UINavigationController *)info.instance).viewControllers[ ((UINavigationController *)info.instance).viewControllers.count-2];
            
            [weak_self changeNavWithSetting:vc];
        } error:nil];
        [self.navigationController aspect_hookSelector:@selector(pushViewController:animated:) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> info){
            UIViewController  *vc = info.arguments.firstObject;
            
            [weak_self changeNavWithSetting:vc];
            
        } error:nil];
        [self.navigationController aspect_hookSelector:@selector(popToRootViewControllerAnimated:) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> info){
            UIViewController *vc = ((UINavigationController *)info.instance).viewControllers.firstObject;
            [weak_self changeNavWithSetting:vc];
        } error:nil];
        self.view.backgroundColor = [UIColor whiteColor];
        self.navigationController.navigationBar.translucent = YES;
        self.view.backgroundColor = [UIColor whiteColor];
        UIBarButtonItem *back = [[UIBarButtonItem alloc]init];
        back.title = @"";
        self.navigationItem.backBarButtonItem = back;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self y_viewDidLoad];
}



- (void)y_viewDidAppear:(BOOL)animated{
    if (![self isKindOfClass:[UINavigationController class]]&&self.navigationController) {
        
        NSNumber *orientationTarget = [NSNumber numberWithInt:self.y_screenOrientation== UIInterfaceOrientationMaskLandscapeLeft?UIInterfaceOrientationLandscapeLeft:(self.y_screenOrientation==UIInterfaceOrientationMaskLandscapeRight?UIInterfaceOrientationLandscapeRight:UIInterfaceOrientationPortrait)];
        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
        
    }
    [self y_viewDidAppear:animated];
}

- (void)y_viewWillAppear:(BOOL)animated{
    if (![self isKindOfClass:[UINavigationController class]]&&self.navigationController) {
        
        NSNumber *orientationTarget = [NSNumber numberWithInt:self.y_screenOrientation== UIInterfaceOrientationMaskLandscapeLeft?UIInterfaceOrientationLandscapeLeft:(self.y_screenOrientation==UIInterfaceOrientationMaskLandscapeRight?UIInterfaceOrientationLandscapeRight:UIInterfaceOrientationPortrait)];
        
        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
        self.navigationController.navigationBar.translucent = YES;
        if (self.y_navBarHidden) {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        }else{
            [self.navigationController setNavigationBarHidden:NO animated:YES];
        }
        [self changeNavWithSetting:self];
    }
    [self y_viewWillAppear:animated];
}



- (void)changeNavWithSetting:(UIViewController *)vc{
    [self mj_setBlacklist:@[@"SpecialController",
    @"TZPhotoPickerController",
    @"TZGifPhotoPreviewController",
    @"TZAlbumPickerController",
    @"TZPhotoPreviewController",
                            @"TZVideoPlayerController",@"TZImagePickerController"]];
    NSString *vcStr = NSStringFromClass(vc.class);
    NSLog(@"[self blacklist]:%@---vcStr:%@",[self blacklist],vcStr);
    if (![[self blacklist] containsObject:vcStr]) {
        UINavigationController *na = [self isKindOfClass:[UINavigationController class]]?(UINavigationController *)self:self.navigationController;
        na.navigationBar.barTintColor = vc.y_navBarBgColor?: BarBgColor;
        na.navigationBar.tintColor = vc.y_navBarTextColor?: [UIColor whiteColor];
        NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:vc.y_navBarTextColor?:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:18],NSFontAttributeName,nil];
        na.navigationBar.titleTextAttributes = attributes;
        [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName,nil] forState:UIControlStateNormal];
        [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName,nil] forState:UIControlStateSelected];
        [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName,nil] forState:UIControlStateHighlighted];

        if(!vc.y_navLine){
            vc.y_navLine = [self findHairlineImageViewUnder:na.navigationBar];
        }
        [vc setY_largeTitleMode:vc.y_largeTitleMode];

        vc.y_navLine.hidden = YES;
        [self changeNavBarAlpha:self.y_navBarAlpha];
        if (@available(iOS 11.0, *)) {
            //        na.navigationBar.largeTitleTextAttributes = attributes;
        } else {
            // Fallback on earlier versions
        }
    }else {
        UINavigationController *na = [self isKindOfClass:[UINavigationController class]]?(UINavigationController *)self:self.navigationController;
        na.navigationBar.barTintColor = BarBgColor;
        na.navigationBar.backgroundColor = BarBgColor;
        [na.navigationBar setBackgroundImage:[self createImageWithColor:BarBgColor withRect:CGRectMake(0, 0, 1, 1)] forBarMetrics:UIBarMetricsDefault];
    }
}

-(UIImage*)createImageWithColor:(UIColor*)color withRect:(CGRect)rect
{
    //    rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

- (void)setY_navLine:(UIView *)y_navLine{
    objc_setAssociatedObject(self, @selector(y_navLine), y_navLine, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)y_navLine{
    return objc_getAssociatedObject(self, @selector(y_navLine));
}

- (void)setY_popController:(UIViewController *)y_popController{
    if (self.navigationController&&y_popController) {
        NSMutableArray *vcs = [NSMutableArray array];
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isEqual:y_popController]||[obj isEqual:self]) {
                *stop = YES;
            }else{
                [vcs addObject:obj];
            }
        }];
        [vcs addObject:y_popController];
        [vcs addObject:self];
        self.navigationController.viewControllers = vcs;
    }
}

- (UIViewController *)y_popController{
    if (self.navigationController) {
        NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
        if (index>0) {
            return self.navigationController.viewControllers[index-1];
        }
    }
    return nil;
}

- (void)setY_navBarHidden:(BOOL)y_navBarHidden{
    if (![self isKindOfClass:[UINavigationController class]]) {
        if (self.y_navBarHidden) {
            
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        }else{
            [self.navigationController setNavigationBarHidden:NO animated:YES];
        }
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
        if (self.y_navBarAlpha<1||self.y_navBarHidden) {
            self.edgesForExtendedLayout = UIRectEdgeTop;
        }
    }
    objc_setAssociatedObject(self, @selector(y_navBarHidden), @(y_navBarHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (BOOL)y_navBarHidden{
    return [objc_getAssociatedObject(self, @selector(y_navBarHidden)) boolValue];
}


- (void)changeNavBarAlpha:(CGFloat)alpha{

    if (self.navigationController&&!self.navigationController.y_contentView) {
//        UIView *view = [[UIView alloc] init];
//        self.navigationController.y_contentView = view;
//        [self.navigationController.navigationBar insertSubview:view atIndex:0];
//        [view mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.left.right.equalTo(@0);
//            make.top.equalTo(@(-[UIApplication sharedApplication].statusBarFrame.size.height));
//        }];
//        UIImageView *imgV = [[UIImageView alloc] init];
//        [view addSubview:imgV];
//        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.right.left.bottom.equalTo(@0);
//        }];
//        self.navigationController.y_contentViewImgV = imgV;
    }
    self.navigationController.navigationBar.barTintColor = self.y_navBarBgColor;
    [self.navigationController.navigationBar setBackgroundColor:self.y_navBarBgColor];
    self.navigationController.y_contentView.backgroundColor = self.y_navBarBgColor;
    self.navigationController.y_contentView.alpha = alpha;
//    self.navigationController.y_contentViewImgV.image = self.y_navBarBgImg;
    [self.navigationController.navigationBar setBackgroundImage:self.y_navBarBgImg forBarMetrics:UIBarMetricsDefault];
    if (alpha<1) {
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
        
    }else {
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    }
    if (alpha<1||self.y_navBarHidden) {
        self.edgesForExtendedLayout = UIRectEdgeTop;
        self.y_navLine.hidden = YES;
    }
    else{
        self.y_navLine.hidden = YES;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}
- (BOOL)isLocalUsed {
    id isLocal = objc_getAssociatedObject(self, &kWRIsLocalUsedKey);
    return (isLocal != nil) ? [isLocal boolValue] : NO;
}
- (NSArray<NSString *> *)blacklist {
    NSArray<NSString *> *list = (NSArray<NSString *> *)objc_getAssociatedObject(self, &kWRBlacklistKey);
    return (list != nil) ? list : nil;
}
- (void)mj_setBlacklist:(NSArray<NSString *> *)list {
    NSAssert(list, @"list 不能设置为nil");
    NSAssert(![self isLocalUsed], @"黑名单是在设置 广泛使用 该库的情况下使用的");
    objc_setAssociatedObject(self, &kWRBlacklistKey, list, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)setY_navBarAlpha:(CGFloat)y_navBarAlpha{
    
    [self changeNavBarAlpha:y_navBarAlpha];
    objc_setAssociatedObject(self, @selector(y_navBarAlpha), @(y_navBarAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (CGFloat)y_navBarAlpha{
    
    return objc_getAssociatedObject(self, @selector(y_navBarAlpha))?[objc_getAssociatedObject(self, @selector(y_navBarAlpha)) floatValue]:1;
}


- (void)setY_navLineHidden:(BOOL)y_navLineHidden{
    
    
    objc_setAssociatedObject(self, @selector(y_navLineHidden), @(y_navLineHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (BOOL)y_navLineHidden{
    return [objc_getAssociatedObject(self, @selector(y_navLineHidden)) boolValue];
}

- (void)setY_largeTitleMode:(BOOL)y_largeTitleMode{
    
    if (![self isKindOfClass:[UINavigationController class]]) {
        if (@available(iOS 11.0, *)) {
            self.navigationController.navigationBar.prefersLargeTitles = y_largeTitleMode;
            self.navigationItem.largeTitleDisplayMode = y_largeTitleMode?UINavigationItemLargeTitleDisplayModeAlways:UINavigationItemLargeTitleDisplayModeNever;
        } else {
            
        }
    }
    objc_setAssociatedObject(self, @selector(y_largeTitleMode), @(y_largeTitleMode), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (BOOL)y_largeTitleMode{
    return [objc_getAssociatedObject(self, @selector(y_largeTitleMode)) boolValue];
}

- (void)setY_screenOrientation:(UIInterfaceOrientationMask)y_screenOrientation{
    objc_setAssociatedObject(self, @selector(y_screenOrientation), @(y_screenOrientation), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (UIInterfaceOrientationMask)y_screenOrientation{
    
    if (objc_getAssociatedObject(self, @selector(y_screenOrientation))) {
        return [objc_getAssociatedObject(self, @selector(y_screenOrientation)) integerValue];
    }else{
        return UIInterfaceOrientationMaskPortrait;
    }
    
}

- (void)setY_navBarTextColor:(UIColor *)y_navBarTextColor{
    objc_setAssociatedObject(self, @selector(y_navBarTextColor), y_navBarTextColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (UIColor *)y_navBarTextColor{
    
    return objc_getAssociatedObject(self, @selector(y_navBarTextColor))?objc_getAssociatedObject(self, @selector(y_navBarTextColor)):BarTextColor;
}


- (void)setY_navBarBgColor:(UIColor *)y_navBarBgColor{
    objc_setAssociatedObject(self, @selector(y_navBarBgColor), y_navBarBgColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (UIColor *)y_navBarBgColor{
    return objc_getAssociatedObject(self, @selector(y_navBarBgColor))?objc_getAssociatedObject(self, @selector(y_navBarBgColor)):BarBgColor;
}



- (void)setY_contentView:(UIView *)y_contentView{
    objc_setAssociatedObject(self, @selector(y_contentView), y_contentView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)y_contentView{
    return objc_getAssociatedObject(self, @selector(y_contentView));
}

- (void)setY_contentViewImgV:(UIView *)y_contentViewImgV{
    objc_setAssociatedObject(self, @selector(y_contentViewImgV), y_contentViewImgV, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImageView *)y_contentViewImgV{
    return objc_getAssociatedObject(self, @selector(y_contentViewImgV));
}


- (void)setY_navBarBgImg:(UIImage *)y_navBarBgImg{
    objc_setAssociatedObject(self, @selector(y_navBarBgImg), y_navBarBgImg, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)y_navBarBgImg{
    return objc_getAssociatedObject(self, @selector(y_navBarBgImg));
}

@end
