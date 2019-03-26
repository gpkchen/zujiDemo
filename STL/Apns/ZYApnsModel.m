//
//  ZYApnsModel.m
//  Apollo
//
//  Created by 李明伟 on 2018/5/24.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYApnsModel.h"

@implementation ZYApnsModel

- (instancetype) initWithDictionary:(NSDictionary *)dic{
    if(self = [super init]){
        _url = [dic objectForKey:@"url"];
        _title = [dic objectForKey:@"title"];
        _content = [dic objectForKey:@"content"];
        _showType = [[dic objectForKey:@"showType"] intValue];
        _btnTitle1 = [dic objectForKey:@"btnTitle1"];
        _btnTitle2 = [dic objectForKey:@"btnTitle2"];
        _remarks = [dic objectForKey:@"remarks"];
    }
    return self;
}

@end
