//
//  Config.h
//  WHIMDemo1
//
//  Created by Gery晖 on 17/4/10.
//  Copyright © 2017年 wh_shine. All rights reserved.
//

#ifndef Config_h
#define Config_h

#ifdef __OBJC__
#import <Foundation/Foundation.h>

#endif

#import <SDAutoLayout.h>
#import <Masonry.h>
#import <ReactiveCocoa.h>

#import "UIImage+FlatUI.h"
#import "NSDate+TimeAgo.h"
#import "NSDate+Extension.h"

#import "NSDictionaryAdditions.h"
#import "NSString+StringType.h"
#import "UIViewAdditions.h"
#import "UIView+ZJQuickControl.h"
#import "NSStringAdditions.h"
#import "MBProgressHUD+MJ.h"
#import "UIViewController+HUD.h"
#import "MJExtension.h"

#import "ToolMethods.h"
#import "UDUserDefault.h"
#import "HttpRequest.h"
#import "ConstantConfig.h"
#import "Enumerate.h"   
#import "XMPPTool.h"

#import "TLFriendConstant.h"

#define RGBColor(r, g, b)   [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define UIColorFromRGB(rgbValue)    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define IMAGECache(name)    [UIImage imageNamed:name]
#define IMAGEBundle(name)   [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:@"png"]]

#define App_displayName [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]


/*****  App 接口 域名 ip */
#define domain_url  @"http://172.247.143.208:8080"
#define domain_ip       @"172.247.143.208"

//#define AppMainColor    RGBColor(232, 125, 26)       //橙
#define AppMainColor    RGBColor(50,45,52)
#define AppMainBgColor  RGBColor(248, 248, 248)

/** 屏幕 Size */
#define Main_Screen_Bounds  [UIScreen mainScreen].bounds
#define Main_Screen_Width   [UIScreen mainScreen].bounds.size.width
#define Main_Screen_Height  [UIScreen mainScreen].bounds.size.height

/*****  release   *****/
#define Release(__object) if(__object){__object=nil;}
/** weak Self */
#define WkSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self;
/** NSLog()  TSYLog() */
#define TSYLog(tips,desc) NSLog(@"%s ####\n%@: %@",__func__,tips,desc);


/** xcode 代码 版本适配 */
#define XCODE_ALLOWED_IOS7_OR_LATER __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
#define XCODE_ALLOWED_IOS8_OR_LATER __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
#define XCODE_ALLOWED_IOS9_OR_LATER __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
#define XCODE_ALLOWED_IOS10_OR_LATER __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0

/** 当前系统版本 判断 */
#define DEVICE_SYSTEM_IOS7_OR_LATER [UIDevice currentDevice].systemVersion.floatValue >= 7.0
#define DEVICE_SYSTEM_IOS8_OR_LATER [UIDevice currentDevice].systemVersion.floatValue >= 8.0
#define DEVICE_SYSTEM_IOS9_OR_LATER [UIDevice currentDevice].systemVersion.floatValue >= 9.0
#define DEVICE_SYSTEM_IOS10_OR_LATER [UIDevice currentDevice].systemVersion.floatValue >= 10.0

#define GCDQueueDEFAULT dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define GCDQueueHIGH dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
#define GCDQueueLOW dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)
#define GCDQueueBACKGROUND dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)
#define GCDQueueMain dispatch_get_main_queue()


#endif /* Config_h */
