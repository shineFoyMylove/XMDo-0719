//
//  XMPPTool.m
//  XmppDemo
//
//  Created by IntelcentMac on 17/6/27.
//  Copyright © 2017年 wh_shine. All rights reserved.
//  直接利用xmpp协议 通过openfire通信

#import "XMPPTool.h"

#import "NewFriendObject+CoreDataProperties.h"
#import "TLFriendHelper.h"

//#define singleton_implementation(class) \
//static class *_instance; \
//\
//+ (id)allocWithZone:(struct _NSZone *)zone \
//{ \
//    static dispatch_once_t onceToken; \
//    dispatch_once(&onceToken, ^{ \
//        _instance = [super allocWithZone:zone]; \
//    }); \
//\
//    return _instance; \
//} \
//\
//+ (instancetype)shared##class \
//{ \
//    if (_instance == nil) { \
//        _instance = [[class alloc] init]; \
//    } \
//\
//    return _instance; \
//}

#ifdef DEBUG
#define ZHLog(...) NSLog(@"%s\n %@\n\n", __func__, [NSString stringWithFormat:__VA_ARGS__]);
#else
#define ZHLog(...)
#endif

static XMPPTool *_shareInstance;

@interface XMPPTool () <XMPPStreamDelegate,XMPPRosterDelegate>
{
    void(^_resultBlock)(XMPPResultType type);
    
    NSString *_resource;
}

@property (nonatomic, retain) NSString *pwdStr;
@property (nonatomic, retain) NSString *username;


@end

@implementation XMPPTool

#pragma mark XMPP Stream 私有方法

-(id)init{
    if (self = [super init]) {
        [self setConfig];
    }
    return self;
}

+(instancetype)shareXMPPTool{
    if (_shareInstance == nil) {
        _shareInstance = [[XMPPTool alloc] init];
    }
    return _shareInstance;
}

    //配置
-(void)setConfig{
    _host = @"122.9.17.208";    //服务器IP
    _domain = @"127.0.0.1";
    _port = 5222;
    _resource = @"iOS";
    
    [self setupStream];   //启动xmpp
}

/**
 初始化 XMPPStream
 */
-(void)setupStream{
    _stream = [[XMPPStream alloc] init];
    [_stream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
    //联系人以及联系人管理 初始化
    self.rosterCoreDataStorage = [XMPPRosterCoreDataStorage sharedInstance];
    self.roster = [[XMPPRoster alloc] initWithRosterStorage:_rosterCoreDataStorage dispatchQueue:dispatch_get_global_queue(0, 0)];
    
    //roster激活
    [self.roster activate:self.stream];
    
    //给roster对象指定代理
    [self.roster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    //禁用自动获取名单
    self.roster.autoFetchRoster = NO;
    
    //自动重连接
    self.reconnect = [[XMPPReconnect alloc] init];
    [self.reconnect activate:self.stream];
    
    //允许后台 Socket运行
    self.stream.enableBackgroundingOnSocket = YES;
}

/**
 连接服务器
 */
-(void)connectToHost{
    if (!_stream) {
        [self setupStream];
    }
    
    //设置用户登录的JID, resource 为用户登录客户端的设备类型
    XMPPJID *myJid = nil;
    myJid = [XMPPJID jidWithUser:_username domain:_domain resource:_resource];
    
    _stream.myJID = myJid;
    
    //设置主机地址
    _stream.hostName = _host;
    //设置主机端口，可以不设置，默认 5222
    _stream.hostPort = _port;
    
    //发起连接，缺失必要参数则会失败
    NSError *error = nil;
    [_stream connectWithTimeout:XMPPStreamTimeoutNone error:&error];
    if (!error) {
        NSLog(@"xmpp server连接成功");
    }else{
        NSLog(@"xmpp server连接失败");
    }
    
    
}

/**
 发送密码,验证登录
 */
-(void)sendPasswordToHost{
    NSError *error = nil;
    NSString *pwdStr = _pwdStr;
    [_stream authenticateWithPassword:pwdStr error:&error];
    if (!error) {
        NSLog(@"登录验证成功");
    }else{
        NSLog(@"登录验证失败");
    }
}

/**
 发送在线消息
 */
-(void)sendOnline{
    XMPPPresence *presence = [XMPPPresence presence];
    NSLog(@"消息体：%@",presence);
    [_stream sendElement:presence];
}

/**
 发送离线消息
 */
-(void)sendOffLine{
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [_stream sendElement:presence];
}

/**
 中断连接 host
 */
-(void)disconnectFromHost{
    [_stream disconnect];
}

#pragma mark 注册验证 XMPP Stream Delegate
/**
 连接成功
 */
-(void)xmppStreamDidConnect:(XMPPStream *)sender{
    NSLog(@"%s",__func__);
    if (self.isRegisterOperation) {
        //注册
        NSError *error = nil;
        NSString *registPwd = _pwdStr;
        [_stream registerWithPassword:registPwd error:&error];
        if (error) {
            NSLog(@"连接失败:%@",error);
        }
    }else{
        [self sendPasswordToHost];
    }
}

/**
 注册成功
 */
- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeRegisterSuccess);
    }
}

