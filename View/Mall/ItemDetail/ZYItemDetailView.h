//
//  ZYItemDetailView.h
//  Apollo
//
//  Created by 李明伟 on 2018/5/3.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYItemDetailUpView.h"

#define ZYItemDetailToolBarHeight (55 * UI_H_SCALE)

@interface ZYItemDetailView : UIView

/**返回按钮*/
@property (nonatomic , strong) ZYElasticButton *backBtn;

@property (nonatomic , strong) UIView *toolBar;

/**租赁按钮*/
@property (nonatomic , strong) ZYElasticButton *rentBtn;

/**客服按钮*/
@property (nonatomic , strong) ZYElasticButton *serviceBtn;
@property (nonatomic , strong) UIImageView *serviceIcon;

/**收藏按钮*/
@property (nonatomic , strong) ZYElasticButton *collectionBtn;
@property (nonatomic , strong) UIImageView *collectionIcon;

@end
