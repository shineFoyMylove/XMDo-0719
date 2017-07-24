//
//  ChatMessage+CoreDataProperties.m
//  XmppProject
//
//  Created by IntelcentMac on 17/7/17.
//  Copyright © 2017年 wh_shine. All rights reserved.
//

#import "ChatMessage+CoreDataProperties.h"
#import "CoreDataManager.h"

@implementation ChatMessage (CoreDataProperties)

+ (NSFetchRequest<ChatMessage *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ChatMessage"];
}

@dynamic conversationId;
@dynamic userphone;
@dynamic messageID;
@dynamic sendState;

@dynamic from_name;
@dynamic from_phone;
@dynamic from_uid;
@dynamic from_headerImage;

@dynamic to_name;
@dynamic to_phone;
@dynamic to_uid;
@dynamic to_headerImage;

@dynamic msgType;
@dynamic textContent;

@dynamic img_url;
@dynamic img_height;
@dynamic img_width;

@dynamic video_url;
@dynamic video_length;
@dynamic voice_url;
@dynamic voice_length;

@dynamic file_url;
@dynamic file_name;
@dynamic file_suffix;
@dynamic file_size;

@dynamic loc_lng;
@dynamic loc_lat;
@dynamic timeInterval;


#pragma mark - 管理 属性
//当前数据模型描述
+(NSEntityDescription *)entityDescription{
    NSManagedObjectContext *context = [CoreDataManager instance].managedObjectContext;
    if (context) {
        return [NSEntityDescription entityForName:@"ChatMessage" inManagedObjectContext:context];
    }
    return nil;
}


#pragma mark - 实例方法 -- 增、删、改操作

+(instancetype)NewMessage{
    ChatMessage *msgItem = [ChatMessage alloc];
    if ([msgItem respondsToSelector:@selector(initWithContext:)]) {
        msgItem = [msgItem initWithContext:[CoreDataManager instance].managedObjectContext];
    }else{
        msgItem = [msgItem initWithEntity:[ChatMessage entityDescription] insertIntoManagedObjectContext:[CoreDataManager instance].managedObjectContext];
    }
    
//    ChatMessage *msgItem  = [[ChatMessage alloc] initWithContext:[CoreDataManager instance].managedObjectContext];
    
    return  msgItem;
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
    if ([ChatMessage entityDescription]) {
  
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
}


#pragma mark - 静态方法、检索、批量操作
/**
 所有聊天记录
 默认按时间排序，倒序
 @return NSArray<ChatMessage *>
 */
+(NSArray <ChatMessage *>*)fetchAllChatMessage{
    NSFetchRequest *requset = [ChatMessage fetchRequest];
    
    //排序
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeInterval"
                                                                   ascending:YES];
    [requset setSortDescriptors:@[sortDescriptor]];
    
    NSError *error = nil;
    
    NSArray *fetchReqeust = [[CoreDataManager instance].managedObjectContext
                             executeFetchRequest:requset
                             error:&error];
    if ([fetchReqeust count] >0) {
        return fetchReqeust;
    }
    
    return nil;
}


/**
 某会话窗口 最新聊天记录 默认 20条
 @param conversationID 会话窗口ID
 @return NSArray<ChatMessage *>
 */
+(NSArray <ChatMessage *>*)fetchTheRecentChatMessageWithID:(NSString *)conversationID{
    
    NSFetchRequest *request = [ChatMessage fetchRequest];
    
    //排序
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeInterval" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    
    //筛选
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"conversationId = %@",conversationID];
    request.predicate = predicate;
    
    NSError *error = nil;
    NSArray *fetchArr = [[CoreDataManager instance].managedObjectContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"数据库访问错误:%@",error.description);
    }
    if (fetchArr.count >0) {
        return fetchArr;
    }
    
    return nil;
}


/**
 检索筛选聊天记录
 @param search 筛选条件
 @return NSArray<ChatMessage *>
 */
+(NSArray <ChatMessage *> *)fetchChatMessageWithSearchText:(NSString *)search{
    return nil;
}


/**
 清除部分聊天记录
 @param messageArray NSArray<ChatMessage *>
 */
+(BOOL)removeChatMessages:(NSArray <ChatMessage *> *)messageArray{
    return YES;
}


/**
 清除所有的聊天记录
 */
+(BOOL)removeAllChatMessage{
    return YES;
}


@end
