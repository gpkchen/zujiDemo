//
//  ZYItemDetailUpTitleCell.h
//  Apollo
//
//  Created by 李明伟 on 2018/5/3.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseTableCell.h"

@class _m_ItemDetail;
@interface ZYItemDetailUpTitleCell : ZYBaseTableCell

@property (nonatomic , strong) ZYElasticButton *depositBtn; //申请免押金
@property (nonatomic , strong) ZYElasticButton *shareBtn; //分享按钮

- (void)showCellWithModel:(_m_ItemDetail *)model;

@end
