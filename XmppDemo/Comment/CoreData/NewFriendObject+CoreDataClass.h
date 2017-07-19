//
//  NewFriendObject+CoreDataClass.h
//  XmppProject
//
//  Created by Gery晖 on 17/7/18.
//  Copyright © 2017年 wh_shine. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewFriendObject : NSManagedObject


+(NSArray <NewFriendObject *> *)featchAllRequest;  //查询所有

-(BOOL)updateFriendObject;   //该条记录更新

+(instancetype)NewMessage;   /**<替换 初始化  */

-(BOOL)insert;   /**< 增加一条记录 */

-(BOOL)remove;   /**< 移除一条记录 */

@end

NS_ASSUME_NONNULL_END

#import "NewFriendObject+CoreDataProperties.h"
