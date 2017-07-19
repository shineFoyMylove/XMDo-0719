//
//  SDTimeLineRefreshHeader.h
//  GSD_WeiXin(wechat)
//
//  Created by gsd on 16/3/5.
//  Copyright © 2016年 GSD. All rights reserved.
//

/*
 
 *********************************************************************************
 *
 *
 * QQ交流群: 459274049
 * Email : gsdios@126.com
 * 新浪微博:GSD_iOS
 *
 *
 *********************************************************************************
 
 */

#import <UIKit/UIKit.h>
#import "SDBaseRefreshView.h"

@interface SDTimeLineRefreshHeader : SDBaseRefreshView<CAAnimationDelegate>

+ (instancetype)refreshHeaderWithCenter:(CGPoint)center;

@property (nonatomic, copy) void(^refreshingBlock)();

@end
