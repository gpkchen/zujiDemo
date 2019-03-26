//
//  ZYPaymentService.h
//  Apollo
//
//  Created by 李明伟 on 2018/5/16.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import "ZYPaymentCommonParam.h"

/**支付方式*/
typedef NS_ENUM(int , ZYPaymentType) {
    ZYPaymentTypeNone = 0, //未选择
    ZYPaymentTypeAlipay = 21, //支付宝
    ZYPaymentTypeWechat = 11, //微信
};

/**支付结果*/
typedef NS_ENUM(int , ZYPaymentResult) {
    ZYPaymentResultGiveUp = 0, //放弃支付
    ZYPaymentResultSuccess = 1, //支付成功
    ZYPaymentResultDealing = 2, //处理中
    ZYPaymentResultFail = 3, //支付失败
    ZYPaymentResultCancel = 4, //支付取消
};


/**支付协议*/
@protocol ZYPaymentDelegate <NSObject>

@required

/**
 支付结果

 @param result 结果
 @param type 支付类型
 */
- (void)paymentResult:(ZYPaymentResult)result type:(ZYPaymentType)type;

@end


/**支付服务*/
@interface ZYPaymentService : NSObject<WXApiDelegate>



/**单例*/
+ (instancetype)service;

/**代理,在发起支付时再赋值*/
@property (nonatomic , weak) id<ZYPaymentDelegate> currentDelegate;

/**隐藏收银台*/
- (void)hideCashier;

/**
 发起支付(外界直接调此方法)
 
 @param param 支付参数
 */
- (void)pay:(ZYPaymentCommonParam *)param;

/**
 发起支付

 @param type 支付方式
 @param orderInfo 支付信息
 */
- (void)pay:(ZYPaymentType)type orderInfo:(NSString *)orderInfo;

/**
 处理支付宝支付结果

 @param orderState 支付宝结果
 */
- (void)alipayResult:(int)orderState;

@end
