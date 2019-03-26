//
//  ZYAddressChoiseCell.h
//  Apollo
//
//  Created by 李明伟 on 2018/4/25.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseTableCell.h"
#import "AddressList.h"

#define ZYAddressChoiseCellHeight (100 * UI_H_SCALE)

@interface ZYAddressChoiseCell : ZYBaseTableCell

- (void)showCellWithModel:(_m_AddressList *)model;

@end
