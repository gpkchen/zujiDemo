//
//  ZYElasticButton.h
//  PodLib
//
//  Created by 李明伟 on 2018/3/28.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**0可伸缩动画的按钮*/
@interface ZYElasticButton : UIButton

/**禁用动画开关(默认YES)*/
@property (nonatomic , assign) BOOL shouldAnimate;
/**是否需要圆角*/
@property (nonatomic , assign) BOOL shouldRound;

@end
