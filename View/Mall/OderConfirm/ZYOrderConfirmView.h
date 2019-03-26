//
//  ZYOrderConfirmView.h
//  Apollo
//
//  Created by 李明伟 on 2018/4/23.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYOrderConfirmFooter.h"
#import "ZYPayBar.h"

@interface ZYOrderConfirmView : UIView

@property (nonatomic , strong) ZYTableView *tableView;
@property (nonatomic , strong) ZYOrderConfirmFooter *footer;
@property (nonatomic , strong) ZYPayBar *payBar;
@property (nonatomic , strong) ZYElasticButton *helpBtn;

@end
