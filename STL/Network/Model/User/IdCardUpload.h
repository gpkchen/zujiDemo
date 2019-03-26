//
//  IdCardUpload.h
//  Apollo
//
//  Created by shaxia on 2018/5/8.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseParam.h"

/**上传身份证参数*/
@interface _p_IdCardUpload : ZYBaseParam

/**身份证正面路径*/
@property (nonatomic , copy) NSString *positivePath;

/**身份证反面路径*/
@property (nonatomic , copy) NSString *backPath;

/**姓名*/
@property (nonatomic , copy) NSString *userName;

/**身份证号*/
@property (nonatomic , copy) NSString *idCard;

/**详细地址*/
@property (nonatomic , copy) NSString *totalAddress;

/**身份证有效期*/
@property (nonatomic , copy) NSString *period;


@end


/**上传身份证返回*/
@interface _m_IdCardUpload : ZYBaseModel

@end
