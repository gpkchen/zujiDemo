//
//  AppListItem.h
//  Apollo
//
//  Created by 李明伟 on 2018/4/25.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**商品列表查询参数*/
@interface _p_AppListItem : ZYBaseParam

/**模板id*/
@property (nonatomic , copy) NSString *templateId;

@property (nonatomic , copy) NSString *page;
@property (nonatomic , copy) NSString *size;

@end





/**商品列表查询返回*/
@interface _m_AppListItem : ZYBaseModel

/**图片地址*/
@property (nonatomic , copy) NSString *image;
/**宝贝id*/
@property (nonatomic , copy) NSString *itemId;
/**是否收藏*/
@property (nonatomic , assign) BOOL collectionStatus;
/**宝贝名称*/
@property (nonatomic , copy) NSString *subTitle;
/**单位*/
@property (nonatomic , copy) NSString *unit;
/**价格*/
@property (nonatomic , assign) double price;

@end
