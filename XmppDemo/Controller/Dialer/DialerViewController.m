//
//  DialerViewController.m
//  WHIMDemo1
//
//  Created by Gery晖 on 17/4/10.
//  Copyright © 2017年 wh_shine. All rights reserved.
//

#import "DialerViewController.h"
#import "AdScrollView.h"
#import "NumberKeyboard.h"
#import "ICWebViewController.h"
#import "UIAddressTextField.h"
#import "MainTabBarController.h"

@interface DialerViewController (){
    IBOutlet NSLayoutConstraint *kbViewHeightConstraint;   //键盘高度
    CGFloat adviewHeihgt;   //广告高度
    
    BOOL inSearch;   //是否处于检索
    BOOL kbIsHidden;   //键盘是否隐藏
    BOOL phoneIsClear;   //页面切换清除号码
    
}

@property (nonatomic, retain) IBOutlet UIView *TitleView;
@property (nonatomic, weak) IBOutlet UIView *navLogoView;  
@property (nonatomic, retain) IBOutlet UIAddressTextField *phoneField;
@property (nonatomic, retain) IBOutlet UILabel *appNameLab;    //

@property (nonatomic, retain) IBOutlet NumberKeyboard *keyboardView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *KeyboardBottom;

@property (nonatomic, assign) CGFloat adViewRadioPresent;   //广告高宽比
@property (nonatomic, retain) AdScrollView *adverScrollView;  //滚动广告
@property (nonatomic, retain) NSMutableArray *dialerAdverData;   //拨号页大图广告

//隐藏，拨号，退格 toolView
@property (nonatomic, retain) IBOutlet UIView *KbToolView;
@property (nonatomic, weak) IBOutlet UIButton *kbHideBtn;
@property (nonatomic, weak) IBOutlet UIButton *kbCallBtn;
@property (nonatomic, weak) IBOutlet UIButton *kbDeleteBtn;
@property (nonatomic, weak) IBOutlet UIImageView *kbHideImageIcon;

@end

@implementation DialerViewController

-(AdScrollView *)adverScrollView{
    if (_adverScrollView == nil) {
        _adverScrollView = [[AdScrollView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, adviewHeihgt)];
        _adverScrollView.PageControlShowStyle = UIPageControlShowStyleCenter;
        
        WkSelf(weakSelf);
        _adverScrollView.didTapBlock = ^(NSInteger index){
            NSLog(@"ImageDidTap:  %ld",(long)index);
            
            if (weakSelf.dialerAdverData.count > index) {
                NSDictionary *tmpItemDic = weakSelf.dialerAdverData[index];
                if ([tmpItemDic isKindOfClass:[NSDictionary class]]) {
                    NSString *tmpUrl = [tmpItemDic getStringValueForKey:@"link" defaultValue:@""];
                    NSString *title = [tmpItemDic getStringValueForKey:@"txt" defaultValue:@""];
                    
                    ICWebViewController *webVc = [[ICWebViewController alloc] init];
                    webVc.Url = tmpUrl;
                    webVc.WebTitle = title;
                    [weakSelf.navigationController pushViewController:webVc animated:YES];
                }
            }
            
        };
        
    }
    return _adverScrollView;
}

