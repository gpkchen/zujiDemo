//
//  ZYBillListHeader.h
//  Apollo
//
//  Created by 李明伟 on 2018/4/27.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ZYBillListHeaderHeight (129 * UI_H_SCALE)

@class _m_GetRepaymentBillList;
@interface ZYBillListHeader : UITableViewHeaderFooterView

/**是否展开*/
@property (nonatomic , assign) BOOL isOpened;

@property (nonatomic , strong) ZYElasticButton *detailBtn;
@property (nonatomic , strong) ZYElasticButton *openBtn;
@property (nonatomic , strong) ZYElasticButton *payBtn;

- (void)showHeaderWithModel:(_m_GetRepaymentBillList *)model;

@end
