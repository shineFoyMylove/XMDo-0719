//
//  HistoryViewController.h
//  CallLiaoBei
//
//  Created by IntelcentMacMini on 16/10/29.
//  Copyright © 2016年 GeryHui. All rights reserved.
//

#import "BaseViewController.h"
#import "HistoryTableViewController.h"

@interface HistoryViewController : BaseViewController


@property (nonatomic, retain) IBOutlet HistoryTableViewController *historyTableVC;
@property (nonatomic, retain) IBOutlet UITableView *contentTable;


@end
