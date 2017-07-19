//
//  AddressbookObject.m
//  CallLiaoBei
//
//  Created by IntelcentMacMini on 16/11/7.
//  Copyright © 2016年 GeryHui. All rights reserved.
//

#import "AddressbookObject.h"
#import "ChineseToPinyin.h"


NSString *const AddressBookUpdate = @"AddressBookUpdate";

static void sync_address_book(ABAddressBookRef addressBook, CFDictionaryRef info , void *context);

@interface AddressbookObject()

@property (nonatomic, assign) ABAddressBookRef addressbookRef;


@end

@implementation AddressbookObject


-(id)init{
    if (self = [super init]) {
        
        self.contactsData   = [NSMutableArray array];
        self.contactsSortData = [NSMutableArray array];
        self.allContactsPhones = [NSMutableArray array];
        
        self.contactsIdValueKey = [NSMutableDictionary dictionary];
        self.contactsNumberValueKey = [NSMutableDictionary dictionary];
        
    }
    return self;
}


#pragma mark Tool Methods

//ABRecordRef获取联系人名称
+(NSString *)getContactDisplayName:(ABRecordRef)contact{
    NSString *resultStr = nil;
    if(contact){
        CFStringRef strRef = ABRecordCopyCompositeName(contact);
        if (strRef) {
            resultStr = [NSString stringWithFormat:@"%@",strRef];
        }
        if(strRef) CFRelease(strRef);
        
    }
    return resultStr;
}

//String 去掉 空格，括号()，横杆-等特殊字符
+(NSString *)normalPhoneNumber:(NSString *)address{

    NSMutableString *lNormalAddress = [NSMutableString stringWithFormat:@"%@",address];
    
    [lNormalAddress replaceOccurrencesOfString:@" "
                                    withString:@""
                                       options:NSCaseInsensitiveSearch
                                         range:NSMakeRange(0, lNormalAddress.length)];
    
    [lNormalAddress replaceOccurrencesOfString:@"("
                                    withString:@""
                                       options:0
                                         range:NSMakeRange(0, [lNormalAddress length])];
    
    [lNormalAddress replaceOccurrencesOfString:@")"
                                    withString:@""
                                       options:0
                                         range:NSMakeRange(0, [lNormalAddress length])];
    
    [lNormalAddress replaceOccurrencesOfString:@"-"
                                    withString:@""
                                       options:0
                                         range:NSMakeRange(0, [lNormalAddress length])];
    
    return lNormalAddress;
    
}

#pragma mark 通讯录权限

    //是否允许访问通讯录
+(BOOL)isAccessable{
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    if (status == kABAuthorizationStatusAuthorized) {
        return YES;
    }
    return NO;
}

    //是否允许访问通讯录 Block回调
+(BOOL)addressbookAuthoStatus:(void(^)())authoStatus notDetermined:(void(^)())notDetermined hasDenied:(void(^)())hasDenied{
    
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    if (status == kABAuthorizationStatusNotDetermined) {
        //未决定
        if (notDetermined) {
            notDetermined();
        }
        return NO;
    }else if (status == kABAuthorizationStatusAuthorized){
        //允许
        if (authoStatus) {
            authoStatus();
        }
        return YES;
    }else{
        if (hasDenied) {
            hasDenied();
        }
        return NO;
    }
}
    //获取某个名字的联系人对应的personId
+(NSInteger)getContactPersonIdWithName:(NSString *)name{
    ABAddressBookRef TmpAddressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    
    CFArrayRef lContacts = ABAddressBookCopyArrayOfAllPeople(TmpAddressBook);
    NSInteger count = CFArrayGetCount(lContacts);
    
    NSInteger personId = -1;
    for (int p = 0; p<count; p++) {
        ABRecordRef lPerson = CFArrayGetValueAtIndex(lContacts, p);
        if (lPerson) {
            CFStringRef nameRef = ABRecordCopyCompositeName(lPerson);
            if (nameRef) {
                NSString *disName = [AddressbookObject normalPhoneNumber:(__bridge NSString *)nameRef];
                if ([disName isEqualToString:name]) {
                    personId = (NSInteger)ABRecordGetRecordID(lPerson);
                    
                    if(nameRef) CFRelease(nameRef);
                    break;
                }
            }
            if(nameRef) CFRelease(nameRef);
        }
    }
    if(lContacts)   CFRelease(lContacts);
    
    return personId;
}


