//
//  NewFriendObject+CoreDataProperties.m
//  XmppProject
//
//  Created by Gery晖 on 17/7/18.
//  Copyright © 2017年 wh_shine. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "NewFriendObject+CoreDataProperties.h"

@implementation NewFriendObject (CoreDataProperties)

+ (NSFetchRequest<NewFriendObject *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"NewFriendObject"];
}

@dynamic imageUrl;
@dynamic name;
@dynamic phone;
@dynamic sign;
@dynamic state;
@dynamic timeInterval;
@dynamic uid;
@dynamic userphone;

@end
