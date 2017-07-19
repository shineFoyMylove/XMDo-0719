//
//  TestChatServer.h
//  XmppDemo
//
//  Created by IntelcentMac on 17/7/1.
//  Copyright © 2017年 wh_shine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XMNChat/XMNChatServer.h>


@interface TestChatServer : NSObject<XMNChatServer,XMNChatServerDelegate>



/**
 *  测试使用的 模拟XMNChatServer
 *  重写此类 实现XMNChatServer
 *  实现你自己的与服务器沟通的功能
 *  此示例中 默认发送消息 1秒后发送成功,或者失败
 */


@end
