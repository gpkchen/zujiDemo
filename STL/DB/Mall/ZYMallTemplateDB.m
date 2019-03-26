//
//  ZYMallTemplateDB.m
//  Apollo
//
//  Created by 李明伟 on 2018/8/13.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYMallTemplateDB.h"
#import "ZYDatabase.h"
#import "AppModuleList.h"

@implementation ZYMallTemplateDB

+ (void)saveTemplates:(NSArray *)templates{
    [[ZYDatabase database] inDatabase:^(FMDatabase *db) {
        [db open];
        NSString *sql = [NSString stringWithFormat:@"delete from %@",ZYDatabaseMallDataTableName];
        [db executeUpdate:sql];
        
        NSString *content = [templates json];
        sql = [NSString stringWithFormat:@"insert into %@ (content,time) values (?,?)",ZYDatabaseMallDataTableName];
        [db executeUpdate:sql,
         content,
         [NSDate date]];
        [db close];
    }];
}

+ (NSMutableArray *)getTemplates{
    __block NSMutableArray *templates = [NSMutableArray array];
    [[ZYDatabase database] inDatabase:^(FMDatabase *db) {
        [db open];
        NSString *sql = [NSString stringWithFormat:@"select * from %@",ZYDatabaseMallDataTableName];
        FMResultSet *result = [db executeQuery:sql];
        while([result next]){
            NSString *content = [result stringForColumn:@"content"];
            NSArray *arr = [content array];
            if(arr.count){
                templates = [_m_AppModuleList mj_objectArrayWithKeyValuesArray:arr];
            }
            break;
        }
        [db close];
    }];
    return templates;
}

+ (void)removeAllTemplates{
    [[ZYDatabase database] inDatabase:^(FMDatabase *db) {
        [db open];
        NSString *sql = [NSString stringWithFormat:@"delete from %@",ZYDatabaseMallDataTableName];
        [db executeUpdate:sql];
        [db close];
    }];
}

@end
