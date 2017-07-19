//
//  CallLogObject.m
//  CallLiaoBei
//
//  Created by IntelcentMacMini on 16/11/21.
//  Copyright © 2016年 GeryHui. All rights reserved.
//

#import "CallLogObject.h"
#import <sqlite3.h>

NSString *const CallLogsUpdateNotification = @"CallLogsUpdateNotification";

static sqlite3 *database = nil;

@implementation CallLogObject
@synthesize logsTableName;

-(id)init{
    if (self = [super init]) {
        self.logsTableName = [CallLogObject tablename];
    }
    return self;
}

-(void)copyItem:(CallLogObject *)logItem{
    if ([logItem isKindOfClass:[CallLogObject class]]) {
        self.rowId = logItem.rowId;
        self.uid = logItem.uid;
        self.name = logItem.name;
        self.phone = logItem.phone;
        self.personId = logItem.personId;
        self.callType = logItem.callType;
        self.areaCity = logItem.areaCity;
        self.dateTime = logItem.dateTime;
    }
}

-(void)updateWithDbStatement:(sqlite3_stmt *)stmt{
    if (stmt) {
        [self setRowId:sqlite3_column_int(stmt, 0)];
        
        [self setUid:[NSString stringWithCString:(char *)sqlite3_column_text(stmt,1) encoding:NSUTF8StringEncoding]];
        [self setName:[NSString stringWithCString:(char *)sqlite3_column_text(stmt,2) encoding:NSUTF8StringEncoding]];
        [self setPhone:[NSString stringWithCString:(char *)sqlite3_column_text(stmt,3) encoding:NSUTF8StringEncoding]];
        [self setPersonId:[NSString stringWithCString:(char *)sqlite3_column_text(stmt,4) encoding:NSUTF8StringEncoding]];
        [self setCallType:[NSString stringWithCString:(char *)sqlite3_column_text(stmt,5) encoding:NSUTF8StringEncoding]];
        [self setAreaCity:[NSString stringWithCString:(char *)sqlite3_column_text(stmt,6) encoding:NSUTF8StringEncoding]];
        [self setDateTime:sqlite3_column_double(stmt,7)];
        [self setDuration:sqlite3_column_int(stmt, 8)];
    }
}

#pragma mark DB的操作
+ (void)openDatabase {
    NSString *databasePath = [ToolMethods documentFile:@"sip_app.db"];
    NSFileManager *filemgr = [NSFileManager defaultManager];
    //[filemgr removeItemAtPath:databasePath error:nil];
    BOOL firstInstall= ![filemgr fileExistsAtPath: databasePath ];
    
    if(sqlite3_open([databasePath UTF8String], &database) != SQLITE_OK) {
        NSLog(@"Can't open \"%@\" sqlite3 database.",databasePath);
        return;
    }
    
    if (firstInstall) {
        [self createTable];
    }
}

+ (void)closeDatabase {
    if(database != NULL) {
        if(sqlite3_close(database) != SQLITE_OK) {
            NSLog(@"Can't close sqlite3 database.");
        }
    }
    Release(database);
}

+(NSString *)tablename{
    return @"siplogs";
}

+(void)getShareDatabase{
    if (database == nil) {
        [self openDatabase];
        if (database == nil) {
            //如果还是创建失败，在NSBundle里放入一个空白db文件，然后copy到document目录
        }
    }
}

+(void) createTable{
    //"_id", "number", "name", "date", "duration","type"
    char *errorMsg;
    
    NSString *sql =[NSString stringWithFormat: @"create table if not exists %@ (id integer primary key autoincrement,uid text,name text,phone text,personid text,calltype text,areacity text, datetime double , duration integer)",self.tablename];
    const char *createSql = [sql cStringUsingEncoding:NSUTF8StringEncoding];
    
    if (sqlite3_exec(database, createSql, NULL, NULL, &errorMsg)==SQLITE_OK) {
    }else{
        NSLog(@"Can't create table error[%s]",errorMsg);
        sqlite3_free(errorMsg);
    }
}


#pragma mark 通话记录操作
    //查表
