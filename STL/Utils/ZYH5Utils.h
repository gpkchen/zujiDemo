//
//  ZYH5Utils.h
//  Apollo
//
//  Created by 李明伟 on 2018/5/23.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**h5地址类型*/
typedef NS_ENUM(int , ZYH5Type) {
    ZYH5TypeItemDetail = 1,         //宝贝详情
    ZYH5TypeHelp = 2,               //帮助
    ZYH5TypeExpress = 3,            //物流
    ZYH5TypeMessage = 4,            //消息中心
    ZYH5TypeReturn = 5,             //归还
    ZYH5TypeRepair = 6,             //报修
    ZYH5TypeAbout = 7,              //关于我们
    ZYH5TypeCoupon = 8,             //优惠券使用说明
    ZYH5TypeUserAgreement = 9,      //用户协议
    ZYH5TypeServiceAgreement = 10,  //用户租赁服务协议
    ZYH5TypeFound = 11,             //发现页面
    ZYH5TypeFoundDetail = 12,       //发现详细页面
    ZYH5TypeItemServiceAgreement = 13,  //增值服务协议
    ZYH5TypeUserPublishDetail = 14,       //用户发布详细页面
    ZYH5TypePreemptiveExplanation = 15,       //抢先商品说明
    ZYH5TypeExchangeCouponRule = 16,       //兑换优惠券规则
    ZYH5TypeLimitRecord = 17,       //额度变更记录
};


/**h5工具类*/
@interface ZYH5Utils : NSObject

/**组装json数据*/
+ (NSString *)formatJson;
/**组装h5地址*/
+ (NSString *)formatUrl:(ZYH5Type)type param:(NSString *)param;

@end
