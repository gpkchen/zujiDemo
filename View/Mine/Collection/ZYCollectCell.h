//
//  ZYCollectCell.h
//  Apollo
//
//  Created by 李明伟 on 2018/11/22.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import "ZYBaseTableCell.h"

NS_ASSUME_NONNULL_BEGIN

#define ZYCollectCellHeight (105 * UI_H_SCALE)

@class _m_FavoriteList;
@interface ZYCollectCell : ZYBaseTableCell

- (void)showCellWithModel:(_m_FavoriteList *)model;

@end

NS_ASSUME_NONNULL_END
