//
//  AliUrl.h
//  Apollo
//
//  Created by shaxia on 2018/5/17.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseParam.h"


/**阿里授信查询参数*/
@interface _p_AliUrl : ZYBaseParam

@end

/**阿里授信查询返回*/
@interface _m_AliUrl : ZYBaseModel


@property (nonatomic , strong) NSString *url;


@end