/**
 注册失败
 */
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error
{
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeRegisterFailure);
    }
}


/**
 登录成功
 */
-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    [self sendOnline];
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeLoginSuccess);
        //实现登录功能的时候，登录成功之后需要销毁登录控制器
        //因此block回掉成功的信息后，把block设置nil，不让登录控制器继续持有block，可以让登录控制器自动销毁
        //_resultBlock = nil;
    }
}

/**
 登录失败
 */
-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error{
    NSLog(@"error: %@",error);
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeLoginFailure);
    }
}



#pragma mark XMPP 操作 公共方法

/**
 * 用户注册
 */
- (void)xmppRegisterUser:(NSString *)user password:(NSString *)pwd resultBlock:(XMPPResultBlock)resultBlock{
    [_stream disconnect];
    
    self.username = user;
    self.pwdStr = pwd;
    
    _resultBlock = resultBlock;
    [self connectToHost];
    
}

/**
 * 用户登录
 */
- (void)xmppLoginUser:(NSString *)user password:(NSString *)pwd resultBlock:(XMPPResultBlock)resultBlock{
    //把以前的登录断开，不然如果先输错密码登录失败，之后再登录不管密码是对是错，都会登录失败
    //因为连接服务器和发送密码有先后顺序，之前即使输错了密码，实际上还是成功了连接了服务器
    //不把它断开，会报错——试图连接一个已存在的链接
    [_stream disconnect];
    
    self.username = user;
    self.pwdStr = pwd;
    
    _resultBlock = resultBlock;
    [self connectToHost];
}

/**
 * 用户注销
 */
- (void)xmppLogout{
    [self sendOffLine];
    [self disconnectFromHost];
}



#pragma mark - XMPP Message Send

/**
 发送文字消息
 */
-(void)xmppMsgSendWithText:(NSString *)content toUser:(NSString *)user{
    XMPPJID *toJid = [XMPPJID jidWithUser:user domain:_domain resource:_resource];
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:toJid];
    [message addBody:content];
    
    NSXMLElement *receipt = [NSXMLElement elementWithName:@"request" xmlns:@"urn:xmpp:receipts"];
    [message addChild:receipt];
    
    //设置聊天类型
//    [message addAttributeWithName:@"body-type" stringValue:@"text"];
    
    //发送
    [_stream sendElement:message];
    
}

/**
 发送语音消息
 */
