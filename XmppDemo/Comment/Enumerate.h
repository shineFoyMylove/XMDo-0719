//
//  Enumerate.h
//  XmppProject
//
//  Created by IntelcentMac on 17/7/18.
//  Copyright © 2017年 wh_shine. All rights reserved.
//

#ifndef Enumerate_h
#define Enumerate_h
#import <Foundation/Foundation.h>

/**
 *  会话提示类型
 */
typedef NS_ENUM(NSInteger, TLClueType) {
    TLClueTypeNone,
    TLClueTypePoint,
    TLClueTypePointWithNumber,
};

/**
 *  会话类型
 */
typedef NS_ENUM(NSInteger, TLConversationType) {
    TLConversationTypePersonal,     // 个人
    TLConversationTypeGroup,        // 群聊
    TLConversationTypePublic,       // 公众号
    TLConversationTypeServerGroup,  // 服务组（订阅号、企业号）
};

typedef NS_ENUM(NSInteger, TLMessageRemindType) {
    TLMessageRemindTypeNormal,    // 正常接受
    TLMessageRemindTypeClosed,    // 不提示
    TLMessageRemindTypeNotLook,   // 不看
    TLMessageRemindTypeUnlike,    // 不喜欢
};

/**
 *  消息类型
 */
typedef NS_ENUM(NSInteger, TLMessageType) {
    TLMessageTypeUnknown,
    TLMessageTypeText,          // 文字
    TLMessageTypeImage,         // 图片
    TLMessageTypeExpression,    // 表情
    TLMessageTypeVoice,         // 语音
    TLMessageTypeVideo,         // 视频
    TLMessageTypeURL,           // 链接
    TLMessageTypePosition,      // 位置
    TLMessageTypeBusinessCard,  // 名片
    TLMessageTypeSystem,        // 系统
    TLMessageTypeOther,
};

typedef NS_ENUM(NSUInteger, TLMoreKeyboardItemType) {
    TLMoreKeyboardItemTypeImage,
    TLMoreKeyboardItemTypeCamera,
    TLMoreKeyboardItemTypeVideo,
    TLMoreKeyboardItemTypeVideoCall,
    TLMoreKeyboardItemTypeWallet,
    TLMoreKeyboardItemTypeTransfer,
    TLMoreKeyboardItemTypePosition,
    TLMoreKeyboardItemTypeFavorite,
    TLMoreKeyboardItemTypeBusinessCard,
    TLMoreKeyboardItemTypeVoice,
    TLMoreKeyboardItemTypeCards,
};

typedef NS_ENUM(NSUInteger, TLScannerType) {
    TLScannerTypeQR = 1,        // 扫一扫 - 二维码
    TLScannerTypeCover,         // 扫一扫 - 封面
    TLScannerTypeStreet,        // 扫一扫 - 街景
    TLScannerTypeTranslate,     // 扫一扫 - 翻译
};

typedef NS_ENUM(NSInteger, TLAddMneuType) {
    TLAddMneuTypeGroupChat = 0,
    TLAddMneuTypeAddFriend,
    TLAddMneuTypeScan,
    TLAddMneuTypeWallet,
};


typedef NS_ENUM(NSInteger, TLNewFriendApplyState) {
    TLNewFriendApplyStateAgreed,     //已添加
    TLNewFriendApplyStateWaiting,  //等待验证
    TLNewFriendApplyStateNew      //(待)同意
};

#endif /* Enumerate_h */
