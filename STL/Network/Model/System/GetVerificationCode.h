//
//  GetVerificationCode.h
//  Apollo
//
//  Created by 李明伟 on 2018/4/20.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**发送验证码参数*/
@interface _p_GetVerificationCode : ZYBaseParam

/**手机号*/
@property (nonatomic , copy) NSString *mobile;
/**场景*/
@property (nonatomic , copy) NSString *scene;
/**签名*/
@property (nonatomic , copy) NSString *sign;

@end

