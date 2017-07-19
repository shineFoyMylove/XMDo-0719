//
//  LeftViewController.m
//  WHIMDemo1
//
//  Created by IntelcentMac on 17/3/24.
//  Copyright © 2017年 wh_shine. All rights reserved.
//

#import "LeftViewController.h"
#import "BaseTableViewCell.h"
#import "UserInfoEditViewController.h"

@interface LeftViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *contentArr;
}

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"left_vc";
    self.navigationController.navigationBarHidden = YES;
    
    [self initTableList];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

    //用户资料
-(IBAction)ClickToUserInfo:(id)sender{
    NotificationPost(NTViewPushForLeftDrawer, @"UserInfoEditViewController");
}

-(void)initTableList{
    contentArr = [[NSMutableArray alloc] initWithObjects
                  :@{@"icon":@"cell_default_icon.png"
                     ,@"text":@"我的二维码"
                     ,@"vcname":@"QRCodeViewController"}
//                  ,@{@"icon":@"cell_default_icon.png"
//                     ,@"text":@"我的相册"
//                     ,@"vcname":@""}
                  ,@{@"icon":@"cell_default_icon.png"
                     ,@"text":@"我的收藏"
                     ,@"vcname":@"MyCollectionViewController"}
                  ,@{@"icon":@"cell_default_icon.png"
                     ,@"text":@"消息中心"
                     ,@"vcname":@"MsgCenterViewController"}
                  ,@{@"icon":@"cell_default_icon.png"
                     ,@"text":@"意见反馈"
                     ,@"vcname":@"AdviseViewController"}
                  , nil];
    
    self.contentList.delegate = self;
    self.contentList.dataSource = self;
    self.contentList.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentList registerNib:[UINib nibWithNibName:@"BaseTableViewCell" bundle:nil] forCellReuseIdentifier:@"leftViewTableCellId"];
}

#pragma mark UITableViewDelegate
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGFloat windowWidth = [UIScreen mainScreen].bounds.size.width;
    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, windowWidth, 20)];
    tmpView.backgroundColor = [UIColor clearColor];
    return tmpView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return contentArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"leftViewTableCellId";
    BaseTableViewCell *cell = (BaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[BaseTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
    }
    
    NSDictionary *tmpDic = contentArr[indexPath.row];
    if ([tmpDic isKindOfClass:[NSDictionary class]]) {
        NSString *img = [tmpDic objectForKey:@"icon"];
        NSString *text = [tmpDic objectForKey:@"text"];
        
        [cell.imageIcon setImage:[UIImage imageNamed:img]];
        [cell.R_textLabel setText:text];
        cell.R_textLabel.textColor = [UIColor whiteColor];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    cell.selectedBackgroundView = [self cellBgView];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *tmpDic = contentArr[indexPath.row];
    NSString *text = [tmpDic getStringValueForKey:@"vcname" defaultValue:@""];
    if(text.length >0)  NotificationPost(NTViewPushForLeftDrawer, text);
    
}

-(UIView *)cellBgView{
    CGFloat windowWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat windowHeight = [UIScreen mainScreen].bounds.size.height;
    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,windowWidth , windowHeight)];
    tmpView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
    
    return tmpView;
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
