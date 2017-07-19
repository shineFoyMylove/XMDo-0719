//
//  HistoryTableViewController.m
//  CallLiaoBei
//
//  Created by IntelcentMacMini on 16/11/10.
//  Copyright © 2016年 GeryHui. All rights reserved.
//

#import "HistoryTableViewController.h"
#import "HistoryTableCell.h"
#import "CallLogObject.h"

@interface HistoryTableViewController ()


@end

@implementation HistoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"HistoryTableCell" bundle:nil] forCellReuseIdentifier:@"HistoryTableCellID"];
    
    self.historyContentArr = [NSMutableArray array];
    [self logsReload];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logsReload) name:CallLogsUpdateNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.tableView reloadData];
}

-(void)logsReload{
    NSArray *logsArr = [CallLogObject queryTable];
    [self.historyContentArr removeAllObjects];
    
    __block NSMutableDictionary *logItemDic = [NSMutableDictionary dictionary];   //每个号码对于一个item
    __block NSMutableArray *logsItems = [NSMutableArray array];
    __block CallLogObject *showLog = nil;
    [logsArr enumerateObjectsUsingBlock:^(CallLogObject  *logObj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *phoneNum = logObj.phone;
        showLog = [logItemDic objectForKey:phoneNum];
        NSMutableArray *itemsArr = [logItemDic objectForKey:@"items"];
        if ([showLog isKindOfClass:[CallLogObject class]] && itemsArr.count >0) {
            //已存在
            [itemsArr addObject:logObj];
            
        }else{
            itemsArr = [NSMutableArray array];
            [itemsArr addObject:logObj];
            
            [logItemDic setObject:logObj forKey:phoneNum];
            [logsItems addObject:logObj];   //每组首个item
        }
        
        [logItemDic setObject:itemsArr forKey:@"items"];
        
    }];
    [self.historyContentArr addObjectsFromArray:logsItems];
//    [self.historyContentArr addObjectsFromArray:logsArr];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.historyContentArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"HistoryTableCellID";
    
    HistoryTableCell *cell = (HistoryTableCell *)[tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[HistoryTableCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
    }
    
    WkSelf(weakSelf);
    [cell setCellDetailBlock:^{
        if (weakSelf.CellDetailClickBlock) {
            weakSelf.CellDetailClickBlock(indexPath);
        }
    }];
    
    CallLogObject *logItem = self.historyContentArr[indexPath.row];
    if ([logItem isKindOfClass:[CallLogObject class]]) {
        
        if (logItem.name.length >0) {
            [cell.contactText setText:logItem.name];
            [cell.contactDes setText:logItem.phone];
        }else{
            [cell.contactText setText:logItem.phone];
            [cell.contactDes setText:@"未命名"];
        }
        
        NSDate *tmpDate = [NSDate dateWithTimeIntervalSince1970:logItem.dateTime];
        NSString *dateStr = [tmpDate dateTimeShow];
        [cell.recordDate setText:dateStr];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.CellDidSelectedBlock) {
        self.CellDidSelectedBlock(indexPath);
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //删除操作
        CallLogObject *obj = self.historyContentArr[indexPath.row];
        if ([obj isKindOfClass:[CallLogObject class]]) {
            [obj itemDeleteOfPhone];
        }
        [self.historyContentArr removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationFade)];
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.TableDidScrollBlock) {
        self.TableDidScrollBlock();
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
