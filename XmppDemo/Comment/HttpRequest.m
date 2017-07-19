//
//  HttpRequest.m
//  WHIMDemo1
//
//  Created by Gery晖 on 17/6/5.
//  Copyright © 2017年 wh_shine. All rights reserved.
//

#import "HttpRequest.h"
#import "AppDelegate.h"
#import "NSDate+XMPPDateTimeProfiles.h"
#import "LXNetworking.h"
#import "AFNetworking.h"

static HttpRequest *instance;

@implementation HttpRequest


+(instancetype)instance{
    if (instance == nil) {
        instance = [[HttpRequest alloc] init];
    }
    return instance;
}

+(HttpRequestStatus)requestResult:(NSDictionary *)jsonObj{
    if ([jsonObj isKindOfClass:[NSDictionary class]]) {
        NSString *codeStr = [jsonObj getStringValueForKey:@"code" defaultValue:@""];
        NSInteger code = codeStr.integerValue;
        switch (code) {
            case 1000:
                return HttpRequestStatusSucc;
                break;
            case 1001:
                return HttpRequestStatusDataError;
                break;
            case 1002:
                return HttpRequestStatusVerifyError;
                break;
            case 1003:
                return HttpRequestStatusNoMoreData;
                break;
            case 1004:
                return HttpRequestStatusOperationError;
                break;
            case 1005:
                return HttpRequestStatusXmppOperationError;
                break;
            case 1006:
                return HttpRequestStatusUserExist;
                break;
                
            default:
                break;
        }
    }else{
        NSLog(@"JSON格式错误");
    }
    return HttpRequestStatusDataError;
}

#pragma mark 公共参数
+(NSString *)user{
    NSString *tmpUser =[AppDelegate instance].appManager.userInfo.phone;
    tmpUser = tmpUser!=nil?tmpUser:@"";
    
    return tmpUser;
}

+(AppUserInfo *)userInfo{
    AppUserInfo *userInfo = [AppDelegate instance].appManager.userInfo;
    return userInfo;
}

#pragma mark App注册
+(void)app_userRegist:(NSString *)phone password:(NSString *)pwdStr complite:(void(^)(BOOL result, NSString *errmsg , NSDictionary *jsonDic))complite{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:phone forKey:@"phone"];
    [params setObject:pwdStr forKey:@"password"];
    
    NSString *methodUrl = [NSString stringWithFormat:@"%@/user/add",domain_url];
    [HttpRequest sendPostSession:methodUrl params:params complite:^(BOOL result, NSString *errmsg, NSDictionary *jsonDic) {
        if (complite) {
            complite(result,errmsg,jsonDic);
        }
    }];
}


#pragma mark App登录
+(void)app_userLogin:(NSString *)phone password:(NSString *)pwdStr complite:(void(^)(BOOL result, NSString *errmsg , NSDictionary *jsonDic))complite{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:phone forKey:@"phone"];
    [params setObject:pwdStr forKey:@"password"];
    
    NSString *methodUrl = [NSString stringWithFormat:@"%@/user/login",domain_url];
    [HttpRequest sendPostSession:methodUrl params:params complite:^(BOOL result, NSString *errmsg, NSDictionary *jsonDic) {
        if (complite) {
            complite(result,errmsg,jsonDic);
        }
    }];
}

#pragma mark -

#pragma mark IM 添加好友

/**
 添加好友

 @param friendPhone 添加账号
 @param complite resultBlock
 */
+(void)im_userAddFriend:(NSString *)friendPhone complite:(void(^)(BOOL result, NSString *errmsg , NSDictionary *jsonDic))complite{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.user forKey:@"ownerPhone"];
    [params setObject:friendPhone!=nil?friendPhone:@"" forKey:@"friendPhone"];
    
    NSString *methodUrl = [NSString stringWithFormat:@"%@/friend/addFriend",domain_url];
    [HttpRequest sendPostSession:methodUrl params:params complite:^(BOOL result, NSString *errmsg, NSDictionary *jsonDic) {
        if (complite) {
            complite(result,errmsg,jsonDic);
        }
    }];
}

#pragma mark 解除好友关系
+(void)im_userRemoveFriend:(NSString *)friendPhone complite:(void(^)(BOOL result, NSString *errmsg , NSDictionary *jsonDic))complite{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.user forKey:@"ownerPhone"];
    [params setObject:friendPhone!=nil?friendPhone:@"" forKey:@"friendPhone"];
    
    NSString *methodUrl = [NSString stringWithFormat:@"%@/friend/removeFriend",domain_url];
    [HttpRequest sendPostSession:methodUrl params:params complite:^(BOOL result, NSString *errmsg, NSDictionary *jsonDic) {
        if (complite) {
            complite(result,errmsg,jsonDic);
        }
    }];
}

