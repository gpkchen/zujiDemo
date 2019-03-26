//
//  ZYMineCell.h
//  Apollo
//
//  Created by 李明伟 on 2018/9/4.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseTableCell.h"

#define ZYMineCellHeight (61 * UI_H_SCALE)

@interface ZYMineCell : ZYBaseTableCell

@property (nonatomic , copy) NSString *title;
@property (nonatomic , assign) int num;

@end
