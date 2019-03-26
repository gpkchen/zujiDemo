//
//  ZYReturnExpressSelectorCell.h
//  Apollo
//
//  Created by 李明伟 on 2018/11/7.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import "ZYBaseTableCell.h"

#define ZYReturnExpressSelectorCellHeight (50 * UI_H_SCALE)

NS_ASSUME_NONNULL_BEGIN

@interface ZYReturnExpressSelectorCell : ZYBaseTableCell

@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) ZYCheckBox *cb;

@end

NS_ASSUME_NONNULL_END
