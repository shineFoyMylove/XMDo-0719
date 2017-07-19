//
//  ChatConversation+CoreDataProperties.m
//  XmppProject
//
//  Created by IntelcentMac on 17/7/17.
//  Copyright © 2017年 wh_shine. All rights reserved.
//

#import "ChatConversation+CoreDataProperties.h"

@implementation ChatConversation (CoreDataProperties)

+ (NSFetchRequest<ChatConversation *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ChatConversation"];
}

@dynamic conversationId;
@dynamic headerImage;
@dynamic name;
@dynamic last_message;
@dynamic last_time;
@dynamic chatType;

@end
