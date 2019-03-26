//
//  ZYIdcardScanConfirmAlert.h
//  Apollo
//
//  Created by 李明伟 on 2018/7/10.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseAlert.h"

@interface ZYIdcardScanConfirmAlert : ZYBaseAlert

@property (nonatomic , copy) void (^confirmAction)(NSString *name);

- (void)showWithName:(NSString *)name idcard:(NSString *)idcard;

@end
