//
//  AppManager.m
//  CallLiaoBei
//
//  Created by IntelcentMacMini on 16/11/3.
//  Copyright © 2016年 GeryHui. All rights reserved.
//

#import "AppManager.h"
#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "LoginViewController.h"
#import "BaseNaviViewController.h"

#import "LeftViewController.h"
#import <SystemConfiguration/CaptiveNetwork.h>

#import "XMPPTool.h"
#import "ChatMessage+CoreDataProperties.h"

NSString *const NTCurrentUserInfo = @"CurrentUserInfo";

@interface AppManager()<UIAlertViewDelegate>

@property (nonatomic, retain) NSString *updateUrl;   //更新链接
@property (nonatomic, retain) Reachability *reachability;

@end

@implementation AppManager

#pragma mark 登录、注销 账号

+(AppDelegate *)appDelegate{
    return (AppDelegate  *)[UIApplication sharedApplication].delegate;
}

-(id)init{
    if (self = [super init]) {
        self.haveNetwork = YES;     //默认有网络
        [CallLogObject openDatabase];
    }
    return self;
}

-(void)AppLogin{
    
//    MainTabBarViewController *mainTabVc = [[MainTabBarViewController alloc] init];
//    [AppManager appDelegate].window.rootViewController = mainTabVc;
//    [[AppManager appDelegate].window makeKeyAndVisible];
//    
//    self.userInfo.lastLoginTime = [[NSDate date] timeIntervalSince1970];
//    
//    //请求广告
//    self.adverObj = [[AdverObject alloc] init];
//    self.adverObj.enableTimerRefrsh = YES;
    
    NSString *name = self.userInfo.phone;
    NSString *pwd = self.userInfo.pwdStr;
    
    UDSetObject(username_preference, self.userInfo.phone);  //保存当前登录账号
    
    
    MainTabBarController *naviCenterVc = [[MainTabBarController alloc] init];
    
    UIViewController *leftVc = [[LeftViewController alloc] init];
    
    MMDrawerController *drawerVc = [[MMDrawerController alloc] initWithCenterViewController:naviCenterVc leftDrawerViewController:leftVc];
    [AppManager appDelegate].DrawerController = drawerVc;
    //设置抽屉参数
    [drawerVc setShowsShadow:YES]; //阴影
    [drawerVc setMaximumLeftDrawerWidth:Main_Screen_Width *3/4];
    [drawerVc setOpenDrawerGestureModeMask:(MMOpenDrawerGestureModeAll)];
    [drawerVc setCloseDrawerGestureModeMask:(MMCloseDrawerGestureModeAll)];
    
    [AppManager appDelegate].window.rootViewController = drawerVc;
    [[AppManager appDelegate].window makeKeyAndVisible];
    
        //登录xmpp
    [[XMPPTool shareXMPPTool] xmppLoginUser:name password:pwd resultBlock:nil];
    
}

-(void)AppSignOut{
    
    LoginViewController *loginVc = [[LoginViewController alloc] init];
    BaseNaviViewController *naviLoginVc = [[BaseNaviViewController alloc] initWithRootViewController:loginVc];
    [AppManager appDelegate].window.rootViewController = naviLoginVc;
    [[AppManager appDelegate].window makeKeyAndVisible];
    
    [self clearUserInfo];  //清除Ó
    [[XMPPTool shareXMPPTool] xmppLogout];  //注销xmpp
    
    UDSetObject(username_preference, @"");  //清除当前登录账号
    
//    dispatch_async(GCDQueueDEFAULT, ^{
//        [[EMClient sharedClient] logout:YES];  //解除绑定，不接受消息推送
//    });
    
//    [self.adverObj timerRelease];  //关闭
}

#pragma mark 通讯录
-(AddressbookObject *)addressBook{
    if (_addressBook == nil) {
        _addressBook = [[AddressbookObject alloc] init];

        [_addressBook readLocalAddressBook];
    }
    return _addressBook;
}

