//
//  ZYBaseSheet.h
//  PodLib
//
//  Created by 李明伟 on 2018/3/28.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**面板显示方式*/
typedef NS_ENUM(NSInteger, ZYSheetPanelViewShowType){
    ZYSheetPanelViewShowTypeFromBottom = 1,     //从下到上
    ZYSheetPanelViewShowTypeFromTop = 2,        //从上到下
    ZYSheetPanelViewShowTypeFromRight = 3,      //从右到左
    ZYSheetPanelViewShowTypeFromLeft = 4,       //从左到右
    ZYSheetPanelViewShowTypeFromNavBottom = 5,  //从上到下（导航栏底部）
};

//消失回调
typedef void (^ZYBaseSheetDismissAction)(void);
//背景点击事件
typedef void (^ZYBaseSheetPatchViewTapAction)(void);

/**显示菜单基类，支持各方向*/
@interface ZYBaseSheet : UIView

/**是否已显示*/
@property (nonatomic , assign , readonly) BOOL isShowed;
/**是否轻触消失(默认yes)*/
@property (nonatomic , assign) BOOL shouldTapToDismiss;
/**展示的面板*/
@property (nonatomic , strong) UIView *panelView;
/**面板展示方式 默认从底部出来*/
@property (nonatomic , assign) ZYSheetPanelViewShowType showType;
/**背景点击事件*/
@property (nonatomic , copy) ZYBaseSheetPatchViewTapAction patchViewTapAction;

//显示消失
- (void)show;
- (void)dismiss:(ZYBaseSheetDismissAction)finish;

@end
