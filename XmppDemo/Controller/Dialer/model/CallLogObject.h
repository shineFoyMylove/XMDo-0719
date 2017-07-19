//
//  CallLogObject.h
//  CallLiaoBei
//
//  Created by IntelcentMacMini on 16/11/21.
//  Copyright © 2016年 GeryHui. All rights reserved.
//  通话记录

#import <Foundation/Foundation.h>

extern NSString *const CallLogsUpdateNotification;

@interface CallLogObject : NSObject

@property (nonatomic, assign) int rowId;

@property (nonatomic, retain) NSString *uid;    /**<拨打者 uid */
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *phone;
@property (nonatomic, retain) NSString *personId;
@property (nonatomic, retain) NSString *callType;   /**<1-回拨 2-直拨 3-来电 */
@property (nonatomic, retain) NSString *areaCity;   /**<归属地 */

@property (nonatomic, assign) double dateTime;      /**<呼叫日期 */
@property (nonatomic, assign) int duration;         /**<时长 */

@property (nonatomic, retain) NSString *logsTableName;


-(void)copyItem:(CallLogObject *)logItem;

#pragma mark DB的操作
+ (void)openDatabase;
+ (void)closeDatabase;

#pragma mark 通话记录操作
/**
 查表 */
+(NSArray *)queryTable;

/**
 差某个号码，pid 的所有号码记录*/
+(NSArray *)queryLogsWithPhone:(NSString *)phone personId:(NSString *)pId;

/**
 删除某个联系人的所有记录 */
+(void)deletePeron:(NSString *)personId;
/**
 删表*/
+(void)deleteTable;

/**
 插入记录 */
-(void)insetDB;
/**
 删除本记录 */
-(void)itemDelete;
/**
 删除当前号码的所有记录*/
-(void)itemDeleteOfPhone;
/**
 某个号码对应的所有记录更新 */
-(BOOL)itemUpdateOfPhone;

-(NSString *)debugDescription;

@end
