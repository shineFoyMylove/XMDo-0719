//
//  MyFirendCircleTable.h
//  WHIMDemo1
//
//  Created by IntelcentMac on 17/5/31.
//  Copyright © 2017年 wh_shine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyFriendCircleTable : UITableViewController

//Header
@property (nonatomic, retain) UIView *headerView;
@property (nonatomic, retain) UIImageView *headerBgImage;
@property (nonatomic, copy) void(^headerViewTagBlock)();  //点击触发

@property (nonatomic, retain) UIView *inputView;  //评论输入View


@end
