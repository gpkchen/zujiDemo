//
//  ZYPayPenaltyView.h
//  Apollo
//
//  Created by 李明伟 on 2018/7/2.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYPayPenaltyFooter.h"
#import "ZYPayBar.h"

@interface ZYPayPenaltyView : UIView

@property (nonatomic , strong) ZYTableView *tableView;
@property (nonatomic , strong) ZYPayPenaltyFooter *footer;
@property (nonatomic , strong) ZYPayBar *payBar;

@end
