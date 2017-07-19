//
//  HistoryDetailCell.h
//  CallLiaoBei
//
//  Created by IntelcentMacMini on 16/11/22.
//  Copyright © 2016年 GeryHui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryDetailCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *typeLabel;
@property (nonatomic, weak) IBOutlet UILabel *durationLab;


-(void)setDetailItem:(id)item;

@end
