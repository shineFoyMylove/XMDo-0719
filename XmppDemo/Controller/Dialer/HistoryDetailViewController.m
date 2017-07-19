//
//  HistoryDetailViewController.m
//  CallLiaoBei
//
//  Created by IntelcentMacMini on 16/11/11.
//  Copyright © 2016年 GeryHui. All rights reserved.
// 通话记录详情

#import "HistoryDetailViewController.h"
#import "HistoryDetailCell.h"
#import "BaseNaviViewController.h"

#import <AddressBookUI/AddressBookUI.h>
#import "AddressbookObject.h"

@interface HistoryDetailViewController ()<UITableViewDelegate,UITableViewDataSource,ABNewPersonViewControllerDelegate,ABPeoplePickerNavigationControllerDelegate>{
    IBOutlet NSLayoutConstraint *contactAddHeight;
    BOOL logsReload;
    IBOutlet UIButton *callButton;
    
}

@property (nonatomic, retain) IBOutlet UILabel *NameLabel;
@property (nonatomic, retain) IBOutlet UILabel *PhoneLabel;
@property (nonatomic, retain) IBOutlet UIImageView *HeaderImage;


@property (nonatomic, retain) NSMutableArray *logsItemArray;


@end

@implementation HistoryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"通话详情";
    
    self.logsItemArray = [NSMutableArray array];
    if (self.logItem.phone) {
        [self queryLogs];
    }
    
    [self.NameLabel setText:_logItem.name];
    [self.PhoneLabel setText:_logItem.phone];
    if (_logItem.name.length > 0) {
        contactAddHeight.constant = 0;
    }else{
        [self.NameLabel setText:@"未知号码"];
    }
    
    self.logsTable.delegate = self;
    self.logsTable.dataSource = self;
//    self.logsTable.separatorColor = RGBColor(235, 235, 235);
    self.logsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.logsTable registerNib:[UINib nibWithNibName:@"HistoryDetailCell" bundle:nil] forCellReuseIdentifier:@"HistoryDetailCellID"];
    
    [callButton setBackgroundImage:[UIImage imageWithColor:RGBColor(240, 240, 240) cornerRadius:0.0]  forState:(UIControlStateHighlighted)];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
        //回调刷新通话记录
    if (logsReload) {
        [[NSNotificationCenter defaultCenter] postNotificationName:CallLogsUpdateNotification object:nil];
    }
}

-(void)queryLogs{
    NSArray *queryArr = [CallLogObject queryLogsWithPhone:_logItem.phone personId:_logItem.personId];
    if (queryArr) {
        [self.logsItemArray addObjectsFromArray:queryArr];
    }
}

-(IBAction)ClickToCall:(id)sender{
    
    [self dialerCall:_logItem.phone name:_logItem.name];
}


#pragma mark 添加联系人
    //创建新联系人
-(IBAction)ClickToAddNewPerson:(id)sender{
    if ([AddressbookObject isAccessable] == NO) {
        [self.appManager.addressBook showAddressBookAcceableTips];
        return;
    }
    
    ABRecordRef personItem = ABPersonCreate();
    ABMutableMultiValueRef multiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    CFErrorRef error = NULL;
    ABMultiValueAddValueAndLabel(multiValue, (__bridge CFTypeRef)(_logItem.phone), kABPersonPhoneMobileLabel, NULL);
    ABRecordSetValue(personItem, kABPersonPhoneProperty, multiValue, &error);
    
    ABNewPersonViewController *newPersonVc = [[ABNewPersonViewController alloc] init];
    newPersonVc.displayedPerson = personItem;
    newPersonVc.newPersonViewDelegate = self;
    
    [self pushViewController:newPersonVc];
    
    if(multiValue)  CFRelease(multiValue);
    if(personItem)  CFRelease(personItem);
}

    //NewPersonViewDelegate
