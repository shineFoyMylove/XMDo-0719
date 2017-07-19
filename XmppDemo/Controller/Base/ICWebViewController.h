//
//  ICWebViewController.h
//  YinKa
//
//  Created by IntelcentMacMini on 16/9/20.
//  Copyright © 2016年 GeryHui. All rights reserved.
//

#import "BaseViewController.h"

@interface ICWebViewController : BaseViewController


@property (nonatomic, retain) NSString *Url;
@property (nonatomic, retain) NSString *WebTitle;

@property (nonatomic, retain) UIWebView *contentWebView;

@property (nonatomic) BOOL haveMoreActionBtn;  //有更多操作 Default=YES
@property (nonatomic) BOOL popRootVc;  //

-(void)loadUrl:(NSString *)url;

@end
