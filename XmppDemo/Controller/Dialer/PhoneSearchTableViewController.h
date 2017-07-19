//
//  PhoneSearchTableViewController.h
//  CallLiaoBei
//
//  Created by IntelcentMacMini on 16/11/9.
//  Copyright © 2016年 GeryHui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhoneSearchTableViewController : UITableViewController

@property (nonatomic, retain) NSMutableArray *searchPhoneArr;

@property (nonatomic, copy) void(^CellDidSelectedBlock)(NSIndexPath *indexPath);
@property (nonatomic, copy) void(^TableDidScrollBlock)();

@end
