//
//  AppModuleList.h
//  Apollo
//
//  Created by 李明伟 on 2018/4/23.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**首页模块信息查询参数*/
@interface _p_AppModuleList : ZYBaseParam

/**页面位置 1-首页*/
@property (nonatomic , copy) NSString *pagePosition;

@end





/**首页模块信息查询返回*/
@interface _m_AppModuleList : ZYBaseModel

/**模块名*/
@property (nonatomic , copy) NSString *name;
/**模板样式*/
@property (nonatomic , assign) ZYMallTemplateStyle templateStyle;
/**更多协议链接*/
@property (nonatomic , copy) NSString *url;
/**商品列表 image title url price unit url*/
@property (nonatomic , strong) NSArray *configureItemVOList;

@end
