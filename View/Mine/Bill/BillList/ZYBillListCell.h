//
//  ZYBillListCell.h
//  Apollo
//
//  Created by 李明伟 on 2018/4/20.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseTableCell.h"

#define ZYBillListCellHeight (80 * UI_H_SCALE)

@class _m_GetRepaymentBillList_Bill;
@interface ZYBillListCell : ZYBaseTableCell

- (void)showCellWithModel:(_m_GetRepaymentBillList_Bill *)model;

@end