-(void)readLocalAddressBook{
    if (_addressbookRef != nil) {
        ABAddressBookUnregisterExternalChangeCallback(_addressbookRef, sync_address_book, (__bridge void *)(self));
    }
    _addressbookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    WkSelf(weakSelf);
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    if (status == kABAuthorizationStatusNotDetermined) {
        //未决定
        ABAddressBookRequestAccessWithCompletion(_addressbookRef, ^(bool granted, CFErrorRef error) {
                //注册回调更新不能在支线程
//            dispatch_async(GCDQueueDEFAULT, ^{
//                CFAbsoluteTime start =  CFAbsoluteTimeGetCurrent();
//                [weakSelf loadAddressData];  //读取
//                CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();
//                NSLog(@"通讯录检索耗时:%.5f",(end-start));
//            });
            
            [weakSelf loadAddressData];  //读取
            ABAddressBookRegisterExternalChangeCallback(_addressbookRef, sync_address_book, (__bridge void *)(weakSelf));
        });
        
    }else if (status == kABAuthorizationStatusAuthorized){
        //允许
        //注册回调更新不能在支线程
//        dispatch_async(GCDQueueDEFAULT, ^{
//            CFAbsoluteTime start =  CFAbsoluteTimeGetCurrent();
//            [weakSelf loadAddressData];  //读取
//            CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();
//            NSLog(@"通讯录检索耗时:%.5f",(end-start));
//        });
        
        [weakSelf loadAddressData];  //读取
        ABAddressBookRegisterExternalChangeCallback(_addressbookRef, sync_address_book,(__bridge void *)(self));
       
    }else{
        //拒绝
      [self showAddressBookAcceableTips];
    }
    
}
    //提示设置-隐身-通讯录 运行访问
-(void)showAddressBookAcceableTips{
    NSString *errtips = @"您设置允许访问通讯录\n 请打开设置 > 隐私 > 通讯录可以进行设置";
    UIAlertView *alertTips = [[UIAlertView alloc] initWithTitle:@"请允许访问通讯录"
                                                            message:errtips
                                                           delegate:self
                                                  cancelButtonTitle:@"好的"
                                                  otherButtonTitles:@"立即前往", nil];
    [alertTips show];
}

#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        //立即前往
        NSString *ContactsUrl = [NSString stringWithFormat:@"prefs:root=Privacy&path=Contacts"];
        if (DEVICE_SYSTEM_IOS10_OR_LATER) {
            ContactsUrl = [NSString stringWithFormat:@"%@",UIApplicationOpenSettingsURLString];
        }
        
        NSURL *Url = [NSURL URLWithString:ContactsUrl];
        if ([[UIApplication sharedApplication] canOpenURL:Url]) {
            [[UIApplication sharedApplication] openURL:Url];
        }
    }
}


