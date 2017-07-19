//
//  NewFriendObject+CoreDataClass.m
//  XmppProject
//
//  Created by Gery晖 on 17/7/18.
//  Copyright © 2017年 wh_shine. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "NewFriendObject+CoreDataClass.h"
#import "CoreDataManager.h"

@implementation NewFriendObject


//查询所有
+(NSArray <NewFriendObject *> *)featchAllRequest{
    
    NSFetchRequest *fetchRequset = [NewFriendObject fetchRequest];
    
    //排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"timeInterval" ascending:YES];
    fetchRequset.sortDescriptors = @[sort];
    
    //筛选过滤
    NSString *userphone = UDGetString(username_preference);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userphone = %@",userphone];
    fetchRequset.predicate = predicate;
    
    NSError *error = nil;
    NSArray *results = [[NewFriendObject context] executeFetchRequest:fetchRequset error:&error];
    if (error) {
        [NSException raise:@"查询失败" format:@"%@",error.description];
    }
    
    if (results.count >0) {
        return results;
    }
    
    return nil;
}

//更新数据
-(BOOL)updateFriendObject{
    //找到该记录
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSString *classname = NSStringFromClass([self class]);
    fetchRequest.entity = [NSEntityDescription entityForName:classname inManagedObjectContext:[NewFriendObject context]];
    
    //筛选过滤
    NSString *userphone = UDGetString(username_preference);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userphone = %@ , phone = %@",userphone,self.phone];
    fetchRequest.predicate = predicate;
    
    NSError *error = nil;
    NSArray *objs = [[NewFriendObject context] executeFetchRequest:fetchRequest error:&error];
    if (error) {
        [NSException raise:@"查询失败" format:@"%@",error.description];
    }
    if (objs.count >0){
        NewFriendObject *obj = [objs firstObject];
        //修改
        [self CopySelfToManagedObject:obj];
        
        //保存
        if ([self saveContext]) {
            return YES;
        }
    }
    
    return NO;
}

    //将self属性同步到 managedObject，然后持久化保存
-(void)CopySelfToManagedObject:(NSManagedObject *)object{

    NSString *username = UDGetString(username_preference);
    [object setValue:NotNullString(username) forKey:@"userphone"];   //当前登录用户

    [object setValue:NotNullString(self.uid) forKey:@"uid"];
    [object setValue:NotNullString(self.name) forKey:@"name"];  //昵称
    [object setValue:NotNullString(self.phone) forKey:@"phone"];
    [object setValue:NotNullString(self.imageUrl) forKey:@"imageUrl"];
    [object setValue:NotNullString(self.sign) forKey:@"sign"];  //签名
    [object setValue:[NSNumber numberWithInt:self.state] forKey:@"state"];

    [object setValue:[NSNumber numberWithDouble:[NSDate timeInterval]] forKey:@"timeInterval"];  //时间戳、排序
}

//-(NSManagedObject *)insertManagedObject{
//    // 创建实体对象，出入上下文
//    NSString *className = NSStringFromClass([self class]);
//    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:className
//                                                            inManagedObjectContext:[NewFriendObject context]];
//    
//    [self CopySelfToManagedObject:object];
//    
//    //同步到上下文，持久保存数据库
//    if (![self saveContext]) {
//        [NSException raise:@"访问数据库错误" format:@""];
//        return nil;
//    }
//    return object;
//}

//上下文
+(NSManagedObjectContext *)context{
    return [CoreDataManager instance].managedObjectContext;
}

//当前数据模型描述
+(NSEntityDescription *)entityDescription{
    NSManagedObjectContext *context = [CoreDataManager instance].managedObjectContext;
    if (context) {
        NSString *className = NSStringFromClass([NewFriendObject class]);
        return [NSEntityDescription entityForName:className inManagedObjectContext:context];
    }
    return nil;
}

#pragma mark - 实例方法 -- 增、删、改操作

+(instancetype)NewMessage{
    NewFriendObject *newObj  = [[NewFriendObject alloc] initWithContext:[CoreDataManager instance].managedObjectContext];
    return  newObj;
}

//重写 init
-(id)init{
    if (self = [super init]) {
        self = [self initWithContext:[CoreDataManager instance].managedObjectContext];
    }
    return self;
}
//增加一条记录
-(BOOL)insert{
    if ([NewFriendObject entityDescription]) {
        
            //默认属性
        self.timeInterval = [NSDate timeInterval];
        self.userphone = UDGetObject(username_preference);
        
        return [self saveContext];
    }
    return NO;
}
//移除一条记录
-(BOOL)remove{
    NSManagedObjectContext *context = [CoreDataManager instance].managedObjectContext;
    if (context) {
        [context deleteObject:self];
    }
    return [self saveContext];
}


//保存
-(BOOL)saveContext{
    return [[CoreDataManager instance] saveContext];
    
//    NSError *error = nil;
//    NSManagedObjectContext *managedObjectContext = [NewFriendObject context];
//    if (managedObjectContext != nil) {
//        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
//            
//            //持久化失败
//            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//            return NO;
//        }
//    }else{
//        NSLog(@"Managed Object Context is nil");
//        return NO;
//    }
//    NSLog(@"Context Saved");
//    return YES;
}


@end
