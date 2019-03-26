//
//  GetGoodsSearchKeyList.h
//  Apollo
//
//  Created by 李明伟 on 2018/8/1.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**获取热搜词list参数*/
@interface _p_GetGoodsSearchKeyList : ZYBaseParam

@end




/**获取热搜词list返回*/
@interface _m_GetGoodsSearchKeyList : ZYBaseModel

/**关键字*/
@property (nonatomic , copy) NSString *value;


/**本地：记录cell宽度*/
@property (nonatomic , assign) CGFloat width;

@end