-(void)setAdViewRadioPresent:(CGFloat)adViewRadioPresent{
    if (adViewRadioPresent <0 || adViewRadioPresent >1) {
        adViewRadioPresent = 0.7;   //高 比 宽
    }
    _adViewRadioPresent = adViewRadioPresent;
    
    adviewHeihgt = Main_Screen_Width *adViewRadioPresent;
    CGFloat kbHeight = Main_Screen_Height-64-49-adviewHeihgt;
    kbViewHeightConstraint.constant = kbHeight;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    self.adViewRadioPresent = 0.75;
    [self.TitleView setFrame:CGRectMake(0, 0, Main_Screen_Width, 44)];
    self.navigationItem.titleView = self.TitleView;
    [self.appNameLab setText:App_displayName];
    
    UIColor *selColor = RGBColor(240, 240, 240);
    [self.kbCallBtn setBackgroundImage:[UIImage imageWithColor:selColor cornerRadius:0.0] forState:(UIControlStateHighlighted)];
    [self.kbHideBtn setBackgroundImage:[UIImage imageWithColor:selColor cornerRadius:0.0] forState:(UIControlStateHighlighted)];
    [self.kbDeleteBtn setBackgroundImage:[UIImage imageWithColor:selColor cornerRadius:0.0] forState:(UIControlStateHighlighted)];
    
        //键盘
    WkSelf(weakSelf);
    [self.keyboardView setKeyboardDidTapBlock:^(NSInteger tapNum, NumberKeyboardTextStyle textStyle) {
        
        NSString *curText = weakSelf.phoneField.text;
        if (tapNum <10 && textStyle == NumberKeyboardTextStyleNumber) {
            //1-9
            curText = [NSString stringWithFormat:@"%@%ld",curText,(long)tapNum];
            NSLog(@"点击 : %d",(int)tapNum);
        }else if (tapNum == 11 & textStyle == NumberKeyboardTextStyleNumber){
            //0
            curText = [NSString stringWithFormat:@"%@0",curText];
            NSLog(@"点击: 0");
        }
        
        switch (textStyle) {
            case NumberKeyboardTextStylePaste:
            {
                NSLog(@"点击: 粘贴");
                NSString *pasteStr = [UIPasteboard generalPasteboard].string;
                if (pasteStr.length) {
                    curText = pasteStr;
                }else{
//                    [weakSelf SVWithText:@"粘贴内容为空"];
                }
            }
                break;
            case NumberKeyboardTextStyleAdd:
                NSLog(@"点击: 添加联系人");
            {
//                ABNewPersonViewController *newPersonVc = [[ABNewPersonViewController alloc] init];
//                if (weakSelf.phoneField.text.length >0) {
//                    
//                    ABRecordRef personItem = ABPersonCreate();
//                    ABMutableMultiValueRef multiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
//                    CFErrorRef error = NULL;
//                    ABMultiValueAddValueAndLabel(multiValue, (__bridge CFTypeRef)(weakSelf.phoneField.text), kABPersonPhoneMobileLabel, NULL);
//                    ABRecordSetValue(personItem, kABPersonPhoneProperty, multiValue, &error);
//                    //保存已输入的号码
//                    newPersonVc.displayedPerson = personItem;
//                    
//                    if(multiValue)  CFRelease(multiValue);
//                    if(personItem)  CFRelease(personItem);
//                }
//                
//                newPersonVc.newPersonViewDelegate = weakSelf;
//                [weakSelf pushViewController:newPersonVc];
                
            }
                break;
            case NumberKeyboardTextStyleSetting:
                NSLog(@"点击: 设置");
                break;
            case NumberKeyboardTextStyleDelete:
                NSLog(@"点击: 退格键");
            {
                if (curText.length>0) {
                    curText = [curText substringWithRange:NSMakeRange(0, curText.length-1)];  //-1
                }
            }
                break;
            default:
                break;
        }
        
        [weakSelf.phoneField setText:curText];
        
    }];
    
    //通话记录Table滚动隐藏键盘
    [self.historyVC setTableDidScrollBlock:^{
        [weakSelf keyboardViewHidden:YES];
    }];
    
    //通话记录列表Cell点击查看 详情
    [self.historyVC setCellDetailClickBlock:^(NSIndexPath *indexPath) {
        if (weakSelf.historyVC.historyContentArr.count > indexPath.row) {
            HistoryDetailViewController *historyDetailVc = [[HistoryDetailViewController alloc] init];
            CallLogObject *tmpLog = weakSelf.historyVC.historyContentArr[indexPath.row];
            [historyDetailVc setLogItem:tmpLog];
            [weakSelf pushViewController:historyDetailVc];
        }
    }];
    
    //通话记录cell点击拨号
    [self.historyVC setCellDidSelectedBlock:^(NSIndexPath *indexpath) {
        NSLog(@"index: section:%ld , row:%ld",(long)indexpath.section,(long)indexpath.row);
        if (weakSelf.historyVC.historyContentArr.count > indexpath.row) {
            CallLogObject *model = weakSelf.historyVC.historyContentArr[indexpath.row];
            if ([model isKindOfClass:[CallLogObject class]]) {
                [weakSelf CallActionForItem:nil phone:model.phone];
            }
        }
    }];
    
    //检索table滚动，键盘隐藏
    [self.searchVC setTableDidScrollBlock:^{
        [weakSelf keyboardViewHidden:YES];
    }];
    
    //号码检索列表cell点击拨号
    [self.searchVC setCellDidSelectedBlock:^(NSIndexPath *indexpath) {
        NSLog(@"index: section:%ld , row:%ld",(long)indexpath.section,(long)indexpath.row);
        if (weakSelf.searchVC.searchPhoneArr.count > indexpath.row) {
            ContactModel *model = weakSelf.searchVC.searchPhoneArr[indexpath.row];
            if ([model isKindOfClass:[ContactModel class]]) {
                [weakSelf CallActionForItem:model phone:nil];
            }
        }
    }];
    
    [self setupAdverImageView];  //初始化广告View
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (phoneIsClear == NO) {
        [self.KbToolView setHidden:NO];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if (phoneIsClear) {
        [self.phoneField setText:nil];
        phoneIsClear = NO;
    }else{
        [self.KbToolView setHidden:YES];
    }
}

#pragma mark 滚动广告

-(void)setupAdverImageView{
    self.adverScrollView.imageNameArray = [NSArray arrayWithObjects:@"adver_image1.jpg",@"adver_image2.jpg",@"adver_image3.jpg", nil];
    [self.view addSubview:self.adverScrollView];
}

#pragma mark 拨号

-(void)CallActionForItem:(ContactModel *)model phone:(NSString *)number{
 
    if (model) {
        if ([self dialerCall:model.dialerPhone name:model.name]) {
            phoneIsClear = YES;
        }
    }else{
        if ([self dialerCall:number name:nil]) {
            phoneIsClear = YES;  //页面切换清除号码
        }
    }
}


#pragma mark  *** Button Action
-(IBAction)ClickToCall:(id)sender{
    NSString *curPhone = self.phoneField.text;
    
    [self CallActionForItem:nil phone:curPhone];
}
    //点击logo 侧栏
-(IBAction)navLogoClick:(id)sender{
    [self.ShareApp.DrawerController openDrawerSide:(MMDrawerSideLeft) animated:YES completion:nil];
}


#pragma mark Keyboard ToolView Action 隐藏、拨号、退格
//隐藏键盘
-(IBAction)KbToolClickHidden:(id)sender{
    kbIsHidden = !kbIsHidden;
    
    [self keyboardViewHidden:kbIsHidden];  //键盘
    
    WkSelf(weakSelf);
    if (kbIsHidden) {
        //隐藏- 转180度
        weakSelf.kbHideImageIcon.transform = CGAffineTransformMakeRotation(M_PI);
    }else{
        
        weakSelf.kbHideImageIcon.transform = CGAffineTransformMakeRotation(0.0);
    }
    
}
//拨打号码
-(IBAction)KbToolClickDialerCall:(id)sender{
    [self ClickToCall:nil];
}

//退格键删除号码
-(IBAction)KbToolClickToDeleteNumber:(id)sender{
    NSString *curText = self.phoneField.text;
    if (curText.length>0) {
        curText = [curText substringWithRange:NSMakeRange(0, curText.length-1)];  //-1
    }
    [self.phoneField setText:curText];
    
    //退格键 当号码为空，show键盘
    if (self.phoneField.text.length == 0) {
        
    }
}

#pragma mark 号码检索
-(IBAction)inputPhoneChange:(UITextField *)sender{
    NSLog(@"当前号码:%@",sender.text);
    WkSelf(weakSelf);
    if ([sender isKindOfClass:[UITextField class]]) {
        NSString *curNum = sender.text;
        
        if (curNum.length >0) {
            
            [self.appNameLab setHidden:YES];
            [self.navLogoView setHidden:YES];
            [self showKeyboardToolSearchingNumber:YES];   //Show Tool
            
            [UIView animateWithDuration:0.2 animations:^{
                weakSelf.historyTable.alpha = 0.0;
                weakSelf.adverScrollView.alpha = 0.0;
            } completion:^(BOOL finished) {
                [weakSelf.historyTable setHidden:YES];
                [weakSelf.adverScrollView setHidden:YES];
            }];
            
            inSearch = YES;
            
        }
        else{
            [self.appNameLab setHidden:NO];
            [self.navLogoView setHidden:NO];
            [self showKeyboardToolSearchingNumber:NO];   //Hidden Tool
            
            [self keyboardViewHidden:NO];    //弹出键盘
            
            weakSelf.historyTable.hidden = NO;
            weakSelf.adverScrollView.hidden = NO;
            [UIView animateWithDuration:0.2 animations:^{
                weakSelf.historyTable.alpha = 1.0;
                weakSelf.adverScrollView.alpha = 1.0;
            } completion:nil];
            
            inSearch = NO;
        }
        
        if (inSearch) {
            
            NSArray *searArr = [self.addressBook searchTextFromKeyboard:curNum];
            [self.searchVC.searchPhoneArr removeAllObjects];
            [self.searchVC.searchPhoneArr addObjectsFromArray:searArr];
            
            //更新UI
            [UIView transitionWithView:_searchResultTable duration:0.1 options:(UIViewAnimationOptionTransitionCrossDissolve) animations:^{
                [weakSelf.searchResultTable reloadData];
            } completion:nil];
            
            if (searArr.count >0) {
                [self.searchVC.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:(UITableViewScrollPositionTop) animated:NO];
            }
        }
        
    }

}


#pragma mark 键盘展开以及隐藏
//显示隐藏、拨号，退格 ToolView
-(void)showKeyboardToolSearchingNumber:(BOOL)show{
    WkSelf(weakSelf);
    if (show) {
        if (inSearch == NO) {
            UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
            [self.KbToolView setFrame:CGRectMake(0, Main_Screen_Height-49, Main_Screen_Width, 49)];
            [keyWindow addSubview:self.KbToolView];
            _KbToolView.alpha = 0.0;
            
            self.kbHideImageIcon.transform = CGAffineTransformMakeRotation(0.0);  //reset
            [UIView animateWithDuration:0.2 animations:^{
                weakSelf.KbToolView.alpha = 1.0;
            }];
        }
        
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.KbToolView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [weakSelf.KbToolView removeFromSuperview];
        }];
    }
}