+(NSArray *)queryTable{
    sqlite3_stmt *statement;
    NSString *sql = [NSString stringWithFormat:@"select * from %@ order by datetime desc",self.tablename];
    const char *squerySql = [sql cStringUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableArray *array = nil;
    CallLogObject *itemObj = nil;
    if (sqlite3_prepare_v2(database, squerySql, -1, &statement, nil)==SQLITE_OK) {
        array=[[NSMutableArray alloc]init];
    }
    
    while (sqlite3_step(statement)==SQLITE_ROW) {
        itemObj = [[CallLogObject alloc] init];
        [itemObj updateWithDbStatement:statement];
        
        [array addObject:itemObj];
    }
    sqlite3_finalize(statement);
    
    return array;
}

+(NSArray *)queryLogsWithPhone:(NSString *)phone personId:(NSString *)pId{
    phone = phone!=nil?phone:@"";
    pId = pId!=nil?pId:@"";
    
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where phone=%@ and personid=%@",self.tablename,phone,pId];
    sqlite3_stmt *statement;
    if (pId.length == 0) {
        sql = [NSString stringWithFormat:@"select * from %@ where phone=%@",self.tablename,phone];
    }
    const char *squerySql = [sql cStringUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableArray *array = nil;
    CallLogObject *itemObj = nil;
    if (sqlite3_prepare_v2(database, squerySql, -1, &statement, nil)==SQLITE_OK) {
        array=[[NSMutableArray alloc]init];
    }
    
    while (sqlite3_step(statement)==SQLITE_ROW) {
        itemObj = [[CallLogObject alloc] init];
        [itemObj updateWithDbStatement:statement];
        
        [array addObject:itemObj];
    }
    sqlite3_finalize(statement);
    
    return array;
}

//删除某个联系人的所有记录
+(void)deletePeron:(NSString *)personId{
    char *errmsg = "";
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where personid = %@",self.tablename,personId];
    const char *deleteSql = [sql cStringUsingEncoding:(NSUTF8StringEncoding)];
    if (sqlite3_exec(database, deleteSql, NULL, NULL, &errmsg)) {
        
    }else{
        sqlite3_free(errmsg);
    }
    
}

//删表
+(void)deleteTable{
    char *errmsg = "";
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where 1 = 1",self.tablename];
    const char *deleteSql = [sql cStringUsingEncoding:(NSUTF8StringEncoding)];
    if (sqlite3_exec(database, deleteSql, NULL, NULL, &errmsg)) {
    }else{
        sqlite3_free(errmsg);
    }
}

//插入记录
-(void)insetDB{
    [self getNormalProperty];  //去除nil,null
    
    char *errmsg = "";
    NSString *sql = [NSString stringWithFormat:@"insert into %@ ('uid', 'name', 'phone', 'personid', 'calltype', 'areacity', 'datetime', 'duration') values('%@', '%@', '%@', '%@', '%@', '%@', '%f', '%i')",logsTableName, _uid,_name,_phone,_personId,_callType,_areaCity,_dateTime,_duration];
    const char *insetSql = [sql cStringUsingEncoding:NSUTF8StringEncoding];
    if (sqlite3_exec(database, insetSql, NULL, NULL, &errmsg)) {
        
    }else{
        sqlite3_free(errmsg);
    }
        //更新
    [[NSNotificationCenter defaultCenter] postNotificationName:CallLogsUpdateNotification object:nil];
}

    //删除本记录
-(void)itemDelete{
    char *errmsg = "";
    int curRow = self.rowId;
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where id = %i",logsTableName,curRow];
    const char *deleteSql = [sql cStringUsingEncoding:NSUTF8StringEncoding];
    if (sqlite3_exec(database, deleteSql, NULL, NULL, &errmsg)) {
        
    }else{
        sqlite3_free(errmsg);
    }
}
    //删除某个号码的所有记录
-(void)itemDeleteOfPhone{
    char *errmsg = "";
    NSString *curPhone = self.phone;
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where phone = %@",logsTableName,curPhone];
    const char *deleteSql = [sql cStringUsingEncoding:NSUTF8StringEncoding];
    if (sqlite3_exec(database, deleteSql, NULL, NULL, &errmsg)) {
        
    }else{
        sqlite3_free(errmsg);
    }
}
    //某个号码的所有记录更新
-(BOOL)itemUpdateOfPhone{
    char *errmsg = "";
    NSString *curPhone = self.phone;
    NSString *sql = [NSString stringWithFormat:@"update %@ set uid='%@', name='%@', phone='%@', personid='%@', calltype='%@', areacity='%@',datetime=%f, duration=%i where phone='%@' ",logsTableName,_uid,_name,_phone,_personId,_callType,_areaCity,_dateTime,_duration,curPhone];
    const char *updateSql = [sql cStringUsingEncoding:(NSUTF8StringEncoding)];
    if (sqlite3_exec(database, updateSql, NULL, NULL, &errmsg) == SQLITE_OK) {
        NSLog(@"记录更新成功");
        return YES;
    }else{
        sqlite3_free(errmsg);
    }
    return NO;
}

-(void)getNormalProperty{
    self.uid = [self getNormalString:_uid];
    self.name = [self getNormalString:_name];
    self.phone = [self getNormalString:_phone];
    self.personId = [self getNormalString:_personId];
    self.callType = [self getNormalString:_callType];
    self.areaCity = [self getNormalString:_areaCity];
    self.dateTime = (double)[[NSDate date] timeIntervalSince1970];
    
}

-(NSString *)getNormalString:(NSString *)str{
    NSString *resultStr = @"";
    if (str != nil && (NSNull *)str != [NSNull null]) {
        resultStr = str;
    }
    return resultStr;
}

-(NSString *)debugDescription{
    NSString *des = [NSString stringWithFormat:@"uid = %@ , name = %@ , phone = %@ , personId = %@ , callType = %@ , areaCity = %@ , dateTime = %f , duration = %d",_uid,_name,_phone,_personId,_callType,_areaCity,_dateTime,_duration];
    return des;
}



@end
