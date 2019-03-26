//
//  ZYUserCenterView.h
//  Apollo
//
//  Created by 李明伟 on 2018/7/27.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYUserCenterView : UIView

@property (nonatomic , strong) ZYTableView *tableView;

@property (nonatomic , strong) ZYElasticButton *backBtn;
@property (nonatomic , strong) ZYElasticButton *editBtn;

@property (nonatomic , strong) UIView *navigationBar;
@property (nonatomic , strong) ZYElasticButton *backOnBarBtn;
@property (nonatomic , strong) ZYElasticButton *editOnBarBtn;

@end
