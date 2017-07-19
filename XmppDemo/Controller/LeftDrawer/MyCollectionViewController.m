//
//  MyCollectionViewController.m
//  WHIMDemo1
//
//  Created by IntelcentMac on 17/5/22.
//  Copyright © 2017年 wh_shine. All rights reserved.
//  我的收藏

#import "MyCollectionViewController.h"
#import "MyCollectionCell.h"
#import "MyCollectionModel.h"
#import "MJRefresh.h"

@interface MyCollectionViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, retain) NSMutableArray *dataArry;


@end

@implementation MyCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的收藏";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.collectionTable = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
    self.collectionTable.dataSource = self;
    self.collectionTable.delegate = self;
    [self.view addSubview:self.collectionTable];
    
    self.collectionTable.estimatedRowHeight = 120;  //预计高度
    
    [[ToolMethods instance] MJ_addRefresh:self.collectionTable headerBlock:^{
        //刷新
        [self.collectionTable.mj_header endRefreshing];
    } footBlock:^{
        //加载更多
        [self.collectionTable.mj_footer endRefreshing];
    }];
    
    NSArray *iconImageNamesArray = @[@"icon0.jpg",
                                     @"icon1.jpg",
                                     @"icon2.jpg",
                                     @"icon3.jpg",
                                     @"icon4.jpg",
                                     ];
    
    NSArray *namesArray = @[@"GSD_iOS",
                            @"风口上的猪",
                            @"当今世界网名都不好起了",
                            @"我叫郭德纲",
                            @"Hello Kitty"];
    
    NSArray *textArray = @[@"当你的 app 没有提供 3x 的 LaunchImage 时，系统默认进入兼容模式，https://github.com/gsdios/SDAutoLayout大屏幕一切按照 320 宽度渲染，屏幕宽度返回 320；然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。",
                           @"然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，https://github.com/gsdios/SDAutoLayout等于把小屏完全拉伸。",
                           @"当你的 app 没有提供 3x 的 LaunchImage 时屏幕宽度返回 320；然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。但是建议不要长期处于这种模式下。屏幕宽度返回 320；https://github.com/gsdios/SDAutoLayout然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。但是建议不要长期处于这种模式下。屏幕宽度返回 320；然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。但是建议不要长期处于这种模式下。",
                           @"但是建议不要长期处于这种模式下，否则在大屏上会显得字大，内容少，容易遭到用户投诉。",
                           @"屏幕宽度返回 320；https://github.com/gsdios/SDAutoLayout然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。但是建议不要长期处于这种模式下。"
                           ];
    
    NSArray *picImageNamesArray = @[ @"pic0.jpg",
                                     @"pic1.jpg",
                                     @"pic2.jpg",
                                     @"pic3.jpg",
                                     @"pic4.jpg",
                                     @"pic5.jpg",
                                     @"pic6.jpg",
                                     @"pic7.jpg",
                                     @"pic8.jpg"
                                     ];
    
    self.dataArry = [NSMutableArray array];
    
    for (int i = 0; i<namesArray.count; i++) {
        MyCollectionModel *model = [MyCollectionModel new];
        model.userHeader = iconImageNamesArray[i];
        model.username = namesArray[i];
        model.text_content = textArray[i];
        model.timeString = @"2018-08-08";
        model.contentType = sh_messageTypeTxt;
        
        [self.dataArry addObject:model];
    }
    
    for (int i = 0; i<picImageNamesArray.count; i++) {
        NSUInteger armIndex = arc4random() % (namesArray.count);
        
        MyCollectionModel *model = [MyCollectionModel new];
        model.userHeader = iconImageNamesArray[armIndex];
        model.username = namesArray[armIndex];
        model.timeString = @"15天前";
        model.contentType = sh_messageTypePicture;
        model.pic_image = picImageNamesArray[i];
        
        armIndex = arc4random() % (_dataArry.count);
        [self.dataArry insertObject:model atIndex:armIndex];
    }
    
}

#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArry.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 30;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"collectionCellId";
    MyCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[MyCollectionCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
    }
    
    cell.selectedBackgroundView = [UIView new];
    cell.selectedBackgroundView.backgroundColor = RGBColor(242, 242, 242);
    
    [cell setCollectionModel:self.dataArry[indexPath.row]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
