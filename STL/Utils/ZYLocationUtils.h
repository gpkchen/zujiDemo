//
//  ZYLocationUtils.h
//  Apollo
//
//  Created by 李明伟 on 2018/4/10.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**当前定位数据类*/
@interface ZYLocation : NSObject<NSCoding,NSCopying>

@property (nullable , nonatomic , copy) NSString *latitude;            //维度
@property (nullable , nonatomic , copy) NSString *longitude;           //经度
@property (nullable , nonatomic , copy) NSString *country;             //国家
@property (nullable , nonatomic , copy) NSString *province;            //省/直辖市
@property (nullable , nonatomic , copy) NSString *city;                //市
@property (nullable , nonatomic , copy) NSString *district;            //区
@property (nullable , nonatomic , copy) NSString *street;              //街道名称
@property (nullable , nonatomic , copy) NSString *number;              //门牌号
@property (nullable , nonatomic , copy) NSString *address;             //具体位置

@end


extern NSString * _Nonnull const ZYLocationSuccessNotification;   //定位成功通知名
extern NSString * _Nonnull const ZYLocationChangedNotification;   //定位区域发生变化通知名


/**定位管理工具*/
@interface ZYLocationUtils : NSObject

/**当前定位信息*/
@property (nullable , nonatomic , strong , readonly) ZYLocation *userLocation;
/**是否定位成功*/
@property (nonatomic , assign , readonly) BOOL isLocSuccess;

/**单例*/
+ (nonnull instancetype) utils;


/**
 是否有定位权限

 @param shouldNotice 在没有权限的情况下是否弹窗询问
 @return 是否有定位权限
 */
- (BOOL) isAuthLocation:(BOOL)shouldNotice;

/**
 *开始定位

 @param shouldNotice 在没有权限的情况下是否弹窗询问
 */
- (void) startLocating:(BOOL)shouldNotice;

/**终止定位*/
- (void) stopLocating;

@end
