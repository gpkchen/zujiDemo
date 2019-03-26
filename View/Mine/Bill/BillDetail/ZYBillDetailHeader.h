//
//  ZYBillDetailHeader.h
//  Apollo
//
//  Created by 李明伟 on 2018/4/28.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ZYBillDetailHeaderHeight (116 * UI_H_SCALE)

@class _m_GetOrderBillDetail;
@interface ZYBillDetailHeader : UIView

- (void)showHeaderWithModel:(_m_GetOrderBillDetail *)model;

@end
