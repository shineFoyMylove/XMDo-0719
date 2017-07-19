//
//  UDUserDefault.h
//  iCallWeiDianHuaFX
//
//  Created by IntelcentMacMini on 16/8/22.
//  Copyright © 2016年 英之杰讯邦网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark ----- UserDefault Helper

void UserDefaultSync();     /**< 数据持久化 立即保存*/

void UserDefaultRemoveKey(NSString *key);   /**<数据移除 */

void UserDefaultRegister(NSDictionary *defaultDictionary);  /**<注册默认参数配置*/

void UserDefaultClearAllExcept(NSArray *keys);      /**< 除了 key1,key2...其他都移除*/

void UserDefaultClearObjects(NSArray *objKeys);  /**< 移除 key1,key2...*/

void UserDefaultClearAll();         /**<清除 userDefault所有参数 */

NSDictionary *UserDefaultAllValue();    /**<获取 UserDefault所有数据*/


#pragma mark  ----- UserDefault Get value 

id UDGetObject(NSString *key);        /**< Get Object对象*/

BOOL UDGetBool(NSString *key);        /**< Get Bool 对象*/

float UserDefaultFloat(NSString *key);      /**< Get Float 对象*/

double UDGetDouble(NSString *key);      /**< Get Double 对象*/

NSInteger UDGetInteger(NSString *key);    /**< Get Intege 对象*/

NSData *UDGetData(NSString *key);      /**< Get Data 对象*/

NSString *UDGetString(NSString *key);     /**< Get String 对象*/

NSArray *UDGetArray(NSString *key);       /**< Get NSArray 对象*/

NSDictionary *UDGetDictionary(NSString *key);     /**< Get Dictionary 对象*/

NSArray *UDGetStringArray(NSString *key);     /**< Get StringArray 对象*/

NSURL *UDGetURL(NSString *key);           /**< Get URL 对象*/



#pragma mark ----- UserDefault Get value with default value

id UDGetObjectWithDefault(NSString *key, id defaultObj);  /**< Get Object对象 (有默认值)*/

NSData *UDGetDataWithDefault(NSString *key,NSData *defaultData);  /**< Get Data 对象 (有默认值)*/

NSString *UDGetStringWithDefault(NSString *key,NSString *defaultString);  /**< Get String 对象 (有默认值)*/

NSArray *UDGetArrayWithDefault(NSString *key,NSArray *defaultArray);  /**< Get NSArray 对象 (有默认值)*/

NSDictionary *UDGetDictionaryWithDefault(NSString *key,NSDictionary *defaultDictionary);  /**< Get Dictionary 对象 (有默认值)*/

NSArray *UDGetStringArrayWithArray(NSString *key,NSArray *defaultStrArray);    /**< Get StringArray 对象 (有默认值)*/

NSURL *UDGetURLWithDefault(NSString *key,NSURL *defaultUrl);  /**< Get URL 对象 (有默认值)*/



#pragma mark ----- UserDefault Set value method

void UDSetObject(NSString *key, id value);     /**< Set Object对象*/

void UDSetBool(NSString *key, BOOL value);     /**< Set Bool对象*/

void UDSetFloat(NSString *key, float value);   /**< Set Float对象*/

void UDSetDouble(NSString *key, double value); /**< Set Double对象*/

void UDSetInteger(NSString *key, NSInteger value); /**< Set Integer对象*/

void UDSetURL(NSString *key, NSURL *value);    /**< Set URL对象*/



