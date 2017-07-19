//
//  TSYChatViewController.h
//  XmppProject
//
//  Created by IntelcentMac on 17/7/7.
//  Copyright © 2017年 wh_shine. All rights reserved.
//

#import <XMNChat/XMNChat.h>


@interface TSYChatViewController : XMNChatController

@property (nonatomic, retain,readonly) NSString *userId;   //用户id (暂用手机号码替代)

-(id)initWithChatMode:(XMNChatMode)aChatMode UserId:(NSString *)userId;


@end
