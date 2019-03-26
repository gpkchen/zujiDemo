//
//  ZYItemDetailSkuMenuServiceCell.h
//  Apollo
//
//  Created by 李明伟 on 2018/5/5.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseTableCell.h"
#import "ItemDetail.h"

@interface ZYItemDetailSkuMenuServiceCell : ZYBaseTableCell

/**是否已选中*/
@property (nonatomic , assign) BOOL isSelected;
/**服务协议按钮*/
@property (nonatomic , strong) ZYElasticButton *agreementBtn;

+ (CGFloat)heightForCellWithModel:(_m_ItemDetail_Service *)model;

- (void)showCellWithModel:(_m_ItemDetail_Service *)model;

@end
