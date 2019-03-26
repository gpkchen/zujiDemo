//
//  ZYItemDetailSkuMenuButton.h
//  Apollo
//
//  Created by 李明伟 on 2018/5/12.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ItemDetail.h"

typedef NS_ENUM(int , ZYItemDetailSkuMenuButtonState) {
    ZYItemDetailSkuMenuButtonStateNormal = 1,
    ZYItemDetailSkuMenuButtonStateSelected = 2,
    ZYItemDetailSkuMenuButtonStateDisable = 3,
};

@interface ZYItemDetailSkuMenuButton : ZYElasticButton

@property (nonatomic , assign) ZYItemDetailSkuMenuButtonState buttonState;
@property (nonatomic , strong) _m_ItemDetail_SkuAttribute_Sub *value;

@end
