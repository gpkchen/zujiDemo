//
//  ZYOrderListCell.h
//  Apollo
//
//  Created by 李明伟 on 2018/4/28.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseTableCell.h"

#define ZYOrderListCellHeight (187 * UI_H_SCALE)
#define ZYOrderListCellHeightNoButton (160 * UI_H_SCALE)

@class _m_GetOrderList;

/**按钮事件*/
typedef void (^ZYOrderListCellButtonAction)(_m_GetOrderList *model,ZYOrderStateAcionType type);
/**订单关闭回调（倒计时到0）*/
typedef void (^ZYOrderListCellOrderCloseBlock)(_m_GetOrderList *model);

@interface ZYOrderListCell : ZYBaseTableCell

@property (nonatomic , copy) ZYOrderListCellButtonAction buttonAction;
@property (nonatomic , copy) ZYOrderListCellOrderCloseBlock orderCloseBlock;

/**用于倒计时*/
@property (nonatomic , assign) int timeCount;

- (void)showCellWithModel:(_m_GetOrderList *)model;

@end
