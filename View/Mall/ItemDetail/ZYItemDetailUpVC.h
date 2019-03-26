//
//  ZYItemDetailUpVC.h
//  Apollo
//
//  Created by 李明伟 on 2018/5/3.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseVC.h"
#import "ItemDetail.h"

/**应该显示图文详情回调*/
typedef void (^ZYItemDetailUpVCShouldScrollBlock)(void);
/**选择规格点击事件*/
typedef void (^ZYItemDetailUpVCChoiseSkuAction)(void);
/**下单事件*/
typedef void (^ZYItemDetailUpVCRentAction)(void);
/**收藏事件*/
typedef void (^ZYItemDetailUpVCCollectionAction)(void);


@interface ZYItemDetailUpVC : ZYBaseVC

@property (nonatomic , strong) ZYTableView *tableView;

/**选择的sku拼成的标题*/
@property (nonatomic , copy) NSString *selectedSkuTitle;
/**商品详情*/
@property (nonatomic , strong) _m_ItemDetail *detail;
/**待领取优惠券*/
@property (nonatomic , strong) NSMutableArray *toReceiveCoupons;
/**已领取优惠券*/
@property (nonatomic , strong) NSMutableArray *receivedCoupons;

@property (nonatomic , assign) int timeCount;

/**上拉显示详情回调*/
@property (nonatomic , copy) ZYItemDetailUpVCShouldScrollBlock scrollBlock;
/**选择规格点击事件*/
@property (nonatomic , copy) ZYItemDetailUpVCChoiseSkuAction skuAction;
/**下单事件*/
@property (nonatomic , copy) ZYItemDetailUpVCRentAction rentAction;
/**收藏事件*/
@property (nonatomic , copy) ZYItemDetailUpVCCollectionAction collectionAction;

- (void)pause;

@end
