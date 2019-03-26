//
//  ZYAddContactCell.h
//  Apollo
//
//  Created by 李明伟 on 2018/7/10.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseTableCell.h"

#define ZYAddContactCellHeight (49 * UI_H_SCALE)

@interface ZYAddContactCell : ZYBaseTableCell

@property (nonatomic , strong) UILabel *leftLabel;
@property (nonatomic , strong) ZYTextField *textView;

@end
