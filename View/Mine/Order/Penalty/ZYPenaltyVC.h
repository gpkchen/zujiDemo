//
//  ZYPenaltyVC.h
//  Apollo
//
//  Created by 李明伟 on 2018/6/20.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseVC.h"

@interface ZYPenaltyVC : ZYBaseVC

/**订单id（其他不为空时查询的是账单逾期金额，接口不同）*/
@property (nonatomic , copy) NSString *orderId;
/**账单id*/
@property (nonatomic , copy) NSString *billIds;
/**1：单笔账单 2：所有剩余账单*/
@property (nonatomic , copy) NSString *payBillType;

@end
