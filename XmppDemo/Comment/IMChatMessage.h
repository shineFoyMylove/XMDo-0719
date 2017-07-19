//
//  IMChatMessage.h
//  XmppProject
//
//  Created by IntelcentMac on 17/7/11.
//  Copyright © 2017年 wh_shine. All rights reserved.
//  聊天记录消息

#import <XMNChat/XMNChat.h>
#import "MessageModel.h"

@interface IMChatMessage : XMNChatBaseMessage

    //from
@property (nonatomic, retain) NSString *from_headerImage;
@property (nonatomic, retain) NSString *from_uid;

@property (nonatomic, assign) IMMessgeType msgType;

@property (nonatomic, retain) NSString *textContent;

@property (nonatomic, retain) NSString *imageUrl;
@property (nonatomic, assign) CGFloat imgWidth;
@property (nonatomic, assign) CGFloat imgHeight;




-(void)insertCoreData;  //保存到 XMPPMessageArchiving_Message_CoreDataObject CoreData


@end
