//
//  GetRepaymentBillList.m
//  Apollo
//
//  Created by 李明伟 on 2018/5/15.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "GetRepaymentBillList.h"

@implementation _p_GetRepaymentBillList

- (instancetype)init{
    if(self = [super init]){
        self.url = @"/app/trade/order/getRepaymentBillList";
    }
    return self;
}

@end




@implementation _m_GetRepaymentBillList

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"billList":@"_m_GetRepaymentBillList_Bill"};
}

@end



@implementation _m_GetRepaymentBillList_Bill

@end
