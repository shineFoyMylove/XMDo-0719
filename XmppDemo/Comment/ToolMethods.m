//
//  ToolMethods.m
//  CallLiaoBei
//
//  Created by IntelcentMacMini on 16/10/31.
//  Copyright © 2016年 GeryHui. All rights reserved.
//

#import "ToolMethods.h"
#import "MJRefresh.h"

static ToolMethods *shareInstance;

@interface ToolMethods (){
    UIWebView *callWebView;   //webView拨号
}

@end

@implementation ToolMethods

+(ToolMethods *)instance{
    if (shareInstance == nil) {
        shareInstance = [[ToolMethods alloc] init];
    }
    return shareInstance;
}

#pragma mark 常用的对象、属性

+(NSString *)AppVersion{
    NSString *tmpVer = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    return tmpVer;
}
+(NSString *)AppShortVersion{
    NSString *tmpVer = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return tmpVer;
}

+(BOOL)AppVersionIsChange{
    NSString *shortVer = [self AppVersion];
    NSString *oldVer = UDGetStringWithDefault(@"shortVer", @"1.0");
    if ([shortVer isEqualToString:oldVer] == YES) {
        return NO;
    }
    
    UDSetObject(@"shortVer", shortVer);
    return YES;
}


#pragma mark 线程
//将某个UI更新操作放入主线程执行
+(void)asynMainThreadWithAction:(void(^)())actionBlock{
    if ([NSThread currentThread].isMainThread) {
        if (actionBlock) {
            actionBlock();
        }
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (actionBlock) {
                actionBlock();
            }
        });
    }
}


#pragma mark MJRefresh 添加上拉下拉刷新
-(void)MJ_addRefresh:(UIScrollView *)targetView headerBlock:(void(^)())headerBlock footBlock:(void(^)())footBlock{
    if ([targetView isKindOfClass:[UIScrollView class]]) {
        
        if (headerBlock) {
            //添加下拉刷新
            targetView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                //回调
                headerBlock();
                
                BOOL isMain = [NSThread currentThread].isMainThread;
                NSLog(@"%@",isMain?@"MJRefresh回调在主线程":@"MJ回调在支线程");
                double timeOutSeconds = 10.0;  //超时时间
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeOutSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [targetView.mj_header endRefreshing];
                });
                
            }];
        }
        
        if (footBlock) {
            //添加上拉加载更多
            targetView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
               //回调
                footBlock();
                
                double timeOutSeconds = 10.0;  //超时时间
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeOutSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [targetView.mj_footer endRefreshingWithNoMoreData];
                });
            }];
        }
    }
}


#pragma mark  设置控件圆角、添加平均分割线
//设 圆
+(void)layerViewRound:(id)view withBorderColor:(UIColor *)color{
    if ([view isKindOfClass:[UIView class]]) {
        UIView *tempView = (UIView *)view;
        CGFloat radiu = tempView.frame.size.width/2;
        [ToolMethods layerViewCorner:tempView withRadiu:radiu color:color];
    }
}

//设置圆角
+(void)layerViewCorner:(id)view withRadiu:(CGFloat)radiu color:(UIColor *)color{
    if ([view isKindOfClass:[UIView class]]) {
        UIView *tempView = (UIView *)view;
        tempView.layer.masksToBounds = YES;
        tempView.layer.cornerRadius = radiu;
        
        if (color) {
            tempView.layer.borderColor = color.CGColor;
            tempView.layer.borderWidth = 0.5;
        }
    }
}

/**
 @添加 竖直分割线
 @lineNumber 线条数量
 */
+(void)addSeparateLine:(UIView *)targetView withVerticalLine:(NSInteger)lineNumber Color:(UIColor *)lineColor{
    if (targetView && [targetView isKindOfClass:[UIView class]]) {
        CGFloat viewWidth = targetView.frame.size.width;
        CGFloat viewHeight = targetView.frame.size.height;
        UIColor *tempColor = DFSeparateLineColor;
        if (lineColor != nil)   tempColor = lineColor;
        
        CGFloat itemWidth = viewWidth/(lineNumber+1);
        for (int i = 0; i< lineNumber; i++) {
            UIView *tempLine = [[UIView alloc] initWithFrame:CGRectMake(itemWidth*(i+1), 5, 1, viewHeight-10)];
            tempLine.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            tempLine.backgroundColor = tempColor;
            [targetView addSubview:tempLine];
        }
    }
}

