//
//  AdviseViewController.m
//  WHIMDemo1
//
//  Created by IntelcentMac on 17/5/22.
//  Copyright © 2017年 wh_shine. All rights reserved.
//  意见反馈

#import "AdviseViewController.h"
#import "EMTextView.h"

@interface AdviseViewController ()

@property (weak, nonatomic) IBOutlet EMTextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@end

@implementation AdviseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"意见反馈";
    
}

-(IBAction)ClickSubmitAdvise:(id)sender{
    
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
