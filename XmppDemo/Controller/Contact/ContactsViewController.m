//
//  ContactsViewController.m
//  WHIMDemo1
//
//  Created by Gery晖 on 17/4/7.
//  Copyright © 2017年 wh_shine. All rights reserved.
//

#import "ContactsViewController.h"
#import "ContactTableCell.h"
#import "ContactDetailViewController.h"
#import "UIImage+Color.h"

@interface ContactsViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>{
    NSMutableArray *sectionIndexArr;  //索引
}


@property (nonatomic, retain) NSMutableArray *addressData;  //联系人数据(已排序)
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;

@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"通讯录";
    
    //通讯录 、索引
    self.searchBar.delegate = self;
    
    [self.searchBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorGrayBG]]];
    [self.searchBar setBarTintColor:[UIColor colorGrayBG]];
    [self.searchBar setTintColor:[UIColor colorGreenDefault]];
    
    self.addressData = [NSMutableArray array];
    sectionIndexArr = [[NSMutableArray alloc] init];
    [self AddressBookFinishLoad];
    
    self.addressList.delegate = self;
    self.addressList.dataSource = self;
    self.addressList.separatorStyle = UITableViewCellSelectionStyleNone;
        //索引背景色、字体颜色
    [self.addressList setSectionIndexColor:AppMainColor];
    [self.addressList setSectionIndexBackgroundColor:[UIColor clearColor]];
    
    [self.addressList registerNib:[UINib nibWithNibName:@"ContactTableCell" bundle:nil] forCellReuseIdentifier:@"ContactTableCellID"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddressBookFinishLoad) name:@"AddressBookFinishLoad" object:nil];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AddressBookFinishLoad" object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (_addressData.count == 0) {
        [self AddressBookFinishLoad];
    }
}

//读取完成
-(void)AddressBookFinishLoad{
    [self.addressData removeAllObjects];
    [self.addressData addObjectsFromArray:self.addressBook.contactsSortData];
    [self sectionIndexArrar];
    [self.addressList reloadSectionIndexTitles];
    [self.addressList reloadData];
}
-(void)sectionIndexArrar{
    [sectionIndexArr removeAllObjects];
    [self.addressData enumerateObjectsUsingBlock:^(NSDictionary  *charArrDic , NSUInteger idx, BOOL * _Nonnull stop) {
        if ([charArrDic isKindOfClass:[NSDictionary class]]) {
            NSString *tmpChar = [[charArrDic allKeys] firstObject];
            [sectionIndexArr addObject:tmpChar];
        }
    }];
}

#pragma UISearchBar 通讯录检索
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length == 0) {
        [self searchTextChange:nil];
    }else{
        [self searchTextChange:searchText];
    }
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self searchTextChange:nil];
}

-(void)searchTextChange:(NSString *)searchText{
    if (searchText.length == 0) {
        [self AddressBookFinishLoad];
        return;
    }
    
    WkSelf(weakSelf);
    dispatch_async(GCDQueueDEFAULT, ^{
        CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
        NSArray *contacsArr = [NSArray arrayWithArray:weakSelf.addressBook.contactsSortData];
        __block NSMutableArray *resultArr = [NSMutableArray array];
        
        [contacsArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSString *tmpChar = [[obj allKeys] firstObject];
                NSArray *oncCharArr = [[obj allValues] firstObject];
                
                NSMutableArray *charResultArr = [NSMutableArray array];
                if (tmpChar.length >0 && [oncCharArr isKindOfClass:[NSArray class]]) {
                    for (ContactModel *model in oncCharArr) {
                        if ([model isKindOfClass:[ContactModel class]] && [model isFitFromSearchText:searchText]) {
                            [charResultArr addObject:model];
                        }
                    }
                    
                    if (charResultArr.count >0) {
                        [resultArr addObject:@{tmpChar:charResultArr}];
                    }
                }
            }
            
        }];
        
        CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();
        NSLog(@"检索耗时:%.4f",end-start);
        
        dispatch_async(GCDQueueMain, ^{
            
            [weakSelf.addressData removeAllObjects];
            [weakSelf.addressData addObjectsFromArray:resultArr];
            [weakSelf sectionIndexArrar];
            [weakSelf.addressList reloadSectionIndexTitles];
            
            [UIView transitionWithView:weakSelf.addressList duration:0.1 options:(UIViewAnimationOptionTransitionCrossDissolve) animations:^{
                [weakSelf.addressList reloadData];
            } completion:nil];
            
        });
        
    });
}

#pragma mark UITableView Delegate
//索引
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return sectionIndexArr;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (sectionIndexArr.count >0) {
        return sectionIndexArr[section];
    }
    return @"";
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 18;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.addressData.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *secDic = self.addressData[section];
    if ([secDic isKindOfClass:[NSDictionary class]] && secDic.count >0) {
        NSArray *rowArr = [[secDic allValues] firstObject];
        if ([rowArr isKindOfClass:[NSArray class]]) {
            return rowArr.count;
        }
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"ContactTableCellID";
    ContactTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[ContactTableCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
    }
    
    NSDictionary *secDic = self.addressData[indexPath.section];
    if ([secDic isKindOfClass:[NSDictionary class]] && secDic.count >0) {
        NSArray *rowArr = [[secDic allValues] firstObject];
        if ([rowArr isKindOfClass:[NSArray class]]) {
            ContactModel *model = (ContactModel *)[rowArr objectAtIndex:indexPath.row];
            [cell setDataItem:model];
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *secDic = self.addressData[indexPath.section];
    if ([secDic isKindOfClass:[NSDictionary class]] && secDic.count >0) {
        NSArray *rowArr = [[secDic allValues] firstObject];
        if ([rowArr isKindOfClass:[NSArray class]]) {
            ContactModel *model = (ContactModel *)[rowArr objectAtIndex:indexPath.row];
            
            ContactDetailViewController *detailVC = [[ContactDetailViewController alloc] init];
            [detailVC setItemModel:model];
            [self pushViewController:detailVC];
        }
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self viewEndEdit];
}

-(void)viewEndEdit{
    [self.view endEditing:YES];
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
