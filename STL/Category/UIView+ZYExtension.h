//
//  UIView+ZYExtension.h
//  PodLib
//
//  Created by 李明伟 on 2018/3/27.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ZYExtension)

/**方位坐标*/
@property (nonatomic , assign) CGFloat left;
@property (nonatomic , assign) CGFloat top;
@property (nonatomic , assign) CGFloat right;
@property (nonatomic , assign) CGFloat bottom;
@property (nonatomic , assign) CGFloat width;
@property (nonatomic , assign) CGFloat height;
@property (nonatomic , assign) CGFloat centerX;
@property (nonatomic , assign) CGFloat centerY;
@property (nonatomic , assign) CGPoint origin;
@property (nonatomic , assign) CGSize  size;

/**图层相关*/
@property (nonatomic , assign) CGFloat cornerRadius;    //圆角半径
@property (nonatomic , assign) CGFloat borderWidth;     //边框宽度
@property (nonatomic , strong) UIColor *borderColor;    //边框颜色

/**控制器相关*/
@property (nonatomic , strong , readonly) UIViewController *viewController;
@property (nonatomic , strong , readonly) UINavigationController *navigationController;
@property (nonatomic , strong , readonly) UITabBarController *tabBarController;


/**
 添加红色小圆点（未读）
 @param center 圆点中心位置
 */
- (void)addRedDot:(CGPoint)center;
/**移除小圆点*/
- (void)removeRedDot;

/**
 添加未读消息数目（未读）
 @param center 中心位置
 @param num 数目
 */
- (void)addBadge:(CGPoint)center num:(NSInteger)num;
/**移除小圆点*/
- (void)removeBadge;

/**
 设置阴影
 @param color 阴影颜色
 @param opacity 阴影透明度
 @param radius 阴影半径
 @param offset 阴影位置偏移量
 */
- (void)layerShadow:(UIColor *)color
            opacity:(float)opacity
             radius:(CGFloat)radius
             offset:(CGSize)offset;

/**
 设置虚线边框
 @param borderColor 边框颜色
 @param lineWidth 线的粗细
 @param radius 边框半径
 */
- (void)dashedBorder:(UIColor *)borderColor
           lineWidth:(CGFloat)lineWidth
              radius:(CGFloat)radius;

/**
 设置虚线边框
 @param borderColor 边框颜色
 @param lineWidth 线的粗细
 @param radius 边框半径
 */
- (void)solidBorder:(UIColor *)borderColor
          lineWidth:(CGFloat)lineWidth
             radius:(CGFloat)radius;

/**
 设置实线边框
 @param borderColor 边框颜色
 @param top left righthu bottom 各边边框的粗细
 */
- (void)solidBorder:(UIColor *)borderColor
                top:(CGFloat)top
               left:(CGFloat)left
              right:(CGFloat)righthu
             bottom:(CGFloat)bottom;

/**
 *  设置部分圆角(绝对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 */
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii;
/**
 *  设置部分圆角(相对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 *  @param rect    需要设置的圆角view的rect
 */
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii
                 viewRect:(CGRect)rect;

/**
 移除所有的子视图
 */
- (void)removeAllSubviews;

/**
 设置点击事件
 @param clicked 事件处理内容
 */
- (void)tapped:(void(^)(UITapGestureRecognizer *gesture))clicked
      delegate:(id <UIGestureRecognizerDelegate>)delegate;

/**
 设置长按事件
 @param longPressed 事件处理内容
 */
- (void)longPressed:(void(^)(UILongPressGestureRecognizer *))longPressed
           delegate:(id <UIGestureRecognizerDelegate>)delegate;

/**
 截屏工具
 */
- (UIImage *)screenShot;

/**
 快速截屏工具
 */
-(UIImage *)quickScreenShot;

@end
