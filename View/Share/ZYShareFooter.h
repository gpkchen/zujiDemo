//
//  ZYShareFooter.h
//  Apollo
//
//  Created by 李明伟 on 2018/6/30.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ZYShareFooterHeight (96 * UI_H_SCALE)

@interface ZYShareFooter : UIView

@property (nonatomic , strong) ZYElasticButton *taskBtn;
@property (nonatomic , strong) ZYElasticButton *shareBtn;

@end
