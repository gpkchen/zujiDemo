//
//  ZYShareHeader.h
//  Apollo
//
//  Created by 李明伟 on 2018/6/30.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYJumpLabel.h"

#define ZYShareHeaderHeight (FRINGE_TOP_EXTRA_HEIGHT + 245 * UI_H_SCALE)

@interface ZYShareHeader : UIView

@property (nonatomic , strong) UILabel *inviteNumLab;
@property (nonatomic , strong) UILabel *inviteAmountLab;
@property (nonatomic , strong) ZYJumpLabel *jumpLabel;

@end
