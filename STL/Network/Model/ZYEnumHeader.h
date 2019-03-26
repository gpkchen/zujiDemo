//
//  ZYEnumHeader.h
//  Apollo
//
//  Created by 李明伟 on 2018/4/23.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#ifndef ZYEnumHeader_h
#define ZYEnumHeader_h

/**商城首页模板样式*/
typedef NS_ENUM(int , ZYMallTemplateStyle) {
    ZYMallTemplateStyleHot = 1,     //热门板块
    ZYMallTemplateStyleContent = 2, //内容板块
    ZYMallTemplateStyleSpecial = 3, //专区板块
    ZYMallTemplateStyleClassify = 4,//分类板块
    ZYMallTemplateStyleBanner = 5,  //banner板块
    ZYMallTemplateStyleTiny = 6,    //小分类板块
    ZYMallTemplateStyleEvent = 7,   //事件板块
};


/**订单状态*/
typedef NS_ENUM(int , ZYOrderState) {
    ZYOrderStateWaitPay = 0,        //代付款
    ZYOrderStateCanceled = 2,       //已取消（已关闭）
    ZYOrderStateAbnormal = 3,       //异常
    ZYOrderStateWaitDeliver = 4,    //待发货
    ZYOrderStateWaitReceipt = 5,    //已发货（待收货）
    ZYOrderStateUsing = 8,          //已确认收货（使用中）
    ZYOrderStateMailedBack = 9,     //已寄回
    ZYOrderStateDone = 10,          //已完成
};

/**商城首页模板样式*/
typedef NS_ENUM(int , ZYExemptedAmountResultType) {
    ZYExemptedAmountResultTypeGetMoney = 1,     //获得额度
    ZYExemptedAmountResultTypeSuccess = 2, //认证成功
    ZYExemptedAmountResultTypeFail = 3, //认证失败
};

/**授信状态*/
typedef NS_ENUM(int , ZYAuthState) {
    ZYAuthStateUnAuth = 0,     //未授信
    ZYAuthStateAuthed = 1, //已授信
    ZYAuthStateCanceled = 2, //取消授信
    ZYAuthStateAuthing = 3, //授信中
    ZYAuthStateImprove = 4, //正在提额
};

/**收货类型*/
typedef NS_ENUM(int , ZYExpressType) {
    ZYExpressTypeMail = 1, //邮寄
    ZYExpressTypeSelfLifting = 2, //自提
};

/**商品状态*/
typedef NS_ENUM(int , ZYItemState) {
    ZYItemStateSelling = 0, //已上架
    ZYItemStateUnSelling = 1, //已下架
    ZYItemStateToSell = 2, //即将上架
};

/**租期类型*/
typedef NS_ENUM(int , ZYRentType) {
    ZYRentTypeLong = 1, //长期
    ZYRentTypeShort = 2, //短期
};

/**不同订单状态操作类型*/
typedef NS_ENUM(int , ZYOrderStateAcionType) {
    ZYOrderStateAcionTypeCancel = 1, //取消订单
    ZYOrderStateAcionTypeLogistics = 2, //查看物流
    ZYOrderStateAcionTypeReceipt = 3, //确认收货
    ZYOrderStateAcionTypeRepair = 4, //报修
    ZYOrderStateAcionTypePayOrder = 5, //支付订单
    ZYOrderStateAcionTypeReturn = 6, //归还
    ZYOrderStateAcionTypeBuy = 7, //购买
    ZYOrderStateAcionTypePayBill = 8, //支付账单
    ZYOrderStateAcionTypeRenewal = 9, //续租
    ZYOrderStateAcionTypePayPenalty = 10, //支付违约金
    ZYOrderStateAcionTypeService = 11, //联系客服
    ZYOrderStateAcionTypeCancelExamine = 12, //待发货取消订单
};

/**账单状态*/
typedef NS_ENUM(int , ZYBillState) {
    ZYBillStateOverdue = 1, //已逾期
    ZYBillStateWaitPay = 2, //待还款
    ZYBillStatePayedOverdue = 3, //逾期还款
    ZYBillStatePayedNormal = 4, //正常还款
    ZYBillStateCanceled = 5, //已取消
};

/**买断支付类型*/
typedef NS_ENUM(int , ZYBuyOffPayType) {
    ZYBuyOffPayTypePay = 1, //支付
    ZYBuyOffPayTypeReturn = 2, //退还
};

/**咨询来源*/
typedef NS_ENUM(int , ZYArticleSource) {
    ZYArticleSourceOfficial = 1, //官方咨询
    ZYArticleSourceUser = 2, //用户发布
};

/**商品运营类型*/
typedef NS_ENUM(int , ZYItemOpetationType) {
    ZYItemOpetationTypeNormal = 0, //普通商品
    ZYItemOpetationTypePreemption = 1, //抢先商品
};

#endif /* ZYEnumHeader_h */