#pragma mark 通讯录联系人遍历获取
-(void)loadAddressData{
    
    ABAddressBookRevert(_addressbookRef);
    @synchronized (_contactsData) {
    
        [_contactsData removeAllObjects];
        [_allContactsPhones removeAllObjects];
        
        [_contactsIdValueKey removeAllObjects];
        [_contactsNumberValueKey removeAllObjects];
        
        NSMutableDictionary *sortContacts = [NSMutableDictionary dictionary];  //联系人分组
        
        CFArrayRef lContacts = ABAddressBookCopyArrayOfAllPeople(_addressbookRef);
        CFIndex count = CFArrayGetCount(lContacts);
        for (CFIndex idx = 0; idx < count; idx ++) {
            ABRecordRef lPerson = CFArrayGetValueAtIndex(lContacts, idx);
            
            //获取姓名
            NSString *getDisName = [AddressbookObject getContactDisplayName:lPerson];
            //姓 firstName
            CFStringRef lFirstName = ABRecordCopyValue(lPerson, kABPersonFirstNameProperty);
            CFStringRef lLocalizedFirstName = (lFirstName !=nil)?ABAddressBookCopyLocalizedLabel(lFirstName):nil;
            
            //名 lastName
            CFStringRef lLastName = ABRecordCopyValue(lPerson, kABPersonLastNameProperty);
            CFStringRef lLocalizedLastName = (lLastName !=nil)?ABAddressBookCopyLocalizedLabel(lLastName):nil;
            NSString *name = nil;
            if (lLocalizedFirstName !=nil && lLocalizedLastName !=nil) {
                name = [NSString stringWithFormat:@"%@%@",lLocalizedLastName,lLocalizedFirstName];
            }else if (lLocalizedLastName!=nil){
                name = [NSString stringWithFormat:@"%@",lLocalizedLastName];
            }else if (lLocalizedFirstName !=nil){
                name = [NSString stringWithFormat:@"%@",lLocalizedFirstName];
            }else{
                name = @"";
            }
            if(lFirstName) CFRelease(lFirstName);
            if(lLocalizedFirstName) CFRelease(lLocalizedFirstName);
            if(lLastName) CFRelease(lLastName);
            if(lLocalizedLastName) CFRelease(lLocalizedLastName);
            
            
            
            //联系人模型数据
            ContactModel *ctacModel = [[ContactModel alloc] initWithContactName:name];
            
            // Person Record ID
            ABRecordID perIdRef = ABRecordGetRecordID(lPerson);
            NSString *perId = [NSString stringWithFormat:@"%d",perIdRef];
            
            //属性赋值
            ctacModel.personId = perId;
            
            //首字母 sort排序
            NSString *sortChar = ctacModel.sortChar;
            if (![sortChar isWordCharacter] || sortChar == nil) {
                sortChar = @"#";
            }
            ctacModel.sortChar = sortChar;   //
            
            if ([name isEqualToString:@"爱新觉罗"]) {
                NSLog(@"---");
            }
            
            //获取号码属性
            NSMutableArray *phonesArr = [NSMutableArray array];
            ABMultiValueRef lMap = ABRecordCopyValue(lPerson, kABPersonPhoneProperty);
            if (lMap) {
                for ( int i = 0; i<ABMultiValueGetCount(lMap); i++) {
                    CFStringRef lValue = ABMultiValueCopyValueAtIndex(lMap, i);
                    if (lValue) {
                        NSString *tmpNum = [NSString stringWithFormat:@"%@",lValue];
                        
                        tmpNum = [AddressbookObject normalPhoneNumber:tmpNum];
                        [phonesArr addObject:tmpNum];
                        
                            //数据模型copy
                        ContactModel *ctacModel2 = [[ContactModel alloc] init];
                        ctacModel2.name = ctacModel.name;
                        ctacModel2.pinyinName = ctacModel.pinyinName;
                        ctacModel2.sortChar = ctacModel.sortChar;
                        ctacModel2.firLetters = ctacModel.firLetters;
                        ctacModel2.firstNameChar = ctacModel.firstNameChar;
                        ctacModel2.logoColor = ctacModel.logoColor;
                        ctacModel2.numPinyin = ctacModel.numPinyin;
                        
                        ctacModel2.personId = ctacModel.personId;
                        ctacModel2.sortChar = ctacModel2.sortChar;
                        ctacModel2.dialerPhone = tmpNum;  //当前号码
                        [_allContactsPhones addObject:ctacModel2];
                        
                        if (tmpNum.length >0) {
                            [_contactsNumberValueKey setObject:ctacModel2 forKey:tmpNum];  //号码->model
                        }
                    }
                    
                }
            }
                // Phones属性
            ctacModel.phones = phonesArr;
            if(phonesArr.count >0)  ctacModel.firstPhone = [phonesArr firstObject];
            
                //Logo颜色
            NSArray *colorArr = [ContactModel contactLogoColor];
            NSInteger armIndex = arc4random() % (colorArr.count-1);
            ctacModel.logoColor = [colorArr objectAtIndex:armIndex];
            
            
                //按首字母分组
            NSMutableArray *tmpCharArr = [sortContacts objectForKey:sortChar];
            if ([sortChar isEqualToString:@"#"]) {
                NSLog(@"%@",tmpCharArr);
            }
            
            if (tmpCharArr && [tmpCharArr isKindOfClass:[NSArray class]]) {
                
                tmpCharArr = [NSMutableArray arrayWithArray:tmpCharArr];
                NSUInteger atIndex = 0;
                NSString *pinyinN = [ctacModel pinyinName];
                
                for (atIndex = 0; atIndex < tmpCharArr.count; atIndex++) {
                    NSString *tmpPinyin = [(ContactModel *)[tmpCharArr objectAtIndex:atIndex] pinyinName];
                    NSComparisonResult compareResult = [tmpPinyin compare:pinyinN options:(NSNumericSearch)];
                    if (compareResult == NSOrderedSame || compareResult == NSOrderedDescending) {
                        break;
                    }
                }
                
                [tmpCharArr insertObject:ctacModel atIndex:atIndex]; //
                
            }else{
                tmpCharArr = [NSMutableArray array];
                [tmpCharArr addObject:ctacModel];
            }
  
            [sortContacts setObject:tmpCharArr forKey:sortChar];
            
            if(lPerson) CFRelease(lPerson);
            if(lMap)    CFRelease(lMap);
            if (!getDisName || getDisName.length == 0) {
                NSLog(@"name:%@",name);
            }
            
            //添加数据
            [_contactsData addObject:ctacModel];
            [_contactsIdValueKey setObject:ctacModel forKey:perId];
            
        }
        
        if(lContacts) CFRelease(lContacts);
        
        //排序
        [_contactsSortData removeAllObjects];   //置空
        NSArray *allKeys = [sortContacts allKeys];
        allKeys = [allKeys sortedArrayUsingSelector:@selector(compare:)];
        
        NSDictionary *tmpJinCharDic = nil;
        for (NSString *tmpChar in allKeys) {
            NSMutableArray *oncharArr = [sortContacts objectForKey:tmpChar];
            
            if ([tmpChar isEqualToString:@"#"]) {
                tmpJinCharDic = [NSDictionary dictionaryWithObject:oncharArr forKey:@"#"];
            }else{
                NSDictionary *oneCharDic = [NSDictionary dictionaryWithObject:oncharArr forKey:tmpChar];
                
                [_contactsSortData addObject:oneCharDic];
            }
        }
        if(tmpJinCharDic){
            [_contactsSortData addObject:tmpJinCharDic];  // #排最后
        }

        [ToolMethods asynMainThreadWithAction:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AddressBookFinishLoad" object:nil];
        }];
        
    }

}


