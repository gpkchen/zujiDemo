//
//  StudentCard.m
//  Apollo
//
//  Created by 李明伟 on 2018/7/18.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "StudentCard.h"

@implementation _p_StudentCard

- (instancetype)init{
    if(self = [super init]){
        self.url = @"app/user/upload/studentcard";
    }
    return self;
}

@end
