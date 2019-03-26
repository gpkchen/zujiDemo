//
//  ZYStoreChoiseCell.h
//  Apollo
//
//  Created by 李明伟 on 2018/5/11.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseTableCell.h"

@class _m_MerchantAddressList;
@interface ZYStoreChoiseCell : ZYBaseTableCell

@property (nonatomic , strong) UIImageView *selectionIV;

- (void)showCellWithModel:(_m_MerchantAddressList *)model;

@end
