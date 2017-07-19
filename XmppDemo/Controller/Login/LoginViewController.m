//
//  LoginViewController.m
//  WHIMDemo1
//
//  Created by Gery晖 on 17/4/11.
//  Copyright © 2017年 wh_shine. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistViewController.h"


@interface LoginViewController (){
    IBOutlet UIButton *registBtn;
    IBOutlet UIButton *loginBtn;
    
}

@property (nonatomic, weak) IBOutlet UITextField *accountField;
@property (nonatomic, weak) IBOutlet UITextField *passwordField;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *inputViewBottomConstraint;  /**< 距 底部 */

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"登录";
}

#pragma mark Button Action
    //注册
-(IBAction)ClickToRegist:(id)sender{
    RegistViewController *registVc = [[RegistViewController alloc] init];
    [self pushViewController:registVc];
}
    //登录
-(IBAction)ClickToLogin:(id)sender{
    if ([self inputTextCorrect]) {
        [self loginWithUsername:_accountField.text password:_passwordField.text];
        
//        [[[HttpRequest alloc] init] app_userRegist:_accountField.text password:_passwordField.text complite:^(BOOL result, NSString *errmsg, NSDictionary *jsonDic) {
//            NSLog(@"%@",jsonDic);
//        }];
//        
//        [[[HttpRequest alloc] init] app_userLogin:@"18127134405" password:@"123456" complite:^(BOOL result, NSString *errmsg, NSDictionary *jsonDic) {
//            NSLog(@"%@",jsonDic);
//        }];
//        
//        [[[HttpRequest alloc] init] im_userAddFriend:@"15200791090" complite:^(BOOL result, NSString *errmsg, NSDictionary *jsonDic) {
//            NSLog(@"%@",jsonDic);
//        }];
//        
//        [[[HttpRequest alloc] init] im_userInBlack:@"15200791090" complite:^(BOOL result, NSString *errmsg, NSDictionary *jsonDic) {
//            NSLog(@"%@",jsonDic);
//        }];
        
        
    }
}

#pragma mark 登录
//点击登陆后的操作
- (void)loginWithUsername:(NSString *)username password:(NSString *)password
{
    [self showHudInView:self.view hint:nil];
    //异步登陆账号
    __weak typeof(self) weakself = self;
    
    //测试账号
//    [MBProgressHUD showMessage:@"注册中" toView:self.view];
    [HttpRequest app_userLogin:_accountField.text password:_passwordField.text complite:^(BOOL result, NSString *errmsg, NSDictionary *jsonDic) {
        [weakself hideHud];
        
        if (jsonDic) {
            HttpRequestStatus status = [HttpRequest requestResult:jsonDic];
            if (status == HttpRequestStatusSucc) {
                NSDictionary *userDic = [jsonDic getDictionaryForKey:@"user"];
                if (userDic) {
                    [weakself saveLoginUserWithUser:userDic];
                    [weakself.appManager AppLogin];
                }
                
            }else{
                errmsg = [jsonDic getStringValueForKey:@"msg" defaultValue:@"操作失败"];
            }
        }
        if (errmsg.length >0) {
            [weakself showAlertView:errmsg detail:nil withDelegate:nil];
        }
    }];
    
    
    
}

-(void)xmppLogin:(NSString *)username password:(NSString *)password{
    [[XMPPTool shareXMPPTool] xmppLoginUser:username password:password resultBlock:^(XMPPResultType type) {
        
        //xmpp 代理回调在支线程
        [ToolMethods asynMainThreadWithAction:^{
            if (type == XMPPResultTypeLoginSuccess) {
                NSLog(@"XMPP服务验证成功");
            }
        }];
        
    }];
}

-(BOOL)inputTextCorrect{
    NSString *errmsg = @"";
    NSString *name = self.accountField.text;
    NSString *pwd = self.passwordField.text;
    
    if (name.length == 0) {
        errmsg = @"请输入账号";
    }else if ([name isChineseWordString]){
        errmsg = @"账号不支持中文字符";
    }
    else if (pwd.length == 0){
        errmsg = @"请输入密码";
    }
    
    if (errmsg.length >0) {
        [self showAlertView:errmsg detail:nil withDelegate:nil];
        return NO;
    }
    return YES;
}

    //保存信息
-(void)saveLoginUserWithUser:(NSDictionary *)userInfo{
    self.userInfo.phone = _accountField.text;
    self.userInfo.pwdStr = _passwordField.text;
    
    [self.userInfo updateLoginInfo:userInfo];
    [self.appManager saveUserInfo];
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _accountField) {
        [_accountField resignFirstResponder];
        [_passwordField becomeFirstResponder];
    }else if (textField == _passwordField){
        [_passwordField resignFirstResponder];
        [self ClickToLogin:nil];
    }
    
    return YES;
}


#pragma  mark - private
- (void)saveLastLoginUsername
{
//    NSString *username = [[EMClient sharedClient] currentUsername];
//    if (username && username.length > 0) {
//        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//        [ud setObject:username forKey:[NSString stringWithFormat:@"em_lastLogin_username"]];
//        [ud synchronize];
//    }
}

- (NSString*)lastLoginUsername
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *username = [ud objectForKey:[NSString stringWithFormat:@"em_lastLogin_username"]];
    if (username && username.length > 0) {
        return username;
    }
    return nil;
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
