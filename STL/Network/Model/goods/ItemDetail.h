//
//  ItemDetail.h
//  Apollo
//
//  Created by 李明伟 on 2018/5/9.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class _m_ItemDetail_SkuAttribute;
@class _m_ItemDetail_SkuAttribute_Sub;

/**商品详情查询参数*/
@interface _p_ItemDetail : ZYBaseParam

/**商品id*/
@property (nonatomic , copy) NSString *itemId;

@end




/**商品详情查询返回*/
@interface _m_ItemDetail : ZYBaseModel

/**客服电话*/
@property (nonatomic , copy) NSString *servicePhone;
/**运营类型*/
@property (nonatomic , assign) ZYItemOpetationType operateType;
/**商品id*/
@property (nonatomic , copy) NSString *itemId;
/**抢先商品的解释说明*/
@property (nonatomic , copy) NSString *preemptionExplain;
/**秒杀活动专用：是否已关注秒杀*/
@property (nonatomic , assign) BOOL isFocusSpike;
/**秒杀活动专用：关注秒杀人数*/
@property (nonatomic , copy) NSString *spikeFocusNum;
/**秒杀活动专用：秒杀进度*/
@property (nonatomic , assign) double spikeRate;
/**秒杀活动专用：秒杀距离结束剩余时间（毫秒）*/
@property (nonatomic , assign) long long spikeEndRestTime;
/**秒杀活动专用：秒杀距离开始剩余时间（毫秒）*/
@property (nonatomic , assign) long long spikeStartRestTime;
/**秒杀活动专用：秒杀开始时间*/
@property (nonatomic , copy) NSString *spikeStartTime;
/**秒杀活动专用：秒杀抢购数*/
@property (nonatomic , assign) int spikeLeaseNum;
/**活动类型: 0没有活动 1一般活动 2秒杀活动*/
@property (nonatomic , assign) int activityType;
/**活动名称*/
@property (nonatomic , copy) NSString *activityName;
/**活动有效期*/
@property (nonatomic , copy) NSString *effectiveTime;
/**活动配置id*/
@property (nonatomic , copy) NSString *activityConfigureId;
/**活动优惠i列表{name}*/
@property (nonatomic , strong) NSArray *activityDiscountList;
/**类目id*/
@property (nonatomic , copy) NSString *categoryId;
/**剩余免押额度，用户已登录的状态返回*/
@property (nonatomic , assign) double surplusLimit;
/**宝贝名称*/
@property (nonatomic , copy) NSString *title;
/**最低租金价格*/
@property (nonatomic , assign) double price;
/**单位*/
@property (nonatomic , copy) NSString *unit;
/**押金*/
@property (nonatomic , assign) double deposit;
/**市场价*/
@property (nonatomic , assign) double marketPrice;
/**是否已收藏*/
@property (nonatomic , assign) BOOL collectionStatus;
/**分享标题*/
@property (nonatomic , copy) NSString *shareTitle;
/**分享内容*/
@property (nonatomic , copy) NSString *shareContent;
/**分享链接*/
@property (nonatomic , copy) NSString *shareUrl;
/**分享logo地址*/
@property (nonatomic , copy) NSString *shareImageUrl;
/**授信状态*/
@property (nonatomic , copy) NSString *authStatus;
/**视频地址*/
@property (nonatomic , copy) NSString *videoUrl;
/**宝贝图片地址{url}*/
@property (nonatomic , strong) NSArray *imageList;
/**保障信息*/
@property (nonatomic , strong) NSArray *guaranteeList;
/**sku及属性列表<_m_ItemDetail_SkuAttribute>*/
@property (nonatomic , strong) NSArray *skuAttributeList;
/**sku及价格库存列表<_m_ItemDetail_SkuPrice>*/
@property (nonatomic , strong) NSArray *skuPriceList;
/**增值服务列表*/
@property (nonatomic , strong) NSArray *serviceList;
/**租期*/
@property (nonatomic , strong) _m_ItemDetail_SkuAttribute *rentPeriod;
/**商品状态*/
@property (nonatomic , assign) ZYItemState status;
/**租期类型（长期短期）*/
@property (nonatomic , assign) ZYRentType rentType;
/**上架时间*/
@property (nonatomic , assign) NSString *putawayTime;
/**授信步骤列表：USER_INFO,ZHIMA_SCORE,WRITE_OPERATOR,WRITE_TAOBAO*/
@property (nonatomic , strong) NSArray *authStepList;


@end



/**sku及属性*/
@interface _m_ItemDetail_SkuAttribute : ZYBaseModel

/**一级sku名称*/
@property (nonatomic , copy) NSString *name;
/**SKU配置ID*/
@property (nonatomic , copy) NSString *attributeId;
/**二级sku列表<_m_ItemDetail_SkuAttribute_Sub>*/
@property (nonatomic , strong) NSArray *valueList;

/**是否已选中子项目*/
@property (nonatomic , assign) BOOL isSelected;
/**选中的二级sku*/
@property (nonatomic , strong) _m_ItemDetail_SkuAttribute_Sub *selectedSkuValue;

@end


/**sku及属性*/
@interface _m_ItemDetail_SkuAttribute_Sub : ZYBaseModel

/**SKU属性值名称*/
@property (nonatomic , copy) NSString *name;
/**SKU属性值ID*/
@property (nonatomic , copy) NSString *valueId;

/**非接口传输：是否有库存（动态计算）*/
@property (nonatomic , assign) BOOL hasStorage;
/**是否已选中*/
@property (nonatomic , assign) BOOL isSelected;

@end



/**sku及价格库存*/
@interface _m_ItemDetail_SkuPrice : ZYBaseModel

/**价格*/
@property (nonatomic , assign) double price;
/**单位*/
@property (nonatomic , copy) NSString *unit;
/**押金*/
@property (nonatomic , assign) double deposit;
/**市场价*/
@property (nonatomic , assign) double marketPrice;
/**库存*/
@property (nonatomic , assign) NSUInteger storage;
/**两级sku id路径，格式：attributeId1:valueId1;attributeId2:valueId2*/
@property (nonatomic , copy) NSString *path;
/**sku价格 id*/
@property (nonatomic , copy) NSString *priceId;
/**期限（数字无单位，用于计算）*/
@property (nonatomic , assign) NSUInteger periods;

@end


/**增值服务*/
@interface _m_ItemDetail_Service : ZYBaseModel

/**是否必选*/
@property (nonatomic , assign) BOOL isRequired;
/**增值服务名称*/
@property (nonatomic , copy) NSString *name;
/**增值服务价格*/
@property (nonatomic , assign) double price;
/**增值服务id*/
@property (nonatomic , copy) NSString *serviceId;
/**增值服务说明*/
@property (nonatomic , copy) NSString *remarks;
/**是否存在协议*/
@property (nonatomic , assign) BOOL isNeedAgreement;
/**增值服务id（查增值服务协议专用）*/
@property (nonatomic , copy) NSString *valueServiceId;

/**是否已选中*/
@property (nonatomic , assign) BOOL isSelected;

@end
