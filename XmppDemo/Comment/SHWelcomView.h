//
//  SHWelcomView.h
//  iCallYiQiTong
//
//  Created by IntelcentMacMini on 16/9/10.
//  Copyright © 2016年 英之杰讯邦网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHWelcomView : UIView

@property (nonatomic, assign) BOOL enableJumpOverClick;
@property (nonatomic, assign) BOOL havePageControl;

-(BOOL)enableJumpOverClick;   /**<允许跳过*/

-(void)setViewOverBlock:(void(^)())overBlock ;

/**
 *欢迎启动条件 condition判断 
 */
-(void)setViewOverBlock:(void (^)())overBlock withSwithOnCondition:(BOOL(^)())condition;

-(void)setWelcomeImages:(NSArray *)images;

-(void)viewShow;
-(void)viewHidden;


@end
