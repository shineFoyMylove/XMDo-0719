//
//  ContactDetailViewController.m
//  CallLiaoBei
//
//  Created by IntelcentMacMini on 16/11/11.
//  Copyright © 2016年 GeryHui. All rights reserved.
//

#import "ContactDetailViewController.h"
#import "AddressbookObject.h"
#import "ContactDetailCell.h"


@interface ContactDetailViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *phonesArr;
}

@property (strong, nonatomic) IBOutlet UILabel *NameLabe;
@property (strong, nonatomic) IBOutlet UIImageView *HeadImage;

@end

@implementation ContactDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"联系人详情";
    self.view.backgroundColor  = AppMainBgColor;
    
    self.phonesTable.delegate = self;
    self.phonesTable.dataSource = self;
    self.phonesTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.phonesTable registerNib:[UINib nibWithNibName:@"ContactDetailCell" bundle:nil] forCellReuseIdentifier:@"ContactDetailCellID"];
    
    [self updateUI];
}

-(void)updateUI{
    if ([self.itemModel isKindOfClass:[ContactModel class]]) {
        [self.NameLabe setText:_itemModel.name];
        if (_itemModel.phones.count >0) {
            phonesArr = [[NSArray alloc] initWithArray:_itemModel.phones];
        }
    }
}


#pragma mark UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return phonesArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"ContactDetailCellID";
    ContactDetailCell *cell = (ContactDetailCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[ContactDetailCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
    }
    
    [cell.phoneLab setText:[phonesArr objectAtIndex:indexPath.row]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *tmpPhone = [phonesArr objectAtIndex:indexPath.row];
    
    self.itemModel.dialerPhone = tmpPhone;
    [self dialerCall:_itemModel.dialerPhone name:_itemModel.name];
    
//    [self dialerCall:tmpPhone name:tmpName];
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
