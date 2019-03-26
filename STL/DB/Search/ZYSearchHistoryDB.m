//
//  ZYSearchHistoryDB.m
//  Apollo
//
//  Created by 李明伟 on 2018/8/1.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYSearchHistoryDB.h"
#import "ZYDatabase.h"

@implementation ZYSearchHistoryDB

+ (void)saveHistory:(NSString *)content type:(ZYSearchHistoryType)type{
    [[ZYDatabase database] inDatabase:^(FMDatabase *db) {
        [db open];
        NSString *sql = [NSString stringWithFormat:@"delete from %@ where content = ? and type = ?",ZYDatabaseSearchHistoryTableName];
        [db executeUpdate:sql,content,@(type)];
        
        sql = [NSString stringWithFormat:@"insert into %@ (content,type,time) values (?,?,?)",ZYDatabaseSearchHistoryTableName];
        [db executeUpdate:sql,
         content,
         @(type),
         [NSDate date]];
        [db close];
    }];
}

+ (NSMutableArray *)getHistory:(ZYSearchHistoryType)type{
    NSMutableArray *historys = [NSMutableArray array];
    [[ZYDatabase database] inDatabase:^(FMDatabase *db) {
        [db open];
        NSString *sql = [NSString stringWithFormat:@"select * from %@ where type = ? order by time desc",ZYDatabaseSearchHistoryTableName];
        FMResultSet *result = [db executeQuery:sql,@(type)];
        while([result next]){
            NSString *content = [result stringForColumn:@"content"];
            [historys addObject:content];
            if(historys.count >= 10){
                break;
            }
        }
        [db close];
    }];
    return historys;
}

+ (void)removeAllHistory:(ZYSearchHistoryType)type{
    [[ZYDatabase database] inDatabase:^(FMDatabase *db) {
        [db open];
        NSString *sql = [NSString stringWithFormat:@"delete from %@ where type = ?",ZYDatabaseSearchHistoryTableName];
        [db executeUpdate:sql,@(type)];
        [db close];
    }];
}

@end
