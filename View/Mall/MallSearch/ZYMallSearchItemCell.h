//
//  ZYMallSearchItemCell.h
//  Apollo
//
//  Created by 李明伟 on 2018/8/2.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ZYMallSearchItemCellSize CGSizeMake(165 * UI_H_SCALE, 228 * UI_H_SCALE)

@class _m_GetGoodsListByKey;
@interface ZYMallSearchItemCell : UICollectionViewCell

- (void)showCellWithModel:(_m_GetGoodsListByKey *)model;

@end
