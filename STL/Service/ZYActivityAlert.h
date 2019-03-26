//
//  ZYActivityAlert.h
//  Apollo
//
//  Created by 李明伟 on 2018/7/17.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseAlert.h"

@class _m_AppActiveInfo;
@interface ZYActivityAlert : ZYBaseAlert

- (void)showWithModel:(_m_AppActiveInfo *)model;

@end