#pragma mark 加入黑名单
+(void)im_userInBlack:(NSString *)blackPhone complite:(void(^)(BOOL result, NSString *errmsg , NSDictionary *jsonDic))complite{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.user forKey:@"ownerPhone"];
    [params setObject:blackPhone!=nil?blackPhone:@"" forKey:@"friendPhone"];
    
    NSString *methodUrl = [NSString stringWithFormat:@"%@/friend/addBlack",domain_url];
    [HttpRequest sendPostSession:methodUrl params:params complite:^(BOOL result, NSString *errmsg, NSDictionary *jsonDic) {
        if (complite) {
            complite(result,errmsg,jsonDic);
        }
    }];
}

#pragma mark 移除黑名单
+(void)im_userRemoveBlack:(NSString *)blackPhone complite:(void(^)(BOOL result, NSString *errmsg , NSDictionary *jsonDic))complite{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.user forKey:@"ownerPhone"];
    [params setObject:blackPhone!=nil?blackPhone:@"" forKey:@"friendPhone"];
    
    NSString *methodUrl = [NSString stringWithFormat:@"%@/friend/removeBlack",domain_url];
    [HttpRequest sendPostSession:methodUrl params:params complite:^(BOOL result, NSString *errmsg, NSDictionary *jsonDic) {
        if (complite) {
            complite(result,errmsg,jsonDic);
        }
    }];
}

#pragma mark 发送文字消息

//测试数据
//    MessageModel *msgModel = [[MessageModel alloc] init];
//    msgModel.from.uid = @"20015";
//    msgModel.from.phone = @"18127134405";
//    msgModel.from.name = @"wanghui";
//    msgModel.from.headUrl = @"http://headUrl";
//
//    msgModel.to.uid = @"20031";
//    msgModel.to.phone = @"13800005555";
//    msgModel.to.name = @"my QQ friend";
//    msgModel.to.headUrl = @"http://headUrl.to";
//
//    msgModel.content =@"你在哪？";
//    msgModel.image = @{@"url": @"test.png"};
//    //    msgModel.contentFile = @"";
//    //    msgModel.contentVideo = @"";
//    //    msgModel.contentVoice = @"";
//    msgModel.lng = @"0";
//    msgModel.lat = @"0";
//    msgModel.time = @"2017-05-20";
//    msgModel.readState = @"1";
//    msgModel.afterReadBurn = @"1";
//    msgModel.typeChat = @"100";
//    msgModel.typeFile = @"2";

