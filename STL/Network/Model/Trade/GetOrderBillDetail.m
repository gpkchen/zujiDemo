//
//  GetOrderBillDetail.m
//  Apollo
//
//  Created by 李明伟 on 2018/5/21.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "GetOrderBillDetail.h"

@implementation _p_GetOrderBillDetail

- (instancetype)init{
    if(self = [super init]){
        self.url = @"/app/trade/order/getRepaymentBillDetail";
    }
    return self;
}

@end




@implementation _m_GetOrderBillDetail

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"billList":@"_m_GetOrderBillDetail_Bill"};
}

@end




@implementation _m_GetOrderBillDetail_Bill

@end
