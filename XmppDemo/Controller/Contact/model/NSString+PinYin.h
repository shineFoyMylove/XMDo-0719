//
//  NSString+PinYin.h
//  WhichBank
//
//  Created by libokun on 15/9/8.
//  Copyright (c) 2015年 lettai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (PinYin)

- (NSString *) pinyin;   /**<全拼音  */
- (NSString *) pinyinInitial;  /**< 首拼音 */

@end
