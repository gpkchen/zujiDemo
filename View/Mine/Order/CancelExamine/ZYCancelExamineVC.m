//
//  ZYCancelExamineVC.m
//  Apollo
//
//  Created by 李明伟 on 2018/10/8.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYCancelExamineVC.h"
#import "ZYCancelExamineView.h"

@interface ZYCancelExamineVC ()

@property (nonatomic , strong) ZYCancelExamineView *baseView;

@end

@implementation ZYCancelExamineVC

- (void)viewDidLoad {
    self.shouldShowBackBtn = NO;
    [super viewDidLoad];
    
    self.view = self.baseView;
    self.title = @"取消订单";
    self.rightBarItems = @[@"确定"];
}

- (void)rightBarItemsAction:(int)index{
    [self systemBackButtonClicked];
}

#pragma mark - getter
- (ZYCancelExamineView *)baseView{
    if(!_baseView){
        _baseView = [ZYCancelExamineView new];
        
        __weak __typeof__(self) weakSelf = self;
        [_baseView.homeBtn clickAction:^(UIButton * _Nonnull button) {
            [[ZYRouter router] returnToRoot];
            [ZYMainTabVC shareInstance].selectedIndex = 1;
        }];
        [_baseView.detailBtn clickAction:^(UIButton * _Nonnull button) {
            [weakSelf systemBackButtonClicked];
        }];
    }
    return _baseView;
}

@end
