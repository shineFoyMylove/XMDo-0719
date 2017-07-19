//
//  ToolMethods.h
//  CallLiaoBei
//
//  Created by IntelcentMacMini on 16/10/31.
//  Copyright © 2016年 GeryHui. All rights reserved.
//

#import <Foundation/Foundation.h>


#define DFSeparateLineColor   [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0]
#define LightFontItem(FONTSIZE) [UIFont fontWithName:@"HelveticaNeue-Light" size:(FONTSIZE)]


@interface ToolMethods : NSObject

+(ToolMethods *)instance;

#pragma mark 常用的对象、属性
+(NSString *)AppVersion;   /**< version #CFBundleVersion */

+(NSString *)AppShortVersion;   /**< Short Version #CFBundleShortVersionString */

+(BOOL)AppVersionIsChange;      /**< 有作版本改动 */

+(NSString *)pwdEncrypt:(NSString *)pwd;   /**<密码移位加密 */

+(void)showSysAlert:(NSString *)text;   /**< AlertView 提示框 */

#pragma mark 线程
/**
 将某个UI更新操作放入主线程执行 */
+(void)asynMainThreadWithAction:(void(^)())actionBlock;

#pragma mark MJRefresh 添加上拉下拉刷新
/**
 MJRefresh 添加上拉下载刷新 */
-(void)MJ_addRefresh:(UIScrollView *)targetView headerBlock:(void(^)())headerBlock footBlock:(void(^)())footBlock;

#pragma mark  设置控件圆角、添加平均分割线
+(void)layerViewRound:(id)view withBorderColor:(UIColor *)color; /**<切圆 */
+(void)layerViewCorner:(id)view withRadiu:(CGFloat)radiu color:(UIColor *)color; /**<设置圆角 */
/**
 @添加 竖直分割线
 @lineNumber 线条数量
 */
+(void)addSeparateLine:(UIView *)targetView withVerticalLine:(NSInteger)lineNumber Color:(UIColor *)lineColor;

/**
 @添加 水平分割线
 @lineNumber 线条数量
 */
+(void)addSeparateLine:(UIView *)targetView withHorizontalLine:(NSInteger)lineNumber Color:(UIColor *)lineColor;


#pragma mark  HTTPURLCache清理缓存
+(void)clearWebCacheAndCookies;
+(void)clearWebCache;
+(void)clearWebHttpCookies;


#pragma mark 获取随机字符串
+(NSString *)randomStringLength:(int)length;  /**<获取随机字符串 length-字符长度*/
/**
 *获取随机字符串 length-字符长度
 *source - 字符源 */
+(NSString *)randomStringLength:(int)length source:(NSString *)sourceStr;

#pragma mark 获取文件目录
+ (NSString*)documentFile:(NSString*)file;   /**<获取文件路径*/

#pragma mark Call With WebView 
-(void)callWithWebView:(NSString *)number;


#pragma mark URL编码
+(NSString *)URLEncodeString:(NSString *)URLString;    /**< URL 编码 */

+(NSString *)URLDecodeString:(NSString *)URLString;    /**<URL解码 */


#pragma mark ********  静态获取控件对象   ********
+(UIButton *)createButton:(NSString *)title image:(UIImage *)image;  /**< 获取按钮对象 */


@end


#pragma mark - StaticMathods

/**
 * 发送广播 */
void NotificationPost(NSString *name, id obj);

/**
 * 移除广播监听 */
void NotificationRemoveWithName(id observer , NSString *name, id obj);

/**
 * 移除所有广播监听
 */
void NotificationRemove(id observe);



#pragma mark - ViewController
/**
 * 根据 Name 获取ViewController
 */
UIViewController *GetViewController(NSString *VcName);

/**
 * 根据 View 获取所在ViewController
 */
UIViewController *GetWindowVisibleViewController();

/**
 * 根据 Window当前ViewController
 */
UIViewController *GetViewControllerOfView(UIView *view);


#pragma mark UIAlert提示
// alert 提示自动消失
void AlertTipWithMessage(NSString *text);


#pragma mark - NSString
NSString *NotNullString(NSString *str);

