//
//  ICWebViewController.m
//  YinKa
//
//  Created by IntelcentMacMini on 16/9/20.
//  Copyright © 2016年 GeryHui. All rights reserved.
//

#import "ICWebViewController.h"

#import <WebKit/WebKit.h>

#define IOS8_OR_LATER __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0

@interface ICWebViewController ()<UIWebViewDelegate,WKNavigationDelegate,UIActionSheetDelegate>{
    BOOL nativeActivityShow;  //显示自带指示器
    UILabel *errorTips;
}

@property (nonatomic, retain) WKWebView *wkWebView;

@property (nonatomic, retain) UIActivityIndicatorView *indicatorView;   //指示器

@property (nonatomic, retain) UIProgressView *wkProgress;  //WKWeb 进度条



@end

@implementation ICWebViewController

-(id)init{
    if (self = [super init]) {
        self.haveMoreActionBtn = YES;
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self.haveMoreActionBtn = YES;
    }
    return self;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.haveMoreActionBtn = YES;
    }
    return self;
}

-(void)setupErrorTipsLabe{
    if (!errorTips) {
        errorTips = [[UILabel alloc] init];
        errorTips.font = [UIFont systemFontOfSize:15.0];
        errorTips.textColor = [UIColor darkGrayColor];
        errorTips.numberOfLines = 0;
        [self.view addSubview:errorTips];
        
        [errorTips mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(15);
            make.left.offset(15);
            make.width.mas_lessThanOrEqualTo(Main_Screen_Width-15*2);
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.WebTitle.length >0) {
        self.navigationItem.title = _WebTitle;
    }
    
    NSURL *URL = [NSURL URLWithString:_Url!=nil?_Url:@""];
    NSURLRequest *requset = [NSURLRequest requestWithURL:URL];
    
    CGRect webFrame = CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-64);
//    CGRect webFrame = self.view.bounds;
    if (IOS8_OR_LATER) {
        [self.wkWebView setFrame:webFrame];
        [self.view addSubview:self.wkWebView];
        
        [self.wkWebView loadRequest:requset];
        
        [self.wkWebView addSubview:self.wkProgress];
        [self.wkWebView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:(NSKeyValueObservingOptionNew) context:nil];
        
    }else{
        [self.contentWebView setFrame:webFrame];
        [self.view addSubview:self.contentWebView];
        
        [self.contentWebView loadRequest:requset];
    }
    
    nativeActivityShow = YES;
    if (nativeActivityShow) {
        [self.view addSubview:self.indicatorView];
    }
        // URL错误
    if (!URL) {
        [self setupErrorTipsLabe];
        [errorTips setText:_Url];
    }
    
        //更多按钮
    if (_haveMoreActionBtn) {
        WkSelf(weakSelf);
        [self configureRightBarButtonWithTitle:@"更多" image:nil action:^{
            [weakSelf ClickToMoreAction:nil];
        }];
    }
}

-(void)popViewControllerAnimated:(BOOL)animated{
    if (_popRootVc) {
        [self.navigationController popToRootViewControllerAnimated:animated];
    }else{
        [self.navigationController popViewControllerAnimated:animated];
    }
}

-(UIActivityIndicatorView *)indicatorView{
    if (_indicatorView == nil) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((Main_Screen_Width-30)/2,(Main_Screen_Height-64-30)/2, 30, 30)];
        _indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        _indicatorView.tintColor = [UIColor whiteColor];
    }
    return _indicatorView;
}

    // IOS8.0 以下
-(UIWebView *)contentWebView{
    if (_contentWebView == nil) {
        _contentWebView = [[UIWebView alloc] init];
        _contentWebView.delegate = self;
        _contentWebView.scalesPageToFit = YES;
        _contentWebView.backgroundColor = [UIColor whiteColor];
    }
    return _contentWebView;
}

-(WKWebView *)wkWebView{
    if (_wkWebView == nil) {
        _wkWebView = [[WKWebView alloc] init];
        _wkWebView.navigationDelegate = self;
    }
    return _wkWebView;
}

-(UIProgressView *)wkProgress{
    if (_wkProgress == nil) {
        _wkProgress = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, self.wkWebView.width, 5)];
