//
//  AddFriendViewController.m
//  XmppProject
//
//  Created by IntelcentMac on 17/7/18.
//  Copyright © 2017年 wh_shine. All rights reserved.
//

#import "AddFriendViewController.h"
#import "NewFriendObject+CoreDataClass.h"

@interface AddFriendViewController ()<UITextFieldDelegate>
{
    IBOutlet UITextField *_accountField;
    IBOutlet UILabel *MyAccountLabl;
}

@property (nonatomic, retain) NSMutableArray *dataArray;


@end

@implementation AddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加好友";
    
    self.dataArray = [NSMutableArray array];
    
    [MyAccountLabl setText:[NSString stringWithFormat:@"我的账号: %@",UDGetString(username_preference)]];
    
    _accountField.returnKeyType = UIReturnKeySearch;
    
    WkSelf(weakSelf);
    [self configureRightBarButtonWithTitle:@"添加" image:nil action:^{
//        [weakSelf searchNumber];
        [weakSelf sendRequestAddFriend];
    }];
}
    //搜索账号用户
-(void)searchNumber{
    
}

    //请求添加账号
-(void)sendRequestAddFriend{
    if (_accountField.text.length == 0) {
        AlertTipWithMessage(@"账号不能为空");
        return;
    }
    
    WkSelf(weakSelf);
    [[XMPPTool shareXMPPTool] xmppAddFriendSubscribe:_accountField.text complite:^(BOOL result) {
        if (result) {
            NewFriendObject *friendObj = [NewFriendObject NewMessage];
            friendObj.phone = _accountField.text;
            friendObj.state = TLNewFriendApplyStateWaiting;
            friendObj.name  = [NSString stringWithFormat:@"测试: %@",_accountField.text];
            
            if ([friendObj insert]) {
                NotificationPost(NTIMHaveNewFriend, nil);
            }
            
            AlertTipWithMessage(@"添加成功");
            [weakSelf popViewControllerAnimated:YES];
        }
        NSLog(@"Complite");
    }];
    
    
}

#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self sendRequestAddFriend];
    return YES;
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
