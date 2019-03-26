//
//  ZYExchangeCouponResultView.h
//  Apollo
//
//  Created by 李明伟 on 2018/10/9.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYExchangeCouponResultView : UIView

@property (nonatomic , strong) ZYTableView *tableView;
@property (nonatomic , strong) UIView *header;
@property (nonatomic , strong) ZYElasticButton *orderBtn;

@end

NS_ASSUME_NONNULL_END
