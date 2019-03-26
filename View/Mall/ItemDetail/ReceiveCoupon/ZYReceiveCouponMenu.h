//
//  ZYReceiveCouponMenu.h
//  Apollo
//
//  Created by 李明伟 on 2018/11/27.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import "ZYBaseSheet.h"

/**刷新优惠券列表回调*/
typedef void (^ZYReceiveCouponMenuRefreshCouponAction)(void);

@interface ZYReceiveCouponMenu : ZYBaseSheet

/**待领取优惠券*/
@property (nonatomic , strong) NSMutableArray *toReceiveCoupons;
/**已领取优惠券*/
@property (nonatomic , strong) NSMutableArray *receivedCoupons;

/**刷新优惠券列表回调*/
@property (nonatomic , copy) ZYReceiveCouponMenuRefreshCouponAction refreshCouponAction;

- (void)setToReceiveCoupons:(NSMutableArray *)toReceiveCoupons receivedCoupons:(NSMutableArray *)receivedCoupons;

@end

