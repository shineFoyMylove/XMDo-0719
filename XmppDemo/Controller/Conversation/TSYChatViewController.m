//
//  TSYChatViewController.m
//  XmppProject
//
//  Created by IntelcentMac on 17/7/7.
//  Copyright © 2017年 wh_shine. All rights reserved.
//

#import "TSYChatViewController.h"
#import "TestChatViewModel.h"
#import "LXNetworking.h"
#import "AppDelegate.h"
#import "AFNetworking.h"

#import "ChatMessage+CoreDataClass.h"
#import "ChatConversation+CoreDataClass.h"

@interface TSYChatViewController ()


@end

@implementation TSYChatViewController

-(id)initWithChatMode:(XMNChatMode)aChatMode UserId:(NSString *)userId{
    if (self = [super initWithChatMode:aChatMode]) {
        _userId = userId;
    }
    return self;
}

-(AppDelegate *)ShareApp{
    return [AppDelegate instance];
}

-(AppUserInfo *)userInfo{
    return [self ShareApp].appManager.userInfo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TestChatViewModel *chatModel = [[TestChatViewModel alloc] initWithChatMode:(XMNChatSingle)];
    self.chatVM = chatModel;
    
    [self setupChatOtherItemsDefault];

    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xmppMessageReceive:) name:XMPPChatReceiveMessageNotification object:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    NotificationRemoveWithName(self,XMPPChatReceiveMessageNotification,nil);
}

-(void)setupChatOtherItemsDefault{
    //keyboard other 数据源
    XMNChatOtherItem *item1 = [XMNChatOtherItem new];
    item1.icon = @"moreKB_image";
    item1.title = @"图片";
    
    XMNChatOtherItem *item2 = [XMNChatOtherItem new];
    item2.icon = @"moreKB_video_call";
    item2.title = @"拍摄";
    
    XMNChatOtherItem *item3 = [XMNChatOtherItem new];
    item3.icon = @"moreKB_sight";
    item3.title = @"小视频";
    
    XMNChatOtherItem *item4 = [XMNChatOtherItem new];
    item4.icon = @"moreKB_voice";
    item4.title = @"语音通话";
    
    XMNChatOtherItem *item5 = [XMNChatOtherItem new];
    item5.icon = @"moreKB_video";
    item5.title = @"视频聊天";
    
    XMNChatOtherItem *item6 = [XMNChatOtherItem new];
    item6.icon = @"moreKB_favorite";
    item6.title = @"收藏";
    
    XMNChatOtherItem *item7 = [XMNChatOtherItem new];
    item7.icon = @"moreKB_location";
    item7.title = @"位置";
    
    XMNChatOtherItem *item8 = [XMNChatOtherItem new];
    item8.icon = @"moreKB_friendcard";
    item8.title = @"名片";
    
//    XMNChatOtherItem *item9 = [XMNChatOtherItem new];
//    item9.icon = @"moreKB_favorite";
//    item9.title = @"收藏";
//    
//    
//    XMNChatOtherItem *item10 = [XMNChatOtherItem new];
//    item10.icon = @"moreKB_pay";
//    item10.title = @"转账";
//    
//    XMNChatOtherItem *item11 = [XMNChatOtherItem new];
//    item11.icon = @"moreKB_wallet";
//    item11.title = @"钱包";
//    
//    XMNChatOtherItem *item12 = [XMNChatOtherItem new];
//    item12.icon = @"";
//    item12.title = @"其他";
    
    [self setupChatOtherItems:@[item1,item2,item3,item4,item5,item6,item7,item8]];
    
}

#pragma mark 通知监听
    //键盘 otherView点击Action
