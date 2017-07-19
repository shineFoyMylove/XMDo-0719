//
//  TSYContact.h
//  XmppDemo
//
//  Created by IntelcentMac on 17/7/1.
//  Copyright © 2017年 wh_shine. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XMPPJID;
@class XMPPvCardTemp;

@interface TSYContact : NSObject

//TSY是一个关于联系人的Model,包含 联系人的JID以及联系人电子名片
@property (nonatomic, strong) XMPPJID *jid;
@property (nonatomic, strong) XMPPvCardTemp *vCard;

@property (nonatomic, assign) BOOL isAvailable; //是否在线


@end