#pragma mark 通讯录检索
    //号码检索  拨号盘模糊检索
-(NSMutableArray *)searchTextFromKeyboard:(NSString *)numText{
    __block NSMutableArray *resultArr = [NSMutableArray array];
    if (_allContactsPhones.count >0 && numText.length >0) {
        [self.allContactsPhones enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            ContactModel *model = (ContactModel *)obj;
            BOOL isFit = NO;
            if (model.dialerPhone.length >0 && [model.dialerPhone rangeOfString:numText].location != NSNotFound) {
                //号码匹配
                isFit = YES;
            }else if (model.numPinyin.length >0 && [model.numPinyin rangeOfString:numText].location != NSNotFound){
                isFit = YES;
            }
            if (isFit) {
                [resultArr addObject:model];
            }
            
        }];
    }
    
    return resultArr;
}


-(void)searchContactsWithText:(NSString *)text isKeyboard:(BOOL)isKb{
    
}

#pragma mark  本地通讯录修改更新 回调
void sync_address_book (ABAddressBookRef addressBook, CFDictionaryRef info , void *context){
    AddressbookObject *tmpAddress = (__bridge AddressbookObject *)(context);
    if ([tmpAddress isKindOfClass:[AddressbookObject class]]) {
        [tmpAddress readLocalAddressBook];
    }
}


/**
 通讯录某个name插入号码 */
