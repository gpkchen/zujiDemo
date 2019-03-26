//
//  ZYBillConfirmVC.h
//  Apollo
//
//  Created by 李明伟 on 2018/4/28.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseVC.h"

@interface ZYBillConfirmVC : ZYBaseVC

/**订单id*/
@property (nonatomic , copy) NSString *orderId;
/**账单id，支付单笔账单时需要使用*/
@property (nonatomic , copy) NSString *billId;

@end
