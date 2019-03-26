//
//  ZYBuyOffView.h
//  Apollo
//
//  Created by 李明伟 on 2018/5/3.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYPayBar.h"

@interface ZYBuyOffView : UIView

@property (nonatomic , strong) ZYTableView *tableView;
@property (nonatomic , strong) ZYPayBar *payBar;
@property (nonatomic , strong) ZYElasticButton *helpBtn;

@end
