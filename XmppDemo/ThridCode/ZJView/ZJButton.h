//
//  ZJButton.h
//  ZJQuickControlDemo
//
//  Created by mac on 15/1/29.
//  Copyright (c) 2015年 zhang jian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJButton : UIButton
@property (nonatomic,copy) void (^action)(UIButton *button);
@end
