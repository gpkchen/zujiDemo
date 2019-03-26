//
//  BackItemExpress.h
//  Apollo
//
//  Created by 李明伟 on 2018/11/7.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**用户归还商品参数*/
@interface _p_BackItemExpress : ZYBaseParam

/**订单id*/
@property (nonatomic , copy) NSString *orderId;
/**快递单号*/
@property (nonatomic , copy) NSString *expressNo;
/**快递公司编号*/
@property (nonatomic , copy) NSString *companyCode;

@end

NS_ASSUME_NONNULL_END
