//
//  ZYOrderListVC.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/28.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYOrderListVC.h"
#import "ZYOrderListView.h"
#import "ZYOrderListSubVC.h"
#import "ZYOrderStateBtn.h"

@interface ZYOrderListVC ()

@property (nonatomic , strong) ZYOrderListView *baseView;

@property (nonatomic , strong) NSMutableArray *vcs;
@property (nonatomic , strong) ZYOrderListSubVC *curVC; //当前子控制器

@end

@implementation ZYOrderListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = self.baseView;
    self.title = @"订单列表";
    
    for(int i=0;i<self.baseView.stateBtns.count;++i){
        ZYOrderStateBtn *btn = self.baseView.stateBtns[i];
        ZYOrderListSubVC *vc = [ZYOrderListSubVC new];
        if(0 == i){
            vc.orderState = nil;
            [self.view addSubview:vc.view];
            _curVC = vc;
        }else{
            vc.orderState = [NSString stringWithFormat:@"%d",btn.orderState];
        }
        [self addChildViewController:vc];
        [self.vcs addObject:vc];
    }
    
    if(!_orderState){
        NSString *state = self.dicParam[@"orderState"];
        if(state){
            self.orderState = [state intValue];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:UIColor.clearColor]];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:NAVIGATIONBAR_SHADOW_COLOR]];
}

#pragma mark - 按钮事件
- (void)btnAction:(UIButton *)button{
    if(button.isSelected){
        return;
    }
    NSUInteger index = [self.baseView.stateBtns indexOfObject:button];
    for(ZYElasticButton *btn in self.baseView.stateBtns){
        if([btn isEqual:button]){
            btn.selected = YES;
        }else{
            btn.selected = NO;
        }
    }
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.baseView.corsur.centerX = button.centerX;
                     }];
    ZYOrderListSubVC *toVC = self.vcs[index];
    __weak __typeof__(self) weakSelf = self;
    [self transitionFromViewController:self.curVC
                      toViewController:toVC
                              duration:0
                               options:UIViewAnimationOptionTransitionNone
                            animations:nil
                            completion:^(BOOL finished) {
                                weakSelf.curVC = toVC;
                            }];
    
    if(button.right > self.baseView.scrollView.contentOffset.x + self.baseView.scrollView.width){
        [self.baseView.scrollView setContentOffset:CGPointMake(button.right - self.baseView.scrollView.width, 0) animated:YES];
    }
    if(button.left < self.baseView.scrollView.contentOffset.x){
        [self.baseView.scrollView setContentOffset:CGPointMake(button.left, 0) animated:YES];
    }
}

#pragma mark - setter
- (void)setOrderState:(ZYOrderState)orderState{
    _orderState = orderState;
    
    for(int i=0;i<self.baseView.stateBtns.count;++i){
        ZYOrderStateBtn *btn = self.baseView.stateBtns[i];
        if(btn.orderState == orderState){
            [self btnAction:btn];
            break;
        }
    }
}

#pragma mark - getter
- (ZYOrderListView *)baseView{
    if(!_baseView){
        _baseView = [ZYOrderListView new];
        
        __weak __typeof__(self) weakSelf = self;
        for(ZYElasticButton *btn in self.baseView.stateBtns){
            [btn clickAction:^(UIButton * _Nonnull button) {
                [weakSelf btnAction:button];
            }];
        }
    }
    return _baseView;
}

- (NSMutableArray *)vcs{
    if(!_vcs){
        _vcs = [NSMutableArray array];
    }
    return _vcs;
}

@end
