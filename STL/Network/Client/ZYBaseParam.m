//
//  ZYBaseParam.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/17.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseParam.h"

@implementation ZYBaseParam

- (instancetype)init{
    if(self = [super init]){
        _timestamp = [NSString stringWithFormat:@"%lld",[[NSDate date] millisecondSince1970]];
        _needApiToekn = YES;
        _apiVersion = ApiVersion;
    }
    return self;
}

- (NSDictionary *)getDicParam{
    return self.mj_keyValues;
}

- (NSString *)countSign:(NSString *)s k:(NSString *)k{
    NSString *c = nil;
    NSString *toSign = @"";
    for(int i =0; i < s.length; i++){
        c = [s substringWithRange:NSMakeRange(i, 1)];
        if([c isEqualToString:@"1"]){
            toSign = [toSign stringByAppendingString:_timestamp];
        }
        if([c isEqualToString:@"2"]){
            toSign = [toSign stringByAppendingString:[ZYDeviceUtils utils].uuidForDevice];
        }
        if([c isEqualToString:@"3"]){
            NSString *body = [[self getDicParam] json];
            toSign = [toSign stringByAppendingString:body];
        }
        if([c isEqualToString:@"4"]){
            toSign = [toSign stringByAppendingString:k];
        }
    }
    NSString *md5 = [toSign md5];
    return md5;
}

+ (NSMutableArray *)mj_totalIgnoredPropertyNames{
    NSMutableArray *names = [NSMutableArray arrayWithObjects:@"url",@"timestamp",@"needApiToekn",@"apiVersion", nil];
    return names;
}

@end
