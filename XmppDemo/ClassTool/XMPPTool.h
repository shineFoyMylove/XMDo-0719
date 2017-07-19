//
//  XMPPTool.h
//  XmppDemo
//
//  Created by IntelcentMac on 17/6/27.
//  Copyright © 2017年 wh_shine. All rights reserved.
//  直接利用xmpp协议 通过openfire通信

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"

//#define singleton_interface(class)+ (instancetype)shared##class


/// ========================================
/// @name   相关通知定义
/// ========================================

/** 接收消息通知 */
static NSString *const XMPPChatReceiveMessageNotification = @"MSG.XMPPChatReceiveMessageNotification";


typedef enum {
    XMPPResultTypeLoginSuccess,
    XMPPResultTypeLoginFailure,
    XMPPResultTypeRegisterSuccess,
    XMPPResultTypeRegisterFailure
    
}XMPPResultType;

typedef void(^XMPPResultBlock)(XMPPResultType type);

@interface XMPPTool : NSObject



@property (nonatomic, strong, readonly) XMPPStream *stream;

//通讯录好友
@property (nonatomic, strong) XMPPRoster *roster;
@property (nonatomic, strong) XMPPRosterCoreDataStorage *rosterCoreDataStorage;

//自动重连接
@property (nonatomic, strong) XMPPReconnect *reconnect;

@property (nonatomic,copy,readonly) NSString *host;  /**< 服务器 IP */
@property (nonatomic,copy,readonly) NSString *domain;
@property (nonatomic, assign) int port; /**< xmpp 端口 */


+(instancetype)shareXMPPTool;   //声明、实现单例

/**
 *  判断执行的登录还是注册操作, YES为注册, NO为登录
 */
@property (nonatomic, assign,getter=isRegisterOperation) BOOL registerOperation;


/**
 * 用户注册
 */
- (void)xmppRegisterUser:(NSString *)user password:(NSString *)pwd resultBlock:(XMPPResultBlock)resultBlock;

/**
 * 用户登录
 */
- (void)xmppLoginUser:(NSString *)user password:(NSString *)pwd resultBlock:(XMPPResultBlock)resultBlock;

/**
 * 用户注销
 */
- (void)xmppLogout;


#pragma mark - XMPP Message Send

/**
 发送文字消息
 */
-(void)xmppMsgSendWithText:(NSString *)content toUser:(NSString *)user;

/**
 发送语音消息
 */
-(void)xmppMsgSendWithVoiceData:(NSData *)data type:(NSString *)type duringTime:(NSTimeInterval)time toUser:(NSString *)user;

/*
 发送图片消息
 */
-(void)xmppMsgSendWithImageData:(NSData *)data type:(NSString *)type imageSize:(CGSize)imgSize toUser:(NSString *)user;

#pragma mark - 好友

/**
 申请添加好友
 @param name 好友账号
 @param complite 结果回调
 */
-(void)xmppAddFriendSubscribe:(NSString *)name complite:(void(^)(BOOL result))complite;


/**
 同意好友申请
 @param name 好友账号
 */
-(void)xmppAgreeWithFriendRequest:(NSString *)name;

@end
