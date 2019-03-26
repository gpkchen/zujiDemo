//
//  ZYAuthingCell.h
//  Apollo
//
//  Created by 李明伟 on 2018/7/9.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseTableCell.h"

#define ZYAuthingCellHeight (90 * UI_H_SCALE)

@interface ZYAuthingCell : ZYBaseTableCell

@property (nonatomic , strong) UIImageView *logoIV;
@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) UILabel *detailLab;
@property (nonatomic , strong) ZYElasticButton *authBtn;

@end
