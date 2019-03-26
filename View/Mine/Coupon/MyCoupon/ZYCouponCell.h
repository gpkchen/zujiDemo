//
//  ZYCouponCell.h
//  Apollo
//
//  Created by 李明伟 on 2018/4/25.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseTableCell.h"
#import "ListUserCoupon.h"

@interface ZYCouponCell : ZYBaseTableCell

@property (nonatomic , assign) BOOL choosed;

@property (nonatomic , strong) ZYElasticButton *useBtn;
@property (nonatomic , strong) ZYElasticButton *openBtn;

- (void)showCellWithModel:(_m_ListUserCoupon *)model;
- (void)showHistoryCellWithModel:(_m_ListUserCoupon *)model;
- (void)showChooseCellWithModel:(_m_ListUserCoupon *)model;
- (void)showReceiveCellWithModel:(_m_ListUserCoupon *)model;

@end
