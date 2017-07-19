//
//  HistoryDetailViewController.h
//  CallLiaoBei
//
//  Created by IntelcentMacMini on 16/11/11.
//  Copyright © 2016年 GeryHui. All rights reserved.
//

#import "BaseViewController.h"
#import "CallLogObject.h"

@interface HistoryDetailViewController : BaseViewController


@property (retain, nonatomic) CallLogObject *logItem;
@property (retain, nonatomic) IBOutlet UITableView *logsTable;

@property (nonatomic, copy) void(^CallLogsReload)();

@end
