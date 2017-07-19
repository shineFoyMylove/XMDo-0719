//
//  MsgCenterTableViewCell.h
//  WHIMDemo1
//
//  Created by IntelcentMac on 17/6/9.
//  Copyright © 2017年 wh_shine. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MsgCenterModel;
@interface MsgCenterTableViewCell : UITableViewCell

@property (nonatomic, strong) MsgCenterModel *model;



@end


@interface MsgCenterModel : NSObject

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) NSString *time;
@property (nonatomic, retain) NSString *detailUrl;


@end
