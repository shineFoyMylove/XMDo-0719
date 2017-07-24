//
//  NewFriendViewController.m
//  XmppProject
//
//  Created by IntelcentMac on 17/7/18.
//  Copyright © 2017年 wh_shine. All rights reserved.
//

#import "NewFriendViewController.h"
#import "NewFriendObject+CoreDataClass.h"
#import "NewFriendTableViewCell.h"
#import "AddFriendViewController.h"

@interface NewFriendViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, retain) UITableView *NewFriendList;
@property (nonatomic, retain) NSMutableArray *NewFriendsArray;


@end

@implementation NewFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.navigationItem.title = @"新的朋友";
    
    self.NewFriendList = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
    _NewFriendList.delegate = self;
    _NewFriendList.dataSource = self;
    _NewFriendList.separatorStyle = UITableViewCellSeparatorStyleNone;
    _NewFriendList.rowHeight = 50;
    [self.view addSubview:self.NewFriendList];
    
    [_NewFriendList registerNib:[UINib nibWithNibName:@"NewFriendTableViewCell" bundle:nil] forCellReuseIdentifier:@"NewFriendCellId"];
    
    //初始化数据源
    self.NewFriendsArray = [NSMutableArray array];
    [_NewFriendsArray addObjectsFromArray:[NewFriendObject featchAllRequest]];
    
    //添加好友
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_add_friend"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonDown:)];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newFriendUpdate:) name:NTIMHaveNewFriend object:nil];
}

-(void)dealloc{
    NotificationRemoveWithName(self, NTIMHaveNewFriend, nil);
}

    //数据重载
-(void)newFriendUpdate:(NSNotification *)notify{
    
    WkSelf(weakSelf);
    dispatch_async(GCDQueueDEFAULT, ^{
        [weakSelf.NewFriendsArray removeAllObjects];
        [weakSelf.NewFriendsArray addObjectsFromArray:[NewFriendObject featchAllRequest]];
        
        dispatch_async(GCDQueueMain, ^{
            [weakSelf.NewFriendList reloadData];
            [weakSelf getOnlieNewFriendData];
        });
    });
}

    //先读取本地，再获取服务器新的好友数据
-(void)getOnlieNewFriendData{
    
    WkSelf(weakSelf);
    [HttpRequest im_userNewFriendListComplite:^(BOOL result, NSString *errmsg, NSDictionary *jsonDic) {
        if (jsonDic) {
            HttpRequestStatus state = [HttpRequest requestResult:jsonDic];
            if (state == HttpRequestStatusSucc) {
                
                
                
            }else{
                errmsg = [jsonDic getStringValueForKey:@"msg" defaultValue:@""];
                [MBProgressHUD showToastWithText:@"数据获取失败" inView:nil];
            }
        }else{
            [MBProgressHUD showToastWithText:@"请求错误" inView:nil];
        }
        
        [weakSelf.NewFriendList reloadData];
    }];
}

#pragma mark - Event Response -
- (void)rightBarButtonDown:(UIBarButtonItem *)sender
{
    AddFriendViewController *addFriendVC = [[AddFriendViewController alloc] init];
    [addFriendVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:addFriendVC animated:YES];
}

#pragma mark UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _NewFriendsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"NewFriendCellId";
    NewFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[NewFriendTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
    }
    cell.haveBottomLine = YES;
    
    NewFriendObject *friendObj = [_NewFriendsArray objectAtIndex:indexPath.row];
    [cell setObjItem:friendObj];
    
    UIView *selBgView = [UIView new];
    selBgView.backgroundColor = RGBColor(240, 240, 240);
    cell.selectedBackgroundView = selBgView;
    
    __block NewFriendObject *weakObj = friendObj;
    WkSelf(weakSelf);
    [cell setAgreeActionBlock:^(BOOL result) {
        if (result) {
            weakObj.state = TLNewFriendApplyStateAgreed;
            [weakSelf.NewFriendList reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationFade)];
            NotificationPost(NTIMUpdateFirendList, nil);
        }
    }];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AlertTipWithMessage(@"点击查看个人资料");
    
}

//TODO: 右滑编辑
//-(BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
//    return YES;
//}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //删除
        NewFriendObject *obj = self.NewFriendsArray[indexPath.row];
        
        if ([obj remove]) {
            [self.NewFriendsArray removeObject:obj];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationFade)];
        }
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
