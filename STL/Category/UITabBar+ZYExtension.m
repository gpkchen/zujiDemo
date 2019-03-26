//
//  UITabBar+ZYExtension.m
//  PodLib
//
//  Created by 李明伟 on 2018/3/27.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "UITabBar+ZYExtension.h"

@implementation UITabBar (ZYExtension)

//显示红点
- (void)showBadgeOnItmIndex:(int)index{
    UIView *view = [self viewWithTag:888 + index];
    if(view){
        [view removeFromSuperview];
    }
    
    //新建小红点
    UIView *bview = [[UIView alloc]init];
    bview.tag = 888 + index;
    bview.layer.cornerRadius = 4.0;
    bview.clipsToBounds = YES;
    bview.backgroundColor = [UIColor redColor];
    CGRect tabFram = self.frame;
    
    CGFloat itemWidth = tabFram.size.width / self.items.count;
    CGFloat x = itemWidth * index +  itemWidth * 0.6;
    CGFloat y = 0.1 * tabFram.size.height;
    bview.frame = CGRectMake(x, y, 8.0, 8.0);
    [self addSubview:bview];
    [self bringSubviewToFront:bview];
}

//隐藏红点
-(void)hideBadgeOnItemIndex:(int)index{
    UIView *view = [self viewWithTag:888 + index];
    [view removeFromSuperview];
}

@end
