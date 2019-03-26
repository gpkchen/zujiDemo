//
//  ExpressCompanyList.h
//  Apollo
//
//  Created by 李明伟 on 2018/11/7.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**j快递公司查询参数*/
@interface _p_ExpressCompanyList : ZYBaseParam

@end




/**快递公司查询返回*/
@interface _m_ExpressCompanyList : ZYBaseModel

/**公司id*/
@property (nonatomic , copy) NSString *companyId;
/**公司名*/
@property (nonatomic , copy) NSString *name;
/**公司code*/
@property (nonatomic , copy) NSString *companyCode;

@end

NS_ASSUME_NONNULL_END
