//
//  ZYCustomNavigationBar.h
//  Apollo
//
//  Created by 李明伟 on 2018/11/5.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define CNBTitleLabDefaultMaxFontSize   30
#define CNBTitleLabDefaultMinFontSize   17
#define CNBAnimationDuration            0.1
#define CNBMaxHeight                    (NAVIGATION_BAR_HEIGHT + 58 * UI_H_SCALE)
#define CNBMinHeight                    NAVIGATION_BAR_HEIGHT

typedef void (^ZYCustomNavigationBarAnimationBlock)(CGFloat progress);

@interface ZYCustomNavigationBar : UIView

/**设置最大高度*/
@property (nonatomic , assign) CGFloat maxHeight;
/**设置最小高度*/
@property (nonatomic , assign) CGFloat minHeight;
/**设置标题最大字体大小*/
@property (nonatomic , assign) CGFloat maxTitleFontSize;
/**设置标题最小字体大小*/
@property (nonatomic , assign) CGFloat minTitleFontSize;
/**返回按钮事件*/
@property (nonatomic , copy) void (^backAction)(void);
/**标题*/
@property (nonatomic , copy) NSString *title;
/**向上收Y坐标偏移量*/
@property (nonatomic , assign) CGFloat pullY;
/**请将需要渐变显示/消失的子视图加入cv此列表*/
@property (nonatomic , strong) NSMutableArray *fadeSubViews;
/**动画过程回调*/
@property (nonatomic , copy) ZYCustomNavigationBarAnimationBlock animationBlock;

@end

NS_ASSUME_NONNULL_END
