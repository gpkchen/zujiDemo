//
//  ZYCashier.h
//  Apollo
//
//  Created by 李明伟 on 2018/5/11.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseSheet.h"
#import "ZYPaymentService.h"

typedef void (^ZYCashierAction)(ZYPaymentType paymentType);

@interface ZYCashier : ZYBaseSheet

/**事件*/
@property (nonatomic , copy) ZYCashierAction action;

- (void)show;

@end
