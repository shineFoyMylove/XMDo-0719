//
//  ZFTabBar.h
//  ZFTabBar
//
//  Created by 任子丰 on 15/9/10.
//  Copyright (c) 2014年 任子丰. All rights reserved.
//

#import <UIKit/UIKit.h>

// 1.判断是否为iOS7
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
// 2.获得RGB颜色
#define ZFColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@class ZFTabBar;

@protocol ZFTabBarDelegate <NSObject>

@optional
- (void)tabBar:(ZFTabBar *)tabBar didSelectedButtonFrom:(NSInteger)from to:(NSInteger)to;

@end

@interface ZFTabBar : UIView
- (void)addTabBarButtonWithItem:(UITabBarItem *)item;

@property (nonatomic, weak) id<ZFTabBarDelegate> delegate;

@property (nonatomic, retain) UIColor *titleColor;
@property (nonatomic, retain) UIColor *titleSelectedColor;
@property (nonatomic, retain) UIFont *titleFont;

@end
