//
//  ZYDatabase.m
//  Apollo
//
//  Created by 李明伟 on 2018/7/25.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYDatabase.h"

NSString * const ZYDatabaseMomentsTableName = @"ZYDatabaseMomentsTableName_1_0_0";
NSString * const ZYDatabaseSearchHistoryTableName = @"ZYDatabaseSearchHistoryTableName_1_0_0";
NSString * const ZYDatabaseMallDataTableName = @"ZYDatabaseMallDataTableName_1_0_0";

@implementation ZYDatabase

+ (instancetype)database{
    static ZYDatabase *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"apollo.db"];
        _instance = [[ZYDatabase alloc] initWithPath:path];
    });
    return _instance;
}

#pragma mark - 重载初始化方法
- (id)initWithPath:(NSString *)aPath{
    self = [super initWithPath:aPath];
    if(self){
        [self dealTables];
    }
    return self;
}

#pragma mark - 创建(删除)数据库表
- (void)dealTables{
    [self inDatabase:^(FMDatabase *db) {
        [db open];
        
        /////创建表
        NSString *momentsTableSql = [NSString stringWithFormat:@"create table if not exists %@ (t_id INTEGER PRIMARY KEY AUTOINCREMENT , content varchar(2000) ,images text)",ZYDatabaseMomentsTableName];
        NSString *searchHistoryTableSql = [NSString stringWithFormat:@"create table if not exists %@ (t_id INTEGER PRIMARY KEY AUTOINCREMENT , content varchar(128),type int ,time date)",ZYDatabaseSearchHistoryTableName];
        NSString *mallDataTableSql = [NSString stringWithFormat:@"create table if not exists %@ (t_id INTEGER PRIMARY KEY AUTOINCREMENT , content text,time date)",ZYDatabaseMallDataTableName];
        [db executeUpdate:momentsTableSql];
        [db executeUpdate:searchHistoryTableSql];
        [db executeUpdate:mallDataTableSql];
        [db close];
    }];
}

@end
