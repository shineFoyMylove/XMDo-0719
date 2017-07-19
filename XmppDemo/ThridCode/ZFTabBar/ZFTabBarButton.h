//
//  ZFTabBarButton.h
//  ZFTabBar
//
//  Created by 任子丰 on 15/9/10.
//  Copyright (c) 2014年 任子丰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFTabBarButton : UIButton
@property (nonatomic, strong) UITabBarItem *item;

@property (nonatomic, retain) UIColor *titleColor;
@property (nonatomic, retain) UIColor *titleSelectedColor;
@property (nonatomic, retain) UIFont *titleFont;



@end