- (void)handleOtherItemAction:(NSNotification *)notification {
    
    if ([notification.object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *obj = (NSDictionary *)notification.object;
        NSString *itemTitle = [obj getStringValueForKey:kXMNChatOtherItemNotificationDataKey defaultValue:@""];
        NSLog(@"chatBar other view notification :%@",itemTitle);
        
        if ([itemTitle isEqualToString:@"图片"]) {
            [self actionForSendPicture];
        }
        else if ([itemTitle isEqualToString:@"拍摄"]){
            [self actionForSendPictureFromCamera];
        }
        else if ([itemTitle isEqualToString:@"小视频"]){
            [self actionForSendShortVideo];
        }
        else if ([itemTitle isEqualToString:@"语音通话"]){
            [self actionForAudioChat];
        }
        else if ([itemTitle isEqualToString:@"视频聊天"]){
            [self actionForVideoChat];
        }
        else if ([itemTitle isEqualToString:@"收藏"]){
            [self actionForSendCollection];
        }
        else if ([itemTitle isEqualToString:@"位置"]){
            [self actionForSendLocation];
        }
    }
 
}

- (void)handleMessageClicked:(NSNotification *)aNotification {
    NSLog(@" you  clicked message :%@",aNotification.userInfo);
    
}

#pragma mark Other View 功能触发
    //发送图片
-(void)actionForSendPicture{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypePhotoLibrary)]) {
        //相册
        [imagePicker setSourceType:(UIImagePickerControllerSourceTypePhotoLibrary)];
        [self presentViewController:imagePicker animated:YES completion:nil];
        __weak typeof(self) weakSelf = self;
        
        [imagePicker.rac_imageSelectedSignal subscribeNext:^(id x) {
            [imagePicker dismissViewControllerAnimated:YES completion:^{
                UIImage *image = [x objectForKey:UIImagePickerControllerOriginalImage];
                [weakSelf sendMsgRequeset:(id)image type:(XMNMessageTypeImage)];
            }];
        } completed:^{
            [imagePicker dismissViewControllerAnimated:YES completion:nil];
        }];
    }
    
    
    [HttpRequest im_userAddFriend:@"20170627" complite:^(BOOL result, NSString *errmsg, NSDictionary *jsonDic) {
        if (jsonDic) {
            NSLog(@"%@",jsonDic);
        }
    }];
}

    //调起拍摄
-(void)actionForSendPictureFromCamera{
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)]) {
        //相册
        [imagePicker setSourceType:(UIImagePickerControllerSourceTypeCamera)];
        [self presentViewController:imagePicker animated:YES completion:nil];
        __weak typeof(self) weakSelf = self;
        [imagePicker.rac_imageSelectedSignal subscribeNext:^(id x) {
            [imagePicker dismissViewControllerAnimated:YES completion:^{
                UIImage *image = [x objectForKey:UIImagePickerControllerOriginalImage];
                [weakSelf sendMsgRequeset:(id)image type:(XMNMessageTypeImage)];
            }];
        } completed:^{
            [imagePicker dismissViewControllerAnimated:YES completion:nil];
        }];
    }else{
        [UIAlertView bk_alertViewWithTitle:@"错误" message:@"相机初始化失败"];
    }
    
    [HttpRequest im_userRemoveFriend:@"20170627" complite:^(BOOL result, NSString *errmsg, NSDictionary *jsonDic) {
        if (jsonDic) {
            NSLog(@"%@",jsonDic);
        }
    }];
}

    //录制小视频发送
-(void)actionForSendShortVideo{
//    [HttpRequest im_userInBlack:@"20170627" complite:^(BOOL result, NSString *errmsg, NSDictionary *jsonDic) {
//        if (jsonDic) {
//            NSLog(@"%@",jsonDic);
//        }
//    }];
    
//    NSString *url = @"http://122.9.17.208/group1/M00/00/00/egkR0FlnP9uAKeO-AAAABmzNJf4359.amr";
//    NSString *url = @"https://raw.githubusercontent.com/ws00801526/XMNAudio/master/XMNAudioExample/XMNAudioExample/letitgo_v.mp3";
    NSString *url = @"http://122.9.17.208/group1/M00/00/00/egkR0FloP7uAZAAtAAAlpgcVISI324.amr";
    
//    NSString *path = [[NSFileManager documentsPath] stringByAppendingPathComponent:@"audiotest.amr"];
    [LXNetworking downloadWithUrl:url saveToPath:nil progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        NSLog(@"已经下载：%d%%",(int)(bytesProgress *100/totalBytesProgress));
    } success:^(id response) {
        if ([response isKindOfClass:[NSData class]]) {
            NSLog(@"下载成功: %@",[[NSString alloc] initWithData:response encoding:(NSUTF8StringEncoding)]);
        }else{
            NSLog(@"下载成功: %@",response);
        }
        
    } failure:^(NSError *error) {
        NSLog(@"下载失败: %@",error.description);
    } showHUD:YES];
    
}

    //发起视频聊天
-(void)actionForVideoChat{
    [HttpRequest im_userRemoveBlack:@"20170627" complite:^(BOOL result, NSString *errmsg, NSDictionary *jsonDic) {
        if (jsonDic) {
            NSLog(@"%@",jsonDic);
        }
    }];
    
    
}

    //发起语音聊天
