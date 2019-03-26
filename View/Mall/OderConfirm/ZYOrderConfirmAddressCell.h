//
//  ZYOrderConfirmAddressCell.h
//  Apollo
//
//  Created by 李明伟 on 2018/4/23.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseTableCell.h"

#define ZYOrderConfirmAddressCellHeightNoAddress (110 * UI_H_SCALE)

@class _m_AddressList;
@class _m_MerchantAddressList;

@interface ZYOrderConfirmAddressCell : ZYBaseTableCell

@property (nonatomic , strong) ZYElasticButton *mailBtn;
@property (nonatomic , strong) ZYElasticButton *selfLiftingBtn;

@property (nonatomic , assign) BOOL noAddress;

@property (nonatomic , strong) UILabel *noAddressLab;

- (void)selectBtn:(ZYElasticButton *)btn;

- (void)showCellWithAddressModel:(_m_AddressList *)model;
- (void)showCellWithStoreModel:(_m_MerchantAddressList *)model;

@end
