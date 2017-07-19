//
//  HistoryTableCell.h
//  CallLiaoBei
//
//  Created by IntelcentMacMini on 16/10/29.
//  Copyright © 2016年 GeryHui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *contactText;
@property (nonatomic, weak) IBOutlet UILabel *contactDes;
@property (nonatomic, weak) IBOutlet UILabel *recordDate;  /**<通话时间*/


@property (nonatomic, copy) void(^CellDetailBlock)();


@end
