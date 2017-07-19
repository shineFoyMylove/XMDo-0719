//
//  NewFriendObject+CoreDataProperties.h
//  XmppProject
//
//  Created by Gery晖 on 17/7/18.
//  Copyright © 2017年 wh_shine. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "NewFriendObject+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface NewFriendObject (CoreDataProperties)

+ (NSFetchRequest<NewFriendObject *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *uid;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *phone;

@property (nullable, nonatomic, copy) NSString *imageUrl;
@property (nullable, nonatomic, copy) NSString *sign;  //签名信息

@property (nonatomic) TLNewFriendApplyState state;        //申请状态

@property (nonatomic) double timeInterval;
@property (nullable, nonatomic, copy) NSString *userphone;


@end

NS_ASSUME_NONNULL_END