+(BOOL)insertAddressBookContact:(NSArray *)phones name:(NSString *)displayName{
    if ([AddressbookObject isAccessable] == NO || displayName.length ==0) {
        NSLog(@"未允许访问通讯录 或者 名字为空");
        return NO;
    }
    
    ABAddressBookRef TmpAddressbook = ABAddressBookCreateWithOptions(NULL, NULL);
    
    ABRecordRef personRef = NULL;
    NSInteger perId = [AddressbookObject getContactPersonIdWithName:displayName];
    if (perId != kABRecordInvalidID) {
        //已存在
        personRef = ABAddressBookGetPersonWithRecordID(TmpAddressbook, perId);
    }else{
        personRef = ABPersonCreate();   //新增一个联系人
    }
    
    NSArray *numsArray  = [NSArray array];
    CFErrorRef error_addRecord = nil;
    if (personRef && phones.count >0) {
        numsArray = [NSArray arrayWithArray:phones];   //需要录入的号码
        ABAddressBookAddRecord(TmpAddressbook, personRef, &error_addRecord);
    }else{
        NSLog(@"添加失败");
        return NO;
    }
    
    CFErrorRef error_setName = nil;
    ABRecordSetValue(personRef, kABPersonLastNameProperty, (__bridge CFTypeRef)(displayName), &error_setName);
    if (error_addRecord || error_setName) {
        NSLog(@"添加失败");
        CFRelease(personRef);
        return NO;
    }
    
    ABMutableMultiValueRef phoneMultiValue = ABMultiValueCreateMutable(kABStringPropertyType);
    
    NSString *phoneLab = @"企业专线";
    ABMultiValueIdentifier identifier;
    for (int i = 0; i<numsArray.count; i++) {
        NSString *tmpNum = [numsArray objectAtIndex:i];
        bool setSucc = NO;
        if ([tmpNum isKindOfClass:[NSString class]]) {
            setSucc = ABMultiValueAddValueAndLabel(phoneMultiValue, (__bridge CFTypeRef)(tmpNum), (__bridge CFStringRef)(phoneLab), &identifier);
        }
        if(!setSucc)    NSLog(@"号码保存失败:%@",tmpNum);
    }
    
    CFErrorRef error_saveMultiValue = nil;
    if (ABRecordSetValue(personRef, kABPersonPhoneProperty, phoneMultiValue, (CFErrorRef *)&error_saveMultiValue)) {
        // 号码保存成功
    }else{
        //号码保存失败
        NSLog(@"personRef 保存号码失败");
        CFRelease(personRef);
        CFRelease(phoneMultiValue);
        return NO;
    }
    
    // 保存 personRef 到通讯录 addressBook
    BOOL saveSucc = YES;
    CFErrorRef error_recordSave = NULL;
    ABAddressBookSave(TmpAddressbook, &error_recordSave);
    if (error_recordSave){
        NSLog(@"personRef 保存号码失败");
        saveSucc = NO;
    }
    
    CFRelease(personRef);
    CFRelease(phoneMultiValue);
    
    return saveSucc;
}


@end



/*********************** 联系人数据模型  *********************/


@implementation ContactModel

-(id)initWithContactName:(NSString *)name{
    if (self = [super init]) {
        personName = NormalString(name, @"");
        [self updateContact];
    }
    
    return self;
}

-(void)updateContactWithName:(NSString *)name{
    personName = NormalString(name, @"");
    [self updateContact];
}

-(void)updateWithPersonItem:(ABRecordRef)person{
    //获取姓名
    NSString *getDisName = [AddressbookObject getContactDisplayName:person];
    personName = NormalString(getDisName, @"");
    
    [self updateContact];
    
    // Person Record ID
    ABRecordID perIdRef = ABRecordGetRecordID(person);
    NSString *tmpPerId = [NSString stringWithFormat:@"%d",perIdRef];
    //属性赋值
    self.personId = tmpPerId;
    
    //首字母 sort排序
    NSString *sortChar = self.sortChar;
    if (![sortChar isWordCharacter] || sortChar == nil) {
        sortChar = @"#";
    }
    self.sortChar = sortChar;   //
    
    //获取号码属性
    NSMutableArray *phonesArr = [NSMutableArray array];
    ABMultiValueRef lMap = ABRecordCopyValue(person, kABPersonPhoneProperty);
    if (lMap) {
        for ( int i = 0; i<ABMultiValueGetCount(lMap); i++) {
            CFStringRef lValue = ABMultiValueCopyValueAtIndex(lMap, i);
            if (lValue) {
                NSString *tmpNum = [NSString stringWithFormat:@"%@",lValue];
                
                tmpNum = [AddressbookObject normalPhoneNumber:tmpNum];
                [phonesArr addObject:tmpNum];
            }
            
        }
    }
    // Phones属性
    self.phones = phonesArr;
    if(phonesArr.count >0)  self.firstPhone = [phonesArr firstObject];
    
    //Logo颜色
    NSArray *colorArr = [ContactModel contactLogoColor];
    NSInteger armIndex = arc4random() % (colorArr.count-1);
    self.logoColor = [colorArr objectAtIndex:armIndex];
}

