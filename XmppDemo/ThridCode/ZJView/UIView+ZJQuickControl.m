//
//  UIView+ZJQuickControl.m
//  ZJQuickControlDemo
//
//  Created by mac on 15/1/29.
//  Copyright (c) 2015年 zhang jian. All rights reserved.
//

#import "UIView+ZJQuickControl.h"

#import "ZJButton.h"

@implementation UIView (ZJQuickControl)
//添加标签
-(UILabel *)addLabelWithFrame:(CGRect)frame
                         text:(NSString *)text
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    [self addSubview:label];
    return label;
}
//添加系统按钮
-(UIButton *)addSystemButtonWithFrame:(CGRect)frame
                                title:(NSString *)title
                               action:(void (^)(UIButton *button))action
{
    ZJButton *button = [ZJButton buttonWithType:UIButtonTypeSystem];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    button.action = action;
    [self addSubview:button];
    return button;
}
//添加图片按钮
-(UIButton *)addImageButtonWithFrame:(CGRect)frame
                               title:(NSString *)title
                           backgroud:(NSString *)backgroud
                              action:(void (^)(UIButton *button))action
{
    ZJButton *button = [ZJButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:backgroud] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.action = action;
    [self addSubview:button];
    return button;
}
//添加图片视图
-(UIImageView *)addImageViewWithFrame:(CGRect)frame
                                image:(NSString *)image
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = [UIImage imageNamed:image];
    imageView.userInteractionEnabled = YES;
    [self addSubview:imageView];
    return imageView;
}

@end
