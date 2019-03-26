//
//  UITabBar+ZYExtension.h
//  PodLib
//
//  Created by 李明伟 on 2018/3/27.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (ZYExtension)

/**显示红点*/
- (void)showBadgeOnItmIndex:(int)index;
/**隐藏红点*/
- (void)hideBadgeOnItemIndex:(int)index;

@end
