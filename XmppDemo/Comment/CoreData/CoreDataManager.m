//
//  CoreDataManager.m
//  XmppProject
//
//  Created by Gery晖 on 17/7/17.
//  Copyright © 2017年 wh_shine. All rights reserved.
//

#import "CoreDataManager.h"
#import "AppDelegate.h"

#define ManagedObjectModelFileName @"XmppDemo"

static CoreDataManager *shareInstance;

@implementation CoreDataManager

@synthesize PersistentStoreCoordinator = _PersistentStoreCoordinator;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;

+(instancetype)instance
{
    @synchronized(self)
    {
        if (shareInstance == nil) {
            shareInstance = [[self alloc]init];
        }
    }
    return shareInstance;
}


-(BOOL)saveContext{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            
            //持久化失败
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            return NO;
        }
    }else{
        NSLog(@"Managed Object Context is nil");
        return NO;
    }
    NSLog(@"Context Saved");
    
    return YES;
}

#pragma mark ———— 数据持久化、管理对象上下文————

/**
 创建调度器
 */
-(NSPersistentStoreCoordinator *)PersistentStoreCoordinator{
    if (_PersistentStoreCoordinator != nil) {
        return _PersistentStoreCoordinator;
    }
    // 持久化存储调度器
    _PersistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",ManagedObjectModelFileName]];
    NSDictionary *options = nil;
    
    //添加持久化存储
    NSError *error = nil;
    if (![_PersistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                   configuration:nil
                                                             URL:storeURL
                                                         options:options
                                                           error:&error]) {
        // Handle the error
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _PersistentStoreCoordinator;
}

//管理对象上下文（数据管理器）相当于一个临时数据库
-(NSManagedObjectContext *)managedObjectContext{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self PersistentStoreCoordinator];
    
    if (coordinator != nil) {
        NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [moc performBlockAndWait:^{
            NSUndoManager *undoManager = [[NSUndoManager alloc] init];
            [undoManager setGroupsByEvent:NO];
            [moc setUndoManager:undoManager];
            
            [moc setPersistentStoreCoordinator:coordinator];
        }];
        
        _managedObjectContext = moc;
    }
    
    return _managedObjectContext;
}

//被管理对象模型（数据模型器）
-(NSManagedObjectModel *)managedObjectModel{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:ManagedObjectModelFileName withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

    // Document 路径
- (NSURL *)applicationDocumentsDirectory{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}




@end