-(CallLogObject *)logsObject{
    if (_logsObject == nil) {
        _logsObject = [[CallLogObject alloc] init];
    }
    return _logsObject;
}

#pragma mark 用户信息

    //读取用户信息
-(BOOL)haveUserInfo{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *userData = [defaults dataForKey:NTCurrentUserInfo];
    
    BOOL haveUser = NO;
    if (userData.length >0) {
        AppUserInfo *userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
        if ([userInfo isKindOfClass:[AppUserInfo class]]) {
            haveUser = YES;
            self.userInfo = userInfo;
        }
    }
    if (haveUser == NO) {
        self.userInfo = [[AppUserInfo alloc] init];
    }
    
    NSString *curDomain = [NSString stringWithFormat:@"%@",domain_url];
    if ([self.userInfo.appDomain isEqualToString:curDomain] == NO) {
        [self AppSignOut];
    }else{
        //保存域名
        self.userInfo.appDomain = [NSString stringWithFormat:@"%@",domain_url];
    }
    
    return haveUser;
}

    //保存用户信息
-(void)saveUserInfo{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //保存域名
    self.userInfo.appDomain = [NSString stringWithFormat:@"%@",domain_url];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.userInfo];
    if (data) {
        [defaults setObject:data forKey:NTCurrentUserInfo];
        
    }
    [defaults synchronize];
}
    //清除用户信息
-(void)clearUserInfo{
    self.userInfo.uid = self.userInfo.phone = nil;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:NTCurrentUserInfo];
    [defaults synchronize];
}


#pragma mark App在线更新
-(void)AppUpdate:(BOOL)isLaunch{
    WkSelf(weakSelf);
    self.updateUrl = nil;
//    [HTTPRequest requestForAppUpdate:^(BOOL result, NSString *errmsg, NSDictionary *jsonDic) {
//        if (result && jsonDic) {
//            NSString *codeStr = [jsonDic getStringValueForKey:@"code" defaultValue:@""];
//            NSString *showText = @"";
//            if ([codeStr isEqualToString:@"1"]) {
//                //有更新
//                weakSelf.updateUrl = [jsonDic getStringValueForKey:@"url" defaultValue:@""];
//                weakSelf.haveNew = YES;
//            }else if ([codeStr isEqualToString:@"2"]){
//                showText = @"已经是最新版本";
//            }else if ([codeStr isEqualToString:@"3"]){
//                showText = @"验证串错误";
//            }else{
//                showText = @"参数错误";
//            }
//            
//            if (weakSelf.updateUrl.length >0) {
//                [weakSelf showUpdate:YES message:@"有新版本更新"];
//            }else if (isLaunch){
//                showText = @"";
//            }
//            
//            if (showText.length >0) {
//                [weakSelf showUpdate:NO message:showText];
//            }
//        }else{
//            NSLog(@"error : %@",errmsg);
//            if (isLaunch == NO) {
//                [weakSelf showUpdate:NO message:@"检测失败"];
//            }
//        }
//    }];
}


