//
//  NSString+StringType.h
//  WT-YiShouZhangGui
//
//  Created by yingzhijie on 15/9/23.
//  Copyright (c) 2015年 Kiwaro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (StringType)

-(BOOL)isNumberTypeString;          /**<纯数字字符串*/

-(BOOL)isWordCharacter;         /**<字母字符*/

-(BOOL)isNumberOrCharacter;   /**<字母 或者 数字字符 */

-(BOOL)isTelephoneTypeString;       /**<手机号码字符串*/

-(BOOL)isEmailTypeString;           /**<是邮箱字符串*/

-(BOOL)isChineseWordString;     /**< 中文字符串*/

-(BOOL)isChineseWordStringWithMinLimited:(NSInteger)numer
                              withLength:(NSInteger)lenght;     /**< 中文字符 (个数限制) limitNum = number  长度 = lenght*/
/**
 6-16位字母或者数字 */
-(BOOL)isNumberOrWordCharWithMinLimited:(NSInteger)number withLenght:(NSInteger)lenght;

@end