//        _wkProgress.progressTintColor = [UIColor greenColor];
        _wkProgress.progressImage = IMAGECache(@"progress_line_green.png");
        _wkProgress.trackTintColor = [UIColor whiteColor];
//        _wkProgress.trackImage = IMAGECache(@"progress_line_white.png");
        _wkProgress.alpha = 0.0;
    }
    return _wkProgress;
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    if (IOS8_OR_LATER) {
        
    }else{
        [self.contentWebView stopLoading];
        [self.contentWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:break"]]];
    }
    
    [ToolMethods clearWebCacheAndCookies];
    
}
-(void)loadUrl:(NSString *)url{
    if (url) {
        self.Url = url;
    }
}

-(void)setHaveMoreActionBtn:(BOOL)haveMoreActionBtn{
    _haveMoreActionBtn = haveMoreActionBtn;
    if (!haveMoreActionBtn) {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

#pragma mark ---webView Delegate

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    if (nativeActivityShow) {
        [self.indicatorView startAnimating];
    }else{
        [MBProgressHUD showMessage:nil toView:self.view];
    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.indicatorView stopAnimating];
    
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (title.length >0 && self.WebTitle.length == 0) {
        self.navigationItem.title = title;
    }
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
     NSString *errorStr = [error description];
     NSLog(@"webSite Error : %@",errorStr);
    
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [MBProgressHUD showError:@"加载失败" toView:self.view];
    [self.indicatorView stopAnimating];
}

#pragma mark WKWebView Observer
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.wkWebView) {
        [self.wkProgress setAlpha:1.0];
        BOOL animated = self.wkWebView.estimatedProgress >self.wkProgress.progress;
        [self.wkProgress setProgress:_wkWebView.estimatedProgress animated:animated];
        if (self.wkWebView.estimatedProgress >0.97) {
            [UIView animateWithDuration:0.1 animations:^{
                self.wkProgress.alpha = 0.0;
            } completion:^(BOOL finished) {
                [self.wkProgress setProgress:0.0 animated:NO];
            }];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

-(void)dealloc{
    [self.wkWebView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
}

#pragma mark ---WKNavigationDelegate
    //开始请求
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    if (nativeActivityShow) {
        [self.indicatorView startAnimating];
    }else{
        [MBProgressHUD showMessage:nil toView:self.view];
    }
}
    //内容开始返回时 调用
-(void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    NSLog(@"%@",webView.URL.host);
}

    //请求结束
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.indicatorView stopAnimating];
    
    __weak ICWebViewController *weakSelf = self;
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable resultObj, NSError * _Nullable error) {
        if ([resultObj isKindOfClass:[NSString class]] && weakSelf.WebTitle.length == 0) {
            weakSelf.navigationItem.title = [NSString stringWithFormat:@"%@",resultObj];
        }
    }];
}

-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"fail navigation Error:%@",error.description);
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [self.indicatorView stopAnimating];
}

-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"FailProvisional navigation Error : %@",error.description);
    
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [MBProgressHUD showError:@"加载失败" toView:self.view];
    [self.indicatorView stopAnimating];
}


#pragma mark 更多
-(void)ClickToMoreAction:(id)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"浏览器打开",@"刷新",@"回到首页", nil];
    [actionSheet showInView:self.view];
    
}


#pragma mark UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.numberOfButtons -1 == buttonIndex) {
        return;
    }
    //webView更多功能
    switch (buttonIndex) {
        case 0:
            //浏览器打开
        {
            NSURL *openUrl = [NSURL URLWithString:_Url.length >0 ?_Url:@""];
            UIApplication *curApp = [UIApplication sharedApplication];
            if ([curApp canOpenURL:openUrl]) {
                [curApp openURL:openUrl];
            }else{
                NSLog(@"open url error: %@",openUrl.absoluteString);
            }
        }
            break;
        case 1:
            //刷新
        {
            if (IOS8_OR_LATER) {
                [_wkWebView reload];
            }else{
                [_contentWebView reload];
            }
        }
            break;
        case 2:
            //回到首页
        {
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_Url]];
            if (IOS8_OR_LATER) {
                [_wkWebView loadRequest:request];
            }else{
                [_contentWebView loadRequest:request];
            }
        }
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
