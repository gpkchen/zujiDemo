//
//  ZYQuotaHeader.h
//  Apollo
//
//  Created by 李明伟 on 2018/7/9.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ZYQuotaHeaderHeight (242.5 * UI_H_SCALE)

@class _m_AuditStatus;
@interface ZYQuotaHeader : UIView

/**认证信息*/
@property (nonatomic , strong) _m_AuditStatus *authInfo;

@property (nonatomic , strong) ZYElasticButton *quotaHelpBtn;
@property (nonatomic , strong) ZYElasticButton *authBtn;
@property (nonatomic , strong) ZYElasticButton *recordBtn;
@property (nonatomic , strong) ZYElasticButton *instructionBtn;

@end
