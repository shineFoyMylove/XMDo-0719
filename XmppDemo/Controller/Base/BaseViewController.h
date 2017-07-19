//
//  BaseViewController.h
//  WHIMDemo1
//
//  Created by IntelcentMac on 17/3/24.
//  Copyright © 2017年 wh_shine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "AddressbookObject.h"
#import "AppUserInfo.h"
#import "AppManager.h"

@class LeftViewController;

typedef void (^RightBarButtonActionBlock) (void);
typedef void (^LeftBarButtonActionBlock) (void);

@interface BaseViewController : UIViewController

@property (nonatomic, retain) AppDelegate *ShareApp;
@property (nonatomic, retain) AppManager *appManager;
@property (nonatomic, retain) AppUserInfo *userInfo;
@property (nonatomic, strong) AddressbookObject *addressBook;

@property (nonatomic, retain, getter=CUS_GET_TABBARVC) UIViewController *tabBarController;
@property (nonatomic, retain) UINavigationController *centerNavController;


/**
 *  push新的控制器到导航控制器
 *  @_param newViewController 目标新的视图控制器
 */
- (void)pushViewController:(UIViewController *)newViewController;

/**
 *  普通pop，popRootViewController
 */
-(void)popViewControllerAnimated:(BOOL)animated;

//延时 pop
-(void)popViewControllerAnimated:(BOOL)animated delay:(BOOL)delay;

/**
 *  设置带文字的左导航按钮并且回调方法
 *
 *  @_param title 设置左侧导航按钮的文字内容
 *  @_param action 设置动作
 */
//- (void)configureLeftBarButtonWithTitle:(NSString *)title action:(LeftBarButtonActionBlock)action;
- (void)configureLeftBarButtonWithTitle:(NSString *)title image:(UIImage *)image action:(LeftBarButtonActionBlock)action;

//- (void)configureLeftBarButtonWithTitle:(NSString *)title image:(UIImage *)image sel:(SEL)select;

/**
 *  设置带文字的右导航按钮并且回调方法
 *
 *  @_param title 设置右侧导航按钮的文字内容
 *  @_param action 设置动作
 */
- (void)configureRightBarButtonWithTitle:(NSString *)title image:(UIImage *)image action:(RightBarButtonActionBlock)action;
//- (void)configureRightBarButtonWithTitle:(NSString *)title image:(UIImage *)image sel:(SEL)select;


#pragma mark 抽屉开关
/**
 *  控制抽屉可否打开左侧页面
 *  @_param enable YES 打开抽屉  NO 关闭抽屉
 */
- (void)enableOpenLeftDrawer:(BOOL)enable;


#pragma mark 回拨呼叫
/**
 回拨呼叫请求*/
-(BOOL)dialerCall:(NSString *)phone name:(NSString *)diaplayName;

#pragma mark 通用方法
-(void)showMBText:(NSString *)text;   /**< show 提示 */

-(void)MBLoadingWithText:(NSString *)text;   /**<MBProgressHUD 加载指示器*/
/**
 加载中指示器，是否需要蒙板 */
-(void)MBLoadingWithText:(NSString *)text haveDimBg:(BOOL)dimbg;

-(void)MBLoading:(BOOL)load;        /**< MProgressHUD加载 或者停止*/

/*** 提示框 */
-(void)showAlertView:(NSString *)title detail:(NSString *)detailText withDelegate:(UIViewController *)targetVc;



@end


