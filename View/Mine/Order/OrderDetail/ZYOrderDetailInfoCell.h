//
//  ZYOrderDetailInfoCell.h
//  Apollo
//
//  Created by 李明伟 on 2018/5/2.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseTableCell.h"

#define ZYOrderDetailInfoCellHeight (60 * UI_H_SCALE)

#define ZYOrderDetailInfoCellHeight_returnData (100 * UI_H_SCALE)

@class _m_GetOrderDetail;

@interface ZYOrderDetailInfoCell : ZYBaseTableCell

@property (nonatomic , strong) ZYElasticButton *cpBtn;

- (void)showCellWithModel:(_m_GetOrderDetail *)model;

@end
