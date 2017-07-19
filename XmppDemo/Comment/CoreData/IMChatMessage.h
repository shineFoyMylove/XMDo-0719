//
//  IMChatMessage.h
//  XmppProject
//
//  Created by IntelcentMac on 17/7/11.
//  Copyright © 2017年 wh_shine. All rights reserved.
//  聊天记录消息

#import <XMNChat/XMNChat.h>
#import "MessageModel.h"

@interface IMChatMessage : XMNChatBaseMessage

    //from
@property (nonatomic, retain) NSString *from_headerImage;
@property (nonatomic, retain) NSString *from_uid;
@property (nonatomic, retain) NSString *from_phone; //号码
@property (nonatomic, retain) NSString *from_name; //nikeName

    //To
@property (nonatomic, retain) NSString *to_headerImage;
@property (nonatomic, retain) NSString *to_uid;
@property (nonatomic, retain) NSString *to_phone;
@property (nonatomic, retain) NSString *to_name;

@property (nonatomic, assign) IMMessgeType msgType;
    //text
@property (nonatomic, retain) NSString *textContent;
    //image
@property (nonatomic, retain) NSString *img_url;
@property (nonatomic, assign) CGFloat img_width;
@property (nonatomic, assign) CGFloat img_height;
    //voice
@property (nonatomic, strong) NSString *voice_url;
@property (nonatomic, assign) NSInteger voice_length;
    //Video
@property (nonatomic, strong) NSString *video_url;
@property (nonatomic, assign) NSInteger video_length;
    //File
@property (nonatomic, strong) NSString *file_url;
@property (nonatomic, strong) NSString *file_name;
@property (nonatomic, strong) NSString *file_suffix;  /**< 文件后缀 */
@property (nonatomic, assign) double file_size; /**< 文件大小 kb */
    //Location
@property (nonatomic, assign) CGFloat loc_lng;  /**< 经度 */
@property (nonatomic, assign) CGFloat loc_lat;  /**<纬度 */
@property (nonatomic, assign) double timeInterval;  /**<时间戳 */


-(void)insertCoreData;  //保存到 XMPPMessageArchiving_Message_CoreDataObject CoreData


@end
