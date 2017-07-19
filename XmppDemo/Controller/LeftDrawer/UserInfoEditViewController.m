//
//  UserInfoEditViewController.m
//  YinKa
//
//  Created by IntelcentMacMini on 16/10/5.
//  Copyright © 2016年 GeryHui. All rights reserved.
//  用户资料

#import "UserInfoEditViewController.h"
#import "UIImageView+WebCache.h"
#import "UserEditViewController.h"

@interface UserInfoEditViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    
    NSMutableDictionary *iconDic;   //头像数据
    NSMutableDictionary *nickDic;   //昵称数据
    NSMutableDictionary *numDic;    //号码数据
    NSMutableDictionary *sexDic;    //性别数据
    NSMutableDictionary *areaDic;    //地区数据
    
//    NSString *iconUrl;
//    NSString *nickName;
//    NSString *phoneNumber;
//    NSString *sexType;
//    NSString *areaText;
    
    NSMutableArray *contentArr;
    
    UIImageView *headImage;  //头像图片View
    UIImage *tmpPickerImg;  //临时保存的IMG对象
    UIImage *headImgObj;   //头像图片对象
    NSString *headImgUrl;  //头像URL
    BOOL infoHaveEdit;    //资料已经修改
    
    NSString *sexType;    //性别 0-未知 1-男 2-女
    NSString *sexName;   // 男-女
    NSString *nickName;   //昵称
    NSString *provinceName;  //省
    NSString *cityName;     //市
}

@property (nonatomic, retain) UIActionSheet *headerEditSheet;   //头像编辑
@property (nonatomic, retain) UIImagePickerController *imagePicker;   //图片获取picker


@end

@implementation UserInfoEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"用户资料";
    self.view.backgroundColor = RGBColor(237, 236, 242);
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self dataInit];            //初始化原始数据
    
    self.contentTable.delegate = self;
    self.contentTable.dataSource = self;
    self.contentTable.backgroundColor = [UIColor clearColor];
    self.contentTable.separatorColor = RGBColor(235, 235, 235);
    
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;

    [self updateInfo];      //当前数据
}

-(void)dataInit{
    iconDic = [[NSMutableDictionary alloc] init];
    [iconDic setObject:@"头像" forKey:@"text"];
    [iconDic setObject:@"" forKey:@"url"];
    
    nickDic = [[NSMutableDictionary alloc] init];
    [nickDic setObject:@"昵称" forKey:@"text"];
    [nickDic setObject:@"名字" forKey:@"detail"];
    
    numDic = [[NSMutableDictionary alloc] init];
    [numDic setObject:@"号码" forKey:@"text"];
    [numDic setObject:@"" forKey:@"detail"];
    
    sexDic = [[NSMutableDictionary alloc] init];
    [sexDic setObject:@"性别" forKey:@"text"];
    [sexDic setObject:@"未设置" forKey:@"detail"];
    
    areaDic = [[NSMutableDictionary alloc] init];
    [areaDic setObject:@"地区" forKey:@"text"];
    [areaDic setObject:@"未设置" forKey:@"detail"];
    
    contentArr = [[NSMutableArray alloc] initWithObjects:@[iconDic,nickDic,numDic],@[sexDic], nil];
    
//    [self setRightBarButton:@"保存" selector:@selector(leftBarClickToSave:)];
//        //初始化数据
//    ICUserInfo *userInfo = self.userInfo;
//    nickName = userInfo.nickName;
//    sexType = userInfo.sex;
//    sexName = userInfo.sexText;
//    provinceName = userInfo.province;
//    cityName = userInfo.city;
//    headImgUrl = userInfo.headImage;
}

-(void)updateInfo{
//    ICUserInfo *userInfo = self.userInfo;
//    
//    NSMutableArray *arr1 =[NSMutableArray array];
//    NSMutableArray *arr2 = [NSMutableArray array];
//        //头像
//    if (userInfo.headImage.length >0) {
//        [iconDic setObject:userInfo.headImage forKey:@"url"];
//    }
//        //昵称
//    if (nickName.length >0) {
//        [nickDic setObject:nickName forKey:@"detail"];
//    }
//        //号码
//    if (userInfo.username.length >0) {
//        [numDic setObject:userInfo.username forKey:@"detail"];
//    }
//        //性别
//    if (sexName.length >0) {
//        [sexDic setObject:sexName forKey:@"detail"];
//    }
//
//    if (provinceName.length >0) {
//        NSString *citystr = cityName.length>0?cityName:@"";
//        citystr = [NSString stringWithFormat:@"%@ %@",userInfo.province,citystr];
//        [areaDic setObject:citystr forKey:@"detail"];
//        
//    }
//    
//    [arr1 addObject:iconDic];
//    [arr1 addObject:nickDic];
//    [arr1 addObject:numDic];
//    
//    [arr2 addObject:sexDic];
////    [arr2 addObject:areaDic];
//    
//    [contentArr removeAllObjects];
//    [contentArr addObject:arr1];
//    [contentArr addObject:arr2];
//    
//    [self.contentTable reloadData];
}