-(void)actionForAudioChat{
    
}

    //发送收藏信息
-(void)actionForSendCollection{
    
}

    //发送位置信息
-(void)actionForSendLocation{
    
}

#pragma mark - 消息发送 - 文字表情
-(void)sendMessage:(XMNChatBaseMessage *)aMessage{
    [super sendMessage:aMessage];
    
    if ([aMessage isKindOfClass:[XMNChatTextMessage class]]) {
        [self sendMessage:aMessage msgItem:aMessage.content withType:(IMMessgeTypeText)]; //文本
    }else if ([aMessage isKindOfClass:[XMNChatVoiceMessage class]]){
        //音频文件 amessage.content ，传参 filePath ,secodes时长
        // @"path" , @"second
        [self sendMsgRequeset:aMessage type:(XMNMessageTypeVoice)];
    }
    
    
    //xmpp发送消息
//    [[XMPPTool shareXMPPTool] xmppMsgSendWithText:@"发个文本消息给 20170708" toUser:@"20170708"];
}

    //发送 消息到后台
-(void)sendMessage:(XMNChatBaseMessage *)aMessage msgItem:(id)msgItem withType:(IMMessgeType)type{
    CTToModel *toModel = [[CTToModel alloc] init];
    //    toModel.uid = self.userId;
    toModel.phone = self.userId;
    toModel.name = @"my QQ friend";
    toModel.headUrl = @"http://headUrl.to";
    
    WkSelf(weakSelf);
    __block XMNChatBaseMessage *weakMsg = aMessage;
    MessageModel *sendModel = [HttpRequest im_userSendMessageWithItem:msgItem targetItem:toModel type:type chatType:IMChatTypeSingle complite:^(BOOL result, NSString *errmsg, NSDictionary *jsonDic) {
        BOOL succ = NO;
        if (jsonDic) {
            HttpRequestStatus status = [HttpRequest requestResult:jsonDic];
            if (status == HttpRequestStatusSucc) {
                succ = YES;
                weakMsg.state = XMNMessageStateSuccess;
                weakMsg.substate = XMNMessageSubStateReadedContent;  //已读
//                for (int i = 0; i<weakSelf.chatVM.messages.count; i++) {
//                    XMNChatBaseMessage *msg = weakSelf.chatVM.messages[i];
//                    NSLog(@"state: %d, subState:%d",msg.state,msg.substate);
//                    [self saveMessageCoreDataStore:msg];
//                    [weakSelf tableViewReload];
//                }
            }
            NSLog(@"图片发送: %@",jsonDic[@"msg"]);
        }
        if (!succ) {
            weakMsg.state = XMNMessageStateFailed;
        }
        [weakSelf tableViewReload];
    }];
    
    ChatMessage *messageItem = [ChatMessage NewMessage];
    [messageItem updateWithMessageModel:sendModel];
    if (![messageItem insert]) {
        NSLog(@"消息记录 - 存储失败");
    }
    
    NSArray *msgArr = [ChatMessage fetchAllChatMessage];
    for (ChatMessage *msg in msgArr) {
        NSLog(@"content: %@",msg.textContent);
    }
    
}

    //上传文件
