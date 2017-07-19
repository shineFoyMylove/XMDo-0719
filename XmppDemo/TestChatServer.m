//
//  TestChatServer.m
//  XmppDemo
//
//  Created by IntelcentMac on 17/7/1.
//  Copyright © 2017年 wh_shine. All rights reserved.
//

#import "TestChatServer.h"
#import "MessageModel.h"


@implementation TestChatServer
@synthesize delegate = _delegate;


/**
 *  需要实现此方法,进行服务器交互,将消息发送到服务器
 *
 *  @param aMessage 发送的消息
 *  回到通过 delegate 或者设置sendMessageBlock实现
 */

- (void)sendMessage:(XMNChatBaseMessage  * _Nonnull)aMessage{
    
    NSLog(@"do send message");
    
    //测试数据
    MessageModel *msgModel = [[MessageModel alloc] init];
//    msgModel.from.uid = @"20";
    msgModel.from.phone = @"20170707";
    msgModel.from.name = @"wanghui";
    msgModel.from.headUrl = @"http://headUrl";
    
//    msgModel.to.uid = @"17";
    msgModel.to.phone = @"20170708";
    msgModel.to.name = @"my QQ friend";
    msgModel.to.headUrl = @"http://headUrl.to";
    
    msgModel.content =aMessage.content;
//    msgModel.image = @{@"url": @"test.png"};
//    msgModel.contentFile = @"";
//    msgModel.contentVideo = @"";
//    msgModel.contentVoice = @"";
    msgModel.lng = @"0";
    msgModel.lat = @"0";
    msgModel.time = @"2017-05-20";
    msgModel.readState = 1;
    msgModel.afterReadBurn = 1;
    msgModel.typeChat = 100;
    msgModel.typeFile = 2;
    
//    NSData *tmpData = [msgModel jsonData];
    
    CTToModel *toModel = [[CTToModel alloc] init];
//    toModel.uid = @"17";
    toModel.phone = @"20170708";
    toModel.name = @"my QQ friend";
    toModel.headUrl = @"http://headUrl.to";
    
    [HttpRequest im_userSendMessageWithItem:aMessage.content targetItem:toModel type:(IMMessgeTypeText) chatType:IMChatTypeSingle complite:^(BOOL result, NSString *errmsg, NSDictionary *jsonDic) {
        if (jsonDic) {
            HttpRequestStatus status = [HttpRequest requestResult:jsonDic];
            if (status == HttpRequestStatusSucc) {
//                aMessage.state = XMNMessageStateSuccess;
                aMessage.substate = XMNMessageSubStateReadedContent;  //已读
            }
        }
    }];
    
//    NSString *urlStr = @"http://122.9.17.208:8080/message/sendMessage";
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
//    [request setHTTPMethod:@"POST"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
//    if (tmpData) {
//        [request setHTTPBody:tmpData];
//    }
//    
//    NSURLSession *session = [NSURLSession sharedSession];
//    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        
//        BOOL succ = NO;
//        NSString *errmsg = @"";
//        NSDictionary *resultDic = nil;
//        
//        if (error || data.length == 0) {
//            errmsg = @"请求失败";
//        }
//        
//        id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments | NSJSONReadingMutableContainers) error:nil];
//        if ([jsonObj isKindOfClass:[NSDictionary class]]) {
//            succ = YES;
//            resultDic = (NSDictionary *)jsonObj;
//            
//            
//            
//            NSLog(@"\nCode = %@ \nMessage: %@",resultDic[@"code"],resultDic[@"msg"]);
//        }else{
//            errmsg = @"JSON格式错误";
//        }
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (succ == NO) {
//                NSLog(@"\nresult: %@  errmsg: %@",succ?@"YES":@"NO",errmsg);
//            }
//        });
//        
//    }];
//    
//    [task resume];
//    
    
    //xmpp发送消息
//    [[XMPPTool shareXMPPTool] xmppMsgSendWithText:@"发个文本消息给 20170708" toUser:@"20170708"];
    
    
}


/** 提供delegate方式进行回调 */

/**
 *  服务器发送消息的回调
 *
 *  @param aServer   发送的chatServer实例
 *  @param aMessage  被发送的消息
 *  @param aProgress 发送进度
 */
- (void)chatServer:(id<XMNChatServer> _Nonnull)aServer
       sendMessage:(XMNChatBaseMessage  * _Nonnull)aMessage
      withProgress:(CGFloat)aProgress{
    
    NSLog(@"发送消息:%@  进度:%.2f",aMessage.content,aProgress);
    
}

/**
 *  服务器接收消息的回调
 *
 *  @param aServer   接收的chatServer实例
 *  @param aMessage  接收的消息
 *  @param aProgress 进度
 */
- (void)chatServer:(id<XMNChatServer> _Nonnull)aServer
    receiveMessage:(XMNChatBaseMessage  * _Nonnull)aMessage
      withProgress:(CGFloat)aProgress{
    
    NSLog(@"接收消息:%@  进度:%.2f",aMessage.content,aProgress);
    
}


@end
