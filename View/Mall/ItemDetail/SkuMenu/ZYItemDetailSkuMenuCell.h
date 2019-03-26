//
//  ZYItemDetailSkuMenuCell.h
//  Apollo
//
//  Created by 李明伟 on 2018/5/5.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseTableCell.h"
#import "ItemDetail.h"

typedef void (^ZYItemDetailSkuMenuCellSelectionBlock)(_m_ItemDetail_SkuAttribute *sku , _m_ItemDetail_SkuAttribute_Sub *skuValue);

@interface ZYItemDetailSkuMenuCell : ZYBaseTableCell

@property (nonatomic , copy) ZYItemDetailSkuMenuCellSelectionBlock selectionBlock;

+ (CGFloat)heightForCellWithModel:(_m_ItemDetail_SkuAttribute *)model;


/**
 显示cell方法

 @param model 数据源
 @param is 是否是租期
 */
- (void)showCellWithModel:(_m_ItemDetail_SkuAttribute *)model isPeriod:(BOOL)is;

/**
 根据数据源刷新cell（此时不会移除添加控件，防止失贞）
 */
- (void)refreshCell;

@end