+(MessageModel *)im_userSendMessageWithItem:(id)msgItem targetItem:(CTToModel *)targetItem type:(IMMessgeType)type chatType:(IMChatType)chatType complite:(void(^)(BOOL result, NSString *errmsg , NSDictionary *jsonDic))complite{
    
        //消息
    MessageModel *msgModel = [[MessageModel alloc] init];
        //来源
    CTFromModel *fromItem = msgModel.from;
//    fromItem.uid = self.userInfo.uid;
    fromItem.phone = self.userInfo.phone;
    fromItem.name = self.userInfo.nickName;
    fromItem.headUrl = self.userInfo.headImage;
    
    msgModel.to = targetItem;
    
    switch (type) {
        case IMMessgeTypeText:
            //文字
            msgModel.content = [NSString stringWithFormat:@"%@",msgItem];
            break;
        case IMMessgeTypeImage:
            //图片
            if ([msgItem isKindOfClass:[CTImageItem class]]) {
                msgModel.image = (CTImageItem *)msgItem;
            }
            break;
        case IMMessgeTypeVideo:
            //小视频
            if ([msgItem isKindOfClass:[CTVideoItem class]]) {
                msgModel.video = (CTVideoItem *)msgItem;
            }
            break;
        case IMMessgeTypeAudio:
            //音频
            if ([msgItem isKindOfClass:[CTAudioItem class]]) {
                msgModel.voice = (CTAudioItem *)msgItem;
            }
            break;
        case IMMessgeTypeFile:
            //文件
            if ([msgItem isKindOfClass:[CTFileItem class]]) {
                msgModel.file = (CTFileItem *)msgItem;
            }
            break;
        case IMMessgeTypeLocation:
            //位置
        {
            if ([msgItem isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = (NSDictionary *)msgItem;
                NSString *lngStr = [dict getStringValueForKey:@"lng" defaultValue:@""];
//                lngStr = [NSString stringWithFormat:@"%.2f",lngStr.floatValue];
                NSString *latStr = [dict getStringValueForKey:@"lat" defaultValue:@""];
//                latStr = [NSString stringWithFormat:@"%.2f",lngStr.floatValue];
                
                msgModel.lng = lngStr;
                msgModel.lat = latStr;
            }
        }
            break;
        default:
            NSLog(@"消息格式不对");
            break;
    }
    
    msgModel.time = [[NSDate date] xmppDateTimeString];
    msgModel.readState = 2;
    msgModel.afterReadBurn = 0;
    msgModel.typeChat = chatType;
    msgModel.typeFile = type;
    
    NSData *tmpData = [msgModel jsonData];
    
    NSString *methodUrl = [NSString stringWithFormat:@"%@/message/sendMessage",domain_url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:methodUrl]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    if (tmpData && [tmpData isKindOfClass:[NSData class]]) {
        [request setHTTPBody:tmpData];
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        BOOL succ = NO;
        NSString *errmsg = @"";
        NSDictionary *resultDic = nil;
        
        if (error || data.length == 0) {
            errmsg = @"请求失败";
        }
        else{
            id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments | NSJSONReadingMutableContainers) error:nil];
            if ([jsonObj isKindOfClass:[NSDictionary class]]) {
                succ = YES;
                resultDic = (NSDictionary *)jsonObj;
                
                NSLog(@"\nCode = %@ \nMessage: %@",resultDic[@"code"],resultDic[@"msg"]);
            }else{
                errmsg = @"JSON格式错误";
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (complite) {
                complite(succ,errmsg,resultDic);
            }
            if (succ == NO) {
                NSLog(@"发送失败: errmsg: %@",errmsg);
            }
        });
        
    }];
    
    [task resume];
    
        //返回 model 以便操作
    return msgModel;
}


#pragma mark IM 上传文件
/*
  @param type (image,video,voice,file)
 */
+(void)im_userUploadFile:(id)fileObj
                fileType:(NSString *)type
                progress:(void(^)(int64_t bytesProgress,int64_t totalBytesProgress))progressBlock
                complite:(void(^)(BOOL result, NSString *errmsg , NSDictionary *jsonDic))complite{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.user forKey:@"phone"];

    NSString *methodUrl = [NSString stringWithFormat:@"%@/file/uploadFile",domain_url];
    
    
        //获取 FileData(NSData) , mimeType:(文件类型 application/octet-stream , image/jpg,)
    /*
     mimeType:(文件类型  , )
     二进制流未知类型 application/octet-stream
     图片 JPG image/jpg
     图片 PNG image/png
     视频 MP4 video/mpeg4
     音频 MP3 audio/mp3
     文本 TXT text/plain
     */
    NSData *fileData = nil;
    NSString *mimeType = @"application/octet-stream";
    NSString *fileName = nil;       //文件名
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *dataStr = [formatter stringFromDate:[NSDate date]];
    
    if ([fileObj isKindOfClass:[UIImage class]]) {
        fileData = UIImageJPEGRepresentation(fileObj, 0.7);
        
        //文件名
        
        fileName = [NSString stringWithFormat:@"%@.jpg", dataStr];
        
        //mimeType
        mimeType = @"image/jpg";
    }else if ([fileObj isKindOfClass:[NSString class]]){
        //本地发送的 file路径 (.amr,.mp4,.txt。。。)
        if ([type isEqualToString:@"voice"]) {
            NSString *filePath = [NSString stringWithFormat:@"%@",fileObj];
            NSURL *fileURL = [NSURL URLWithString:filePath];
            NSString *fileType = fileURL.pathExtension;
            
            fileName  = [NSString stringWithFormat:@"%@.%@",dataStr,fileType];
            fileData = [NSData dataWithContentsOfFile:filePath];
            
            mimeType = [NSString stringWithFormat:@"audio/%@",fileType];
        }
        else if ([type isEqualToString:@"video"]){
            
        }
        else if ([type isEqualToString:@"file"]){
            
        }
    }
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    
        //设置 Content-Type, Content-Length 请求头信息
//    NSString *charset = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
//    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; charset=%@; boundary=%@",charset,@"---------------------------im"];
    
