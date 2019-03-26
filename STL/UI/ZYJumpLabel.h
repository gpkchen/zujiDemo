//
//  ZYJumpLabel.h
//  Apollo
//
//  Created by 李明伟 on 2018/5/5.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYJumpLabel : UIView

/**广告内容数组(支持NSString和NSAttributedString)*/
@property (nonatomic, copy) NSArray *titles;
/**头部图片 默认为nil*/
@property (nonatomic, strong) UIImage *headImg;
/**头部图片位置*/
@property (nonatomic, assign) CGRect headImgFrame;
/**广告字体 默认为16号系统字体*/
@property (nonatomic, strong) UIFont *labelFont;
/**广告左右边偏移量*/
@property (nonatomic, assign) CGFloat labelXOffset;
/**广告字体颜色  默认为黑色*/
@property (nonatomic, strong) UIColor *color;
/**轮播时间间隔 默认2s*/
@property (nonatomic, assign) NSTimeInterval time;
/**是否含有Img头 默认为NO*/
@property (nonatomic, assign) BOOL isHaveHeadImg;
/**是否开启点击事件 默认为NO*/
@property (nonatomic, assign) BOOL isHaveTouchEvent;
/**点击事件响应*/
@property (nonatomic, copy) void (^clickAdBlock)(NSUInteger index);
/**文本对齐方式*/
@property (nonatomic, assign) NSTextAlignment textAlignment;

/**开始轮播*/
- (void)beginScroll;
/**暂停轮播*/
- (void)pauseScroll;
/**移除定时器*/
- (void)removeTimer;

/**实例化方法*/
- (instancetype)initWithTitles:(NSArray *)titles;

@end
