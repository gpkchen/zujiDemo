//
//  ZYBillDetailItemCell.h
//  Apollo
//
//  Created by 李明伟 on 2018/4/28.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseTableCell.h"

#define ZYBillDetailItemCellHeight (122 * UI_H_SCALE)

@class _m_GetOrderBillDetail;
@interface ZYBillDetailItemCell : ZYBaseTableCell

- (void)showCellWithModel:(_m_GetOrderBillDetail *)model;

@end
