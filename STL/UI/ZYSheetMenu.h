//
//  ZYSheetMenu.h
//  PodLib
//
//  Created by 李明伟 on 2018/3/28.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseSheet.h"

//选择回调
typedef void (^ZYSheetMenuSelectionAction)(NSUInteger index);
//取消回调
typedef void (^ZYSheetMenuCancelAction)(void);

typedef NS_ENUM(int , ZYSheetMenuCancelBtnStyle) {
    ZYSheetMenuCancelBtnStyleRound = 0, //默认：圆角
    ZYSheetMenuCancelBtnStyleFull = 1, //直角铺满
};

/**上拉菜单*/
@interface ZYSheetMenu : ZYBaseSheet

@property (nonatomic , assign) ZYSheetMenuCancelBtnStyle cancelBtnStyle;

/**数据源NSString*/
@property (nonatomic , strong) NSArray *dateArr;

/**显示方法*/
- (void)show;
/**消失方法*/
- (void)dismissWithCompletion:(ZYBaseSheetDismissAction)completion;
/**设置选择回调*/
- (void)selectionAction:(ZYSheetMenuSelectionAction)action;
/** 设置取消回调*/
- (void)cancelAction:(ZYSheetMenuCancelAction)action;

@end


/*************上拉菜单Cell*************/
@interface ZYSheetMenuCell : UITableViewCell

@property (nonatomic , strong) UIImageView *separator;
@property (nonatomic , copy) NSString *text;
@property (nonatomic , strong) UIColor *textColor;

@end
