//
//  ZYMallTemplateDB.h
//  Apollo
//
//  Created by 李明伟 on 2018/8/13.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**商城首页数据库表管理*/
@interface ZYMallTemplateDB : NSObject

+ (void)saveTemplates:(NSArray *)templates;
+ (NSMutableArray *)getTemplates;
+ (void)removeAllTemplates;

@end
