//
//  UIButton+ZYExtension.h
//  PodLib
//
//  Created by 李明伟 on 2018/3/27.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (ZYExtension)

/**按钮字体*/
@property (nonatomic , strong) UIFont * _Nullable font;

/**
 *  设置点击事件
 *
 *  @param clickAction 点击事件block
 */
- (void)clickAction:(void(^_Nonnull)(UIButton *_Nonnull button))clickAction;

/**设置网络图片*/
- (void)loadImage:(NSString *_Nullable)url;
- (void)loadImage:(NSString *_Nullable)url placeholder:(UIImage *_Nullable)placeholder;
- (void)loadBackgroundImage:(NSString *_Nullable)url;
- (void)loadBackgroundImage:(NSString *_Nullable)url placeholder:(UIImage *_Nullable)placeholder;

/**根据状态设置背景色*/
- (void)setBackgroundColor:(UIColor *_Nullable)color forState:(UIControlState)state;

@end
