//
//  AboutViewController.m
//  WHIMDemo1
//
//  Created by IntelcentMac on 17/5/22.
//  Copyright © 2017年 wh_shine. All rights reserved.
//

#import "AboutViewController.h"
#import "BaseTableViewCell.h"

@interface AboutViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *contentArr;
    CGFloat cellRowHeight;
    
    IBOutlet UILabel *appNameLab;
}

@property (nonatomic, weak) IBOutlet UITableView *contentTable;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关于我们";
    
    NSString *ver = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *appN = [NSString stringWithFormat:@"%@ V %@",App_displayName,ver];
    [appNameLab setText:appN];
    
    contentArr = [[NSMutableArray alloc] init];
    [contentArr addObject:@{@"text":@"去评分",@"detail":@""}];
    [contentArr addObject:@{@"text":@"官方网站",@"detail":@""}];
    [contentArr addObject:@{@"text":@"客服QQ",@"detail":@""}];
    [contentArr addObject:@{@"text":@"帮助中心",@"detail":@""}];
    
    self.contentTable.delegate = self;
    self.contentTable.dataSource = self;
    self.contentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.contentTable.bounces = NO;
    
//    [self.contentTable registerNib:[UINib nibWithNibName:@"BaseTableViewCell" bundle:nil] forCellReuseIdentifier:@"aboutCellId"];
//    cellRowHeight = 50;
}


#pragma mark UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return contentArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellRowHeight;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"aboutCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
    }
    
    NSDictionary *tmpDic = contentArr[indexPath.row];
    if ([tmpDic isKindOfClass:[NSDictionary class]]) {
        NSString *txt = [tmpDic getStringValueForKey:@"text" defaultValue:@""];
        NSString *detail = [tmpDic getStringValueForKey:@"detail" defaultValue:@""];
        [cell.textLabel setText:txt];
        [cell.detailTextLabel setText:detail];
    }
    
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
