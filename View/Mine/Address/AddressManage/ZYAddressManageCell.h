//
//  ZYAddressManageCell.h
//  Apollo
//
//  Created by 李明伟 on 2018/4/25.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseTableCell.h"
#import "AddressList.h"

#define ZYAddressManageCellHeight (150 * UI_H_SCALE)

@interface ZYAddressManageCell : ZYBaseTableCell

@property (nonatomic , strong) ZYImageTitleButton *defaultBtn;
@property (nonatomic , strong) ZYImageTitleButton *editBtn;
@property (nonatomic , strong) ZYImageTitleButton *deleteBtn;

- (void)showCellWithModel:(_m_AddressList *)model;

@end
