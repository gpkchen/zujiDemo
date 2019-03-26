//
//  ZYOrderDetailAddressCell.h
//  Apollo
//
//  Created by 李明伟 on 2018/5/2.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseTableCell.h"

#define ZYOrderDetailAddressCellHeight (130 * UI_H_SCALE)

@class _m_GetOrderDetail;

@interface ZYOrderDetailAddressCell : ZYBaseTableCell

- (void)showCellWithModel:(_m_GetOrderDetail *)model;

@end
