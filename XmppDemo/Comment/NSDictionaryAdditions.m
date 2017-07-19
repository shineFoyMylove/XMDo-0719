//
//  NSDictionaryAdditions.m
//  WeiboPad
//
//  Created by junmin liu on 10-10-6.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "NSDictionaryAdditions.h"


@implementation NSDictionary (Additions)

- (BOOL)getBoolValueForKey:(NSString *)key defaultValue:(BOOL)defaultValue {
    id tmpValue = [self objectForKey:key];
    
    if (tmpValue == nil || tmpValue == [NSNull null]) {
        return defaultValue;
    }
    
    if ([tmpValue isKindOfClass:[NSNumber class]]) {
        return [tmpValue boolValue];
    } else {
        @try {
            return [tmpValue boolValue];
        }
        @catch (NSException *exception) {
            NSLog(@"getBoolValueForKey : %@",key);
            NSLog(@"tmpValue : %@",tmpValue);
            return defaultValue;
        }
    }
}

- (int)getIntValueForKey:(NSString *)key defaultValue:(int)defaultValue {
    id tmpValue = [self objectForKey:key];
    
    if (tmpValue == nil || tmpValue == [NSNull null]) {
        return defaultValue;
    }
    
    if ([tmpValue isKindOfClass:[NSNumber class]]) {
        return [tmpValue intValue];
    } else {
        @try {
            return [tmpValue intValue];
        }
        @catch (NSException *exception) {
            NSLog(@"getIntValueForKey : %@",key);
            NSLog(@"tmpValue : %@",tmpValue);
            return defaultValue;
        }
    }
}

- (float)getFloatValueForKey:(NSString *)key defaultValue:(float)defaultValue {
    id tmpValue = [self objectForKey:key];
    
    if (tmpValue == nil || tmpValue == [NSNull null]) {
        return defaultValue;
    }
    
    if ([tmpValue isKindOfClass:[NSNumber class]]) {
        return [tmpValue floatValue];
    } else {
        @try {
            return [tmpValue floatValue];
        }
        @catch (NSException *exception) {
            NSLog(@"getFloatValueForKey : %@",key);
            NSLog(@"tmpValue : %@",tmpValue);
            return defaultValue;
        }
    }
}

- (double)getDoubleValueForKey:(NSString*)key defaultValue:(double)defaultValue {
    id tmpValue = [self objectForKey:key];
    
    if (tmpValue == nil || tmpValue == [NSNull null]) {
        return defaultValue;
    }
    
    if ([tmpValue isKindOfClass:[NSNumber class]]) {
        return [tmpValue doubleValue];
    } else {
        @try {
            return [tmpValue doubleValue];
        }
        @catch (NSException *exception) {
            NSLog(@"getDoubleValueForKey : %@",key);
            NSLog(@"tmpValue : %@",tmpValue);
            return defaultValue;
        }
    }
}

- (long long)getLongLongValueValueForKey:(NSString *)key defaultValue:(long long)defaultValue {
    id tmpValue = [self objectForKey:key];
    
    if (tmpValue == nil || tmpValue == [NSNull null]) {
        return defaultValue;
    }
    
    if ([tmpValue isKindOfClass:[NSNumber class]]) {
        return [tmpValue longLongValue];
    } else {
        @try {
            return [tmpValue longLongValue];
        }
        @catch (NSException *exception) {
            NSLog(@"getLongLongValueValueForKey : %@",key);
            NSLog(@"tmpValue : %@",tmpValue);
            return defaultValue;
        }
    }
}

- (NSString *)getStringValueForKey:(NSString *)key defaultValue:(NSString *)defaultValue {
    id tmpValue = [self objectForKey:key];
    
    if (tmpValue == nil || tmpValue == [NSNull null]) {
        return defaultValue;
    }
    
    if ([tmpValue isKindOfClass:[NSString class]]) {
        return [NSString stringWithString:tmpValue];
    } else {
        @try {
            return [NSString stringWithFormat:@"%@",tmpValue];
        }
        @catch (NSException *exception) {
            NSLog(@"getStringValueForKey : %@",key);
            NSLog(@"tmpValue : %@",tmpValue);
            return defaultValue;
        }
    }
}

- (NSDictionary*)getDictionaryForKey:(NSString*)key {
    id tmpValue = [self objectForKey:key];
    if ([tmpValue isKindOfClass:[NSDictionary class]]) {
        return tmpValue;
    } else {
        return nil;
    }
}

- (NSArray*)getArrayForKey:(NSString*)key {
    id tmpValue = [self objectForKey:key];
    if ([tmpValue isKindOfClass:[NSArray class]]) {
        return tmpValue;
    } else {
        return nil;
    }
}

@end


@implementation NSDictionary (CollationAdditions)
- (NSString*)getNameValue {
    return [self getStringValueForKey:@"name" defaultValue:@""];
}
- (NSString*)getCodeValue {
    return [self getStringValueForKey:@"code" defaultValue:@""];
}


-(void)lyh_GetResultData:(void (^)(BOOL succ, NSString *errmsg, NSArray *dataList, BOOL noMore))complite{
    if ([self isKindOfClass:[NSDictionary class]]) {
        BOOL succ = NO;
        NSString *errmsg = @"";
        NSArray *dataList = nil;
        BOOL noMoreData = NO;   //默认更多数据
        
        NSString *codeValue = [self getStringValueForKey:@"code" defaultValue:@""];
        NSString *msg = [self getStringValueForKey:@"msg" defaultValue:@""];
        NSDictionary *dataDic = [self getDictionaryForKey:@"data"];
        if ([codeValue isEqualToString:@"0"]) {
            //成功
            succ = YES;
            if ([dataDic isKindOfClass:[NSDictionary class]]) {
                NSString *page = [dataDic getStringValueForKey:@"page" defaultValue:@""];
                NSString *pageCount = [dataDic getStringValueForKey:@"pageCount" defaultValue:@""];
                NSArray *tempList = [dataDic getArrayForKey:@"list"];
                if ([tempList isKindOfClass:[NSArray class]] && tempList.count >0) {
                    dataList = [[NSArray alloc] initWithArray:tempList];
                }
                if ([page isEqualToString:pageCount] == YES) {
                    //有更多数据
                    noMoreData = YES;
                }
            }
        }else{
            errmsg = msg.length >0?msg:@"数据请求失败";
        }
        
        if (complite) {
            complite(succ,errmsg,dataList,noMoreData);
        }
    }else{
        NSLog(@"JSON数据错误(非NSDictionary)");
    }
    
}




@end
