//
//  NSUserDefaults+ZYExtension.h
//  PodLib
//
//  Created by 李明伟 on 2018/3/27.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (ZYExtension)

/**
 存入自定义对象
 @param object 需要存入的自定义对象
 @param key 自定义对象对应的key
 */
+ (void)writeWithObject:(id)object
                 forKey:(NSString *)key;

/**
 获取自定义对象
 @param key 自定义对象对应的key
 @return 返回自定义对象
 */
+ (id)readObjectWithKey:(NSString *)key;

/**
 删除自定义对象
 @param key 自定义对象对应的key
 */
+ (void)removeObjectForKey:(NSString *)key;

@end
