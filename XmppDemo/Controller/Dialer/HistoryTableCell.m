//
//  HistoryTableCell.m
//  CallLiaoBei
//
//  Created by IntelcentMacMini on 16/10/29.
//  Copyright © 2016年 GeryHui. All rights reserved.
//

#import "HistoryTableCell.h"

@implementation HistoryTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(IBAction)DeatilClick:(id)sender{
    if (self.CellDetailBlock) {
        self.CellDetailBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
