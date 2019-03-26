//
//  GetOrderList.h
//  Apollo
//
//  Created by 李明伟 on 2018/5/10.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**订单列表查询参数*/
@interface _p_GetOrderList : ZYBaseParam

//获取全部订单
/**1：进行中 2：已完成 3：已取消*/
@property (nonatomic , copy) NSString *stateType;

//获取我的界面订单
/**0: 待付款, 3: 异常, 4: 待发货, 5: 已发货（待收货）, 8：已确认收货（使用中），9：已寄回*/
@property (nonatomic , copy) NSString *status;

/**页码数*/
@property (nonatomic , copy) NSString *page;
/**每页数量*/
@property (nonatomic , copy) NSString *size;

@end




/**订单列表查询返回*/
@interface _m_GetOrderList : ZYBaseModel

/**客服电话*/
@property (nonatomic , copy) NSString *servicePhone;
/**订单id*/
@property (nonatomic , copy) NSString *orderId;
/**账单id，用于支付*/
@property (nonatomic , copy) NSString *billId;
/**宝贝名称*/
@property (nonatomic , copy) NSString *title;
/**规格*/
@property (nonatomic , copy) NSString *goodsSkuNames;
/**订单状态*/
@property (nonatomic , assign) ZYOrderState status;
/**租金*/
@property (nonatomic , copy) NSString *rentPrice;
/**下单时间*/
@property (nonatomic , copy) NSString *orderTime;
/**支付剩余时间 单位:毫秒*/
@property (nonatomic , assign) long long payExpireTime;
/**租期类型*/
@property (nonatomic , assign) ZYRentType rentType;
/**宝贝图片*/
@property (nonatomic , copy) NSString *imageUrl;
/**距离账单日天数*/
@property (nonatomic , assign) int repayBillDays;
/**逾期天数*/
@property (nonatomic , assign) int overdueDays;
/**距离归还日天数*/
@property (nonatomic , assign) int returnBackDays;
/**距离归还日天数（不计算推延）*/
@property (nonatomic , assign) int realReturnBackDays;
/**账单是否已还清*/
@property (nonatomic , assign) BOOL isPayAllBills;
/**邮寄方式*/
@property (nonatomic , assign) ZYExpressType expressType;
/**归还超时天数*/
@property (nonatomic , assign) int returnOverDays;
/**是否显示支付违约金按钮*/
@property (nonatomic , assign) BOOL isPenalty;
/**是否可续租*/
@property (nonatomic , assign) BOOL isRelet;
/**0正常 1取消中 2取消驳回*/
@property (nonatomic , assign) int isCanceling;
/**是否上传过快递单号*/
@property (nonatomic , assign) BOOL isReturnBack;

@end
