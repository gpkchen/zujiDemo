//
//  ZYBaseAlert.h
//  PodLib
//
//  Created by 李明伟 on 2018/3/28.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**消失回调*/
typedef void (^ZYBaseAlertDismissBlock)(void);

/**弹框基础类（实现一些基础的动画与事件，用于继承）*/
@interface ZYBaseAlert : UIView

/**是否允许点击旁白消失（默认YES）*/
@property (nonatomic , assign) BOOL shouldTapToDissmiss;
/**是否已显示*/
@property (nonatomic , assign , readonly) BOOL isShowed;

/**显示方法*/
- (void)showWithPanelView:(UIView *)panelView;

/**消失方法*/
- (void)dismiss;
- (void)dismissWithBlock:(ZYBaseAlertDismissBlock)block;

@end
