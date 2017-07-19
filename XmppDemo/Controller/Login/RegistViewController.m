//
//  RegistViewController.m
//  WHIMDemo1
//
//  Created by Gery晖 on 17/4/11.
//  Copyright © 2017年 wh_shine. All rights reserved.
//

#import "RegistViewController.h"

@interface RegistViewController ()<UITextFieldDelegate>{
    IBOutlet UIButton *registBtn;
}


@property (nonatomic, weak) IBOutlet UITextField *accountField;
@property (nonatomic, weak) IBOutlet UITextField *passwordField;
@property (nonatomic, weak) IBOutlet UITextField *repasswordField;

@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"注册";
    
    self.accountField.delegate = self;
    self.passwordField.delegate = self;
}

#pragma mark Button Action
    //注册
-(IBAction)ClickToRegist:(id)sender{
    if ([self inputTextCorrect]) {
        [self.view endEditing:YES];
        
        [self showHudInView:self.view hint:nil];
        WkSelf(weakSelf);
        
        [HttpRequest app_userRegist:_accountField.text password:_passwordField.text complite:^(BOOL result, NSString *errmsg, NSDictionary *jsonDic) {
            [self hideHud];
            if (jsonDic) {
                HttpRequestStatus status = [HttpRequest requestResult:jsonDic];
                if (status == HttpRequestStatusSucc) {
                    NSDictionary *userInfo = [jsonDic getDictionaryForKey:@"user"];
                    if (userInfo) {
                        [weakSelf saveLoginUserWithUser:userInfo];
                        [weakSelf.appManager AppLogin];
                    }
                    
                }else if (status == HttpRequestStatusUserExist){
                    
                    [UIAlertView bk_showAlertViewWithTitle:@"用户已存在" message:@"是否进行登录" cancelButtonTitle:@"取消" otherButtonTitles:@[@"去登录"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                        if (buttonIndex == 1) {
                            [weakSelf popViewControllerAnimated:YES];
                        }
                    }];
                    
                    return;
                }
                else{
                    errmsg = [jsonDic getStringValueForKey:@"msg" defaultValue:@"操作失败"];
                }
            }
            
            if (errmsg.length >0) {
                [weakSelf showAlertView:errmsg detail:nil withDelegate:nil];
            }
        }];
    }
}

-(void)loginCurrentUser{
    //异步登陆账号
    [self showHudInView:self.view hint:@"登录中"];
    
    __weak typeof(self) weakself = self;
    
}

-(void)saveLoginUserWithUser:(NSDictionary *)userInfo{
    self.userInfo.phone = _accountField.text;
    self.userInfo.pwdStr = _passwordField.text;
    
    [self.userInfo updateLoginInfo:userInfo];
    [self.appManager saveUserInfo];
}

-(BOOL)inputTextCorrect{
    NSString *errmsg = @"";
    NSString *name = self.accountField.text;
    NSString *pwd = self.passwordField.text;
    NSString *repwd = self.repasswordField.text;
    if (name.length == 0) {
        errmsg = @"请输入账号";
    }else if ([name isChineseWordString]){
        errmsg = @"账号不支持中文字符";
    }
    else if (pwd.length == 0){
        errmsg = @"请输入密码";
    }else if ([pwd isEqualToString:repwd] == NO){
        errmsg = @"密码必须一致";
    }
    if (errmsg.length >0) {
        [self showAlertView:errmsg detail:nil withDelegate:nil];
        return NO;
    }
    return YES;
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _accountField) {
        [_accountField resignFirstResponder];
        [_passwordField becomeFirstResponder];
    }else if (textField == _passwordField){
        [_passwordField resignFirstResponder];
        [_repasswordField becomeFirstResponder];
    }else if (textField == _repasswordField){
        [_repasswordField resignFirstResponder];
        [self ClickToRegist:nil];
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
