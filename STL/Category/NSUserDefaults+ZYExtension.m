//
//  NSUserDefaults+ZYExtension.m
//  PodLib
//
//  Created by 李明伟 on 2018/3/27.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "NSUserDefaults+ZYExtension.h"

@implementation NSUserDefaults (ZYExtension)

+ (void)writeWithObject:(id)object
                 forKey:(NSString *)key{
    //    id obj = [self readObjectWithKey:key];
    //    if(obj)
    [self removeObjectForKey:key];
    
    NSUserDefaults *userDefault = [self standardUserDefaults];
    
    //transform data
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object];
    [userDefault setObject:data
                    forKey:key];
    [userDefault synchronize];
}

+ (id)readObjectWithKey:(NSString *)key{
    NSUserDefaults *userDefault = [self standardUserDefaults];
    id obj = [userDefault objectForKey:key];
    //transform object
    if (obj) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:obj];
    } else {
        return nil;
    }
}

+ (void)removeObjectForKey:(NSString *)key{
    NSUserDefaults *userDefault = [self standardUserDefaults];
    [userDefault removeObjectForKey:key];
    [userDefault synchronize];
}

@end
