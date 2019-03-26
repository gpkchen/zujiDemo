//
//  ZYDatabase.h
//  Apollo
//
//  Created by 李明伟 on 2018/7/25.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "FMDatabaseQueue.h"
#import "FMDatabase.h"

/**资讯表名*/
extern NSString * const ZYDatabaseMomentsTableName;
/**搜索历史表名*/
extern NSString * const ZYDatabaseSearchHistoryTableName;
/**商城首页数据表名*/
extern NSString * const ZYDatabaseMallDataTableName;

/**********数据库管理基类**********/
@interface ZYDatabase : FMDatabaseQueue

/**
 获取数据库单例
 **/
+ (instancetype)database;

@end
