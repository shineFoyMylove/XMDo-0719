//
//  MBProgressHUD+MJ.h
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (MJ)
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;
+ (void)showSuccess:(NSString *)success detail:(NSString *)des toView:(UIView *)view;


+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;


+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;

+ (MBProgressHUD *)showMessage:(NSString *)message;
+ (MBProgressHUD *)showMessage:(NSString *)message haveDimbg:(BOOL)dimBg;  /**<是否有朦版*/

+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;

// 类似 Toast 提示
+(void)showToastWithText:(NSString *)text inView:(UIView *)view;

@end