-(void)xmppMsgSendWithVoiceData:(NSData *)data type:(NSString *)type duringTime:(NSTimeInterval)time toUser:(NSString *)user{
    XMPPJID *toJid = [XMPPJID jidWithUser:user domain:_domain resource:_resource];
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:toJid];
    [message addBody:type];
    
    NSXMLElement *receipt = [NSXMLElement elementWithName:@"request" xmlns:@"urn:xmpp:receipts"];
    [message addChild:receipt];
    
    //传参数
    NSString *timeStr = [NSString stringWithFormat:@"%f",time];
    [message addAttributeWithName:@"duringTime" stringValue:timeStr];
    [message addAttributeWithName:@"body-type" stringValue:@"voice"];
    
    //添加节点内容
    if (data) {
        NSString *base64Str = [data base64EncodedStringWithOptions:(NSDataBase64Encoding64CharacterLineLength)]; //0
        XMPPElement *attachment = [XMPPElement elementWithName:@"attachment" stringValue:base64Str];
        [message addChild:attachment];
    }
    [_stream sendElement:message];
    
}

/*
 发送图片消息
 */
-(void)xmppMsgSendWithImageData:(NSData *)data type:(NSString *)type imageSize:(CGSize)imgSize toUser:(NSString *)user{
    XMPPJID *toJid = [XMPPJID jidWithUser:user domain:_domain resource:_resource];
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:toJid];
    [message addBody:type];
    
    NSXMLElement *receipt = [NSXMLElement elementWithName:@"request" xmlns:@"urn:xmpp:receipts"];
    [message addChild:receipt];
    
    //传参数
    NSString *sizeStr = NSStringFromCGSize(imgSize);
    [message addAttributeWithName:@"imageSize" stringValue:sizeStr];
    [message addAttributeWithName:@"body-type" stringValue:@"image"];
    
    //添加节点内容
    if (data) {
        NSString *base64Str = [data base64EncodedStringWithOptions:0];
        XMPPElement *attachment = [XMPPElement elementWithName:@"attachment" stringValue:base64Str];
        [message addChild:attachment];
    }
    //发送
    [_stream sendElement:message];
    
}


#pragma mark - 需要覆盖重写 XMPPStreamDelegate

//TODO:消息发送成功
-(void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message{
    NSXMLElement *request = [message elementForName:@"request"];
    if (request) {
        NSLog(@"%@: 已发送消息 -- %@",NSStringFromClass([self class]),message.body);
    }
}

//TODO:消息发送失败
-(void)xmppStream:(XMPPStream *)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error{
    
    NSLog(@"%@: 消息发送失败! -- %@\n%@",NSStringFromClass([self class]),message.body,error.description);
}

//TODO:接收到消息
-(void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    
    NSXMLElement *request = [message elementForName:@"request"];
    if (request) {
        if ([request.xmlns isEqualToString:@"urn:xmpp:receipts"]) {
            //消息回执、组装消息回执
            NSString *type = [message attributeStringValueForName:@"type"];
            NSString *idStr = [message attributeStringValueForName:@"id"];
            
            XMPPMessage *msg = [XMPPMessage messageWithType:type to:message.from elementID:idStr];
            NSXMLElement *recieved = [NSXMLElement elementWithName:@"received" xmlns:@"urn:xmpp:receipts"];
            [msg addChild:recieved];
            
            //发送回执
            [_stream sendElement:msg];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //接收到消息
                NotificationPost(XMPPChatReceiveMessageNotification, message);
            });
            
        }
    }else{
        //有消息回执
        NSXMLElement *received = [message elementForName:@"received"];
        if (received) {
            if ([received.xmlns isEqualToString:@"urn:xmpp:receipts"]) {
                NSLog(@"已经发送成功,收到回执");
            }
        }
        //无消息回执(jabber:client) 来自服务器
        if ([message.xmlns isEqualToString:@"jabber:client"]) {
            NSXMLElement *bodyXML = [message elementForName:@"body"];
            if (bodyXML && bodyXML.stringValue.length >0) {
                NSData *data = [bodyXML.stringValue dataUsingEncoding:(NSUTF8StringEncoding)];
                if (data.length >0) {
                    NSDictionary *bodyDic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments|NSJSONReadingMutableLeaves) error:nil];
                    //接收到消息
                    if ([bodyDic isKindOfClass:[NSDictionary class]]) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //接收到消息
                            NotificationPost(XMPPChatReceiveMessageNotification, bodyDic);
                        });
                        
                        TSYLog(@"接收消息",bodyXML.stringValue);
                    }else{
                        TSYLog(@"消息结构体不正确",bodyXML.stringValue);
                    }
                }
                
            }else{
                NSLog(@"%s Error: %@",__func__,@"消息Body为空");
            }
        }
    }
     
    
    
}

