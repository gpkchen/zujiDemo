//
//  GetMoneyDetails.m
//  Apollo
//
//  Created by shaxia on 2018/5/12.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "GetMoneyDetails.h"

@implementation _p_GetMoneyDetails
- (instancetype)init{
    if(self = [super init]){
        self.url = @"/app/oper/money/getMoneyDetails";
        self.apiVersion = @"2";
    }
    return self;
}
@end

@implementation _m_GetMoneyDetails
+ (NSDictionary *) mj_objectClassInArray{
    return @{@"couponHistoryList":@"_m_couponHistoryList_list",
             @"benefitList":@"_m_GetMoneyDetails_benefit"};
}
@end



@implementation _m_GetMoneyDetails_benefit

@end




@implementation _m_couponHistoryList_list

@end