-(void)updateContact{
    self.name = personName;
    
    NSString *tmpSort = @"#";
    NSString *tmpLetters = @"";
    NSString *tmpPinyin  = @"";
    NSString *tmpNum = @"";
    if (personName.length >0) {
            //中->拼音
        tmpPinyin = [ChineseToPinyin pinyinFromChiniseString:personName];
        if ([tmpPinyin rangeOfString:@"#"].location != NSNotFound) {
            NSString *sysPinyin = [ChineseToPinyin SysPinYinStringFromChinese:personName hasSoundMark:NO];
            if (sysPinyin) {
                tmpPinyin = sysPinyin;
            }
        }
        
            //替换多音字 拼音
        NSMutableArray *nameArr = nil;
        if ([tmpPinyin rangeOfString:@" "].location != NSNotFound) {
            nameArr = [NSMutableArray arrayWithArray:[tmpPinyin componentsSeparatedByString:@" "]];
        }
        for (int i =0; i<personName.length; i++) {
            NSString *oneChar = [personName substringWithRange:NSMakeRange(i, 1)];
            NSString *MultiPinyin = haveMultiPinyin(oneChar);
            if (MultiPinyin) {
                //包含多音字
                if (nameArr.count >i) {
                    [nameArr replaceObjectAtIndex:i withObject:MultiPinyin];
                }
            }
        }
            //全拼音  NSArray -> NSString
        if(nameArr) tmpPinyin = [nameArr componentsJoinedByString:@" "];
        tmpPinyin = [AddressbookObject normalPhoneNumber:tmpPinyin];
        
        
            //取首位
        NSString *firName = tmpPinyin;
        if (nameArr.count >0) {
            firName = [nameArr firstObject];
        }
        if(firName.length >0)   tmpSort = [firName substringToIndex:1];
        
            //中文->首字母
        for (NSString *subChar in nameArr) {
            NSString *tmpLet = subChar;
            if (tmpLet.length>0) {
                tmpLet = [subChar substringToIndex:1];
            }
            tmpLetters = [tmpLetters stringByAppendingString:tmpLet];
        }
        tmpLetters = [AddressbookObject normalPhoneNumber:tmpLetters];
        
            //拨号盘模糊检索 数字->拼音
        tmpNum = [self getDialerNumberWithLetters:tmpLetters];
        
    }
    
    self.sortChar = tmpSort.uppercaseString;
    self.firLetters = tmpLetters.lowercaseString;  //小写
    self.pinyinName = tmpPinyin.lowercaseString;   //小写
    self.numPinyin = tmpNum;  //数字
    
    if(self.pinyinName.length >0){
        self.firstNameChar = [_pinyinName substringToIndex:1];
    }else{
        self.firstNameChar = @"#";  //名字为空
    }
}

-(NSString *)getDialerNumberWithLetters:(NSString *)letters{
    NSString *resultNum = @"";
    if (letters.length >0) {
        letters = letters.uppercaseString;   //大写
        for ( int i =0 ; i<letters.length; i++) {
            char let = [letters characterAtIndex:i];
            NSString *tmpNum = @"";
            if (let == 'A'|| let == 'B' || let == 'C'){
                tmpNum = @"2";
            }else if (let == 'D' || let == 'E' || let == 'F'){
                tmpNum = @"3";
            }else if (let == 'G' || let == 'H' || let == 'I'){
                tmpNum = @"4";
            }else if (let == 'J' || let == 'K' || let == 'L'){
                tmpNum = @"5";
            }else if (let == 'M' || let == 'N' || let == 'O'){
                tmpNum = @"6";
            }else if (let == 'P' || let == 'Q' || let == 'R' || let == 'S'){
                tmpNum = @"7";
            }else if (let == 'T' || let == 'U' || let == 'V'){
                tmpNum = @"8";
            }else if (let == 'W' || let == 'X' || let == 'Y' || let == 'Z'){
                tmpNum = @"9";
            }
            
            resultNum = [resultNum stringByAppendingString:tmpNum];
        }
    }
    
    return resultNum;
}

