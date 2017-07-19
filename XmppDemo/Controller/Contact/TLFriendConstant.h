//
//  TLFriendConstant.h
//  XmppProject
//
//  Created by IntelcentMac on 17/7/5.
//  Copyright © 2017年 wh_shine. All rights reserved.
//

#ifndef TLFriendConstant_h
#define TLFriendConstant_h

#import "UIColor+TLChat.h"
#import "BlocksKit+UIKit.h"
#import "UIFont+TLChat.h"
#import "MJExtension.h"
#import "NSFileManager+TLChat.h"
#import "NSFileManager+Paths.h"
#import "UINavigationController+StackManager.h"

#define     DEFAULT_AVATAR_PATH    @"default_head"

#define     BORDER_WIDTH_1PX            ([[UIScreen mainScreen] scale] > 0.0 ? 1.0 / [[UIScreen mainScreen] scale] : 1.0)
#define     LEFT_INFOCELL_SUBTITLE_SPACE     (WIDTH_SCREEN * 0.28)


#pragma mark - # Methods
#define     TLURL(urlString)    [NSURL URLWithString:urlString]
#define     TLNoNilString(str)  (str.length > 0 ? str : @"")
#define     TLWeakSelf(type)    __weak typeof(type) weak##type = type;
#define     TLStrongSelf(type)  __strong typeof(type) strong##type = type;
#define     TLTimeStamp(date)   ([NSString stringWithFormat:@"%lf", [date timeIntervalSince1970]])

#pragma mark - # SIZE
#define     SIZE_SCREEN                 [UIScreen mainScreen].bounds.size
#define     WIDTH_SCREEN                [UIScreen mainScreen].bounds.size.width
#define     HEIGHT_SCREEN               [UIScreen mainScreen].bounds.size.height

#define     HEIGHT_STATUSBAR            20.0f
#define     HEIGHT_TABBAR               49.0f
#define     HEIGHT_NAVBAR               44.0f
#define     NAVBAR_ITEM_FIXED_SPACE     5.0f

#endif /* TLFriendConstant_h */

