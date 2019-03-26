//
//  ZYSearchHistoryDB.h
//  Apollo
//
//  Created by 李明伟 on 2018/8/1.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(int , ZYSearchHistoryType) {
    ZYSearchHistoryTypeItem = 1, //搜索商品
};

/**搜索历史记录库表管理*/
@interface ZYSearchHistoryDB : NSObject

+ (void)saveHistory:(NSString *)content type:(ZYSearchHistoryType)type;
+ (NSMutableArray *)getHistory:(ZYSearchHistoryType)type;
+ (void)removeAllHistory:(ZYSearchHistoryType)type;

@end