-(void)popViewController{
    if (infoHaveEdit) {
//        [self popViewControllerDelay];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
    //保存用户资料
-(void)saveUserInfo{
//    self.userInfo.nickName = nickName;
//    self.userInfo.sex = sexType;
//    self.userInfo.sexText = sexName;
//    [self.userInfo saveInfo];
}

    //延时 pop
-(void)popViewControllerDelay{
    __weak UserInfoEditViewController *weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    });
}

#pragma mark 头像编辑、个人资料上传

-(void)leftBarClickToSave:(id)sender{
    if ([self userInfoIsEditChange]) {
        [self requestForUserInfoEdit:NO];
    }else{
        //资料没有修改，直接pop返回
        [self.navigationController popViewControllerAnimated:YES];
    }
}
    //用户资料修改编辑
-(void)requestForUserInfoEdit:(BOOL)popExit{
    [self MBLoadingWithText:nil];
    
//    ICUserInfo *userInfo = self.userInfo;
//    __weak UserInfoEditViewController *weakSelf = self;
//    [ICRequestTool requestForEditUserInfo:userInfo.username nickName:(NSString *)nickName qq:nil sex:sexType country:@"中国" province:provinceName city:cityName complite:^(BOOL result, NSString *errmsg, NSDictionary *jsonObj) {
//        [weakSelf MBLoading:NO];
//        if (result && jsonObj) {
//            NSString *codeStr = [jsonObj getStringValueForKey:@"code" defaultValue:@""];
//            if ([codeStr isEqualToString:@"0"]) {
//                
//                [weakSelf saveUserInfo];  //保存
//                [weakSelf popViewControllerDelay];  //延时pop
//                
//            }else{
//                errmsg = [jsonObj getStringValueForKey:@"msg" defaultValue:@"保存失败"];
//                [weakSelf showMBText:errmsg];
//                if (popExit) {
//                    [self popViewControllerDelay]; //延时pop
//                }
//            }
//            
//        }else{
//            errmsg = errmsg.length >0?errmsg:@"";
//            [weakSelf showMBText:errmsg];
//            if (popExit) {
//                [self popViewControllerDelay]; //延时pop
//            }
//        }
//        
//    }];
}

    //头像上传
-(void)requestForHeaderImageEdit{
    if (tmpPickerImg == nil) {
        NSLog(@"无头像更新");
        return;
    }
    [self MBLoadingWithText:nil];
    
//    ICUserInfo *userInfo = self.userInfo;
//    __weak UserInfoEditViewController *weakSelf = self;
//    [ICRequestTool requestForUserHeaderUpload:userInfo.username avatarValue:tmpPickerImg complite:^(BOOL result, NSString *errmsg, NSDictionary *jsonObj) {
//        
//        [weakSelf MBLoading:NO];
//        if (result && jsonObj) {
//
//            NSString *codeStr = [jsonObj getStringValueForKey:@"code" defaultValue:@""];
//            if ([codeStr isEqualToString:@"0"]) {
//                NSDictionary *dataDic = [jsonObj getDictionaryForKey:@"data"];
//                if (dataDic) {
//                    [weakSelf showMBText:@"头像上传成功"];
//                    NSString *tmpAvatar = [dataDic getStringValueForKey:@"avatar" defaultValue:@""];
//                    
//                    weakSelf.userInfo.headImage = tmpAvatar;
//                    headImgUrl = tmpAvatar;    //当前头像Url
//                    headImgObj = tmpPickerImg;  //当前头像imgObj
//
//                    [self.contentTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:(UITableViewRowAnimationNone)];
//                    
//                }else{
//                    [weakSelf showMBText:@"Data数据为空"];
//                }
//                
//            }else{
//                errmsg = [jsonObj getStringValueForKey:@"msg" defaultValue:@"上传失败"];
//                [weakSelf showMBText:errmsg];
//            }
//
//        }else{
//            errmsg = errmsg.length >0?errmsg:@"头像修改失败";
//            [weakSelf showMBText:errmsg];
//        }
//    }];
    
//    [ICRequestTool requestForEditUserHeaderImage:userInfo.username avatarValue:headImgObj complite:^(BOOL result, NSString *errmsg, NSDictionary *jsonObj) {
//        [weakSelf MBLoading:NO];
//        if (result && jsonObj) {
//            
//            NSString *codeStr = [jsonObj getStringValueForKey:@"code" defaultValue:@""];
//            if ([codeStr isEqualToString:@"0"]) {
//                [weakSelf showMBText:@"头像上传成功"];
//                [self.contentTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:(UITableViewRowAnimationNone)];
//            }else{
//                errmsg = [jsonObj getStringValueForKey:@"msg" defaultValue:@"上传失败"];
//                [weakSelf showMBText:errmsg];
//            }
//            
//        }else{
//            errmsg = errmsg.length >0?errmsg:@"头像修改失败";
//            [weakSelf showMBText:errmsg];
//        }
//        
//    }];
    
}

