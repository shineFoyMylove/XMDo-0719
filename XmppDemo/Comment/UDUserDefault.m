//
//  UDUserDefault.m
//  iCallWeiDianHuaFX
//
//  Created by IntelcentMacMini on 16/8/22.
//  Copyright © 2016年 英之杰讯邦网络科技. All rights reserved.
//

#import "UDUserDefault.h"

#define StandardUserDefault     [NSUserDefaults standardUserDefaults]


#pragma mark ----- UserDefault Helper

    //数据持久化,立即保存(也会自动调用的)
void UserDefaultSync(){
    [[NSUserDefaults standardUserDefaults] synchronize];
}
    //数据移除
void UserDefaultRemoveKey(NSString *key){
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}
    //注册默认参数配置
void UserDefaultRegister(NSDictionary *defaultDictionary){
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultDictionary];
}
    //除了 key1,key2...其他都移除
void UserDefaultClearAllExcept(NSArray *keys){
    NSDictionary *dict = UserDefaultAllValue();
    for (id key in dict) {
        if ([keys containsObject:key])
            continue;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
    UserDefaultSync();
}

void UserDefaultClearObjects(NSArray *objKeys){
    for (id key in objKeys) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
    UserDefaultSync();
}

    //清除 UserDefault所有参数
void UserDefaultClearAll(){
    UserDefaultClearAllExcept(nil);
}
    //获取 UserDefault所有数据
NSDictionary *UserDefaultAllValue(){
    return [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
}


#pragma mark  ----- UserDefault Get value Method
    //Get Object对象
id UDGetObject(NSString *key){
    return [StandardUserDefault objectForKey:key];
}
    //Get Bool 对象
BOOL UDGetBool(NSString *key){
    return [StandardUserDefault boolForKey:key];
}
    //Get Float 对象
float UDGetFloat(NSString *key){
    return [StandardUserDefault floatForKey:key];
}
    //Get Double 对象
double UDGetDouble(NSString *key){
    return [StandardUserDefault doubleForKey:key];
}
    //Get Intege 对象
NSInteger UDGetInteger(NSString *key){
    return [StandardUserDefault integerForKey:key];
}
    //Get Data对象
NSData *UDGetData(NSString *key){
    return [StandardUserDefault dataForKey:key];
}
    //Get String 对象
NSString *UDGetString(NSString *key){
    NSString *str = [StandardUserDefault stringForKey:key];
    if (str) {
        return [NSString stringWithString:str];
    }
    return nil;
}
    //Get NSArray 对象
NSArray *UDGetArray(NSString *key){
    NSArray *arr = [StandardUserDefault arrayForKey:key];
    if (arr) {
        return [NSArray arrayWithArray:arr];
    }
    return nil;
}
    //Get Dictionary 对象
NSDictionary *UDGetDictionary(NSString *key){
    return [StandardUserDefault dictionaryForKey:key];
}
    //Get StringArray 对象
NSArray *UDGetStringArray(NSString *key){
    return [StandardUserDefault stringArrayForKey:key];
}
    //Get URL 对象
NSURL *UDGetURL(NSString *key){
    return [StandardUserDefault URLForKey:key];
}


#pragma mark ----- UserDefault Get value with default value

    //Get Object对象 (有默认值)
id UDGetObjectWithDefault(NSString *key, id defaultObj){
    id tmpObj = UDGetObject(key);
    if (tmpObj ==nil) {
        return defaultObj;
    }
    return tmpObj;
}

    //Get Data 对象 (有默认值)
NSData *UDGetDataWithDefault(NSString *key,NSData *defaultData){
    id tmpObj = UDGetData(key);
    if (tmpObj == nil) {
        return defaultData;
    }
    return tmpObj;
}
    //Get String 对象 (有默认值)
NSString *UDGetStringWithDefault(NSString *key,NSString *defaultString){
    id tmpObj = UDGetString(key);
    if (tmpObj == nil) {
        return defaultString;
    }
    return (NSString *)tmpObj;
}
    //Get NSArray 对象 (有默认值)
NSArray *UDGetArrayWithDefault(NSString *key,NSArray *defaultArray){
    id tmpObj = UDGetArray(key);
    if (tmpObj == nil) {
        return defaultArray;
    }
    return (NSArray *)tmpObj;
}
    //Get Dictionary 对象 (有默认值)
NSDictionary *UDGetDictionaryWithDefault(NSString *key,NSDictionary *defaultDictionary){
    id tmpObj = UDGetDictionary(key);
    if (tmpObj == nil) {
        return defaultDictionary;
    }
    return tmpObj;
}
    //Get StringArray 对象 (有默认值)
NSArray *UDGetStringArrayWithArray(NSString *key,NSArray *defaultStrArray){
    id tmpObj = UDGetStringArray(key);
    if (tmpObj == nil) {
        return defaultStrArray;
    }
    
    return tmpObj;
}
    //Get URL 对象 (有默认值)
NSURL *UDGetURLWithDefault(NSString *key,NSURL *defaultUrl){
    id tmpObj = UDGetURL(key);
    if (tmpObj == nil) {
        return defaultUrl;
    }
    return tmpObj;
}



#pragma mark ----- UserDefault Set value method
    //Set Object对象
void UDSetObject(NSString *key, id value){
    [StandardUserDefault setObject:value forKey:key];
    UserDefaultSync();
}
    //Set Bool对象
void UDSetBool(NSString *key, BOOL value){
    [StandardUserDefault setBool:value forKey:key];
    UserDefaultSync();
}
    //Set Float对象
void UDSetFloat(NSString *key, float value){
    [StandardUserDefault setFloat:value forKey:key];
    UserDefaultSync();
}
    //Set Double对象
void UDSetDouble(NSString *key, double value){
    [StandardUserDefault setDouble:value forKey:key];
    UserDefaultSync();
}
    //Set Integer对象
void UDSetInteger(NSString *key, NSInteger value){
    [StandardUserDefault setInteger:value forKey:key];
    UserDefaultSync();
}
    //Set URL对象
void UDSetURL(NSString *key, NSURL *value){
    [StandardUserDefault setURL:value forKey:key];
    UserDefaultSync();
}
