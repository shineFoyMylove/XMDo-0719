//
//  FindViewController.m
//  WHIMDemo1
//
//  Created by Gery晖 on 17/4/7.
//  Copyright © 2017年 wh_shine. All rights reserved.
//

#import "FindViewController.h"
#import "BaseTableViewCell.h"

#import "AboutViewController.h"

//@class AboutViewController;
@class PwdChangeViewController;
@class BlackListViewController;
@class CallSetViewController;
@class OtherSetViewController;
@class MyCollectionViewController;
@class MsgCenterViewController;


@interface FindViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>

@property (nonatomic, retain) NSMutableArray *contentData;

@end

@implementation FindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = AppMainBgColor;
    self.navigationItem.title = @"发现";
    
    self.contentData = [NSMutableArray array];
//    NSDictionary *dict0 = @{@"icon":@"cell_default_icon",@"text":@"朋友圈"};
    NSDictionary *dict1 = @{@"icon":@"cell_default_icon",@"text":@"扫一扫"};
    NSDictionary *dict2 = @{@"icon":@"cell_default_icon",@"text":@"修改密码"};
    
    
    NSDictionary *dict3 = @{@"icon":@"cell_default_icon",@"text":@"黑名单"};
    NSDictionary *dict4 = @{@"icon":@"cell_default_icon",@"text":@"拨打设置"};
    NSDictionary *dict5 = @{@"icon":@"cell_default_icon",@"text":@"其他设置"}; //新消息通知、语音默认模式
    
    NSDictionary *dict6 = @{@"icon":@"cell_default_icon",@"text":@"在线更新"};
    NSDictionary *dict7 = @{@"icon":@"cell_default_icon",@"text":@"关于我们"};
    
    NSDictionary *dict8 = @{@"icon":@"cell_default_icon",@"text":@"账号注销"};
    
    [self.contentData addObject:@[dict1,dict2]];
    [self.contentData addObject:@[dict3,dict4,dict5]];
    [self.contentData addObject:@[dict6,dict7]];
    [self.contentData addObject:@[dict8]];
    
    //Table
    self.tableList.delegate = self;
    self.tableList.dataSource = self;
    self.tableList.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableList registerNib:[UINib nibWithNibName:@"BaseTableViewCell" bundle:nil] forCellReuseIdentifier:@"FindTableCellID"];
    self.tableList.backgroundColor = [UIColor clearColor];
    
}

#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _contentData.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *secArr = _contentData[section];
    if ([secArr isKindOfClass:[NSArray class]]) {
        return secArr.count;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 20)];
    tempView.backgroundColor = [UIColor clearColor];
    return tempView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == _contentData.count-1) {
        return 20;
    }
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"FindTableCellID";
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[BaseTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
    }
    cell.haveBottomLine = YES;
    
    NSArray *secArr = _contentData[indexPath.section];
    if ([secArr isKindOfClass:[NSArray class]]) {
        NSDictionary *tmpDic = secArr[indexPath.row];
        if ([tmpDic isKindOfClass:[NSDictionary class]]) {
            NSString *txt = [tmpDic objectForKey:@"text"];
            NSString *icon = [tmpDic objectForKey:@"icon"];
            NSString *des = [tmpDic objectForKey:@"detail"];
            
            [cell.R_textLabel setText:txt];
            [cell.imageIcon setImage:IMAGECache(icon)];
//            [cell.desTipsLab setText:des];  //detail 
            if (self.appManager.haveNew && [txt isEqualToString:@"在线升级"]) {
                //有更新
//                cell.desTipsLab.backgroundColor = RGBColor(254, 66, 58);
//                [cell.desTipsLab setText:@" NEW "];
//                [cell.desTipsLab setFont:[UIFont systemFontOfSize:10.0]];
//                [cell.desTipsLab setTextColor:[UIColor whiteColor]];
            }
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *selText = @"";
    NSArray *secArr = _contentData[indexPath.section];
    if ([secArr isKindOfClass:[NSArray class]]) {
        NSDictionary *tmpDic = secArr[indexPath.row];
        if ([tmpDic isKindOfClass:[NSDictionary class]]) {
            selText = [tmpDic objectForKey:@"text"];
        }
    }
    
//    NSInteger newIndex = indexPath.row;
    
//    if ([selText isEqualToString:@"推荐好友"]) {
//        [self shareFromSystemMessage];
//    }
    if ([selText isEqualToString:@"扫一扫"]) {
        UIViewController *qrScanVc = GetViewController(@"QRScanViewController");
        if(qrScanVc)    [self pushViewController:qrScanVc];
    }
    else if ([selText isEqualToString:@"朋友圈"]){
        UIViewController *myCollectVc = GetViewController(@"MyFriendCircleTable");
        if(myCollectVc) [self pushViewController:myCollectVc];
    }
    else if ([selText isEqualToString:@"收藏列表"]){
        
        UIViewController *myCollectVc = GetViewController(@"MyCollectionViewController");
        if(myCollectVc) [self pushViewController:myCollectVc];
    }
    else if ([selText isEqualToString:@"消息中心"]){
        
        UIViewController *msgCenterVc = GetViewController(@"MsgCenterViewController");
        if(msgCenterVc) [self pushViewController:msgCenterVc];
    }
    else if ([selText isEqualToString:@"拨打设置"]){
        
        UIViewController *callsetVc = GetViewController(@"CallSetViewController");
        if(callsetVc) [self pushViewController:callsetVc];
    }
    else if ([selText isEqualToString:@"黑名单"]){
        
        UIViewController *blacklistVc = GetViewController(@"BlackListViewController");
        if(blacklistVc) [self pushViewController:blacklistVc];
    }
    else if ([selText isEqualToString:@"修改密码"]){
        
        UIViewController *pwdresetVc = GetViewController(@"PwdChangeViewController");
        if(pwdresetVc) [self pushViewController:pwdresetVc];
    }
    else if ([selText isEqualToString:@"其他设置"]){
        
        UIViewController *othersetVc = GetViewController(@"OtherSetViewController");
        if(othersetVc) [self pushViewController:othersetVc];
    }
    else if ([selText isEqualToString:@"在线更新"]){
        [self.appManager AppUpdate:NO];
    }
    else if ([selText isEqualToString:@"关于我们"]){
        
        UIViewController *aboutVc = GetViewController(@"AboutViewController");
        if(aboutVc) [self pushViewController:aboutVc];

//        AboutViewController *aboutVc = [[AboutViewController alloc] init];
//        [self.navigationController pushViewController:aboutVc animated:YES];
    }
    else if ([selText isEqualToString:@"账号注销"]){
        //注销退出
        [self showExitActionSheet];
    }
    
}

#pragma mark 推荐好友
//短信推荐
-(void)shareFromSystemMessage{
//    SystemMSViewController *SMSVc = [[SystemMSViewController alloc] init];
//    [self pushViewController:SMSVc];
}

#pragma mark UIActionSheet

-(void)showExitActionSheet{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"确认退出当前账号"
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:@"注销账号"
                                                    otherButtonTitles:nil, nil];
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            //删除
        {
            [self.appManager AppSignOut];
            
        }
            break;
        default:
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