//TODO:接收消息失败
-(void)xmppStream:(XMPPStream *)sender didReceiveError:(DDXMLElement *)error{
    NSLog(@"%@: 消息接收失败! \n%@",NSStringFromClass([self class]),error.description);
}

-(void)xmppStreamConnectDidTimeout:(XMPPStream *)sender{
    @throw [NSException exceptionWithName:@"XMPP-Error" reason:@"与服务器建立连接超时" userInfo:nil];
}


#pragma mark - Roster 好友Delegate

//申请添加好友
-(void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence{
    NSLog(@"ID: %@ 状态: %@",presence.from.user,presence.type);
    
//    NSString *receiveUser = presence.from.user;
//    
//    NewFriendObject *newObj = [[NewFriendObject alloc] init];
//    newObj.phone = receiveUser;
//    newObj.name  = [NSString stringWithFormat:@"新增测试: %@",receiveUser];
//    newObj.state = TLNewFriendApplyStateNew;
//    
//    [newObj insert];
}

    //好友列表回调
-(void)xmppRoster:(XMPPRoster *)sender didReceiveRosterItem:(DDXMLElement *)item{
    
    NSLog(@"ID: %@",item);
}

-(void)xmppRoster:(XMPPRoster *)sender didReceiveRosterPush:(XMPPIQ *)iq{
    NSLog(@"ID: %@",iq);
}

    //回调 - 新的好友
-(void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence{
    NSLog(@"ID: %@ 状态: %@",presence.from,presence.type);
}

#pragma mark - 好友

/**
 申请添加好友
 @param name 好友账号
 @param complite 结果回调
 */
-(void)xmppAddFriendSubscribe:(NSString *)name complite:(void(^)(BOOL result))complite{
    
    BOOL error = NO;
    NSArray *newArrs = [NewFriendObject featchAllRequest];
    for (NewFriendObject *obj in newArrs) {
        if ([obj.phone isEqualToString:name]) {
            AlertTipWithMessage(@"添加用户已经在你的请求列表中!");
            error = YES;
        }
    }
    
    NSArray *frisArr = [TLFriendHelper sharedFriendHelper].friendsData;
    for (TLUser *user in frisArr) {
        if ([user.userID isEqualToString:name]) {
            AlertTipWithMessage(@"用户已经是你的好友!");
            error = YES;
        }
    }
    
    NSString *curUser = UDGetString(username_preference);
    if ([curUser isEqualToString:name]) {
        AlertTipWithMessage(@"不能添加自己为好友!");
        error = YES;
    }
    
    if (error) {
        if(complite) complite(NO);
        return;
    }
    
    XMPPJID *addJID = [XMPPJID jidWithUser:name domain:_domain resource:_resource];
    [self.roster subscribePresenceToUser:addJID];
    
    if(complite)    complite(YES);
}


/**
 同意好友申请
 @param name 好友账号
 */
-(void)xmppAgreeWithFriendRequest:(NSString *)name{
    XMPPJID *jidName = [XMPPJID jidWithUser:name domain:_domain resource:_resource];
    [self.roster acceptPresenceSubscriptionRequestFrom:jidName andAddToRoster:YES];
    
    AlertTipWithMessage(@"成功添加");
}


@end
