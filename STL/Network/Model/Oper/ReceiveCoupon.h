//
//  ReceiveCoupon.h
//  Apollo
//
//  Created by 李明伟 on 2018/11/29.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**领取优惠券参数*/
@interface _p_ReceiveCoupon : ZYBaseParam

/**发放任务id*/
@property (nonatomic , copy) NSString *couponGrantId;

@end

NS_ASSUME_NONNULL_END
