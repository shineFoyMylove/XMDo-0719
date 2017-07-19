//
//  HistoryViewController.m
//  CallLiaoBei
//
//  Created by IntelcentMacMini on 16/10/29.
//  Copyright © 2016年 GeryHui. All rights reserved.
//  通话记录

#import "HistoryViewController.h"

@interface HistoryViewController ()

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"通话记录";
    
    WkSelf(weakSelf);
    
    //通话记录列表Cell点击查看 详情
    [self.historyTableVC setCellDetailClickBlock:^(NSIndexPath *indexPath) {
        if (weakSelf.historyTableVC.historyContentArr.count > indexPath.row) {
            HistoryDetailViewController *historyDetailVc = [[HistoryDetailViewController alloc] init];
            CallLogObject *tmpLog = weakSelf.historyTableVC.historyContentArr[indexPath.row];
            [historyDetailVc setLogItem:tmpLog];
            [weakSelf pushViewController:historyDetailVc];
        }
    }];
    
    //通话记录cell点击拨号
    [self.historyTableVC setCellDidSelectedBlock:^(NSIndexPath *indexpath) {
        NSLog(@"index: section:%d , row:%d",indexpath.section,indexpath.row);
        if (weakSelf.historyTableVC.historyContentArr.count > indexpath.row) {
            CallLogObject *model = weakSelf.historyTableVC.historyContentArr[indexpath.row];
            if ([model isKindOfClass:[CallLogObject class]]) {
                [weakSelf CallActionForItem:nil phone:model.phone];
            }
        }
    }];
    
}

-(void)CallActionForItem:(ContactModel *)model phone:(NSString *)number{
    if (model) {
        [self dialerCall:model.dialerPhone name:model.name];
    }else{
        [self dialerCall:number name:nil];
    }
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
