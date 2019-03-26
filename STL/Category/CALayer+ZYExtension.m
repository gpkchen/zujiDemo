//
//  CALayer+ZYExtension.m
//  PodLib
//
//  Created by 李明伟 on 2018/3/26.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "CALayer+ZYExtension.h"

@implementation CALayer (ZYExtension)

- (void)removeAllSublayers{
    while (self.sublayers.count) {
        CALayer* child = self.sublayers.lastObject;
        [child removeFromSuperlayer]; 
    }
}

@end
