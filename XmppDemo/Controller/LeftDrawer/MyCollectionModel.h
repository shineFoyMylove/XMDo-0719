//
//  MyCollectionModel.h
//  WHIMDemo1
//
//  Created by IntelcentMac on 17/5/22.
//  Copyright © 2017年 wh_shine. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger , sh_messageType) {
    sh_messageTypeTxt,      /**< 文字类型 */
    sh_messageTypeVoice,    /**< 音频类型 */
    sh_messageTypeLocation,  /**<位置类型 */
    sh_messageTypeVedio,    /**<视频类型 */
    sh_messageTypeShareLink, /**<分享链接类型 */
    sh_messageTypePicture   /**<图片类型 */
    
};

@interface MyCollectionModel : NSObject

//基本属性
@property (nonatomic, retain) NSString  *userHeader;   /**<用户头像 */
@property (nonatomic, retain) NSString  *username;     /**<用户昵称、备注名 */
@property (nonatomic, retain) NSString  *timeString;         /**<收藏日期 */
@property (nonatomic, assign) sh_messageType contentType;   /**<数据类型 */

//媒体 (音频、位置)
@property (nonatomic, retain) NSString  *media_logo;          /**<媒体 logo */
@property (nonatomic, retain) NSString  *media_name;          /**<媒体类型名 */
@property (nonatomic, retain) NSString  *media_detail;        /**<媒体详情描述 */

//文字
@property (nonatomic, retain) NSString  *text_content;
//链接
@property (nonatomic, retain) NSString  *link_image;       /**<链接 - 图标 */
@property (nonatomic, retain) NSString  *link_title;       /**<链接 - 标题 */
//图片
@property (nonatomic, retain) NSString  *pic_image;         /**< 图片类型 */
//视频
@property (nonatomic, retain) NSString  *video_screenImage;  /**<视频截图 */
@property (nonatomic, retain) NSString  *video_playIcon;     /**<播放小图标 */


@end