/**
 @添加 水平分割线
 @lineNumber 线条数量
 */
+(void)addSeparateLine:(UIView *)targetView withHorizontalLine:(NSInteger)lineNumber Color:(UIColor *)lineColor{
    if (targetView && [targetView isKindOfClass:[UIView class]]) {
        CGFloat viewWidth = targetView.frame.size.width;
        CGFloat viewHeight = targetView.frame.size.height;
        UIColor *tempColor = DFSeparateLineColor;
        if (lineColor != nil)   tempColor = lineColor;
        
        CGFloat itemHeight = viewHeight/(lineNumber+1);
        for (int i = 0; i< lineNumber; i++) {
            UIView *tempLine = [[UIView alloc] initWithFrame:CGRectMake(10, itemHeight*(i+1), viewWidth-20, 1)];
            tempLine.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            tempLine.backgroundColor = tempColor;
            [targetView addSubview:tempLine];
        }
        
    }
}


#pragma mark  HTTPURLCache清理缓存
+(void)clearWebCacheAndCookies{
    //Cookies
    NSHTTPCookie *cookie = nil;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    //Cache
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

+(void)clearWebCache{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

+(void)clearWebHttpCookies{
    NSHTTPCookie *cookie = nil;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
}

#pragma mark 密码移位加密
+(NSString *)pwdEncrypt:(NSString *)pwd{
    int i, dataLen;
    unsigned char value;
    const char *data = [pwd cStringUsingEncoding:NSASCIIStringEncoding];
    char out[1024] = {0};
    
    dataLen = (int)strlen(data);
    if(dataLen > 32)
        dataLen = 32;
    
    for(i=0; i < dataLen; i++)
    {
        value = data[i];
        if((value > 0x60) && (value < 0x7B))
        {
            value = value - 0x20;
            value = 0x5A - value + 0x41;
        }
        else if((value > 0x40) && (value < 0x5B))
        {
            value = value + 0x20;
            value = 0x7A - value + 0x61;
        }
        else if((value >= 0x30) && (value <= 0x34))
        {
            value = value + 0x05;
        }
        else if((value >= 0x35) && (value <= 0x39))
        {
            value = value - 0x05;
        }
        out[i] = value;
    }
    
    out[i] = '\0';
    NSString *outData =[[NSString alloc]initWithCString:(const char*) out encoding:NSASCIIStringEncoding];
    
    return outData;
}

+(void)showSysAlert:(NSString *)text{
    UIAlertView *tmpAlert = [[UIAlertView alloc] initWithTitle:text message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [tmpAlert show];
}

/**<计算某个方法耗时 */
+(void)calculateUsedTime:(void(^)())action{
    
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    if (action) {
        action();
    }
    CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();
    
    NSLog(@"方法耗时: %f",end-start);
    
    
}

#pragma mark 获取随机字符串
+(NSString *)randomStringLength:(int)length{
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSString *resultStr = [self randomStringLength:length source:sourceStr];
    return resultStr;
    
}

+(NSString *)randomStringLength:(int)length source:(NSString *)sourceStr{
    int kNumber = length;
    
    NSString *source = sourceStr;
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [source length];
        NSString *oneStr = [source substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    
    return resultStr;
}

#pragma mark 获取文件目录
+ (NSString*)documentFile:(NSString*)file {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    return [documentsPath stringByAppendingPathComponent:file];
}



#pragma mark Call With WebView系统拨号
-(UIWebView *)callWebView{
    if (callWebView == nil) {
        callWebView = [[UIWebView alloc] init];
    }
    return callWebView;
}

-(void)callWithWebView:(NSString *)number{
    NSString *callurl = [NSString stringWithFormat:@"tel://%@",number];
    NSURL *callURL = [NSURL URLWithString:callurl];
    NSURLRequest *tmpRequet = [NSURLRequest requestWithURL:callURL];
    [[self callWebView] loadRequest:tmpRequet];
}


#pragma mark URL编码
+(NSString *)URLEncodeString:(NSString *)URLString{
    NSString *outputStr = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)URLString,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    return outputStr;
}
//URL解码
+(NSString *)URLDecodeString:(NSString *)URLString{
    NSMutableString *outputStr = [NSMutableString stringWithString:URLString];
    [outputStr replaceOccurrencesOfString:@"+"
                               withString:@" "
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0, [outputStr length])];
    
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark ********  静态获取控件对象   ********

+(UIButton *)createButton:(NSString *)title image:(UIImage *)image{
    UIButton *barBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (title) {
        
        [barBtn setTitle:title forState:UIControlStateNormal];
        [barBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //文字大小
        UIFont *font = [UIFont systemFontOfSize:15.0];
        [barBtn.titleLabel setFont:font];
        //标题文字长度适应
        CGFloat btnHeight = 40;
        CGSize size = CGSizeMake(150, btnHeight);
        size = [title boundingRectWithSize:CGSizeMake(Main_Screen_Width, btnHeight)
                                   options:(NSStringDrawingUsesFontLeading)
                                attributes:@{NSFontAttributeName:font}
                                   context:NULL].size;
        barBtn.frame = CGRectMake(0, 0, size.width+8, btnHeight);
        //image
        if (image) {
            CGSize imgSize = CGSizeMake(20, 20);
            barBtn.frame = CGRectMake(0, 0, size.width+imgSize.width+8, size.height);
            barBtn.imageView.width = imgSize.width;
            barBtn.imageView.height = imgSize.height;
            [barBtn setImage:image forState:(UIControlStateNormal)];
            
            barBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -(size.width+6), 0, 0);
            barBtn.imageEdgeInsets = UIEdgeInsetsMake((btnHeight-imgSize.height)/2, 0, (btnHeight-imgSize.height)/2, barBtn.width-imgSize.width);
        }
    }else if (image){
        [barBtn setFrame:CGRectMake(0, 0, 64, 44)];
        [barBtn setImage:image forState:(UIControlStateNormal)];
        barBtn.imageEdgeInsets = UIEdgeInsetsMake(12, 0, 12, 44);
    }
    
    return barBtn;
}

@end



#pragma mark StaticMathods

/**
 * 发送广播 */
void NotificationPost(NSString *name, id obj ){
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:obj];
}

/**
 * 移除广播监听 */
void NotificationRemoveWithName(id observer , NSString *name, id obj){
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:name object:obj];
}

/**
 * 移除所有广播监听
 */
void NotificationRemove(id observe){
    [[NSNotificationCenter defaultCenter] removeObserver:observe];
}

#pragma mark ViewController

/**
 * 根据 Name 获取ViewController
 */
UIViewController *GetViewController(NSString *VcName){
    if (VcName.length >0) {
        Class cls = NSClassFromString(VcName);
        id tmpVc = [[cls alloc] init];
        if ([tmpVc isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)tmpVc;
        }
    }
    return nil;
}

/**
 * 根据 Window当前ViewController
 */
UIViewController *GetWindowVisibleViewController(){
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    if (!window) {
        return nil;
    }
    UIView *tempView;
    for (UIView *subview in window.subviews) {
        if ([[subview.classForCoder description] isEqualToString:@"UILayoutContainerView"]) {
            tempView = subview;
            break;
        }
    }
    if (!tempView) {
        tempView = [window.subviews lastObject];
    }
    
    id nextResponder = [tempView nextResponder];
    while (![nextResponder isKindOfClass:[UIViewController class]] || [nextResponder isKindOfClass:[UINavigationController class]] || [nextResponder isKindOfClass:[UITabBarController class]]) {
        tempView =  [tempView.subviews firstObject];
        
        if (!tempView) {
            return nil;
        }
        nextResponder = [tempView nextResponder];
    }
    return  (UIViewController *)nextResponder;
}

/**
 * 根据 View 获取所在ViewController
 */
UIViewController *GetViewControllerOfView(UIView *view){
    NSInteger num = 0;
    for (UIView *next = [view superview]; next; next = next.superview) {
        num++;
        if (num >5) {
            break;
        }
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}


#pragma mark UIAlert提示
// alert 提示自动消失
void AlertTipWithMessage(NSString *text){
    dispatch_async(dispatch_get_main_queue(), ^{
       
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:text message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alertView show];
        
        [alertView performSelector:@selector(dismissWithClickedButtonIndex:animated:) withObject:@[@0,@1] afterDelay:0.9];
    });
}


#pragma mark - NSString
NSString *NotNullString(NSString *str){
    if (str == nil || (NSNull *)str == [NSNull null]) {
        return @"";
    }
    return [NSString stringWithFormat:@"%@",str];
}


