//
//  ChatConversation+CoreDataProperties.h
//  XmppProject
//
//  Created by IntelcentMac on 17/7/17.
//  Copyright © 2017年 wh_shine. All rights reserved.
//

#import "ChatConversation+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ChatConversation (CoreDataProperties)

+ (NSFetchRequest<ChatConversation *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *conversationId;  /**<会话 Id, 单聊-对方phone, 群聊-群组id */
@property (nullable, nonatomic, copy) NSString *headerImage;    //头像
@property (nullable, nonatomic, copy) NSString *name;           //名称
@property (nullable, nonatomic, copy) NSString *last_message;   //最后一条消息

@property (nonatomic) double last_time;         //最后一条消息时间
@property (nonatomic) IMChatType chatType;      /**< 聊天类型 (100:单聊 200:群聊) 必须*/

@end

NS_ASSUME_NONNULL_END
