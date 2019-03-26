//
//  NSArray+ZYExtension.m
//  PodLib
//
//  Created by 李明伟 on 2018/3/26.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "NSArray+ZYExtension.h"
#import "ZYMacro.h"

@implementation NSArray (ZYExtension)

- (NSString * _Nonnull) json {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:0
                                                         error:&error];
    
    if (! jsonData) {
        ZYLog(@"jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
        return @"[]";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

@end