+(NSArray *)contactLogoColor{
//    UIColor *color1 = RGBColor(62, 167, 133);
//    UIColor *color3 = RGBColor(67, 173, 215);
//    UIColor *color4 = RGBColor(255, 163, 76);
//    UIColor *color5 = RGBColor(68, 198, 177);
    
    UIColor *color1 = UIColorFromRGB(0xf3b1b2);
    UIColor *color2 = UIColorFromRGB(0xc4b3ea);
    UIColor *color3 = UIColorFromRGB(0xa9d2f2);
    UIColor *color4 = UIColorFromRGB(0xf6d4a4);
    UIColor *color5 = UIColorFromRGB(0xa7dcc2);

    
    NSArray *colorArr = [NSArray arrayWithObjects:color1,color2,color3,color4,color5, nil];
    return colorArr;
}


/**
 通讯录检索判断号码是否符合条件 */
-(BOOL)isFitFromSearchText:(NSString *)text{
    if (text.length >0) {
        if ([text isNumberTypeString]) {
            //数字
            for (NSString *tmpNum in self.phones) {
                if ([tmpNum rangeOfString:text].location != NSNotFound) {
                    return YES;
                }
            }
        }
        else if ([text isWordCharacter]){
            text = text.lowercaseString;  //统一小写匹配
            //字母
            if ([self.firLetters rangeOfString:text].location != NSNotFound) {
                return YES;
            }else if ([self.pinyinName rangeOfString:text].location != NSNotFound){
                return YES;
            }
        }else{
            //中文或者其他
            if ([self.name rangeOfString:text].location != NSNotFound) {
                return YES;
            }
        }
    }
    return NO;
}

#pragma mark 小方法

NSString *getMultiPinyin(NSString *firChar){
    NSString *resultStr = nil;
    if (firChar && [firChar isKindOfClass:[NSString class]]) {
        resultStr = firChar;
    }
    
    NSString *tmPinyin = haveMultiPinyin(firChar);
    if (tmPinyin) {
        return tmPinyin;
    }
    
    return resultStr;
}

NSString *haveMultiPinyin(NSString *firChar){
    NSString *resultStr = nil;
    
    //多音字
    if ([firChar isEqualToString:@"曾"]) {
        resultStr = @"zeng";
    }else if ([firChar isEqualToString:@"解"]){
        resultStr = @"xie";
        
    }else if ([firChar isEqualToString:@"仇"]){
        resultStr = @"qiu";
        
    }else if ([firChar isEqualToString:@"朴"]){
        resultStr = @"piao";
        
    }else if ([firChar isEqualToString:@"查"]){
        resultStr = @"zha";
        
    }else if ([firChar isEqualToString:@"能"]){
        resultStr = @"nai";
        
    }else if ([firChar isEqualToString:@"乐"]){
        resultStr = @"yue";
        
    }else if ([firChar isEqualToString:@"单"]){
        resultStr = @"shan";
    }
    
    return resultStr;
}

NSString *NormalString(NSString *str,NSString *defaultValue){
    NSString *resultStr = defaultValue;
    if (str != nil && (NSNull *)str != [NSNull null]) {
        if ([str isKindOfClass:[NSString class]]) {
            resultStr = [[NSString alloc] initWithString:str];
        }else{
            resultStr = [[NSString alloc] initWithFormat:@"%@",str];
        }
    }
    return resultStr;
}

NSArray *NormalArray(NSArray *arrObj){
    NSArray *resultArr = nil;
    if ([arrObj isKindOfClass:[NSArray class]]) {
        resultArr = [[NSArray alloc] initWithArray:arrObj];
    }
    return resultArr;
}



@end



