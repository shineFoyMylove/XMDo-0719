//
//  UserEditViewController.m
//  YinKa
//
//  Created by IntelcentMacMini on 16/10/7.
//  Copyright © 2016年 GeryHui. All rights reserved.
//

#import "UserEditViewController.h"

@interface UserEditViewController ()<UITableViewDelegate,UITableViewDataSource>{
    //昵称
    UIView *nickNameView;
    UITextField *nickNameField;
    
    //性别
    UITableView *sexSelTable;
    NSString *currentSex;   //当前选中性别
}

@property (nonatomic, assign) UserEditType editType;

@end

@implementation UserEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    switch (self.editType) {
        case UserEditTypeForNickname:
            //昵称编辑
            [self createNicknameEditView];
            [self addRightBarItem];
            
            break;
        case UserEditTypeForSexType:
            //性别编辑
            [self createUserSexEditView];
            break;
            
        default:
            break;
    }
}

-(void)addRightBarItem{
    UIButton *tmpBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [tmpBtn setFrame:CGRectMake(0, 0, 60, 40)];
    [tmpBtn setTitle:@"确定" forState:(UIControlStateNormal)];
//    tmpBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
//    [tmpBtn setTitleColor:ICMainColor forState:(UIControlStateNormal)];
    [tmpBtn addTarget:self action:@selector(confirmCurrentEditing) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:tmpBtn];
    self.navigationItem.rightBarButtonItem = barItem;
}

    //编辑内容type
-(void)setUserEditType:(UserEditType)editType{
    self.editType = editType;
}

    //确定修改
-(void)confirmCurrentEditing{
    [self.view endEditing:YES];
    
    if (nickNameField.text == 0) {
        [self showMBText:@"昵称不能为空"];
        return;
    }
    
    if (self.nickNameEditBlock) {
        self.nickNameEditBlock(nickNameField.text);
    }
    
    [self popExit];  //成功pop
}
//    //编辑成功pop
//-(void)editSuccess{
//    __weak UserEditViewController *weakSelf = self;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [weakSelf.navigationController popViewControllerAnimated:YES];
//    });
//}

#pragma mark  昵称编辑
    /** ********** 昵称编辑   *********** */
-(void)createNicknameEditView{
    nickNameView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.width, 40)];
    nickNameView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:nickNameView];
    
    nickNameField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, self.view.width-10*2, 40)];
    nickNameField.clearButtonMode = UITextFieldViewModeWhileEditing;  //显示删除x
    nickNameField.placeholder = @"请输入昵称";
    [nickNameView addSubview:nickNameField];
    
    [nickNameField setText:self.tmpNickName];  //默认昵称
}


/** ********** 性别编辑   *********** */
-(void)createUserSexEditView{
    sexSelTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-20) style:(UITableViewStyleGrouped)];
    sexSelTable.backgroundColor = [UIColor clearColor];
    sexSelTable.delegate = self;
    sexSelTable.dataSource = self;
    sexSelTable.separatorColor = RGBColor(235, 235, 235);
    [self.view addSubview:sexSelTable];
    
    currentSex = self.tmpSexName;  //当前默认性别
    
}
#pragma mark 性别选中Table
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"UserEditCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    UIImageView *tickIcon = [cell.contentView viewWithTag:233];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
        
        CGFloat iconWith = 20;
        tickIcon = [[UIImageView alloc] initWithFrame:CGRectMake(cell.width-40, (cell.height-20)/2, iconWith, iconWith)];
        tickIcon.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        tickIcon.image = IMAGECache(@"ic_correct.png");
        tickIcon.tag = 233;
        [cell.contentView addSubview:tickIcon];
    }
    
    NSString *sex = @"";
    if (indexPath.row == 0) {
        //男
        sex = @"男";
    }else{
        sex = @"女";
    }
    
    [cell.textLabel setText:sex];
    
    if ([sex isEqualToString:currentSex]) {
        [tickIcon setHidden:NO];
    }else{
        [tickIcon setHidden:YES];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *sexType = @"";
    if (indexPath.row == 0) {
        currentSex = @"男";
        sexType = @"1";
    }else{
        currentSex = @"女";
        sexType = @"2";
    }
   
    if (self.sexTypeEditBlock) {
        self.sexTypeEditBlock(sexType,currentSex);
    }
    [self popExit];
}

-(void)popExit{
    [self.navigationController popViewControllerAnimated:YES];
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
