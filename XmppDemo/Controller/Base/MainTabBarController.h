//
//  MainTabBarController.h
//  WHIMDemo1
//
//  Created by Gery晖 on 17/4/7.
//  Copyright © 2017年 wh_shine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFTabBar.h"
#import "ZFTabBarButton.h"

@interface MainTabBarController : UITabBarController

/**
 *  自定义的tabbar
 */
@property (nonatomic, weak) ZFTabBar *CustomTabBar;

-(void)TabVcPushViewController:(UIViewController *)viewController;

-(void)setupTabBar:(NSArray *)titles images:(NSArray *)images selectedImages:(NSArray *)selectedImages;

-(void)setTabBar:(NSInteger)tabIndex badgeValue:(NSString *)badgeValue;

-(void)keyboardIconHidden:(BOOL)hide;   //键盘隐藏 Tab Item logo改变

@end
