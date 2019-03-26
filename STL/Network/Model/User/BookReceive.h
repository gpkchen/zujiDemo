//
//  BookReceive.h
//  Apollo
//
//  Created by shaxia on 2018/5/15.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseParam.h"

/**接收通讯录查询参数*/
@interface _p_BookReceive : ZYBaseParam

/**联系人总数*/
@property (nonatomic , strong) NSString *totalNum;

/**联系人*/
@property (nonatomic , strong) NSArray *bookList;

@end

/**接收通讯录查询返回*/
@interface _m_BookReceive : ZYBaseModel

@end
