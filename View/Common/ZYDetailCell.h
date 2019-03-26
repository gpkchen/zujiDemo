//
//  ZYDetailCell.h
//  Apollo
//
//  Created by 李明伟 on 2018/7/2.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseTableCell.h"

#define ZYDetailCellHeight (50 * UI_H_SCALE)

/**一标题一内容的cell*/
@interface ZYDetailCell : ZYBaseTableCell

@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) UILabel *contentLab;

/**是否显示箭头*/
@property (nonatomic , assign) BOOL showArrow;

@end
