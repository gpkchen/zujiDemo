//
//  ZYTermChoiseCell.h
//  Apollo
//
//  Created by 李明伟 on 2018/6/20.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseTableCell.h"

#define ZYTermChoiseCellHeight (50 * UI_H_SCALE)

@interface ZYTermChoiseCell : ZYBaseTableCell

@property (nonatomic , assign) BOOL isSelectedTerm;
@property (nonatomic , strong) UILabel *titleLab;

@end
