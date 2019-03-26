//
//  ZYMomentsDB.m
//  Apollo
//
//  Created by 李明伟 on 2018/7/25.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYMomentsDB.h"
#import "ZYDatabase.h"

@implementation ZYMomentsDB

+ (void)saveMoment:(ZYMoment *)moment{
    NSString *images = @"";
    for(NSString *url in moment.images){
        images = [images stringByAppendingString:[NSString stringWithFormat:@"%@,",url]];
    }
    [[ZYDatabase database]inDatabase:^(FMDatabase *db) {
        [db open];
        NSString *sql = [NSString stringWithFormat:@"insert into %@ (content,images) values (?,?)",ZYDatabaseMomentsTableName];
        [db executeUpdate:sql,
         moment.content,
         images];
        [db close];
    }];
}

+ (ZYMoment *)readMoment{
    __block ZYMoment *moment = nil;
    [[ZYDatabase database]inDatabase:^(FMDatabase *db) {
        [db open];
        NSString *sql = [NSString stringWithFormat:@"select * from %@",ZYDatabaseMomentsTableName];
        FMResultSet *result = [db executeQuery:sql];
        while([result next]){
            moment = [ZYMoment new];
            moment.content = [result stringForColumn:@"content"];
            NSString *images = [result stringForColumn:@"images"];
            NSArray *imageArr = [images componentsSeparatedByString:@","];
            NSMutableArray *formatImages = [NSMutableArray array];
            for(NSString *url in imageArr){
                if(url.length){
                    [formatImages addObject:url];
                }
            }
            moment.images = formatImages;
            break;
        }
        sql = [NSString stringWithFormat:@"delete from %@",ZYDatabaseMomentsTableName];
        [db executeUpdate:sql];
        [db close];
    }];
    return moment;
}

@end
