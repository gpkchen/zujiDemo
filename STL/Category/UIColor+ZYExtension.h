//
//  UIColor+ZYExtension.h
//  PodLib
//
//  Created by 李明伟 on 2018/3/27.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ZYExtension)

/**转换成16进制字符串*/
- (NSString *)hexString;
/**16进制字符串转颜色*/
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;
/**16进制转颜色*/
+ (UIColor *)colorWithHexRGB:(int)hex;
/**16进制+透明度转颜色*/
+ (UIColor *)colorWithHexRGB:(int)hex alpha:(CGFloat)alpha;

@end
