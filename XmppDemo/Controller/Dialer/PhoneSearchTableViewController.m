//
//  PhoneSearchTableViewController.m
//  CallLiaoBei
//
//  Created by IntelcentMacMini on 16/11/9.
//  Copyright © 2016年 GeryHui. All rights reserved.
//  号码检索table

#import "PhoneSearchTableViewController.h"
#import "PhoneSearchCell.h"
#import "AddressbookObject.h"


@interface PhoneSearchTableViewController ()


@end

@implementation PhoneSearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchPhoneArr = [NSMutableArray array];
    self.tableView.separatorColor = RGBColor(235, 235, 235);
    [self.tableView registerNib:[UINib nibWithNibName:@"PhoneSearchCell" bundle:nil] forCellReuseIdentifier:@"SearchPhoneCellID"];
    
//    self.errorView = [NetworkErrorView errorViewInView:nil target:self didClickBlock:^{
//        
//    }];
//    
//    [self.tableView setTableHeaderView:self.errorView];
    
    
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

    return self.searchPhoneArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"SearchPhoneCellID";
    PhoneSearchCell *cell = (PhoneSearchCell *)[tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    ContactModel *model = self.searchPhoneArr[indexPath.row];
    if ([model isKindOfClass:[ContactModel class]]) {
        [cell.phoneLabel setText:model.dialerPhone];
        [cell.nameLabel setText:model.name];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.CellDidSelectedBlock) {
        self.CellDidSelectedBlock(indexPath);
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
