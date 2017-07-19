//
//  CoreDataManager.h
//  XmppProject
//
//  Created by Gery晖 on 17/7/17.
//  Copyright © 2017年 wh_shine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataManager : NSObject

/**
 持久化存储助理（数据链接器）整个CoreData中的核心
 */
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *PersistentStoreCoordinator;


/**
 被管理对象上下文（数据管理器）相当于一个临时数据库
 */
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

/**
 被管理对象模型（数据模型器）
 */
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;


+(instancetype)instance;

-(BOOL)saveContext;  /**<持久化保存 */

@end
