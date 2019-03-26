//
//  ZYQuotaApnsAlert.h
//  Apollo
//
//  Created by 李明伟 on 2018/7/12.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseAlert.h"

typedef NS_ENUM(int , ZYQuotaApnsAlertShowType) {
    ZYQuotaApnsAlertShowTypePassAuth = 1, //通过认证无额度，不可提额
    ZYQuotaApnsAlertShowTypePassGainAmount = 2, //通过认证有额度，不可提额
    ZYQuotaApnsAlertShowTypePassAuthImprove = 3, //通过认证无额度，可以提额
    ZYQuotaApnsAlertShowTypePassGainAmountImprove = 4, //通过认证有额度，可以提额
};

@interface ZYQuotaApnsAlert : ZYBaseAlert

- (void)showWithType:(ZYQuotaApnsAlertShowType)type amount:(double)amount;

@end
