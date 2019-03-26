//
//  UrgentAdd.h
//  Apollo
//
//  Created by shaxia on 2018/5/15.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseParam.h"


/**添加紧急联系人查询参数*/
@interface _p_UrgentAdd : ZYBaseParam

/**紧急联系姓名*/
@property (nonatomic , strong) NSString *urgentName;
/**紧急联系人号码*/
@property (nonatomic , strong) NSString *urgentMobile;
/**紧急联系人关系 1：父母 2：兄弟姐妹 3：配偶 4：朋友 5：同学 6：同事*/
@property (nonatomic , strong) NSString *urgentRelation;

@end

/**添加紧急联系人查询返回*/
@interface _m_UrgentAdd : ZYBaseModel


@end
