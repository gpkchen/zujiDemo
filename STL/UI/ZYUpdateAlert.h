//
//  ZYUpdateAlert.h
//  Apollo
//
//  Created by 李明伟 on 2018/5/25.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseAlert.h"

@class _m_GetAppVersionInfo;
@interface ZYUpdateAlert : ZYBaseAlert

- (void)showWithModel:(_m_GetAppVersionInfo *)model;

@end
