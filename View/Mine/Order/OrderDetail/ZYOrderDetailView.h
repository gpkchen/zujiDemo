//
//  ZYOrderDetailView.h
//  Apollo
//
//  Created by 李明伟 on 2018/5/2.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class _m_GetOrderDetail;

/**按钮事件*/
typedef void (^ZYOrderDetailViewButtonAction)(ZYOrderStateAcionType type);

@interface ZYOrderDetailView : UIView

@property (nonatomic , strong) ZYElasticButton *billBtn;
@property (nonatomic , strong) ZYElasticButton *buyOffInfoBtn;
@property (nonatomic , strong) _m_GetOrderDetail *detail;
@property (nonatomic , copy) ZYOrderDetailViewButtonAction buttonAction;
@property (nonatomic , strong) ZYElasticButton *helpBtn;

@property (nonatomic , strong) ZYTableView *tableView;

@end
