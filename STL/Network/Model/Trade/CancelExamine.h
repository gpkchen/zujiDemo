//
//  CancelExamine.h
//  Apollo
//
//  Created by 李明伟 on 2018/9/25.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**发货中用户取消订单申请参数*/
@interface _p_CancelExamine : ZYBaseParam

/**订单ID*/
@property (nonatomic , copy) NSString *orderId;
/**取消原因*/
@property (nonatomic , copy) NSString *cancelReason;

@end

