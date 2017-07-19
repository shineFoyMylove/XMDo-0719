//
//  AppUserInfo.h
//  CallLiaoBei
//
//  Created by IntelcentMacMini on 16/11/3.
//  Copyright © 2016年 GeryHui. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AdverObject;

@interface AppUserInfo : NSObject

@property (nonatomic, retain) NSString *phone;
@property (nonatomic, retain) NSString *pwdStr;
@property (nonatomic, retain) NSString *uid;
@property (nonatomic, retain) NSString *nickName;
@property (nonatomic, retain) NSString *headImage;   //头像缩略图
@property (nonatomic, retain) NSString *headLargeImage;  //头像大图

@property (nonatomic, assign) NSInteger phoneCharge;  // Deafult=0(什么属性？)
@property (nonatomic, assign) NSInteger sexType;    /**< 0:未设置 1:男 2:女 */
@property (nonatomic, retain,readonly) NSString *sex;  //男、女
@property (nonatomic, retain) NSString *signText;   //签名内容



@property (nonatomic, retain) NSString *callType;   /**拨打方式 0-固定回拨 1-固定直拨 2-根据网络选择 3-手动选择 */
@property (nonatomic, assign) BOOL insertIncomingNumber;   /**<添加回铃专线 */


@property (nonatomic, retain) NSString *balance;
@property (nonatomic, retain) NSString *availableDate;  /**<有效期 */
@property (nonatomic, retain) NSString *pkgName;     /**<套餐名 */
@property (nonatomic, retain) NSString *pkgDate;    /**<套餐有效期 */

//广告
@property (nonatomic, retain) NSDictionary *adver_textDic;  /**<文字广告 text-url */
@property (nonatomic, retain) NSArray *adver_dialerPic;    /**<图片广告-拨号 @[@{image,url},@{image,url}]*/
@property (nonatomic, retain) NSArray *adver_indexPic;     /**<图片广告-主页 @[@{image,url},@{image,url}]*/
@property (nonatomic, retain) NSArray *adver_callPic;      /**<图片广告-回拨 @[@{image,url},@{image,url}]*/
@property (nonatomic, retain) NSString *servicePhone;   /**<客服热线 */
@property (nonatomic, retain) NSString *soundUrl;     /**<回拨铃声 url*/
@property (nonatomic, retain) NSString *soundPath;     /**<回拨铃声path */

@property (nonatomic, retain) NSArray *adver_moreData;      /**<更多广告 @[@{icon,title,url}]*/

@property (nonatomic, assign) NSTimeInterval lastLoginTime;   //上一次登录时间
@property (nonatomic, retain) NSString *appDomain;   /**<保存数据的用户所属域名 */

@property (nonatomic, assign) BOOL checkSuccess;  //通过成功

-(void)updateLoginInfo:(NSDictionary *)info;  //登录、注册成功，更新服务器上的用户资料信息


-(NSString *)getOriginPwd;

-(void)downloadSoundSource;   /**<下载铃声音频 */

-(BOOL)isLogin;   //是否登录状态



@end
