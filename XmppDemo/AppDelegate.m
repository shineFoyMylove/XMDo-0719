//
//  AppDelegate.m
//  XmppDemo
//
//  Created by IntelcentMac on 17/6/24.
//  Copyright © 2017年 wh_shine. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "TLFriendsViewController.h"
#import "TLFriendHelper.h"
#import "NewFriendObject+CoreDataClass.h"
#import "ChatMessage+CoreDataClass.h"
#import "CoreDataManager.h"

@interface AppDelegate ()<XMPPRosterDelegate,XMPPStreamDelegate>

@end

@implementation AppDelegate

+(AppDelegate *)instance{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleLightContent)];
    
//    UINavigationController *NaviVc = [[UINavigationController alloc] initWithRootViewController:[[TLFriendsViewController alloc] init]];
//    self.window.rootViewController = NaviVc;
//    [self.window makeKeyAndVisible];
    
    self.appManager = [[AppManager alloc] init];
    _appManager.enableNetworkObserver = YES;
    [_appManager haveUserInfo];         //读取用户信息
    
    if ([self.appManager.userInfo isLogin]) {
        [_appManager AppLogin];
    }else{
        [_appManager AppSignOut];
    }
    
    [self setWelcomeImages];  //设置欢迎页面
    [self registTenceBugly];   //注册腾讯bugly
    
    //添加代理回调
    //好友添加以及上线
    XMPPStream *stream = [XMPPTool shareXMPPTool].stream;
    [stream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [stream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xmppMessageReceive:) name:XMPPChatReceiveMessageNotification object:nil];
    
    return YES;
}

//设置欢迎页
-(void)setWelcomeImages{
//    WelcomeView = [[SHWelcomView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
//    WelcomeView.havePageControl = YES;
//    [WelcomeView setWelcomeImages:@[@"welcome1.jpg",@"welcome2.jpg",@"welcome3.jpg",@"welcome4.jpg"]];
//    
//    __block SHWelcomView *weakWel = WelcomeView;
//    [WelcomeView setViewOverBlock:^{
//        NSLog(@"进入主界面");
//        [weakWel removeFromSuperview];
//    } withSwithOnCondition:^BOOL{
//        BOOL isChange = [ToolMethods AppVersionIsChange];
//        return isChange;
//    }];
//    [self.window addSubview:WelcomeView];
}

//注册腾讯bugly
-(void)registTenceBugly{
    //    NSString *bundleName =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
    //    BuglyConfig *bugConfig = [[BuglyConfig alloc] init];
    //    [bugConfig setChannel:[NSString stringWithFormat:@"%@-(精简版)",bundleName]];
    //    [Bugly startWithAppId:@"3e367b9b72"config:bugConfig];
}

#pragma mark 消息接收通知监听
-(void)xmppMessageReceive:(NSNotification *)notify{
    if ([notify.object isKindOfClass:[NSDictionary class]]){
        //服务器回调
        MessageModel *msgObj = [[MessageModel alloc] init];
        msgObj = [MessageModel mj_objectWithKeyValues:notify.object];
        
        //接收到的信息save
        ChatMessage *chatMsg = [ChatMessage NewMessage];
        [chatMsg updateWithMessageModel:msgObj];
        if (![chatMsg insert]) {
            NSLog(@"消息记录 - 存储失败");
        }
    }
}

#pragma mark - XMPPRosterDelegate监听好友请求,收到好友请求时调用该代理方法

    //用户在线，有人请求申请订阅
-(void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence{
    
    [self receiveSubscriptionRequest:presence];
    
}

    //离线 - 新的好友
-(void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence{
    
    NSLog(@"ID: %@ 状态: %@",presence.from,presence.type);
    NSString *receiveUser = presence.from.user;
    
    NSString *username = UDGetString(username_preference);
    
    
    if ([presence.type isEqualToString:@"available"] && [presence.from.user isEqualToString:username]) {
        //我好友的上线状态
        //发送上线通知
    }
    
    if ([presence.type isEqualToString:@"unavailable"] && [presence.from.user isEqualToString:username]) {
        //我好友的上线状态
        //发送下线通知
    }
    
        //收到对方取消订阅我的消息 (被删除)
    if ([presence.type isEqualToString:@"unsubscribe"]) {
        //删除
        [[XMPPTool shareXMPPTool].roster removeUser:presence.from];
    }
    
    if ([presence.type isEqualToString:@"subscribe"]) {
        //用户离线-申请订阅
        [self receiveSubscriptionRequest:presence];
    }
    
}

    //接收到好友请求订阅
-(void)receiveSubscriptionRequest:(XMPPPresence *)presence{
    
    NSString *receiveUser = presence.from.user;
    
    NSString *username = UDGetString(username_preference);
    BOOL isOwner = [username isEqualToString:receiveUser];
    
    BOOL isExist = NO;
    
    NSArray *allNewApply =  [NewFriendObject featchAllRequest];
    for (NewFriendObject *obj in allNewApply) {
        if ([obj.phone isEqualToString:receiveUser]) {
            isExist = YES;
        }
    }
    
    if (receiveUser.length == 0) {
        NSLog(@"other error: %@",presence);
        return;
    }
    
    NSArray *friends = [TLFriendHelper sharedFriendHelper].friendsData;
    for (TLUser *user in friends) {
        if ([user.userID isEqualToString:receiveUser]) {
            isExist = YES;
        }
    }
    
    if (!isExist && !isOwner) {
        NewFriendObject *newObj = [[NewFriendObject alloc] init];
        newObj.phone = receiveUser;
        newObj.name  = [NSString stringWithFormat:@"新增测试: %@",receiveUser];
        newObj.state = TLNewFriendApplyStateNew;
        [newObj insert];
    }
}


#pragma mark - UIApplication Delegate

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
    
    [[CoreDataManager instance] saveContext];
    [[XMPPTool shareXMPPTool] xmppLogout];  //退出xmpp
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"XmppDemo"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}


@end
