//
//  ZYQuotaRecordCell.h
//  Apollo
//
//  Created by 李明伟 on 2018/10/31.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import "ZYBaseTableCell.h"

NS_ASSUME_NONNULL_BEGIN

@class _m_LimitRecord;
@interface ZYQuotaRecordCell : ZYBaseTableCell

- (void)showCellWithModel:(_m_LimitRecord *)model;

@end

NS_ASSUME_NONNULL_END
