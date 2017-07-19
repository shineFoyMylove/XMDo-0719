//
//  AppUserInfo.m
//  CallLiaoBei
//
//  Created by IntelcentMacMini on 16/11/3.
//  Copyright © 2016年 GeryHui. All rights reserved.
//

#import "AppUserInfo.h"
//#import "AdverObject.h"
//#import "AFNDownload.h"
#import <objc/runtime.h>


@implementation AppUserInfo

-(id)init{
    if (self == [super init]) {
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        unsigned int propertyCount = 0;
        objc_property_t * propertyList = class_copyPropertyList([self class], &propertyCount);
        for (int i=0; i<propertyCount; i++) {
            objc_property_t * thisProperty = propertyList + i;
            const char * propertyName = property_getName(*thisProperty);
            NSString * key = [NSString stringWithUTF8String:propertyName];
            id value = [aDecoder decodeObjectForKey:key];
            if (value) {
                [self setValue:value forKey:key];
            }
        }
        free(propertyList);
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    unsigned int propertyCount = 0;
    objc_property_t * propertyList = class_copyPropertyList([self class], &propertyCount);
    for (int i=0; i<propertyCount; i++) {
        objc_property_t *thisProperty = propertyList + i;
        const char* propertyName = property_getName(*thisProperty);
        NSString * key = [NSString stringWithUTF8String:propertyName];
        if ([key isEqualToString:@"shop"]) {
            continue;
        }
        id value = [self valueForKey:key];
        [aCoder encodeObject:value forKey:key];
    }
    free(propertyList);
}

#pragma mark - Methods

-(BOOL)isLogin{
    if (self.uid.length >0 && self.phone.length >0) {
        return YES;
    }
    NSLog(@"账户未登录");
    return NO;
}

-(NSString *)getOriginPwd{
    NSString *pwd = @"";
    if (self.pwdStr.length >0) {
        pwd = [_pwdStr get_pwd];
    }
    return pwd;
}


#pragma mark - Data Update

-(void)setSexType:(NSInteger)sexType{
    _sexType = sexType;
    
    if (sexType == 0) {
        NSLog(@"未设置性别");
    }else if (sexType == 1){
        _sex = @"男";
    }else if (sexType == 2){
        _sex = @"女";
    }
}

-(void)updateLoginInfo:(NSDictionary *)info{
    if ([info isKindOfClass:[NSDictionary class]]) {
        self.headImage = [info getStringValueForKey:@"headSmallUrl" defaultValue:@""];
        self.headLargeImage = [info getStringValueForKey:@"headLargeUrl" defaultValue:@""];
        self.nickName   = [info getStringValueForKey:@"nickName" defaultValue:@""];
//        self.pwdStr = [info getStringValueForKey:@"password" defaultValue:@""];
        self.phone = [info getStringValueForKey:@"phone" defaultValue:@""];
        self.phoneCharge = [info getIntValueForKey:@"phoneCharge" defaultValue:0];
        self.sexType = [info getIntValueForKey:@"sex" defaultValue:0];
        self.signText = [info getStringValueForKey:@"sign" defaultValue:@""];
        self.uid    = [info getStringValueForKey:@"uid" defaultValue:@""];
        
    }
}

#pragma mark 回铃铃声

-(void)setSoundUrl:(NSString *)soundUrl{
    _soundUrl = soundUrl;
    
    [self downloadSoundSource];
}
    //下载铃声音频
-(void)downloadSoundSource{
    if (_soundUrl.length == 0) {
        return;
    }
    
//    NSString *oldPath = [AFNDownload cacheFileFromUrl:_soundUrl];
//    if (!oldPath) {
//        WkSelf(weakSelf);
//        [AFNDownload downloadFile:_soundUrl complite:^(NSString *filePath) {
//            if (filePath) {
//                weakSelf.soundPath = filePath;
//            }
//        }];
//    }else{
//        self.soundPath = oldPath;
//    }
}


@end