-(void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person{
    if (newPersonView.navigationController.viewControllers.count >1) {
        [newPersonView.navigationController popViewControllerAnimated:YES];
    }
    
    if ([newPersonView respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [newPersonView dismissViewControllerAnimated:YES completion:nil];
    }
    if (person) {
        NSLog(@"编辑完成");
        ContactModel *editModel = [[ContactModel alloc] init];
        [editModel updateWithPersonItem:person];   //person 转数据模型
            //需要更新的属性
        _logItem.name = editModel.name;
        _logItem.personId = editModel.personId;
        
        //update sql 号码被修改，更新db
        if ([self.logItem itemUpdateOfPhone]) {
            [self.NameLabel setText:editModel.name];  //修改
            logsReload = YES;  //标识已经修改，回调刷新
        }
        
    }
}

    //添加到现有联系人
-(IBAction)ClickToPersonAddNewPhone:(id)sender{
    if ([AddressbookObject isAccessable] == NO) {
        [self.appManager.addressBook showAddressBookAcceableTips];
        return;
    }
    
    ABPeoplePickerNavigationController *peoplePickerVc = [[ABPeoplePickerNavigationController alloc] init];
    peoplePickerVc.peoplePickerDelegate = self;
    [self presentViewController:peoplePickerVc animated:YES completion:nil];
}

#if XCODE_ALLOWED_IOS8_OR_LATER
// Called after a person has been selected by the user.
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person NS_AVAILABLE_IOS(8_0){
    
    NSString *phoneNumSaved = self.PhoneLabel.text;
    if([peoplePicker respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]){
        WkSelf(weakSelf);

        [peoplePicker dismissViewControllerAnimated:YES completion:^{
            ABNewPersonViewController *personVc = [[ABNewPersonViewController alloc] init];
            
            ABMultiValueRef phonesRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
            ABMutableMultiValueRef multiValue = ABMultiValueCreateMutableCopy(phonesRef);
            
            if(multiValue){
                BOOL setValue = ABMultiValueAddValueAndLabel(multiValue, (__bridge CFTypeRef)(phoneNumSaved), kABPersonPhoneMobileLabel, NULL);
                NSLog(@"号码写入:%@",setValue?@"成功":@"失败");
            }
            
            CFErrorRef error = NULL;
            ABRecordSetValue(person, kABPersonPhoneProperty, multiValue, &error);
            if(phonesRef)   CFRelease(phonesRef);
            if(multiValue)  CFRelease(multiValue);
            
            personVc.displayedPerson = person;
            personVc.newPersonViewDelegate = self;
            [weakSelf.navigationController pushViewController:personVc animated:YES];
        }];
    }
    
    NSLog(@"%s",__func__);
}

// Called after a property has been selected by the user.
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier NS_AVAILABLE_IOS(8_0){
    NSLog(@"%s",__func__);
}

#endif


// Deprecated, use predicateForSelectionOfPerson and/or -peoplePickerNavigationController:didSelectPerson: instead.
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person NS_DEPRECATED_IOS(2_0, 8_0){
    
    NSString *phoneNumSaved = self.PhoneLabel.text;
    if([peoplePicker respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]){
        WkSelf(weakSelf);
        
        [peoplePicker dismissViewControllerAnimated:YES completion:^{
            ABNewPersonViewController *personVc = [[ABNewPersonViewController alloc] init];
            
            ABMultiValueRef phonesRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
            ABMutableMultiValueRef multiValue = ABMultiValueCreateMutableCopy(phonesRef);
            
            if(multiValue){
                BOOL setValue = ABMultiValueAddValueAndLabel(multiValue, (__bridge CFTypeRef)(phoneNumSaved), kABPersonPhoneMobileLabel, NULL);
                NSLog(@"号码写入:%@",setValue?@"成功":@"失败");
            }
            
            CFErrorRef error = NULL;
            ABRecordSetValue(person, kABPersonPhoneProperty, multiValue, &error);
            if(phonesRef)   CFRelease(phonesRef);
            if(multiValue)  CFRelease(multiValue);
            
            personVc.displayedPerson = person;
            personVc.newPersonViewDelegate = self;
            [weakSelf.navigationController pushViewController:personVc animated:YES];
        }];
    }
    
    NSLog(@"%s",__func__);
    return YES;
}

//取消操作
-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    if ([peoplePicker respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [peoplePicker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.logsItemArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"HistoryDetailCellID";
    HistoryDetailCell *cell = (HistoryDetailCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[HistoryDetailCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
    }
    
    CallLogObject *obj = self.logsItemArray[indexPath.row];
    [cell setDetailItem:obj];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //删除操作
        CallLogObject *obj = self.logsItemArray[indexPath.row];
        if ([obj isKindOfClass:[CallLogObject class]]) {
            [obj itemDelete];
        }
        [self.logsItemArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationFade)];
        
        logsReload = YES;
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