-(void)showUpdate:(BOOL)haveUpdate message:(NSString *)updateDes{
    if (haveUpdate) {
        UIAlertView *updateAlert = [[UIAlertView alloc] initWithTitle:updateDes message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"点击更新", nil];
        [updateAlert show];
    }else if (updateDes.length >0){
        [MBProgressHUD showError:updateDes];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 1:
            //更新
        {
            if (self.updateUrl.length >0) {
                NSURL *Url = [NSURL URLWithString:self.updateUrl];
                if ([[UIApplication sharedApplication] canOpenURL:Url]) {
                    [[UIApplication sharedApplication] openURL:Url];
                }
            }
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark 添加网络监听
-(void)setEnableNetworkObserver:(BOOL)enableNetworkObserver{
    _enableNetworkObserver = enableNetworkObserver;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(rechabilityNetworkStatusChange:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    self.reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    [self.reachability startNotifier];
}

-(void)startNetwrokNotifier{
    [self.reachability startNotifier];
}

-(void)rechabilityNetworkStatusChange:(NSNotification *)notify{
    Reachability *reach = [notify object];
    NetworkStatus status = NotReachable;
    if ([notify.userInfo objectForKey:@"networkStatus"]) {
        status = [[notify.userInfo objectForKey:@"networkStatus"] intValue];
    }else{
        status = [reach currentReachabilityStatus];
    }
    
    switch (status) {
        case NotReachable:
            NSLog(@"网络已断开");
            break;
        case ReachableViaWWAN:
            NSLog(@"移动网络");
            break;
        case ReachableViaWiFi:
        {
            CFDictionaryRef dict = CNCopyCurrentNetworkInfo((__bridge CFStringRef)@"en0");
            if (dict) {
                NSString *BSSID = (__bridge NSString *)CFDictionaryGetValue(dict, @"BSSID");
                BSSID = [NSString stringWithFormat:@"%@",BSSID];
                CFRelease(dict);
                NSLog(@"WIFI网络信息:%@",BSSID);
            }
        }
            break;
            
        default:
            break;
    }
    
    if (status != NotReachable) {
        if (_haveNetwork == NO) {
            //无网->有网
            //刷新广告
//            [_adverObj requestAllAdver];
        }
        self.haveNetwork = YES;
    
    }else{
        self.haveNetwork = NO;
    }
    
}


#pragma mark 网络检查
-(BOOL)checkNetworkAccessible{
    Reachability *tmpReach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    Reachability *tmpReach2 = [Reachability reachabilityForInternetConnection];
    
    NetworkStatus tmpStatus = [tmpReach currentReachabilityStatus];
    BOOL hasNet = NO;
    if (tmpStatus == NotReachable) {
        hasNet = NO;
    }else{
        hasNet = YES;
    }
    if (hasNet != _haveNetwork && hasNet == YES) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kReachabilityChangedNotification object:tmpReach];
    }
    
    self.haveNetwork = hasNet;
    return hasNet;
}


#pragma mark 检测是否通过
-(BOOL)checkIsSuccessForStore:(void(^)(BOOL succ))complite{
    if (self.userInfo.checkSuccess == YES) {
        NSLog(@"已经通过");
        if (complite) {
            complite(YES);
        }
        return YES;
    }
    
//    WkSelf(weakSelf);
//    NSString *url = [NSString stringWithFormat:@"%@123.php",biz_domain_url];
//    
//    [HTTPRequest sendPostSession:url keys:nil values:nil complite:^(BOOL result, NSString *errmsg, NSDictionary *jsonDic) {
//        BOOL succ = NO;
//        if (result && jsonDic) {
//            NSString *codeStr = [jsonDic getStringValueForKey:@"msg" defaultValue:@""];
//            if ([codeStr isEqualToString:@"1"]) {
//                NSArray *dataArr = [jsonDic getArrayForKey:@"data"];
//                if (dataArr) {
//                    BOOL haveCode = NO;   //是否已经初始化
//                    for (NSDictionary *tmpDic in dataArr) {
//                        if ([tmpDic isKindOfClass:[NSDictionary class]]) {
//                            NSString *agid = [tmpDic getStringValueForKey:@"agid" defaultValue:@""];
//                            NSString *app_agId = [NSString stringWithFormat:@"%@",agent_id_value];
//                            if ([agid isEqualToString:app_agId]) {
//                                haveCode = YES;  //
//                                NSString *statusValue = [tmpDic getStringValueForKey:@"status" defaultValue:@""];
//                                if ([statusValue isEqualToString:@"1"]) {
//                                    //通过 kai qi
//                                    succ = YES;
//                                }
//                            }
//                        }
//                    }
//                    if (haveCode == NO) {
//                        NSLog(@"未设置代理 检测通过状态");
//                    }
//                    
//                }
//
//            }
//        }
//        
//        weakSelf.userInfo.checkSuccess = succ;
//        if (complite) {
//            complite(succ);
//        }
//    }];
    
    return NO;
}



@end
