//
//  FavoriteList.h
//  Apollo
//
//  Created by shaxia on 2018/5/10.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseParam.h"


/**收藏列表参数*/
@interface _p_FavoriteList : ZYBaseParam

@property (nonatomic , copy) NSString *size;
@property (nonatomic , copy) NSString *page;

@end


/**收藏列表返回*/
@interface _m_FavoriteList : ZYBaseModel

/**宝贝id*/
@property (nonatomic , copy) NSString *itemId;
/**宝贝名称*/
@property (nonatomic , copy) NSString *itemName;
/**宝贝图片*/
@property (nonatomic , copy) NSString *itemPic;
/**宝贝价格*/
@property (nonatomic , copy) NSString *itemPri;
/**宝贝状态 0-上架 1-下架*/
@property (nonatomic , copy) NSString *itemState;

/**本地：是否选中*/
@property (nonatomic , assign) BOOL selected;

@end

