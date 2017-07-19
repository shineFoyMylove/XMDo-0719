//
//  UIView+ZJQuickControl.h
//  ZJQuickControlDemo
//
//  Created by mac on 15/1/29.
//  Copyright (c) 2015年 zhang jian. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UIView (ZJQuickControl)
//添加标签
-(UILabel *)addLabelWithFrame:(CGRect)frame
                         text:(NSString *)text;
//添加系统按钮
-(UIButton *)addSystemButtonWithFrame:(CGRect)frame
                                title:(NSString *)title
                               action:(void (^)(UIButton *button))action;
//添加图片按钮
-(UIButton *)addImageButtonWithFrame:(CGRect)frame
                                title:(NSString *)title
                               backgroud:(NSString *)backgroud
                               action:(void (^)(UIButton *button))action;
//添加图片视图
-(UIImageView *)addImageViewWithFrame:(CGRect)frame
                                image:(NSString *)image;

@end
