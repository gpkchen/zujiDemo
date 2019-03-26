//
//  ZYItemCell.h
//  Apollo
//
//  Created by 李明伟 on 2018/7/2.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseTableCell.h"

#define ZYItemCellHeight (110 * UI_H_SCALE)

/**各种详情页中的商品cell*/
@interface ZYItemCell : ZYBaseTableCell

@property (nonatomic , strong) UIImageView *itemIV;
@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) UILabel *skuLab;
@property (nonatomic , strong) UILabel *priceLab;

@end