#pragma mark UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return contentArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *tmpArr = [contentArr objectAtIndex:section];
    if ([tmpArr isKindOfClass:[NSArray class]]) {
        return tmpArr.count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 80;
    }
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"userInfoCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    headImage = [cell.contentView viewWithTag:122];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:cellId];
        
        headImage = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width-80, 8, 80-8*2, 80-8*2)];
        headImage.tag = 122;
        headImage.layer.masksToBounds = YES;
        headImage.layer.cornerRadius = 5.0;
        headImage.backgroundColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:headImage];
    }

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section ==0) {
        if (indexPath.row == 0 || indexPath.row == 2) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    NSArray *tmpArr = [contentArr objectAtIndex:indexPath.section];
    NSDictionary *tmpDic = [tmpArr objectAtIndex:indexPath.row];
    NSString *text = [tmpDic getStringValueForKey:@"text" defaultValue:@""];
    NSString *detail = [tmpDic getStringValueForKey:@"detail" defaultValue:@""];
    if ([text isEqualToString:@"头像"]) {
        NSString *tmpUrl = [tmpDic getStringValueForKey:@"url" defaultValue:@""];
        if (headImgObj) {
            [headImage setImage:headImgObj];
        }else{
            [headImage sd_setImageWithURL:[NSURL URLWithString:tmpUrl] placeholderImage:IMAGECache(@"mine_logo.jpg")];
        }
        
    }else{
        [headImage removeFromSuperview];
    }
    
    [cell.textLabel setText:text];
    [cell.detailTextLabel setText:detail];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self userInfEditAtSection:indexPath.section row:indexPath.row];
}

