//
//  UIImage+ZYExtension.h
//  PodLib
//
//  Created by 李明伟 on 2018/3/27.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ZYExtension)

/**生成纯色的图片对象*/
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/**base64字符串转图片*/
+ (UIImage *)ImageWithBase64String:(NSString *)string;

/**
 压缩图片
 @param size 压缩后的尺寸
 @return 压缩后的图片对象
 */
- (UIImage *)scaleWithImageWithSize:(CGSize)size;

/**
 高斯模糊方法
 */
- (UIImage *)boxblurImageWithBlur:(CGFloat)blur exclusionPath:(UIBezierPath *)exclusionPath;

/**
 高斯模糊
 */
- (UIImage *)blurryImageWithBlurLevel:(CGFloat)blur;


/**
 将图像转换为黑白照片
 */
- (UIImage *)transformToBlackAndWhite;

/**
 将字符串生成二维码
 */
+ (UIImage *)createQRCodeImage:(NSString *)qrstring
                          size:(CGFloat)size;
/**
 保存图片到相册
 */
- (void)saveToAlbum;

@end
