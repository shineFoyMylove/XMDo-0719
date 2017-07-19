//
//  NewFriendTableViewCell.h
//  XmppProject
//
//  Created by IntelcentMac on 17/7/18.
//  Copyright © 2017年 wh_shine. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewFriendObject;
@interface NewFriendTableViewCell : UITableViewCell


@property (nonatomic, weak) IBOutlet UIButton *applyState;  //申请状态 同意、已添加、等待验证

@property (nonatomic, weak) IBOutlet UIImageView *headerImage;  //头像
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;   //名称
@property (nonatomic, weak) IBOutlet UILabel *descLabel;  //号码

@property (nonatomic,assign) TLNewFriendApplyState state;

@property (nonatomic,retain) NewFriendObject *objItem;

@property (nonatomic, assign) BOOL haveBottomLine;

-(void)setAgreeActionBlock:(void(^)(BOOL result))agreeBlock;


@end


//@interface NewFriendObject : NSObject
//
//@property (nonatomic, retain) NSString *uid;
//@property (nonatomic, retain) NSString *name;
//@property (nonatomic, retain) NSString *phone;
//@property (nonatomic, retain) NSString *imageUrl;
//
//@property (nonatomic, retain) NSString *signString;  //签名信息
//
//@property (nonatomic, assign) TLNewFriendApplyState applyState;  //申请状态
//
//
//+(NSArray <NewFriendObject *> *)featchAllRequest;  //查询所有
//
//-(NSManagedObject *)insertManagedObject;   //插入
//
//-(BOOL)updateFriendObject;   //该条记录更新
//
//
//@end
