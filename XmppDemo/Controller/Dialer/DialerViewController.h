//
//  DialerViewController.h
//  WHIMDemo1
//
//  Created by Gery晖 on 17/4/10.
//  Copyright © 2017年 wh_shine. All rights reserved.
//

#import "BaseViewController.h"
#import "HistoryTableViewController.h"
#import "PhoneSearchTableViewController.h"

@interface DialerViewController : BaseViewController

@property (nonatomic, retain) IBOutlet HistoryTableViewController *historyVC;
@property (nonatomic, retain) IBOutlet UITableView *historyTable;
@property (nonatomic, retain) IBOutlet PhoneSearchTableViewController *searchVC;
@property (nonatomic, retain) IBOutlet UITableView *searchResultTable;

-(void)changeHistoryRecordView:(BOOL)kbHide;   /**<拨打页面-通话记录页面切换 */


@end