-(void)sendMsgRequeset:(id)obj type:(XMNMessageType)type{
    
    switch (type) {
        case XMNMessageTypeImage:
        {
            if ([obj isKindOfClass:[UIImage class]]) {
                
                //添加一条图片消息记录
                XMNChatImageMessage *imgMessage = [[XMNChatImageMessage alloc] initWithContent:obj state:(XMNMessageStateSending) owner:(XMNMessageOwnerSelf) time:[[NSDate date] timeIntervalSinceNow]];
                [self.chatVM.messages addObject:imgMessage];
                [self tableViewReload];
                
                    //消息Item (发送后台)
                __block CTImageItem *imgItem = [[CTImageItem alloc] init];
                [imgItem scalingToSize:CGSizeMake(320, 200) withImage:obj];
                
                WkSelf(weakSelf);
                __block XMNChatImageMessage *weakMsg = imgMessage;
                [HttpRequest im_userUploadFile:obj fileType:@"image" progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
                    NSLog(@"已经上传：%d%%",(int)(bytesProgress *100/totalBytesProgress));
                } complite:^(BOOL result, NSString *errmsg, NSDictionary *jsonDic) {
                    if (jsonDic) {
                        HttpRequestStatus status = [HttpRequest requestResult:jsonDic];
                        if (status == HttpRequestStatusSucc) {
                            NSString *fileUrl = [jsonDic getStringValueForKey:@"fileUrl" defaultValue:nil];
                            if (fileUrl) {
                                NSLog(@"发送图片: %@",fileUrl);
                                imgItem.url = fileUrl;
                                [weakSelf sendMessage:weakMsg msgItem:imgItem withType:(IMMessgeTypeImage)];
                            }
                        }else{
                            weakMsg.state = XMNMessageStateFailed;
                        }
                    }
                }];
                
            }
        }
            break;
        case XMNMessageTypeVoice:
        {
            //语音 baseMessageItem 而且已经刷新到 cell ，只需要上传 - 发送 - 状态判断
            __block XMNChatVoiceMessage *weakMsg = (XMNChatVoiceMessage *)obj;
            if ([weakMsg isKindOfClass:[XMNChatBaseMessage class]]) {
                
                __block CTAudioItem *audioItem = [[CTAudioItem alloc] init];
                audioItem.length = [NSString stringWithFormat:@"%ld",(long)weakMsg.voiceLength];
                
                WkSelf(weakSelf);
                [HttpRequest im_userUploadFile:weakMsg.voicePath fileType:@"voice" progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
                    NSLog(@"已经上传：%d%%",(int)(bytesProgress *100/totalBytesProgress));
                } complite:^(BOOL result, NSString *errmsg, NSDictionary *jsonDic) {
                    
                    if (jsonDic) {
                        HttpRequestStatus status = [HttpRequest requestResult:jsonDic];
                        if (status == HttpRequestStatusSucc) {
                            NSString *fileUrl = [jsonDic getStringValueForKey:@"fileUrl" defaultValue:nil];
                            if (fileUrl) {
                                NSLog(@"发送语音: %@",fileUrl);
                                audioItem.url = fileUrl;
                                [weakSelf sendMessage:weakMsg msgItem:audioItem withType:(IMMessgeTypeAudio)];
                            }
                        }else{
                            weakMsg.state = XMNMessageStateFailed;
                        }
                    }
                }];
            }
            
        }
            break;
            
        default:
            break;
    }
    
}

    //保存
-(void)saveMessageCoreDataStore:(XMNChatBaseMessage *)msg{
    
}

#pragma mark 通知监听
-(void)xmppMessageReceive:(NSNotification *)notify{
    if ([notify.object isKindOfClass:[XMPPMessage class]]) {
        //测试
        XMPPMessage *msgObj = (XMPPMessage *)notify.object;
        

        XMNChatTextMessage *msg = [[XMNChatTextMessage alloc] initWithContent:msgObj.body state:(XMNMessageStateSuccess) owner:(XMNMessageOwnerOther)];
        [self.chatVM.messages addObject:msg];
        [self tableViewReload];
    }else if ([notify.object isKindOfClass:[NSDictionary class]]){
        //服务器回调
        
        MessageModel *msgObj = [[MessageModel alloc] init];
        msgObj = [MessageModel mj_objectWithKeyValues:notify.object];
        
        switch (msgObj.typeFile) {
            case 1:
            {
                XMNChatTextMessage *textMsg = [[XMNChatTextMessage alloc] initWithContent:msgObj.content state:(XMNMessageStateSuccess) owner:(XMNMessageOwnerOther)];
                [self.chatVM.messages addObject:textMsg];
            }
                break;
            case 2:
            {
                
                XMNChatImageMessage *imgMsg = [[XMNChatImageMessage alloc] initWithContent:msgObj.image.url state:(XMNMessageStateSuccess) owner:(XMNMessageOwnerOther)];
                [self.chatVM.messages addObject:imgMsg];
            }
                break;
            case 3:
            {
                //小视频
            }
                break;
            case 4:
            {
                //语音voice
                XMNChatVoiceMessage *voiceMsg = [[XMNChatVoiceMessage alloc] initWithContent:msgObj.voice.url state:(XMNMessageStateSuccess) owner:(XMNMessageOwnerOther)];
                voiceMsg.voiceLength = msgObj.voice.length.integerValue;
                [self.chatVM.messages addObject:voiceMsg];
                
            }
                break;
            default:
                break;
        }
        
        [self tableViewReload];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
