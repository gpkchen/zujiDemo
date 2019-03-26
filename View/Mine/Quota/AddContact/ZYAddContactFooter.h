//
//  ZYContactFooter.h
//  Apollo
//
//  Created by 李明伟 on 2018/7/10.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ZYContactFooterHeight (188 * UI_H_SCALE)

@interface ZYAddContactFooter : UIView

@property (nonatomic , strong) ZYElasticButton *leftBtn;
@property (nonatomic , strong) ZYElasticButton *midBtn;
@property (nonatomic , strong) ZYElasticButton *rightBtn;
@property (nonatomic , strong) ZYElasticButton *confirmBtn;

@end
