//
//  HistoryTableViewController.h
//  CallLiaoBei
//
//  Created by IntelcentMacMini on 16/11/10.
//  Copyright © 2016年 GeryHui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryDetailViewController.h"

@interface HistoryTableViewController : UITableViewController

@property (nonatomic, copy) void(^CellDidSelectedBlock)(NSIndexPath *indexPath);
@property (nonatomic, copy) void(^CellDetailClickBlock)(NSIndexPath *indexPath);
@property (nonatomic, copy) void(^TableDidScrollBlock)();

@property (nonatomic, retain) NSMutableArray *historyContentArr;

-(void)logsReload;

@end
