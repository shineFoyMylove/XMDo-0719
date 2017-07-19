//
//  NSString+StringType.m
//  WT-YiShouZhangGui
//
//  Created by yingzhijie on 15/9/23.
//  Copyright (c) 2015年 Kiwaro. All rights reserved.
//

#import "NSString+StringType.h"



@implementation NSString (StringType)

/**
    @"^[0-9]$"  @"^[A-Za-z]$"       //匹配某一个字符，是数字还是字母
    @"^[0-9]+$"  //匹配1个或者多个字符是数字   @"^[0-9]*$"  //匹配0个或者多个字符是数字
    **/

-(BOOL)isNumberTypeString{
    
    NSString *numberRegex = @"^[0-9]+$";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",numberRegex];
    if ([numberTest evaluateWithObject:self]) {
        return YES;
    }
    return NO;
}

-(BOOL)isWordCharacter{
    NSString *characterRegex = @"^[A-Za-z]+$";
    NSPredicate *charTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",characterRegex];
    if ([charTest evaluateWithObject:self]) {
        return YES;
    }
    return NO;
}

-(BOOL)isNumberOrCharacter{
    NSString *numCharRegex = @"^[A-Za-z0-9]+$";   //a-zA-Z0-9
    NSPredicate *numCharPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",numCharRegex];
    if ([numCharPre evaluateWithObject:self]) {
        return YES;
    }
    return NO;
}

-(BOOL)isTelephoneTypeString{
    //手机号 以13，15，18开头 ，八个\d数字字符串
//    NSString *phoneRegex = @"(^(13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSString *phoneRegex = @"^[1][3-8]+\\d{9}$";                //13-8开头，九个数字字符串
//    NSString *phoneRegex = @"^[1]+\\d{10}+$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    if ([phoneTest evaluateWithObject:self]) {
        return YES;
    }
    return NO;
}

-(BOOL)isEmailTypeString{
    //
    NSString *emailRegex = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    //NSString *emailRegex =@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailRegex];
    if ([emailTest evaluateWithObject:self]) {
        return YES;
    }
    return NO;
}
    //中文字符
-(BOOL)isChineseWordString{
    NSString *wordRegex = @"^[\u4E00-\u9FA5]";
    NSPredicate *wordPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",wordRegex];
    if ([wordPre evaluateWithObject:self]) {
        return YES;
    }
    return NO;
}
    //至少 n个中文字符
-(BOOL)isChineseWordStringWithMinLimited:(NSInteger)numer
                              withLength:(NSInteger)lenght{
    NSString *limitWordRegex = [NSString stringWithFormat:@"^[\u4E00-\u9FA5]{%d,%d}",(int)numer,(int)lenght];
     NSPredicate *wordPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",limitWordRegex];
    if ([wordPre evaluateWithObject:self]) {
        return YES;
    }
    return NO;
}
    //6-16位字母或者数字
-(BOOL)isNumberOrWordCharWithMinLimited:(NSInteger)number withLenght:(NSInteger)lenght{
    NSString *limitNumOrWordRegex = [NSString stringWithFormat:@"^[a-zA-Z0-9]{%d,%d}$",(int)number,(int)lenght];
    NSPredicate *numOrWordPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",limitNumOrWordRegex];
    if ([numOrWordPre evaluateWithObject:self]) {
        return YES;
    }
    return NO;
}

/*          6-16位数字和字母 字符串
    ^ 匹配一行的开头位置
    (?![0-9]+$) 预测该位置后面不全是数字
    (?![a-zA-Z]+$) 预测该位置后面不全是字母
    [0-9A-Za-z] {6,10} 由6-10位数字或这字母组成
    $ 匹配行结尾位置
 */
-(BOOL)isHaveNumberAndWordCharWithLenghtFrom:(NSInteger)limLenght toMaxLenght:(NSInteger)maxLenght{
    NSString *numAndWrodRegex = [NSString stringWithFormat:@"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{%ld,%d}",(long)limLenght,maxLenght];
    NSPredicate *numAndWordPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",numAndWrodRegex];
    if ([numAndWordPre evaluateWithObject:self]) {
        return YES;
    }
    return NO;
}

@end
