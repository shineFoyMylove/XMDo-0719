//
//  BaseViewController.m
//  WHIMDemo1
//
//  Created by IntelcentMac on 17/3/24.
//  Copyright © 2017年 wh_shine. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseNaviViewController.h"
#import "MainTabBarController.h"
#import "LeftViewController.h"
#import "ReturnCallViewController.h"

#import "CallLogObject.h"


@interface BaseViewController ()


@property (nonatomic, copy) RightBarButtonActionBlock rightBarButtonAction;
@property (nonatomic, copy) LeftBarButtonActionBlock leftBarButtonAction;

@end


@implementation BaseViewController

-(AppDelegate *)ShareApp{
    return [AppDelegate instance];
}
-(AppUserInfo *)userInfo{
    return self.appManager.userInfo;
}

-(UIViewController *)CUS_GET_TABBARVC{
    UINavigationController *centerNav = (UINavigationController *)self.ShareApp.DrawerController.centerViewController;
    if ([centerNav isKindOfClass:[UINavigationController class]]) {
        UIViewController *centerVc = centerNav.visibleViewController;
        if ([centerVc isKindOfClass:[MainTabBarController class]]) {
            return (MainTabBarController *)centerVc;
        }
    }
    return nil;
}

-(UINavigationController *)centerNavController{
    UINavigationController *centerNav = (UINavigationController *)self.ShareApp.DrawerController.centerViewController;
    if ([centerNav isKindOfClass:[UINavigationController class]]) {
        return centerNav;
    }
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.appManager = [AppDelegate instance].appManager;
    self.addressBook = self.appManager.addressBook;
    
//    __weak BaseViewController *weakSelf = self;
    if (self.navigationController.viewControllers.count >1 &&
        self.navigationController.navigationBar.hidden == NO) {
        
        [self configureLeftBarButtonWithTitle:nil image:IMAGECache(@"return_back_icon") sel:@selector(popViewControllerAnimated:)];
        
//        [self configureLeftBarButtonWithTitle:nil image:IMAGECache(@"return_back_icon") action:^{
//            [weakSelf.navigationController popViewControllerAnimated:YES];
//        }];
    }
}

    // 普通pop，popRootViewController
-(void)popViewControllerAnimated:(BOOL)animated{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)popViewControllerAnimated:(BOOL)animated delay:(BOOL)delay{
    [self.view endEditing:YES];
    
    if (delay) {
        WkSelf(weakSelf);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf popViewControllerAnimated:YES];
        });
    }else{
        [self popViewControllerAnimated:YES];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.navigationController.viewControllers.count >1) {
        [self enableOpenLeftDrawer:NO];   //关闭抽屉手势
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    
    if (self.navigationController.viewControllers.count == 1) {
        [self enableOpenLeftDrawer:YES];   //打开抽屉手势
    }
}


-(void)pushViewController:(UIViewController *)newViewController{
    if ([newViewController isKindOfClass:[UIViewController class]]) {
        newViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:newViewController animated:YES];
    }
}


