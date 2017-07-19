//
//  HistoryDetailCell.m
//  CallLiaoBei
//
//  Created by IntelcentMacMini on 16/11/22.
//  Copyright © 2016年 GeryHui. All rights reserved.
//

#import "HistoryDetailCell.h"
#import "CallLogObject.h"

@implementation HistoryDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setDetailItem:(id)item{
    if ([item isKindOfClass:[CallLogObject class]]) {
        CallLogObject *obj = (CallLogObject *)item;
            //时间
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd HH:mm:ss"];
        NSString *dateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:obj.dateTime]];
        [self.dateLabel setText:dateStr];
            //类型
        NSString *typeStr = @"";
        if ([obj.callType isEqualToString:@"1"]) {
            typeStr = @"呼出";
        }else if ([obj.callType isEqualToString:@"2"]){
            typeStr = @"呼出(直拨)";
        }else if ([obj.callType isEqualToString:@"3"]){
            typeStr = @"接听";
        }
        [self.typeLabel setText:typeStr];
            //时长
        obj.duration = 0.0;
        [self.durationLab setText:[self timeDurationWithSeconds:obj.duration]];
    }
}

-(NSString *)timeDurationWithSeconds:(NSInteger)seconds{
    NSString *resultStr = @"";
    if (seconds <60) {
        //一分钟内
        resultStr = [NSString stringWithFormat:@"%ld秒",(long)seconds];
    }else if (seconds < 60*60){
        //一小时内
        NSInteger minuteValue = seconds/60;
        NSInteger secondValue = seconds%60;
        resultStr = [NSString stringWithFormat:@"%ld分%ld秒",(long)minuteValue,(long)secondValue];
    }else if (seconds < 24*60*60){
        //一天内
        NSInteger houtValue = seconds/60/60;
        NSInteger minuteValue = (seconds%(60*60))/60;
        NSInteger secondValue = seconds%60;
        resultStr = [NSString stringWithFormat:@"%ld时%ld分%ld秒",(long)houtValue,(long)minuteValue,(long)secondValue];
    }else{
        resultStr = @"久不可言";
    }
    return resultStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
