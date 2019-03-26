//
//  AuthenticationQuery.h
//  Apollo
//
//  Created by shaxia on 2018/5/15.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseParam.h"


/**个人认证信息查询参数*/
@interface _p_AuthenticationQuery : ZYBaseParam


@end


/**个人认证信息查询返回*/
@interface _m_AuthenticationQuery : ZYBaseModel

/**身份识别标识*/
@property (nonatomic , assign) BOOL idcardStatus;
/**手机号*/
@property (nonatomic , copy) NSString *mobile;
/**人脸识别标识*/
@property (nonatomic , assign) BOOL faceStatus;
/**紧急联系人1标识*/
@property (nonatomic , assign) BOOL urgent1Status;
/**紧急联系人2标识*/
@property (nonatomic , assign) BOOL urgent2Status;
/**芝麻分获取标识*/
@property (nonatomic , assign) BOOL zhimaStatus;
/**身份证号*/
@property (nonatomic , copy) NSString *idcard;
/**淘宝认证标识*/
@property (nonatomic , assign) BOOL taoBaoStatus;
/**淘宝开关,0淘宝在提额,1淘宝在基础*/
@property (nonatomic , assign) BOOL taoBaoSwitch;

@end
