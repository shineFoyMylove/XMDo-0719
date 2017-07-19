//
//  BaseNaviViewController.m
//  WHIMDemo1
//
//  Created by IntelcentMac on 17/3/24.
//  Copyright © 2017年 wh_shine. All rights reserved.
//

#import "BaseNaviViewController.h"
#import "BaseViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface BaseNaviViewController ()<UINavigationControllerDelegate>

@end

@implementation BaseNaviViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    UIImage *defaultImg = [UIImage imageWithColor:AppMainColor cornerRadius:0.0];
    [self.navigationBar setBackgroundImage:defaultImg forBarMetrics:(UIBarMetricsDefault)];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys
                                :[UIColor whiteColor], NSForegroundColorAttributeName
                                ,[UIFont boldSystemFontOfSize:18], NSFontAttributeName, nil];
    [self.navigationBar setTitleTextAttributes:attributes];
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
