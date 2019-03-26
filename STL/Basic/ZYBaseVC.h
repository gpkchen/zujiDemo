//
//  ZYBaseVC.h
//  PodLib
//
//  Created by 李明伟 on 2018/3/22.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYErrorView.h"
#import "ZYLoadingView.h"
#import "ZYCustomNavigationBar.h"

/**视图控制器基类*/
@interface ZYBaseVC : UIViewController

/**自定义navigationBar*/
@property (nonatomic , strong , readonly) ZYCustomNavigationBar *customNavigationBar;
/**是否显示自定义navigationBar*/
@property (nonatomic , assign) BOOL showCustomNavigationBar;
/**导航栏透明度，默认1,请在init方法中设值*/
@property (nonatomic , assign) CGFloat navigationBarAlpha;
/**是否应该侧滑返回，默认YES*/
@property (nonatomic , assign) BOOL shouldSwipeToBack;
/**是否需要显示返回按钮，默认YES，需要在子类viewDidLoad之前调用*/
@property (nonatomic , assign) BOOL shouldShowBackBtn;

/**自定义导航栏左边按钮*/
@property (nonatomic , strong) NSArray *leftBarItems;
/**自定义导航栏右边按钮*/
@property (nonatomic , strong) NSArray *rightBarItems;

/**是否可见*/
@property (nonatomic , assign , readonly) BOOL isVisiable;

/**重写返回按钮*/
- (void)overrideBackBtn;

/**系统自带导航栏返回按钮事件*/
- (void)systemBackButtonClicked;

/**自定义导航栏按钮事件,用于继承重载*/
- (void)leftBarItemsAction:(int)index;
- (void)rightBarItemsAction:(int)index;

/**显示hud*/
- (void)showHud;
/**消失hud*/
- (void)hideHud;

/**显示全屏加载动画*/
- (void)showLoadingView;
/**消失全屏加载动画*/
- (void)hideLoadingView;

/**隐藏错误图*/
- (void)hideErrorView;
/**显示错误视图*/
- (void)showErrorViewWithImage:(UIImage *)image contentY:(CGFloat)contentY buttonTitle:(NSString *)buttonTitle buttonAction:(void(^)(void))buttonAvction;
/**显示网络超时错误图*/
- (void)showNetTimeOutView:(ZYErrorViewButtonAction)buttonAction;
/**显示无网络错误图*/
- (void)showNoNetView:(ZYErrorViewButtonAction)buttonAction;
/**显示服务器错误图*/
- (void)showSystemErrorView:(ZYErrorViewButtonAction)buttonAction;
/**显示无收藏错误图*/
- (void)showNoCollectionView:(ZYErrorViewButtonAction)buttonAction;
/**显示无消息错误图*/
- (void)showNoMessageView;
/**显示无账单错误图*/
- (void)showNoBillView;
/**显示无优惠券错误图*/
- (void)showNoCouponView:(ZYErrorViewButtonAction)buttonAction;
/**显示无收货地址错误图*/
- (void)showNoAddressView:(ZYErrorViewButtonAction)buttonAction;
/**显示无订单错误图*/
- (void)showNoOrderView:(ZYErrorViewButtonAction)buttonAction;
/**显示认证通过错误图*/
- (void)showPassAuthView:(ZYErrorViewButtonAction)buttonAction;
/**显示无门店错误图*/
- (void)showNoStoreView;
/**显示无搜索结果错误图*/
- (void)showNoSearchResultView;
/**显示无额度变更记录错误图*/
- (void)showNoLimitRecordView:(ZYErrorViewButtonAction)buttonAction;

@end