//    sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
//    sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
//    [sessionManager.requestSerializer setValue:contentType forHTTPHeaderField:@"Content-Type"];
//    [sessionManager.requestSerializer setValue:[NSString stringWithFormat:@"%lu",(unsigned long)objData.length] forHTTPHeaderField:@"Content-Length"];

    [sessionManager POST:methodUrl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if (fileData) {
            [formData appendPartWithFileData:fileData name:@"file" fileName:fileName mimeType:mimeType];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if(progressBlock)   progressBlock(uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
        
        NSLog(@"进度:%f",(float)uploadProgress.completedUnitCount/uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if(complite)    complite(YES,nil,responseObject);
        }else{
            if(complite)    complite(NO,@"JSON格式有误",nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(complite)    complite(NO,@"请求失败",nil);
        NSLog(@"error :%@",error.description);
    }];
    
    
}


#pragma mark - 群组

#pragma mark IM 创建群组
+(void)im_groupCreateWithName:(NSString *)groupName groupDesc:(NSString *)desc maxMenber:(NSInteger)maxMenberNum isPublic:(BOOL)isPublic complite:(void(^)(BOOL result, NSString *errmsg , NSDictionary *jsonDic))complite{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.userInfo.uid forKey:@"creatorid"];
    [params setObject:self.user forKey:@"creator"];
    [params setObject:groupName!=nil?groupName:@"" forKey:@"name"];
    [params setObject:desc!=nil?desc:@"" forKey:@"sign"];
    [params setObject:@(maxMenberNum) forKey:@"max_count"];
    [params setObject:@(isPublic) forKey:@"is_pulic"];
    
    
    NSString *methodUrl = [NSString stringWithFormat:@"%@/group/createGroup",domain_url];
    [HttpRequest sendPostSession:methodUrl params:params complite:^(BOOL result, NSString *errmsg, NSDictionary *jsonDic) {
        if (complite) {
            complite(result,errmsg,jsonDic);
        }
    }];
}

#pragma mark  IM 请求加入群
+(void)im_groupJoin:(NSString *)groupId complite:(void(^)(BOOL result, NSString *errmsg , NSDictionary *jsonDic))complite{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.userInfo.uid forKey:@"uid"];
    [params setObject:groupId!=nil?groupId:@"" forKey:@"groupid"];
    
    NSString *methodUrl = [NSString stringWithFormat:@"%@/group/joinGroup",domain_url];
    [HttpRequest sendPostSession:methodUrl params:params complite:^(BOOL result, NSString *errmsg, NSDictionary *jsonDic) {
        if (complite) {
            complite(result,errmsg,jsonDic);
        }
    }];
}


#pragma mark  移除群成员
+(void)im_groupRemoveMenber:(NSString *)memberId groupId:(NSString *)groupId complite:(void(^)(BOOL result, NSString *errmsg , NSDictionary *jsonDic))complite{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.userInfo.uid forKey:@"uid"];
    [params setObject:groupId!=nil?groupId:@"" forKey:@"groupid"];
    [params setObject:memberId!=nil?memberId:@"" forKey:@"memberid"];
    
    NSString *methodUrl = [NSString stringWithFormat:@"%@/group/removeMember",domain_url];
    [HttpRequest sendPostSession:methodUrl params:params complite:^(BOOL result, NSString *errmsg, NSDictionary *jsonDic) {
        if (complite) {
            complite(result,errmsg,jsonDic);
        }
    }];
}


#pragma mark IM 请求获取我的群列表
+(void)im_groupGetMyGroupListWithPageNum:(NSInteger)pageNum apageCount:(NSInteger)pageCount complite:(void(^)(BOOL result, NSString *errmsg , NSDictionary *jsonDic))complite{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.userInfo.uid forKey:@"uid"];
    [params setObject:@(pageNum) forKey:@"pageNum"];
    [params setObject:@(pageCount) forKey:@"pageCount"];
    
    NSString *methodUrl = [NSString stringWithFormat:@"%@/group/getMyGroup",domain_url];
    [HttpRequest sendPostSession:methodUrl params:params complite:^(BOOL result, NSString *errmsg, NSDictionary *jsonDic) {
        if (complite) {
            complite(result,errmsg,jsonDic);
        }
    }];
    
}

