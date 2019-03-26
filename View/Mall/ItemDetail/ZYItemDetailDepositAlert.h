//
//  ZYItemDetailDepositAlert.h
//  Apollo
//
//  Created by 李明伟 on 2018/5/9.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseAlert.h"

typedef void (^ZYItemDetailDepositAlertApplyBlock)(BOOL isCancel);

@interface ZYItemDetailDepositAlert : ZYBaseAlert

@property (nonatomic , assign) BOOL shouldShow;
@property (nonatomic , copy) ZYItemDetailDepositAlertApplyBlock applyBlock;

- (void)show;

@end
