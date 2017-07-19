//
//  SDLaunchWebViewController.h
//  SDLaunchDemo
//
//  Created by songjc on 16/11/23.
//  Copyright © 2016年 Don9. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDLaunchWebViewController : UIViewController

@property(nonatomic,strong)NSString *requestURL;

//导航栏view
@property(nonatomic,strong)UIView *navigationView;


/**
 广告标题
 */
@property(nonatomic,strong)NSString *titleString;

/**
 根视图控制器
 */
@property(nonatomic,strong)UIViewController *mainViewController;

@end
