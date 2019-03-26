//
//  UIImageView+ZYExtension.m
//  PodLib
//
//  Created by 李明伟 on 2018/3/27.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "UIImageView+ZYExtension.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (ZYExtension)

- (void)loadImage:(NSString *_Nullable)url{
    [self loadImage:url placeholder:nil];
}

- (void)loadImage:(NSString *_Nullable)url placeholder:(UIImage *_Nullable)placeholder{
    [self sd_setImageWithURL:[NSURL URLWithString:url]
            placeholderImage:placeholder
                     options:SDWebImageRetryFailed | SDWebImageLowPriority];
}

@end
