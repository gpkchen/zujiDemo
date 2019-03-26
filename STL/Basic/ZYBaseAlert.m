//
//  ZYBaseAlert.m
//  PodLib
//
//  Created by 李明伟 on 2018/3/28.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseAlert.h"
#import "POP.h"
#import "UIView+ZYExtension.h"
#import "ZYMacro.h"

@interface ZYBaseAlert ()<UIGestureRecognizerDelegate>

@property (nonatomic , copy) ZYBaseAlertDismissBlock dismissBlock; //消失回调

@property (nonatomic , strong) UIView *back; //背景视图
@property (nonatomic , strong) UIView *zy_panel; //浮板视图

@end

@implementation ZYBaseAlert

- (instancetype)init{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if(self){
        [self _initBaseWidgets];
    }
    return self;
}

#pragma mark - 初始化控件
- (void)_initBaseWidgets{
    self.backgroundColor = [UIColor clearColor];
    _shouldTapToDissmiss = YES;
    
    __weak __typeof__(self) weakSelf = self;
    
    _back = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    _back.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4];
    _back.tag = 100;
    [_back tapped:^(UITapGestureRecognizer * _Nonnull gesture) {
        if(weakSelf.shouldTapToDissmiss){
            [weakSelf dismiss];
        }
    } delegate:self];
    [self addSubview:_back];
    
    _zy_panel = [[UIView alloc]init];
    _zy_panel.backgroundColor = [UIColor clearColor];
    [self addSubview:_zy_panel];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if(touch.view.tag == 100){
        return YES;
    }
    return NO;
}

#pragma mark - public
- (void)showWithPanelView:(UIView *)panelView{
    if(!(panelView.superview && [panelView.superview isEqual:_zy_panel])){
        [_zy_panel addSubview:panelView];
        
        panelView.frame = CGRectMake(0, 0, panelView.width, panelView.height);
        _zy_panel.frame = CGRectMake((SCREEN_WIDTH - panelView.width) / 2,
                                     (SCREEN_HEIGHT - panelView.height) / 2,
                                     panelView.width,
                                     panelView.height);
        _zy_panel.backgroundColor = [UIColor clearColor];
    }
    
    _back.alpha = 0;
    _zy_panel.alpha = 0;
    [SCREEN addSubview:self];
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.back.alpha = 1;
                         self.zy_panel.alpha = 1;
                     }];
    [self animateWithView:_zy_panel isShow:YES];
    _isShowed = YES;
}

- (void)dismiss{
    [self dismissWithBlock:nil];
}

- (void)dismissWithBlock:(ZYBaseAlertDismissBlock)block{
    _dismissBlock = block;
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.back.alpha = 0;
                         self.zy_panel.alpha = 0;
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                         !self.dismissBlock ? : self.dismissBlock();
                     }];
    [self animateWithView:_zy_panel isShow:NO];
    _isShowed = NO;
}

#pragma mark - private
- (void)animateWithView:(UIView *)view isShow:(BOOL)is{
    POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    animation.removedOnCompletion = YES;
    animation.additive = NO;
    if(is){
        animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(0.5, 0.5)];
        animation.toValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
    }else{
        animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
        animation.toValue = [NSValue valueWithCGPoint:CGPointMake(0.5, 0.5)];
    }
    animation.springBounciness = 10;
    [view.layer pop_addAnimation:animation forKey:@"MSODZoom"];
}

@end
