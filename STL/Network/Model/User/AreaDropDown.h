//
//  AreaDropDown.h
//  Apollo
//
//  Created by 李明伟 on 2018/4/26.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**省市区查询参数*/
@interface _p_AreaDropDown : ZYBaseParam

/**地区id*/
@property (nonatomic , copy) NSString *addressId;

@end





/**省市区查询返回*/
@interface _m_AreaDropDown : ZYBaseModel

/**地区id*/
@property (nonatomic , copy) NSString *addressId;
/**地区名称*/
@property (nonatomic , copy) NSString *addressName;

/**父id*/
@property (nonatomic , copy) NSString *parentId;

@end
