//
//  ZYItemDetailUpSpikeCell.h
//  Apollo
//
//  Created by 李明伟 on 2018/12/3.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import "ZYBaseTableCell.h"

NS_ASSUME_NONNULL_BEGIN

#define ZYItemDetailUpSpikeCellHeight (50 * UI_H_SCALE)

@class _m_ItemDetail;
@interface ZYItemDetailUpSpikeCell : ZYBaseTableCell

/**设置倒计时*/
@property (nonatomic , assign) int timeCount;

- (void)showCellWithModel:(_m_ItemDetail *)model;

@end

NS_ASSUME_NONNULL_END
