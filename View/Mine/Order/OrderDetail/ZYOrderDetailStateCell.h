//
//  ZYOrderDetailStateCell.h
//  Apollo
//
//  Created by 李明伟 on 2018/5/2.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseTableCell.h"

#define ZYOrderDetailStateCellHeight (80 * UI_H_SCALE)

@class _m_GetOrderDetail;

/**订单关闭回调（倒计时到0）*/
typedef void (^ZYOrderDetailStateCellOrderCloseBlock)(_m_GetOrderDetail *model);

@interface ZYOrderDetailStateCell : ZYBaseTableCell

//用于倒计时
@property (nonatomic , assign) int timeCount;
/**订单关闭回调*/
@property (nonatomic , copy) ZYOrderDetailStateCellOrderCloseBlock orderCloseBlock;

- (void)showCellWithModel:(_m_GetOrderDetail *)model;

@end
