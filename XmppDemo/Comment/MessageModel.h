//
//  MessageModel.h
//  XmppProject
//
//  Created by IntelcentMac on 17/7/3.
//  Copyright © 2017年 wh_shine. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CTFromModel;
@class CTToModel;
@class CTImageItem;
@class CTVideoItem;
@class CTAudioItem;
@class CTFileItem;

typedef NS_ENUM(NSUInteger, IMMessgeType) {
    IMMessgeTypeText  = 1,       //文字
    IMMessgeTypeImage = 2,      //图片
    IMMessgeTypeVideo = 3,      //视频
    IMMessgeTypeAudio = 4,      //音频
    IMMessgeTypeFile  = 5,       //文件
    IMMessgeTypeLocation = 6    //地址
};

typedef NS_ENUM(NSUInteger, IMChatType) {
    IMChatTypeSingle = 100,   //单聊
    IMChatTypeGroup  = 200,    //群聊
};

/** ********  消息对象 *******/
@interface MessageModel : NSObject

@property (nonatomic, strong) NSString *messageID; /**< 消息ID 服务器消息唯一标识*/

@property (nonatomic, strong) CTFromModel *from; /**< 消息发送来源对象  必须*/
@property (nonatomic, strong) CTToModel   *to;   /**< 消息发送目标对象 必须*/

@property (nonatomic, strong) NSString *content;    /**< 消息内容-txt */
@property (nonatomic, strong) CTImageItem *image;    /**< 消息内容-img */
@property (nonatomic, strong) CTFileItem *file;    /**< 消息内容-file */
@property (nonatomic, strong) CTVideoItem *video;    /**< 消息内容-video */
@property (nonatomic, strong) CTAudioItem *voice;    /**< 消息内容-voice */

@property (nonatomic, strong) NSString *lng;    /**< 坐标-经度 */
@property (nonatomic, strong) NSString *lat;    /**< 消息内容-纬度 */
@property (nonatomic, strong) NSString *time;    /**< 消息时间 必须*/

/**
 * 消息已读状态 1:发送成功  2:发送失败   3:对方已读）
 */
@property (nonatomic, assign) NSInteger readState;

@property (nonatomic, assign) NSInteger afterReadBurn;    /**< 阅后即焚状态（1:开启 0:不开启） 必须*/
@property (nonatomic, assign) NSInteger typeChat;    /**< 聊天类型 (100:单聊 200:群聊) 必须*/

/**< 文件类型 1是文字， 2图片， 3小视频  4语音  5文件， 6地址 必须*/
@property (nonatomic, assign) NSInteger typeFile;

-(void)updateWithDictionary:(NSDictionary *)dict;   //dic 转 obj

-(NSData *)jsonData;                                //obj 转 data

@end


#pragma mark - 消息 item

#pragma mark 消息来源对象
@interface CTFromModel : NSObject

//@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *headUrl;

-(NSDictionary *)jsonDic;

@end

#pragma mark 消息目标对象
@interface CTToModel : NSObject

//@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *headUrl;

-(NSDictionary *)jsonDic;

@end

#pragma mark 图片消息 item
@interface CTImageItem : NSObject

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *width;
@property (nonatomic, strong) NSString *height;

-(NSDictionary *)jsonDic;

//图片缩放
-(void)setImageSizeWithImage:(UIImage *)image;

@end

#pragma mark 小视频消息 item
@interface CTVideoItem : NSObject

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *length;

-(NSDictionary *)jsonDic;

@end

#pragma mark Audio语音消息 item
@interface CTAudioItem : NSObject

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *length;

-(NSDictionary *)jsonDic;

@end

#pragma mark 文件消息 item
@interface CTFileItem : NSObject

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *fileSize; //文件大小
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *fileSuffix;  //文件后缀

-(NSDictionary *)jsonDic;

@end



#pragma mark - public

NSDictionary *converObjToDictionary(id obj);
