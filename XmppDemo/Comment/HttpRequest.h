//
//  HttpRequest.h
//  WHIMDemo1
//
//  Created by Gery晖 on 17/6/5.
//  Copyright © 2017年 wh_shine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageModel.h"

typedef NS_ENUM(NSUInteger,HttpRequestStatus) {
    HttpRequestStatusSucc,      /**<操作成功 */
    HttpRequestStatusDataError, /**<数据异常 */
    HttpRequestStatusVerifyError,  /**<数据验证错误 */
    HttpRequestStatusNoMoreData,   /**<暂无更多数据 */
    HttpRequestStatusOperationError, /**<操作失败 */
    HttpRequestStatusXmppOperationError, /**<XMPP操作失败 */
    HttpRequestStatusUserExist          /**<用户已经存在 */
};


@interface HttpRequest : NSObject

#pragma mark 公共方法


+(instancetype)instance;

/**
 获取请求状态结果 */
+(HttpRequestStatus)requestResult:(NSDictionary *)jsonObj;

#pragma mark - 原生App请求

/**
 * App注册 */
+(void)app_userRegist:(NSString *)phone password:(NSString *)pwdStr complite:(void(^)(BOOL result, NSString *errmsg , NSDictionary *jsonDic))complite;

/**
 * App登录 */
+(void)app_userLogin:(NSString *)phone password:(NSString *)pwdStr complite:(void(^)(BOOL result, NSString *errmsg , NSDictionary *jsonDic))complite;

#pragma mark - IM 操作

/**
 *IM - friend 好友列表 */
+(void)im_userGetFriendListComplite:(void(^)(BOOL result, NSString *errmsg , NSDictionary *jsonDic))complite;

/**
 * IM - friend 添加好友 */
+(void)im_userAddFriend:(NSString *)friendPhone complite:(void(^)(BOOL result, NSString *errmsg , NSDictionary *jsonDic))complite;

/**
 * IM - friend 解除好友关系 */
+(void)im_userRemoveFriend:(NSString *)friendPhone complite:(void(^)(BOOL result, NSString *errmsg , NSDictionary *jsonDic))complite;

/**
 * IM - friend 加入黑名单 */
+(void)im_userInBlack:(NSString *)blackPhone complite:(void(^)(BOOL result, NSString *errmsg , NSDictionary *jsonDic))complite;

/**
 * IM - friend 移除黑名单 */
+(void)im_userRemoveBlack:(NSString *)blackPhone complite:(void(^)(BOOL result, NSString *errmsg , NSDictionary *jsonDic))complite;

/**
 * IM - friend 新的朋友列表 */
+(void)im_userNewFriendListComplite:(void(^)(BOOL result, NSString *errmsg , NSDictionary *jsonDic))complite;


/**
 * IM 发送文字消息 */

+(MessageModel *)im_userSendMessageWithItem:(id)msgItem targetItem:(CTToModel *)targetItem type:(IMMessgeType)type chatType:(IMChatType)chatType complite:(void(^)(BOOL result, NSString *errmsg , NSDictionary *jsonDic))complite;

/**
 IM 上传文件
 
 @param fileObj 文件obj
 @param complite 回调
 */

/**
 IM 上传文件

 @param fileObj 文件obj
 @param type (image,video,voice,file)
 @param complite 结果回调
 */
+(void)im_userUploadFile:(id)fileObj
                fileType:(NSString *)type
                progress:(void(^)(int64_t bytesProgress,int64_t totalBytesProgress))progressBlock
                complite:(void(^)(BOOL result, NSString *errmsg , NSDictionary *jsonDic))complite;




#pragma mark - 群组
/**
 IM 创建群组
 
 @param groupName 群名称
 @param desc 群描述
 @param maxMenberNum 最大群成员数(默认 500)
 @param isPublic 是否公开(添加成员是否需要群主同意 1-是 、0-否)
 */
+(void)im_groupCreateWithName:(NSString *)groupName groupDesc:(NSString *)desc maxMenber:(NSInteger)maxMenberNum isPublic:(BOOL)isPublic complite:(void(^)(BOOL result, NSString *errmsg , NSDictionary *jsonDic))complite;



/**
 IM 请求加入群
 
 @param groupId 群ID
 */
+(void)im_groupJoin:(NSString *)groupId complite:(void(^)(BOOL result, NSString *errmsg , NSDictionary *jsonDic))complite;



/**
 移除群成员

 @param memberId 要移除的成员ID
 @param groupId 群ID
 */
+(void)im_groupRemoveMenber:(NSString *)memberId groupId:(NSString *)groupId complite:(void(^)(BOOL result, NSString *errmsg , NSDictionary *jsonDic))complite;



/**
 IM 请求获取我的群列表
 
 @param pageNum 当前页码
 @param pageCount 每一页数据数量
 */
+(void)im_groupGetMyGroupListWithPageNum:(NSInteger)pageNum apageCount:(NSInteger)pageCount complite:(void(^)(BOOL result, NSString *errmsg , NSDictionary *jsonDic))complite;


/**
 修改更新群资料信息

 @param groupId 群ID
 @param groupName 群名称
 @param desc 群描述
 @param maxMembeCount 最大成员数
 */
+(void)im_groupUpdateGroupData:(NSString *)groupId groupName:(NSString *)groupName groupDesc:(NSString *)desc maxMember:(NSInteger)maxMembeCount complite:(void(^)(BOOL result, NSString *errmsg , NSDictionary *jsonDic))complite;


#pragma mark - 广告

/**
 获取广告数据
 @param adverType 广告类型（0:文字  1： 拨号图片 2：拨打图片）
 */
+(void)im_adverGettingWithType:(NSInteger)adverType complite:(void(^)(BOOL result, NSString *errmsg , NSDictionary *jsonDic))complite;



@end
