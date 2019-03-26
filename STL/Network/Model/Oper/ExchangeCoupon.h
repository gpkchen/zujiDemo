//
//  ExchangeCoupon.h
//  Apollo
//
//  Created by 李明伟 on 2018/10/10.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**兑换优惠券参数*/
@interface _p_ExchangeCoupon : ZYBaseParam

/**兑换码*/
@property (nonatomic , copy) NSString *redeemCode;

@end
