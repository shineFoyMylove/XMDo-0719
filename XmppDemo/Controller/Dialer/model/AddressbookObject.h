//
//  AddressbookObject.h
//  CallLiaoBei
//
//  Created by IntelcentMacMini on 16/11/7.
//  Copyright © 2016年 GeryHui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

extern NSString *const AddressBookUpdate;

@interface AddressbookObject : NSObject

@property (nonatomic, retain) NSMutableArray *contactsData;   /**<通讯录 item 数组 */
@property (nonatomic, retain) NSMutableArray *contactsSortData;  /**<已经排序的通讯录数据 */
@property (nonatomic, retain) NSMutableArray *allContactsPhones;  /**<所有联系人的所有号码 #拨号键 模糊检索*/
@property (nonatomic, retain) NSMutableDictionary *contactsIdValueKey;  /**<personId -> contact数据 */
@property (nonatomic, retain) NSMutableDictionary *contactsNumberValueKey;  /**<phone -> contact数据 */

+(BOOL)isAccessable;  /**< 是否允许访问通讯录 */
/**
 # Authorized  许可
 # NotDetermined  用户还没有决定
 # HasDenied  已经拒绝 */
+(BOOL)addressbookAuthoStatus:(void(^)())authoStatus notDetermined:(void(^)())notDetermined hasDenied:(void(^)())hasDenied;

/**
 String 去掉 空格，括号()，横杆-等特殊字符 */
+(NSString *)normalPhoneNumber:(NSString *)address;

-(void)readLocalAddressBook;    /**<读取本地通讯录 */

-(void)showAddressBookAcceableTips;  /**<提示设置-隐身-通讯录 允许访问 */

//号码检索  拨号盘模糊检索
-(NSMutableArray *)searchTextFromKeyboard:(NSString *)numText;
-(void)searchContactsWithText:(NSString *)text isKeyboard:(BOOL)isKb;   /**<号码检索 isKeyboard 拨号盘模糊检索 */
/**
 通讯录某个name插入号码 */
+(BOOL)insertAddressBookContact:(NSArray *)phones name:(NSString *)displayName;


@end


/*********************** 联系人数据模型  *********************/

@interface ContactModel : NSObject{
    NSString *personName;
    NSString *perId;
    NSString *phonesArray;
}
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *firstPhone;
@property (nonatomic, retain) NSArray *phones;
@property (nonatomic, retain) NSString *personId;

@property (nonatomic, retain) NSString *firstNameChar;
@property (nonatomic, retain) NSString *sortChar;
@property (nonatomic, retain) NSString *firLetters;
@property (nonatomic, retain) NSString *pinyinName;
@property (nonatomic, retain) NSString *numPinyin;   /**<键盘数字 对应的拼音 */

@property (nonatomic, retain) UIColor *logoColor;
@property (nonatomic, retain) NSString *dialerPhone;  /**<当前呼叫号码*/

+(NSArray *)contactLogoColor;

-(id)initWithContactName:(NSString *)name;

-(void)updateContactWithName:(NSString *)name;

-(void)updateWithPersonItem:(ABRecordRef)person;

/**
 通讯录检索判断号码是否符合条件 */
-(BOOL)isFitFromSearchText:(NSString *)text;


@end