//
//  FriendCircleModel.h
//  WHIMDemo1
//
//  Created by IntelcentMac on 17/5/31.
//  Copyright © 2017年 wh_shine. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FriCircleLikeItemModel, FriCircleCommentItemModel;
/***  朋友圈数据 model  ***/
@interface FriendCircleModel : NSObject

@property (nonatomic, retain) NSString *iconName;      //用户头像
@property (nonatomic, retain) NSString *name;          //用户名
@property (nonatomic, retain) NSString *msgContent;    //主题content
@property (nonatomic, retain) NSArray *picNameArr;    //图片组

@property (nonatomic, retain) NSArray<FriCircleLikeItemModel *>   *likeItemArr;   //点赞 组
@property (nonatomic, retain) NSArray<FriCircleCommentItemModel *> *commentItemArr; //评论 组

@property (nonatomic, assign, getter=isLiked) BOOL like;  //用户本人是否点赞
@property (nonatomic, assign) BOOL isOpening;    //是否展开全文
@property (nonatomic, assign, readonly) BOOL shouldShowMoreButton;   //是否有更多按钮

@end


/***  朋友圈点赞 model  ***/
@interface FriCircleLikeItemModel : NSObject

@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSString *userId;
@property (nonatomic, retain) NSAttributedString *attributedContent;  //点赞富文本内容

@end


/***  朋友圈评论 model  ***/
@interface FriCircleCommentItemModel : NSObject

@property (nonatomic, retain) NSString *commentString;  //评论内容

@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSString *userId;
@property (nonatomic, retain) NSString *replyUserName;  //回复To 用户名
@property (nonatomic, retain) NSString *replyUserId;    //回复To 用户ID

@property (nonatomic, retain) NSAttributedString *attributedContent;  //评论富文本内容


@end


