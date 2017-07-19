//
//  ViewController.m
//  XmppDemo
//
//  Created by IntelcentMac on 17/6/24.
//  Copyright © 2017年 wh_shine. All rights reserved.
//

#import "ViewController.h"
#import "XMPPTool.h"
#import "TestChatViewModel.h"

#import <XMNChat/XMNChat.h>

@interface ViewController ()

@property (nonatomic, retain) NSMutableArray *contentsArray;  //所有数据源

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"XmppDemo";
    
    UIButton *tmpBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [tmpBtn setTitle:@"Click To Talk" forState:(UIControlStateNormal)];
    [tmpBtn setFrame:CGRectMake(20, 200, [UIScreen mainScreen].bounds.size.width-20*2, 40)];
    
    [tmpBtn addTarget:self action:@selector(ClickToTalk:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.view addSubview:tmpBtn];
    
}


-(void)ClickToTalk:(id)sender{
    XMNChatController *chatVc = [[XMNChatController alloc] initWithChatMode:(XMNChatGroup)];
    
    TestChatViewModel *chatModel = [[TestChatViewModel alloc] initWithChatMode:(XMNChatGroup)];
    chatVc.chatVM = chatModel;
    
    
    [self.navigationController pushViewController:chatVc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
