//
//  ContactDetailViewController.h
//  CallLiaoBei
//
//  Created by IntelcentMacMini on 16/11/11.
//  Copyright © 2016年 GeryHui. All rights reserved.
//

#import "BaseViewController.h"

@interface ContactDetailViewController : BaseViewController

@property (nonatomic, retain) ContactModel *itemModel;

@property (nonatomic, retain) IBOutlet UITableView *phonesTable;

@end