-(void)changeHistoryRecordView:(BOOL)kbHide{
    [self keyboardViewHidden:kbHide];
    
    WkSelf(weakSelf);
    if (kbHide) {
        
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.adverScrollView.alpha = 0.0;
            
        } completion:^(BOOL finished) {
            [weakSelf.adverScrollView setHidden:YES];
        }];
        
    }else{
        self.adverScrollView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.adverScrollView.alpha = 1.0;
            
        } completion:nil];
    }
}

-(void)keyboardViewHidden:(BOOL)kbHide{
    kbIsHidden = kbHide;
    WkSelf(weakSelf);
    if (kbHide) {
        NSLog(@"键盘已经缩退");
        
        self.KeyboardBottom.constant = -(self.keyboardView.height+50);
        
        [UIView animateWithDuration:0.3 animations:^{
            [weakSelf.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
        
    }else{
        self.KeyboardBottom.constant = 0;
        
        [UIView animateWithDuration:0.3 animations:^{
            [weakSelf.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
        
        NSLog(@"键盘已经展开显示");
    }
    
    if ([self.tabBarController isKindOfClass:[MainTabBarController class]]) {
        MainTabBarController *mainTabVc = (MainTabBarController *)self.tabBarController;
        [mainTabVc keyboardIconHidden:kbHide];
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
