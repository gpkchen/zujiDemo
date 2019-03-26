//
//  AppActiveInfo.h
//  Apollo
//
//  Created by 李明伟 on 2018/5/18.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**广告查询参数*/
@interface _p_AppActiveInfo : ZYBaseParam

/**1、广告位  2、开屏页 3、弹窗*/
@property (nonatomic , copy) NSString *activeType;
/**activeType-1(广告位)：1-支付成功 2-支付失败
 activeType-2（开屏页）：不传
 activeType-3（弹窗）：1-app启动 2-app激活 3- 用户登录 4-静默登录 5-下单成功*/
@property (nonatomic , copy) NSString *type;

@end



/**广告查询返回*/
@interface _m_AppActiveInfo : ZYBaseModel

/**图片地址*/
@property (nonatomic , copy) NSString *imgUrl;
/**协议*/
@property (nonatomic , copy) NSString *url;

@end