#pragma mark 修改更新群资料信息
+(void)im_groupUpdateGroupData:(NSString *)groupId groupName:(NSString *)groupName groupDesc:(NSString *)desc maxMember:(NSInteger)maxMembeCount complite:(void(^)(BOOL result, NSString *errmsg , NSDictionary *jsonDic))complite{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.userInfo.uid forKey:@"uid"];
    [params setObject:groupName!=nil?groupName:@"" forKey:@"name"];
    [params setObject:desc!=nil?desc:@"" forKey:@"sign"];
    [params setObject:@(maxMembeCount) forKey:@"max_count"];
    
    NSString *methodUrl = [NSString stringWithFormat:@"%@/group/updateGroup",domain_url];
    [HttpRequest sendPostSession:methodUrl params:params complite:^(BOOL result, NSString *errmsg, NSDictionary *jsonDic) {
        if (complite) {
            complite(result,errmsg,jsonDic);
        }
    }];
}


#pragma mark - ********请求方法 URLSession
//SessionTask POST 异步请求
+(void)sendPostSession:(NSString *)url params:(NSDictionary *)paramsDic complite:(void(^)(BOOL result, NSString *errmsg , NSDictionary *jsonDic))complite{
    NSMutableURLRequest *request = [HttpRequest getPostRequest:url params:paramsDic];
    [HttpRequest networkStart];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        BOOL succ = NO;
        NSString *msg = @"";
        NSDictionary *jsonObj = nil;
        
        if (error || data.length == 0) {
            msg = @"请求失败";
            if(error)   NSLog(@"Error: %@",error.description);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [HttpRequest networkEnd];
                complite(succ,msg,jsonObj);
            });
            return ;
        }
        
        id jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if ([jsonData isKindOfClass:[NSDictionary class]]) {
            succ = YES;
//            msg = @"请求成功";
            jsonObj = (NSDictionary *)jsonData;
        }else{
            msg = @"JSON数据错误";
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [HttpRequest networkEnd];
            complite(succ,msg,jsonObj);
        });
        
    }];
    [dataTask resume];
}



//SessionTask GET 异步请求
+(void)sendGetMethodSession:(NSString *)url params:(NSDictionary *)paramsDic complite:(void(^)(BOOL result, NSString *errmsg , NSDictionary *jsonDic))complite{
    
    NSURLRequest *request = [HttpRequest GetRequest:url params:paramsDic];
    [HttpRequest networkStart];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        BOOL succ = NO;
        NSString *msg = @"";
        NSDictionary *jsonObj = nil;
        
        if (error || data.length == 0) {
            msg = @"请求失败";
            if(error)   NSLog(@"Error: %@",error.description);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [HttpRequest networkEnd];
                complite(succ,msg,jsonObj);
            });
            return ;
        }
        
        id jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if ([jsonData isKindOfClass:[NSDictionary class]]) {
            succ = YES;
            msg = @"请求成功";
            jsonObj = (NSDictionary *)jsonData;
        }else{
            msg = @"JSON数据错误";
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [HttpRequest networkEnd];
            complite(succ,msg,jsonObj);
        });
        
    }];
    [dataTask resume];
}

//获取POST 请求对象
+(NSMutableURLRequest *)getPostRequest:(NSString *)url params:(NSDictionary *)paramsDic{
    NSURL *URL=[NSURL URLWithString:url];
    
    NSString *postUrl = [HttpRequest stringFromDictionary:paramsDic];
    NSLog(@"post-->URLString = %@ \n Body = %@",url,postUrl);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:(NSURLRequestUseProtocolCachePolicy) timeoutInterval:30.0];
    [request setHTTPMethod:@"POST"];
    NSData *data = [postUrl dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    
    return request;
}

//获取GET请求对象
+(NSMutableURLRequest *)GetRequest:(NSString *)url params:(NSDictionary *)paramsDic{
    NSString *urlStr=[NSString stringWithFormat:@"%@",url];
    NSString *tmpUrl = [HttpRequest stringFromDictionary:paramsDic];
    
    urlStr = [NSString stringWithFormat:@"%@?%@",urlStr,tmpUrl];
    NSURL *URL=[NSURL URLWithString:urlStr];
    NSLog(@"post-->URLString = %@\n",urlStr);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:(NSURLRequestUseProtocolCachePolicy) timeoutInterval:30.0];
    [request setHTTPMethod:@"GET"];
    
    return request;
    
}

/** 在变量之间添加&区别 */
+ (NSString *)stringFromDictionary:(NSDictionary *)dict {
    NSMutableArray *pairs = [NSMutableArray array];
    [dict enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, [obj URLEncodedString]]];
    }];
    NSString *str = [pairs componentsJoinedByString:@"&"];
    if(!str)    str = @"";
    return str;
}

// 网络加载指示器
+(void)networkStart{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

+(void)networkEnd{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end
