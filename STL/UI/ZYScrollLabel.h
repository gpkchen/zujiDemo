//
//  ZYScrollLabel.h
//  PodLib
//
//  Created by 李明伟 on 2018/3/28.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**点击回调*/
typedef void(^ZYScrollLabelAction)(NSUInteger index);

/**滚动显示文字，用于公告等*/
@interface ZYScrollLabel : UIView

/**文字列表*/
@property (nonatomic , strong) NSArray *textArray;
/**文字颜色*/
@property (nonatomic , strong) UIColor *textColor;
/**文字字体*/
@property (nonatomic , strong) UIFont *font;
/**内容偏移量*/
@property (nonatomic , assign) UIEdgeInsets contentInsert;
/**设置点击事件*/
- (void)action:(ZYScrollLabelAction)action;

@end
