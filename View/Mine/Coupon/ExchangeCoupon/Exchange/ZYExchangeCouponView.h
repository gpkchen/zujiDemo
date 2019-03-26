//
//  ZYExchangeCouponView.h
//  Apollo
//
//  Created by 李明伟 on 2018/10/8.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYExchangeCouponView : UIView

@property (nonatomic , strong) ZYScrollView *scrollView;
@property (nonatomic , strong) ZYElasticButton *ruleBtn;
@property (nonatomic , strong) ZYTextField *codeText;
@property (nonatomic , strong) ZYElasticButton *exchangeBtn;
@property (nonatomic , strong) UILabel *errorLab;

@end

NS_ASSUME_NONNULL_END
