//
//  ZYItemDetailSkuMenu.h
//  Apollo
//
//  Created by 李明伟 on 2018/5/4.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemDetail.h"

/**消失回调*/
typedef void (^ZYItemDetailSkuMenuDismissAction)(void);
/**立即租按钮事件*/
typedef void (^ZYItemDetailSkuMenuRentAction)(void);

/**
 选择事件

 @param skus 选择的sku（从上到下顺序）
 @param period 选择的租期
 @param services 选择的增值服务
 @param skuPrice 对应的价格
 */
typedef void (^ZYItemDetailSkuMenuSelectionAction)(NSArray *skus,
                                                   _m_ItemDetail_SkuAttribute_Sub *period,
                                                   NSArray *services,
                                                   _m_ItemDetail_SkuPrice *skuPrice);

@interface ZYItemDetailSkuMenu : UIView

/**商品详情数据源*/
@property (nonatomic , strong) _m_ItemDetail *detail;
/**所有有库存的排列组合（key:一级id:二级id，value:@"1"）*/
@property (nonatomic , strong) NSMutableDictionary *skuStorages;

/**立即租按钮事件*/
@property (nonatomic , copy) ZYItemDetailSkuMenuRentAction rentAction;
/**选择事件*/
@property (nonatomic , copy) ZYItemDetailSkuMenuSelectionAction selectionAction;

//显示消失
- (void)show;
- (void)dismiss:(ZYItemDetailSkuMenuDismissAction)finish;

/**清空选择的数据*/
- (void)reset;

@end