- (void)configureLeftBarButtonWithTitle:(NSString *)title image:(UIImage *)image action:(LeftBarButtonActionBlock)action {
    
    UIButton *barBtn = [self createButton:title image:image];
    [barBtn addTarget:self action:@selector(clickedLeftBarButtonItemAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *navRightBtn = [[UIBarButtonItem alloc] initWithCustomView:barBtn];
    self.navigationItem.leftBarButtonItem =navRightBtn;
    
    self.leftBarButtonAction = action;
}

- (void)configureLeftBarButtonWithTitle:(NSString *)title image:(UIImage *)image sel:(SEL)select{
    UIButton *barBtn = [self createButton:title image:image];
    [barBtn addTarget:self action:select forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *navbarBtn = [[UIBarButtonItem alloc] initWithCustomView:barBtn];
    self.navigationItem.leftBarButtonItem =navbarBtn;

}

- (void)configureRightBarButtonWithTitle:(NSString *)title image:(UIImage *)image action:(RightBarButtonActionBlock)action {
    UIButton *barBtn = [self createButton:title image:image];
    [barBtn addTarget:self action:@selector(clickedRightBarButtonItemAction) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *navbarBtn = [[UIBarButtonItem alloc] initWithCustomView:barBtn];
    self.navigationItem.rightBarButtonItem =navbarBtn;
    
    self.rightBarButtonAction = action;
    
}

- (void)configureRightBarButtonWithTitle:(NSString *)title image:(UIImage *)image sel:(SEL)select{
    UIButton *barBtn = [self createButton:title image:image];
    [barBtn addTarget:self action:select forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *navbarBtn = [[UIBarButtonItem alloc] initWithCustomView:barBtn];
    self.navigationItem.rightBarButtonItem =navbarBtn;
    
}

-(UIButton *)createButton:(NSString *)title image:(UIImage *)image{
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

- (void)clickedLeftBarButtonItemAction
{
    if (self.leftBarButtonAction) {
        self.leftBarButtonAction();
    }
}

- (void)clickedRightBarButtonItemAction
{
    if (self.rightBarButtonAction) {
        self.rightBarButtonAction();
    }
}

#pragma mark 控制抽屉开关
-(void)enableOpenLeftDrawer:(BOOL)enable{
    if (enable == YES) {
        [self.ShareApp.DrawerController setOpenDrawerGestureModeMask:(MMOpenDrawerGestureModeAll)];
    }else{
        //不能打开
        __weak BaseViewController *weakSelf = self;
        [self.ShareApp.DrawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
            [weakSelf.ShareApp.DrawerController setOpenDrawerGestureModeMask:(MMOpenDrawerGestureModeNone)];
        }];
    }
}

#pragma mark 回拨呼叫
-(BOOL)dialerCall:(NSString *)phone name:(NSString *)displayName{
    NSString *err = @"";
    if (phone.length >0) {
        phone = [AddressbookObject normalPhoneNumber:phone];
    }
    if (phone.length == 0) {
        err = @"号码不能为空";
    }else if ([phone hasPrefix:@"+86"]){
        if (phone.length>3) {
            phone = [phone substringFromIndex:4];
        }else{
            phone = [phone substringFromIndex:3];
        }
    }else if ([phone hasPrefix:@"86"]){
        phone = [phone substringFromIndex:2];
    }
    else if ([phone isTelephoneTypeString] == NO){
//        err = @"请确认是否正确手机号码";
    }
    
    if (err.length >0) {
        [self showAlertView:err detail:nil withDelegate:nil];
        return NO;
    }
    
    ReturnCallViewController *returnCallVc = [[ReturnCallViewController alloc] init];
    [returnCallVc returnDialerCall:phone name:displayName];
    
    [self presentViewController:returnCallVc animated:YES completion:nil];
    
    
    ContactModel *tmpItem = [self.addressBook.contactsNumberValueKey objectForKey:phone];
    
    NSString *perId = @"";
    if ([tmpItem isKindOfClass:[ContactModel class]]) {
        perId = tmpItem.personId;
        displayName = tmpItem.name;
    }
    
    //入表
    CallLogObject *callObj = [[CallLogObject alloc] init];
    callObj.name = displayName;
    callObj.phone = phone;
    callObj.uid = self.userInfo.uid;
    callObj.callType = @"1";
    callObj.personId = perId;   //通讯录 id
    [callObj insetDB];
    
    return YES;
}

#pragma mark 通用方法

//MBProgressHUD 提示
-(void)showMBText:(NSString *)text{
    if (text) {
        [MBProgressHUD showError:text toView:self.view];
    }
}

// 加载中 指示器
-(void)MBLoadingWithText:(NSString *)text{
    [MBProgressHUD showMessage:text toView:self.view];
}

//加载中指示器，是否需要蒙板
-(void)MBLoadingWithText:(NSString *)text haveDimBg:(BOOL)dimbg{
    [MBProgressHUD showMessage:text haveDimbg:dimbg];
}

// 显示或者移除 加载指示器
-(void)MBLoading:(BOOL)load{
    if (load)
    {
        [MBProgressHUD showMessage:@"请求中..." toView:self.view];
    }else
    {
        if ([MBProgressHUD hideHUDForView:self.view animated:NO] == NO) {
            [MBProgressHUD hideHUD];
        }
    }
}


-(void)showAlertView:(NSString *)title detail:(NSString *)detailText withDelegate:(UIViewController *)targetVc{
    UIAlertView *tmpAlert = nil;
    if (targetVc) {
        tmpAlert = [[UIAlertView alloc] initWithTitle:title message:detailText delegate:targetVc cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    }else{
        tmpAlert = [[UIAlertView alloc] initWithTitle:title message:detailText delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    }
    [tmpAlert show];
    
}

#pragma mark - Touch Ges
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
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
