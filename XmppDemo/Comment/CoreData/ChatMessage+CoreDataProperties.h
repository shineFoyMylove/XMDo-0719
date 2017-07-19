//
//  ChatMessage+CoreDataProperties.h
//  XmppProject
//
//  Created by IntelcentMac on 17/7/17.
//  Copyright © 2017年 wh_shine. All rights reserved.
//

#import "ChatMessage+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ChatMessage (CoreDataProperties)

+ (NSFetchRequest<ChatMessage *> *)fetchRequest;


@property (nullable, nonatomic, copy) NSString *conversationId;  /**<会话 Id, 单聊-对方phone, 群聊-群组id */
@property (nullable, nonatomic, copy) NSString *userphone;      /**<当前登录用户 phone */
@property (nullable, nonatomic, copy) NSString *messageID;  /**<消息 Id, 服务器提供的 消息唯一标识 */

    //From
@property (nullable, nonatomic, copy) NSString *from_name;
@property (nullable, nonatomic, copy) NSString *from_phone;
@property (nullable, nonatomic, copy) NSString *from_uid;
@property (nullable, nonatomic, copy) NSString *from_headerImage;
    //To
@property (nullable, nonatomic, copy) NSString *to_name;
@property (nullable, nonatomic, copy) NSString *to_phone;
@property (nullable, nonatomic, copy) NSString *to_uid;
@property (nullable, nonatomic, copy) NSString *to_headerImage;


@property (nonatomic) IMMessgeType msgType;  /**< 文件类型 1是文字， 2图片， 3小视频  4语音  5文件， 6地址 必须 */
    //Text
@property (nullable, nonatomic, copy) NSString *textContent;
    //Image
@property (nullable, nonatomic, copy) NSString *img_url;
@property (nonatomic) float img_height;
@property (nonatomic) float img_width;
    //Video
@property (nullable, nonatomic, copy) NSString *video_url;
@property (nonatomic) int32_t video_length;
    //Voice
@property (nullable, nonatomic, copy) NSString *voice_url;
@property (nonatomic) int32_t voice_length;
    //File
@property (nullable, nonatomic, copy) NSString *file_url;
@property (nullable, nonatomic, copy) NSString *file_name;
@property (nullable, nonatomic, copy) NSString *file_suffix;        /**< 文件后缀 */
@property (nonatomic) double file_size;     /**< 文件大小 kb */
    //Location
@property (nonatomic) float loc_lng;    /**< 经度 */
@property (nonatomic) float loc_lat;    /**<纬度 */

@property (nonatomic) double timeInterval;  /**<时间戳 */


#pragma mark - 静态方法、检索、批量操作
/**
 管理属性描述
 @return NSEntityDescription
 */
+(NSEntityDescription *)entityDescription;


/**
 所有聊天记录
 默认按时间排序，倒序
 @return NSArray<ChatMessage *>
 */
+(NSArray <ChatMessage *>*)fetchAllChatMessage;


/**
 某会话窗口 最新聊天记录 默认 20条
 @param conversationID 会话窗口ID
 @return NSArray<ChatMessage *>
 */
+(NSArray <ChatMessage *>*)fetchTheRecentChatMessageWithID:(NSString *)conversationID;


/**
 检索筛选聊天记录
 @param search 筛选条件
 @return NSArray<ChatMessage *>
 */
+(NSArray <ChatMessage *> *)fetchChatMessageWithSearchText:(NSString *)search;


/**
 清除部分聊天记录
 @param messageArray NSArray<ChatMessage *>
 */
+(BOOL)removeChatMessages:(NSArray <ChatMessage *> *)messageArray;


/**
 清除所有的聊天记录
 */
+(BOOL)removeAllChatMessage;


#pragma mark - 实例方法 -- 增、删、改操作

+(instancetype)NewMessage;   /**<替换 初始化  */

-(id)init;      /**<重写 init */

-(BOOL)insert;   /**< 增加一条记录 */

-(BOOL)remove;   /**< 移除一条记录 */


@end

NS_ASSUME_NONNULL_END