#pragma mark 用户资料编辑
-(void)userInfEditAtSection:(NSInteger)section row:(NSInteger)index{
    switch (section) {
        case 0:
            switch (index) {
                case 0:
                    //头像
                    [self actionForEditHeader];
                    break;
                case 1:
                    //昵称
                    [self actionForEditNickname];
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch (index) {
                case 0:
                    //性别
                    [self actionForEditUserSex];
                    break;
                case 1:
                    //地区
                    [self actionForEditUserArea];
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
}

    /** 头像 cell Action */
-(void)actionForEditHeader{
    [self.headerEditSheet showInView:self.view];
}

    /** 昵称 cell Action */
-(void)actionForEditNickname{
    UserEditViewController *editVc = [[UserEditViewController alloc] init];
    [editVc setUserEditType:(UserEditTypeForNickname)];
//    [editVc setTmpNickName:nickName.length>0?nickName:self.userInfo.nickName];
    [self.navigationController pushViewController:editVc animated:YES];
    
    __weak UserInfoEditViewController *weakSelf = self;
    [editVc setNickNameEditBlock:^(NSString *name) {
        nickName = name;
        [weakSelf updateInfo];  //更新UI
    }];
    
}
    /** 性别 cell Action */
-(void)actionForEditUserSex{
    UserEditViewController *editVc = [[UserEditViewController alloc] init];
    [editVc setUserEditType:(UserEditTypeForSexType)];
    editVc.tmpSexName = @"男";
//    [editVc setTmpSexName:sexName.length>0?sexName:self.userInfo.sexText];
    [self.navigationController pushViewController:editVc animated:YES];
    
    __weak UserInfoEditViewController *weakSelf = self;
    [editVc setSexTypeEditBlock:^(NSString *sex, NSString *sexString) {
        sexType = sex;
        sexName = sexString;
        [weakSelf updateInfo];  //更新UI
    }];

    
}

    /** 地区 cell Action */
-(void)actionForEditUserArea{
    
}


/**** **** **** **** 头像编辑  **** **** **** **** */

-(UIActionSheet *)headerEditSheet{
    if (_headerEditSheet == nil) {
//        _headerEditSheet = [[UIActionSheet alloc] initWithTitle:nil
//                                                       delegate:self
//                                              cancelButtonTitle:@"取消"
//                                         destructiveButtonTitle:nil
//                                              otherButtonTitles:@"查看大图",@"拍照",@"从手机相册选择",@"保存图片", nil];
        
        _headerEditSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"拍照",@"从手机相册选择",@"保存图片", nil];
    }
    return _headerEditSheet;
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.numberOfButtons -1 == buttonIndex) {
        //取消
        return;
    }
    
    switch (buttonIndex) {
        case 3:
        {
            //查看大图
            [self showOriginalHeaderImage];
        }
            break;
        case 0:
        {
            // 拍照
            [self showImagePickerViewType:(UIImagePickerControllerSourceTypeCamera)];
        }
            
            break;
        case 1:
        {
            //从手机相册选择
            [self showImagePickerViewType:(UIImagePickerControllerSourceTypeSavedPhotosAlbum)];
        }
            break;
        case 2:
        {
            //保存图片
            [self saveCurrentHeaderImage];
        }
            break;
        default:
            break;
    }
}


/**** **** 查看大图、显示原始大图  **** **** */
-(void)showOriginalHeaderImage{
    
}


/**** **** 拍照、手机相册选择  **** **** */

-(void)showImagePickerViewType:(UIImagePickerControllerSourceType)sourceType{
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        self.imagePicker.sourceType = sourceType;
        self.imagePicker.allowsEditing = YES;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self showMBText:@"获取图片失败"];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    __weak UserInfoEditViewController *weakSelf = self;
    
    [picker dismissViewControllerAnimated:NO completion:^{
       
        UIImage *resultImg = [info objectForKey:UIImagePickerControllerEditedImage];
        if ([resultImg isKindOfClass:[UIImage class]]) {
            tmpPickerImg = resultImg;
        }
        [weakSelf requestForHeaderImageEdit];  //头像上传
        
    }];
}


/**** **** 保存图片  **** **** */
-(void)saveCurrentHeaderImage{
//    NSString *imgStr = self.userInfo.headImage;
//    if (imgStr.length >0) {
//        NSURL *imgUrl = [NSURL URLWithString:imgStr];
//        if (imgUrl && headImage.image) {
//            UIImageWriteToSavedPhotosAlbum(headImage.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//        }
//    }
    

    if (headImgUrl.length >0) {
        if (headImgObj) {
            UIImageWriteToSavedPhotosAlbum(headImgObj, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }else{
            
            [self MBLoadingWithText:@"保存中"];
            __weak UserInfoEditViewController *weakSelf = self;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                __block UIImage *tmpImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:headImgUrl]]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    headImgObj = tmpImg;
                    UIImageWriteToSavedPhotosAlbum(headImgObj, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
                    
                    [weakSelf MBLoading:NO];
                });
            });
        }
    }else{
        [self showMBText:@"保存失败"];
    }
    
}

-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)context{
    NSLog(@"保存到本地相册");
    if (error) {
        NSLog(@"保存到本地相册 Error :%@",error.description);
    }else{
        [self showMBText:@"保存成功"];
    }
}


#pragma mark 判断是否有编辑改动
-(BOOL)userInfoIsEditChange{
    BOOL isEdit = NO;
//    ICUserInfo *userInfo = self.userInfo;
//    if ([nickName isEqualToString:userInfo.nickName] == NO) {
//        isEdit = YES;
//    }else if ([sexType isEqualToString:userInfo.sex] == NO || [sexName isEqualToString:sexName] == NO){
//        isEdit = YES;
//    }else if ([provinceName isEqualToString:userInfo.province] == NO || [cityName isEqualToString:userInfo.city] == NO){
//        
//    }
    
    return isEdit;
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
