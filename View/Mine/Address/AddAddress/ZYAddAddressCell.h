//
//  ZYAddAddressCell.h
//  Apollo
//
//  Created by 李明伟 on 2018/4/26.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseTableCell.h"

#define ZYAddAddressCellHeight (50 * UI_H_SCALE)

@interface ZYAddAddressCell : ZYBaseTableCell

@property (nonatomic , assign) BOOL showArrow;

@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) UILabel *contentLab;
@property (nonatomic , strong) UISwitch *defaultWitch;

@end
