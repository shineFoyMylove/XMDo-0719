//
//  FirendCircleCell.h
//  WHIMDemo1
//
//  Created by IntelcentMac on 17/5/31.
//  Copyright © 2017年 wh_shine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendCircleModel.h"

@protocol FriendCircelCellDelegate <NSObject>

/**
 *  赞 按钮 点击触发
 */
-(void)friendCircleCellDidClickLikeButton:(UITableViewCell *)cell;

/**
 *  评论 按钮 点击触发
 */
-(void)friendCircleCellDidClickCommentButton:(UITableViewCell *)cell;


@end


@class FriendCircleModel;
@interface FriendCircleCell : UITableViewCell


@property (nonatomic, weak) id<FriendCircelCellDelegate> delegate;
@property (nonatomic, strong) FriendCircleModel *model;
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, assign) CGFloat contentFontSize;
@property (nonatomic, assign) CGFloat nameFontSize;

@property (nonatomic, copy) void (^moreButtoClickBlock)(NSIndexPath *indexPath);

@end
