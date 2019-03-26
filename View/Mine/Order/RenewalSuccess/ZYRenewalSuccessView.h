//
//  ZYRenewalSuccessView.h
//  Apollo
//
//  Created by 李明伟 on 2018/6/27.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYRenewalSuccessView : UIView

@property (nonatomic , copy) NSString *rent;

@property (nonatomic , copy) NSString *term;
@property (nonatomic , copy) NSString *termSub;

@property (nonatomic , strong) ZYElasticButton *orderBtn;
@property (nonatomic , strong) ZYElasticButton *homeBtn;

@property (nonatomic , strong) ZYScrollView *scrollView;

@end
