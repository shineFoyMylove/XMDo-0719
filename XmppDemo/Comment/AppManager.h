//
//  AppManager.h
//  CallLiaoBei
//
//  Created by IntelcentMacMini on 16/11/3.
//  Copyright © 2016年 GeryHui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddressbookObject.h"
#import "AppUserInfo.h"
#import "CallLogObject.h"
//#import "AdverObject.h"
#import "Reachability.h"

@interface AppManager : NSObject

@property (nonatomic, retain) AddressbookObject *addressBook;
@property (nonatomic, retain) AppUserInfo *userInfo;
@property (nonatomic, retain) CallLogObject *logsObject;   //通话记录
@property (nonatomic, retain) AdverObject *adverObj;      //广告
@property (nonatomic) BOOL haveNew;        //有新版本
@property (nonatomic) BOOL enableNetworkObserver;   /**<添加网络监听 */
@property (nonatomic) BOOL haveNetwork;   //是否允许访问网络


-(void)AppSignOut;   /**<账号退出 */
-(void)AppLogin;    /**<账号登录 */

#pragma mark 用户信息保存
-(BOOL)haveUserInfo;    /**<读取用户信息 */
-(void)saveUserInfo;   /**<保存用户信息 */
-(void)clearUserInfo;  /**<清除用户信息 */

#pragma mark App在线更新
-(void)AppUpdate:(BOOL)isLaunch;   /**<APP更新检测 */

#pragma mark 网络检查
-(BOOL)checkNetworkAccessible;
-(void)startNetwrokNotifier;   //检测发送广播

#pragma mark 检测是否通过
-(BOOL)checkIsSuccessForStore:(void(^)(BOOL succ))complite;

@end
