//
//  ZYBillDetailCell.h
//  Apollo
//
//  Created by 李明伟 on 2018/4/28.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseTableCell.h"

#define ZYBillDetailCellHeight (80 * UI_H_SCALE)

@class _m_GetOrderBillDetail_Bill;
@interface ZYBillDetailCell : ZYBaseTableCell

@property (nonatomic , strong) ZYElasticButton *payBtn;

- (void)showCellWithModel:(_m_GetOrderBillDetail_Bill *)model;

@end
