//
//  ZYPaySuccessView.h
//  Apollo
//
//  Created by 李明伟 on 2018/4/27.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDCycleScrollView.h>

@interface ZYPaySuccessView : UIView

@property (nonatomic , copy) NSString *rent;

@property (nonatomic , copy) NSString *term;
@property (nonatomic , copy) NSString *termSub;

@property (nonatomic , copy) NSString *deposit;
@property (nonatomic , copy) NSString *depositSub;

@property (nonatomic , strong) UILabel *subTitleLab;

@property (nonatomic , strong) ZYElasticButton *orderBtn;
@property (nonatomic , strong) ZYElasticButton *homeBtn;

@property (nonatomic , strong) ZYScrollView *scrollView;

@property (nonatomic , strong) SDCycleScrollView *banner;

@end
