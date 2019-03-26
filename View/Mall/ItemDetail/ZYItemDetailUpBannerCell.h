//
//  ZYItemDetailUpBannerCell.h
//  Apollo
//
//  Created by 李明伟 on 2018/5/3.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseTableCell.h"

@class _m_ItemDetail;
@interface ZYItemDetailUpBannerCell : ZYBaseTableCell

@property (nonatomic , copy) void (^collectionAction)(void);
@property (nonatomic , copy) void (^rentAction)(void);

- (void)pause;

- (void)showCellWithModel:(_m_ItemDetail *)model;

@end
