//
//  MsgCenterViewController.m
//  WHIMDemo1
//
//  Created by IntelcentMac on 17/5/22.
//  Copyright © 2017年 wh_shine. All rights reserved.
// 消息中心

#import "MsgCenterViewController.h"
#import "MsgCenterTableViewCell.h"
#import "MJRefresh.h"

@interface MsgCenterViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, retain) NSMutableArray *dataArray;


@end

@implementation MsgCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.navigationItem.title = @"消息中心";
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    self.msgTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height) style:(UITableViewStylePlain)];
    self.msgTable.dataSource = self;
    self.msgTable.delegate = self;
    [self.view addSubview:self.msgTable];
    
    self.msgTable.estimatedRowHeight = 120;  //预计高度
    self.msgTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.msgTable.backgroundColor = [UIColor clearColor];
    [self.msgTable setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 30)]];
    
    
    WkSelf(weakSelf);
    [[ToolMethods instance] MJ_addRefresh:self.msgTable headerBlock:^{
        //刷新
        [weakSelf.msgTable.mj_header endRefreshing];
    } footBlock:^{
        //加载更多
        [weakSelf.msgTable.mj_footer endRefreshing];
    }];
    
    
    NSArray *titlesArray = @[@"GSD_iOS",
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
    

    
    self.dataArray = [NSMutableArray array];
    
    for (int i = 0; i<titlesArray.count; i++) {
        MsgCenterModel *model = [MsgCenterModel new];
        model.title = titlesArray[i];
        model.content = textArray[i];
        
        model.time = @"2018-08-08";
        if (i == 1|| i ==3) {
            model.detailUrl = @"http://www.cocoachina.com//";
        }
        
        [self.dataArray addObject:model];
    }
    
}

#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    id model = self.dataArray[indexPath.row];
    CGFloat cellHeight = [self.msgTable cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[MsgCenterTableViewCell class] contentViewWidth:Main_Screen_Width];
    
    return cellHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"collectionCellId";
    MsgCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[MsgCenterTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // cell frame 缓存
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    
    [cell setModel:self.dataArray[indexPath.row]];
    
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
