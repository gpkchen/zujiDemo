//
//  UIButton+ZYExtension.m
//  PodLib
//
//  Created by 李明伟 on 2018/3/27.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "UIButton+ZYExtension.h"
#import "UIButton+WebCache.h"
#import <objc/runtime.h>
#import "UIImage+ZYExtension.h"

static char kButtonActionKey;

@implementation UIButton (ZYExtension)

- (void) setFont:(UIFont *)font{
    self.titleLabel.font = font;
}

- (UIFont *) font{
    return self.titleLabel.font;
}

- (void)clickAction:(void (^)(UIButton * _Nonnull))clickAction{
    objc_setAssociatedObject(self, &kButtonActionKey, clickAction, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self
             action:@selector(clicked:)
   forControlEvents:UIControlEventTouchUpInside];
}

- (void)loadImage:(NSString *_Nullable)url{
    [self loadImage:url placeholder:nil];
}

- (void)loadImage:(NSString *_Nullable)url placeholder:(UIImage *_Nullable)placeholder{
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self sd_setImageWithURL:[NSURL URLWithString:url]
                    forState:UIControlStateNormal
            placeholderImage:placeholder
                     options:SDWebImageRetryFailed | SDWebImageLowPriority];
}

- (void)loadBackgroundImage:(NSString *_Nullable)url{
    [self loadBackgroundImage:url placeholder:nil];
}

- (void)loadBackgroundImage:(NSString *_Nullable)url placeholder:(UIImage *_Nullable)placeholder{
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self sd_setBackgroundImageWithURL:[NSURL URLWithString:url]
                              forState:UIControlStateNormal
                      placeholderImage:placeholder
                               options:SDWebImageRetryFailed | SDWebImageLowPriority];
}

- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state{
    if(!color){
        return;
    }
    [self setBackgroundImage:[UIImage imageWithColor:color] forState:state];
}

#pragma mark - 点击事件
- (void)clicked:(UIButton *)button{
    void (^action)(UIButton *) = objc_getAssociatedObject(self, &kButtonActionKey);
    if(action){
        action(button);
    }
}

@end
