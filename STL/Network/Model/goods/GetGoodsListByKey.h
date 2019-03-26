//
//  GetGoodsListByKey.h
//  Apollo
//
//  Created by 李明伟 on 2018/8/2.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**商品查询参数*/
@interface _p_GetGoodsListByKey : ZYBaseParam

/**关键字*/
@property (nonatomic , copy) NSString *searchValue;
/**页码数*/
@property (nonatomic , copy) NSString *page;
/**每页数量*/
@property (nonatomic , copy) NSString *size;

@end




/**商品查询返回*/
@interface _m_GetGoodsListByKey : ZYBaseModel

/**商品id*/
@property (nonatomic , copy) NSString *itemId;
/**商品名称*/
@property (nonatomic , copy) NSString *subTitle;
/**商品价格*/
@property (nonatomic , assign) double price;
/**单位*/
@property (nonatomic , copy) NSString *unit;
/**图片地址*/
@property (nonatomic , copy) NSString *image;

@end
