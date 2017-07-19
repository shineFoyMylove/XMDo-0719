//
//  MainTabBarController.m
//  WHIMDemo1
//
//  Created by Gery晖 on 17/4/7.
//  Copyright © 2017年 wh_shine. All rights reserved.
//

#import "MainTabBarController.h"
#import "BaseNaviViewController.h"
#import "DialerViewController.h"
#import "LeftViewController.h"

@interface MainTabBarController ()<ZFTabBarDelegate,UINavigationControllerDelegate>{
    BOOL kbHidden;      //隐藏键盘

}

@property (nonatomic, retain) NSMutableArray *titlesArr;
@property (nonatomic, retain) NSMutableArray *imagesArr;
@property (nonatomic, retain) NSMutableArray *selectedImagesArr;


@end

@implementation MainTabBarController

-(void)dealloc{
    NotificationRemoveWithName(self, NTViewPushForLeftDrawer, nil);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titlesArr = [NSMutableArray array];
    self.imagesArr = [NSMutableArray array];
    self.selectedImagesArr = [NSMutableArray array];
    
    NSArray *tmpTitles = @[@"拨号",@"信息",@"好友",@"发现"];
    NSArray *tmpImages = @[@"tabbar_icon1",@"tabbar_icon3",@"tabbar_icon2",@"tabbar_icon4"];
    NSArray *tmpSelImages = @[@"tabbar_icon1-s",@"tabbar_icon3-s",@"tabbar_icon2-s",@"tabbar_icon4-s"];
    
    [self setupTabBar:tmpTitles images:tmpImages selectedImages:tmpSelImages];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LeftDrawViewPuch:) name:NTViewPushForLeftDrawer object:nil];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
    
    [self removeTabBarButtons];
}


