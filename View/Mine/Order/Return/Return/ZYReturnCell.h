//
//  ZYReturnCell.h
//  Apollo
//
//  Created by 李明伟 on 2018/11/6.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import "ZYBaseTableCell.h"

NS_ASSUME_NONNULL_BEGIN

@class _m_GetMerchantAddressList;
@interface ZYReturnCell : ZYBaseTableCell

- (void)showCellWithModel:(_m_GetMerchantAddressList *)model;

@end

NS_ASSUME_NONNULL_END
