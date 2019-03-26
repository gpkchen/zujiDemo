//
//  GetRepaymentBillList.h
//  Apollo
//
//  Created by 李明伟 on 2018/5/15.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**账单列表查询参数*/
@interface _p_GetRepaymentBillList : ZYBaseParam

@end




/**账单列表查询返回*/
@interface _m_GetRepaymentBillList : ZYBaseModel

/**订单id*/
@property (nonatomic , copy) NSString *orderId;
/**账单id*/
@property (nonatomic , copy) NSString *billId;
/**宝贝名称*/
@property (nonatomic , copy) NSString *title;
/**租期类型*/
@property (nonatomic , assign) ZYRentType rentType;
/**租金*/
@property (nonatomic , assign) double rentPrice;
/**当前期数*/
@property (nonatomic , assign) int nowRentPeriod;
/**总租期*/
@property (nonatomic , assign) int allRentPeriod;
/**还款日*/
@property (nonatomic , copy) NSString *repaymentDate;
/**账单状态*/
@property (nonatomic , assign) ZYBillState billStatus;
/**账单是否已还清*/
@property (nonatomic , assign) BOOL isPayAllBills;
/**账单列表*/
@property (nonatomic , strong) NSArray *billList;

/**是否展开（本地计算用）*/
@property (nonatomic , assign) BOOL isOpen;

@end



@interface _m_GetRepaymentBillList_Bill : ZYBaseModel

/**租期类型*/
@property (nonatomic , assign) ZYRentType rentType;
/**账单id*/
@property (nonatomic , copy) NSString *billId;
/**租金*/
@property (nonatomic , assign) double rentPrice;
/**当前期数*/
@property (nonatomic , assign) int nowRentPeriod;
/**总租期*/
@property (nonatomic , assign) int allRentPeriod;
/**还款日*/
@property (nonatomic , copy) NSString *repaymentDate;
/**账单状态*/
@property (nonatomic , assign) ZYBillState billStatus;
/**逾期天数*/
@property (nonatomic , assign) int overdueDays;
/**逾期金额*/
@property (nonatomic , assign) double overdueFee;

@end
