//
//  ZYPayBar.h
//  Apollo
//
//  Created by 李明伟 on 2018/7/4.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ZYPayBarHeight (55 * UI_H_SCALE + DOWN_DANGER_HEIGHT)

/**需要付款的地方的支付工具栏*/
@interface ZYPayBar : UIView

/**价格标题，默认“共计”*/
@property (nonatomic , copy) NSString *priceTitle;
/**价格*/
@property (nonatomic , assign) double price;
/**是否最低支付0.01元，默认yes*/
@property (nonatomic , assign) BOOL isMinLimit;
/**支付按钮*/
@property (nonatomic , strong) ZYElasticButton *payBtn;

@end
