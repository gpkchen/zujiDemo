//
//  ZYOrderConfirmVC.h
//  Apollo
//
//  Created by 李明伟 on 2018/4/23.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseVC.h"
#import "ItemDetail.h"

@interface ZYOrderConfirmVC : ZYBaseVC

/**价格id*/
@property (nonatomic , copy) NSString *priceId;
/**宝贝id*/
@property (nonatomic , copy) NSString *itemId;
/**宝贝类目id*/
@property (nonatomic , copy) NSString *categoryId;
/**增值服务IDs，中间用,隔开*/
@property (nonatomic , copy) NSString *serviceIds;
/**支付宝资金授权号*/
@property (nonatomic , copy) NSString *fundAuthNo;

@end
