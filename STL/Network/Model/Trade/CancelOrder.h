//
//  CancelOrder.h
//  Apollo
//
//  Created by 李明伟 on 2018/5/16.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**取消订单参数*/
@interface _p_CancelOrder : ZYBaseParam

/**订单编号*/
@property (nonatomic , copy) NSString *orderId;

@end


