//
//  TLFriendsViewController.m
//  TLChat
//
//  Created by 李伯坤 on 16/1/23.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "TLFriendsViewController.h"
#import "TLFriendsViewController+Delegate.h"
#import "TLSearchController.h"

#import "TLFriendHelper.h"
#import "UIColor+TLChat.h"
#import "AddFriendViewController.h"
#import "AppDelegate.h"
#import "TestChatViewModel.h"

@interface TLFriendsViewController ()<XMPPRosterDelegate>

@property (nonatomic, strong) UILabel *footerLabel;

@property (nonatomic, strong) TLFriendHelper *friendHelper;

@property (nonatomic, strong) TLSearchController *searchController;

@end

@implementation TLFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"通讯录"];
    self.edgesForExtendedLayout = UIRectEdgeTop;
    self.navigationController.navigationBar.translucent = NO;
    
    [self p_initUI];        // 初始化界面UI
    [self registerCellClass];
    
    self.friendHelper = [TLFriendHelper sharedFriendHelper];      // 初始化好友数据业务类
    self.data = self.friendHelper.data;
    self.sectionHeaders = self.friendHelper.sectionHeaders;
    [self.footerLabel setText:[NSString stringWithFormat:@"%ld位联系人", (long)self.friendHelper.friendCount]];
    
    __weak typeof(self) weakSelf = self;
    [self.friendHelper setDataChangedBlock:^(NSMutableArray *data, NSMutableArray *headers, NSInteger friendCount) {
        weakSelf.data = [NSMutableArray arrayWithArray:data];
        weakSelf.sectionHeaders = [NSMutableArray arrayWithArray:headers];
        [weakSelf.footerLabel setText:[NSString stringWithFormat:@"%ld位联系人", (long)friendCount]];
        [weakSelf.tableView reloadData];
    }];
    
    [self.searchVC setFriendSesrchCellDidSelectedBlock:^(NSIndexPath *indexPath) {
        
    }];
    
    [self loadXmppFetContacts];  //xmpp好友获取
}

-(void)loadXmppFetContacts{
    [[XMPPTool shareXMPPTool].roster fetchRoster];
    [[XMPPTool shareXMPPTool].roster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
}

-(void)dealloc{
    Release(_data);
    Release(_sectionHeaders);
    Release(_searchVC);
    Release(_searchController);
    
    [[XMPPTool shareXMPPTool].roster removeDelegate:self];
    
    [self.friendHelper friendReset];  //重置
}

-(void)xmppRoster:(XMPPRoster *)sender didReceiveRosterItem:(DDXMLElement *)item{
    NSLog(@"%@",[[item attributeForName:@"subscription"] stringValue]);
    
    NSString *subscription = [item attributeStringValueForName:@"subscription"];
    if ([subscription isEqualToString:@"both"] ||
        [subscription isEqualToString:@"from"] ||
        [subscription isEqualToString:@"to"])
    {
        NSString *SJid = [item attributeForName:@"jid"].stringValue;
        XMPPJID *jid = [XMPPJID jidWithString:SJid];
        
        bool isExit = NO;
        
        for (TLUserGroup *group in self.data) {
            for (TLUser *user in group.users) {
                if ([user.username isEqualToString:jid.user]) {
                    isExit = YES;
                }
            }
        }
        if (!isExit) {
            TLUser *tmpUser = [[TLUser alloc] init];
            tmpUser.userID = jid.user;  //uid，phone一致
            tmpUser.username = jid.user;
            tmpUser.nikeName = [NSString stringWithFormat:@"测试账号:%@",jid.user];
            
             [_friendHelper addFriendWithUser:@[tmpUser]];  //添加
        }
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self enableOpenLeftDrawer:YES];   //打开抽屉手势
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if (self.navigationController.viewControllers.count >1) {
        [self enableOpenLeftDrawer:NO];   //关闭抽屉手势
    }
}

-(void)enableOpenLeftDrawer:(BOOL)enable{
    if (enable == YES) {
        [[AppDelegate instance].DrawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
        
    }else{
        //不能打开
        [[AppDelegate instance].DrawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    }
}

#pragma mark - Event Response -
- (void)rightBarButtonDown:(UIBarButtonItem *)sender
{
    AddFriendViewController *addFriendVC = [[AddFriendViewController alloc] init];
    [addFriendVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:addFriendVC animated:YES];
}

#pragma mark - Private Methods -
- (void)p_initUI
{
    [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 0)];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 0)];
    [self.tableView setSeparatorColor:[UIColor colorGrayLine]];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    [self.tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    [self.tableView setSectionIndexColor:[UIColor colorBlackForNavBar]];
    
    [self.tableView setTableHeaderView:self.searchController.searchBar];

    
    [self.tableView setTableFooterView:self.footerLabel];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_add_friend"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonDown:)];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
}

#pragma mark - Getter -
- (TLSearchController *)searchController
{
    if (_searchController == nil) {
        _searchController = [[TLSearchController alloc] initWithSearchResultsController:self.searchVC];
        [_searchController setSearchResultsUpdater:self.searchVC];
        [_searchController.searchBar setPlaceholder:@"搜索"];
        [_searchController.searchBar setDelegate:self];
//        [_searchController setShowVoiceButton:YES];
    }
    return _searchController;
}

- (TLFriendSearchViewController *)searchVC
{
    if (_searchVC == nil) {
        _searchVC = [[TLFriendSearchViewController alloc] init];
    }
    return _searchVC;
}

- (UILabel *)footerLabel
{
    if (_footerLabel == nil) {
        _footerLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50.0f)];
        [_footerLabel setTextAlignment:NSTextAlignmentCenter];
        [_footerLabel setFont:[UIFont systemFontOfSize:17.0f]];
        [_footerLabel setTextColor:[UIColor grayColor]];
    }
    return _footerLabel;
}

@end