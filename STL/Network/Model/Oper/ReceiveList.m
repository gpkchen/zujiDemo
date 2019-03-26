//
//  ReceiveList.m
//  Apollo
//
//  Created by 李明伟 on 2018/11/29.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import "ReceiveList.h"

@implementation _p_ReceiveList

- (instancetype)init{
    if(self = [super init]){
        self.url = @"/app/oper/couponGrant/receiveList";
        self.needApiToekn = NO;
    }
    return self;
}

@end
