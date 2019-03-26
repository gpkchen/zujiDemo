//
//  ZYBaseSheet.m
//  PodLib
//
//  Created by 李明伟 on 2018/3/28.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseSheet.h"
#import "UIView+ZYExtension.h"
#import "ZYMacro.h"

@interface ZYBaseSheet ()<UIGestureRecognizerDelegate>

@property (nonatomic , strong) UIView *patchView;
@property (nonatomic , assign) CGFloat heightForFromNavBottomType;

@end


@implementation ZYBaseSheet

- (instancetype) init{
    if(self = [super init]){
        [self initSelf];
    }
    return self;
}

- (void)initSelf{
    _shouldTapToDismiss = YES;
    _showType = ZYSheetPanelViewShowTypeFromBottom;
    
    self.backgroundColor = [UIColor clearColor];
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    _patchView = [[UIView alloc] init];
    _patchView.frame = self.bounds;
    _patchView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    _patchView.tag = 100;
    [self addSubview:_patchView];
    __weak __typeof__(self) weakSelf = self;
    [_patchView tapped:^(UITapGestureRecognizer * _Nonnull gesture) {
        !weakSelf.patchViewTapAction ? : weakSelf.patchViewTapAction();
        if(weakSelf.shouldTapToDismiss){
            [weakSelf dismiss:nil];
        }
    } delegate:self];
}

- (void)show{
    if (!_panelView)
        return;
    if (!_panelView.superview)
        [self addSubview:_panelView];
    [self initViewsPostion];
    [SCREEN addSubview:self];
    _isShowed = YES;
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.patchView.alpha = 1;
                         switch (self.showType) {
                             case ZYSheetPanelViewShowTypeFromBottom:{
                                 self.panelView.top = SCREEN_HEIGHT - self.panelView.height;
                             }
                                 break;
                             case ZYSheetPanelViewShowTypeFromTop:{
                                 self.panelView.top = 0;
                             }
                                 break;
                             case ZYSheetPanelViewShowTypeFromRight:{
                                 self.panelView.left = SCREEN_WIDTH - self.panelView.width;
                             }
                                 break;
                             case ZYSheetPanelViewShowTypeFromLeft:{
                                 self.panelView.left = 0;
                             }
                                 break;
                             case ZYSheetPanelViewShowTypeFromNavBottom:{
                                 self.panelView.height = self.heightForFromNavBottomType;
                             }
                                 break;
                             default:
                                 break;
                         }
                     } completion:^(BOOL finished){
                         
                     }];
}

- (void)dismiss:(ZYBaseSheetDismissAction)finish{
    if(!_isShowed){
        return;
    }
    _isShowed = NO;
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self initViewsPostion];
                     }completion:^(BOOL finished){
                         [self removeFromSuperview];
                         !finish ? : finish();
                     }];
}

- (void)setPanelView:(UIView *)panelView{
    _panelView = panelView;
    _heightForFromNavBottomType = panelView.height;
}

- (void)initViewsPostion{
    _patchView.alpha = 0;
    
    switch (self.showType) {
        case ZYSheetPanelViewShowTypeFromBottom:{
            _panelView.top = SCREEN_HEIGHT;
            _panelView.left = 0;
        }
            break;
        case ZYSheetPanelViewShowTypeFromTop:{
            _panelView.bottom = 0;
            _panelView.left = 0;
        }
            break;
        case ZYSheetPanelViewShowTypeFromRight:{
            _panelView.left = SCREEN_WIDTH;
            _panelView.centerY = self.height / 2;
        }
            break;
        case ZYSheetPanelViewShowTypeFromLeft:{
            _panelView.left = -SCREEN_WIDTH;
            _panelView.centerY = self.height / 2;
        }
            break;
        case ZYSheetPanelViewShowTypeFromNavBottom:{
            _panelView.height = 0;
        }
            break;
        default:
            break;
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if(touch.view.tag == 100){
        return YES;
    }
    return NO;
}

@end