-(void)removeTabBarButtons{
    //删除系统自动生成的 UITabBarButton
    for (UIView *child in self.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

#pragma mark Public Method

-(void)TabVcPushViewController:(UIViewController *)viewController{
    viewController.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:viewController animated:YES];
}

    //侧栏触发 页面 Push
-(void)LeftDrawViewPuch:(NSNotification *)notify{
    UIViewController *curVc = self.selectedViewController;
    UINavigationController *curNavVc = nil;
    if ([curVc isKindOfClass:[UINavigationController class]]) {
        curNavVc = (UINavigationController *)curVc;
    }else{
        NSLog(@"未知错误");
        return;
    }
    
    NSString *vcname = [NSString stringWithFormat:@"%@",notify.object];
    UIViewController *tarVc = GetViewController(vcname);
    tarVc.hidesBottomBarWhenPushed = YES;
    
    if(tarVc)   [curNavVc pushViewController:tarVc animated:YES];
    
}

#pragma mark Setup TabBar

-(void)setupTabBar:(NSArray *)titles images:(NSArray *)images selectedImages:(NSArray *)selectedImages{
    [self.titlesArr removeAllObjects];
    [self.imagesArr removeAllObjects];
    [self.selectedImagesArr removeAllObjects];
    
    if(titles.count >0) [self.titlesArr addObjectsFromArray:titles];
    if(images.count >0) [self.imagesArr addObjectsFromArray:images];
    if(selectedImages.count >0) [self.selectedImagesArr addObjectsFromArray:selectedImages];
    
    
    [self.CustomTabBar removeFromSuperview];
    for (UIViewController *vc in self.viewControllers) {
        [vc.view removeFromSuperview];
        [vc removeFromParentViewController];
    }
    
    [self setupTabbar];
    [self setupAllChildViewControllers];
    
}

/**
 *  初始化tabbar
 */
- (void)setupTabbar
{
    ZFTabBar *customTabBar = [[ZFTabBar alloc] init];
    customTabBar.frame = self.tabBar.bounds;
    customTabBar.delegate = self;
    [self.tabBar addSubview:customTabBar];
    self.CustomTabBar = customTabBar;
    
    self.CustomTabBar.titleFont = [UIFont systemFontOfSize:12.0];
    self.CustomTabBar.titleSelectedColor = [UIColor colorWithRed:232/255.0 green:125/255.0 blue:26/255.0 alpha:1.0];
    self.CustomTabBar.titleColor = [UIColor blackColor];
    
    self.CustomTabBar.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

/**
 *  初始化tabbar
 */
-(void)setupAllChildViewControllers{
    
    NSArray *controllerNames = @[@"DialerViewController",
                                 @"MessageViewController",
                                 @"TLFriendsViewController",    //FriendViewController
                                 @"FindViewController",
                                 ];
    
    if (controllerNames.count == _titlesArr.count &&
        controllerNames.count == _imagesArr.count &&
        controllerNames.count == _selectedImagesArr.count) {
        for (int i = 0; i< controllerNames.count; i++) {
            NSString *className = [NSString stringWithFormat:@"%@",controllerNames[i]];
            Class class = NSClassFromString(className);
            UIViewController *viewContr = [[class alloc] init];
            if ([viewContr isKindOfClass:[UIViewController class]]) {
                BaseNaviViewController *tmpNaviVc = [[BaseNaviViewController alloc] initWithRootViewController:(UIViewController *)viewContr];
                
                if (i == 1) {
                    tmpNaviVc.tabBarItem.badgeValue = @"99";
                }else if (i == 2){
                    tmpNaviVc.tabBarItem.badgeValue = @"...";
                }else if (i == 3){
                    tmpNaviVc.tabBarItem.badgeValue = @"2";
                }
                
                
                [self setupChildViewController:tmpNaviVc title:_titlesArr[i] imageName:_imagesArr[i] selectedImageName:_selectedImagesArr[i]];
            }
        }
    }
    
}

/**
 *  初始化一个子控制器
 *
 *  @_param childVc           需要初始化的子控制器
 *  @_param title             标题
 *  @_param imageName         图标
 *  @_param selectedImageName 选中的图标
 */
- (void)setupChildViewController:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    // 1.设置控制器的属性
    childVc.title = title;
    // 设置图标
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    // 设置选中图标
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    if (iOS7) {
        childVc.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    }else{
        childVc.tabBarItem.selectedImage = selectedImage;
    }
    
    [self addChildViewController:childVc];
    
    [self.CustomTabBar addTabBarButtonWithItem:childVc.tabBarItem];
    
}

#pragma mark ZFTabBarDelegate
/**
 *  监听tabbar按钮的改变
 *  @_param from   原来选中的位置
 *  @_param to     最新选中的位置
 */
- (void)tabBar:(ZFTabBar *)tabBar didSelectedButtonFrom:(NSInteger)from to:(NSInteger)to
{
    if (self.selectedIndex == to && to == 0 ) {//双击刷新制定页面的列表
        UINavigationController *nav = self.viewControllers[0];
        UIViewController *VC = nav.visibleViewController;
        
        if ([VC isKindOfClass:[DialerViewController class]]) {
            DialerViewController *dialerVc = (DialerViewController *)VC;
            kbHidden = !kbHidden;
            [dialerVc changeHistoryRecordView:kbHidden];
            [self keyboardIconHidden:kbHidden];
        }
    }
    self.selectedIndex = to;
}

#pragma mark TabBar角标修改
-(void)setTabBar:(NSInteger)tabIndex badgeValue:(NSString *)badgeValue{
    NSArray *subTabItems = self.CustomTabBar.subviews;
    if (subTabItems.count >tabIndex) {
        ZFTabBarButton *tmpItem = subTabItems[tabIndex];
        tmpItem.item.badgeValue = badgeValue;
    }
}

#pragma mark 键盘伸缩，icon改变
-(void)keyboardIconHidden:(BOOL)hide{
    NSArray *subTabItems = self.CustomTabBar.subviews;
    ZFTabBarButton *dialerItem = subTabItems[0];
    
    UIImage *hidenImg = [UIImage imageNamed:@"tabbar_icon1-s2.png"];
    UIImage *normalImg = [UIImage imageNamed:_selectedImagesArr[0]];
    
    UITabBarItem *barItem = dialerItem.item;
    kbHidden = hide;
    if (hide) {
        //拨号 - 通话记录
        barItem.selectedImage = hidenImg;
        [barItem setTitle:@"通话记录"];
    }else{
        barItem.selectedImage = normalImg;
        [barItem setTitle:@"拨号"];
    }
    
    [self removeTabBarButtons];
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
