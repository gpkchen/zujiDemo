//
//  ZYPieView.h
//  PodLib
//
//  Created by 李明伟 on 2018/3/28.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**饼状图*/
@interface ZYPieView : UIView

/**饼状图图形宽度*/
@property (nonatomic , assign) CGFloat pieWidth;
/**默认颜色（在没设置数值的时候可以设置默认颜色，那么整个图形只有一种颜色，不设置就不显示）*/
@property (nonatomic , strong) UIColor *defaultColor;


/**
 设置数据
 
 @param dataArr 数值列表
 @param colorArr 颜色列表
 */
- (void) setData:(NSArray<NSNumber *> *)dataArr colorArr:(NSArray<UIColor *> *)colorArr;

@end
