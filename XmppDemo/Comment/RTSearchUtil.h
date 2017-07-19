//
//  RTSearchUtil.h
//  WHIMDemo1
//
//  Created by IntelcentMac on 17/5/12.
//  Copyright © 2017年 wh_shine. All rights reserved.
//  实时检索

#import <Foundation/Foundation.h>

typedef void (^RealTimeSearchResultBlock)(NSArray *results);

@interface RTSearchUtil : NSObject

/**
 单例实例化 */
+(instancetype)currentUtil;

/**
 开始检索   默认YES(要搜索的字符串作为一个整体)
 *  @param source      要搜索的数据源
 *  @param searchText  要搜索的字符串
 *  @param selector    获取元素中要比较的字段的方法
 *  @param resultBlock 回调方法，返回搜索结果
 */
-(void)searchWithSource:(id)source searchText:(NSString *)searchText collationStringSelector:(SEL)selector resultBlock:(RealTimeSearchResultBlock)resultBlock;

/**
 从fromString中搜索是否包含 searchString
 *  @param searchString 要搜索的字串
 *  @param fromString   从哪个字符串搜索
 */
-(BOOL)searchStringContain:(NSString *)searchString fromString:(NSString *)fromString;

/**
 结束检索，只需要调用一次 ，主要用于释放资源
 */
-(void)searchStop;

@end
