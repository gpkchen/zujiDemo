//
//  ZYBuyOffSuccessVC.m
//  Apollo
//
//  Created by 李明伟 on 2018/5/22.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBuyOffSuccessVC.h"
#import "ZYBuyOffSuccessView.h"

@interface ZYBuyOffSuccessVC ()

@property (nonatomic , strong) ZYBuyOffSuccessView *baseView;

@end

@implementation ZYBuyOffSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = self.baseView;
    self.title = @"购买";
    
    if(_backAmount){
        self.baseView.contentLab.text = [NSString stringWithFormat:@"剩余押金%.2f元将在七个工作日内打款至你的付款账号，请注意查收。",_backAmount];
    }
}

#pragma mark - getter
- (ZYBuyOffSuccessView *)baseView{
    if(!_baseView){
        _baseView = [ZYBuyOffSuccessView new];
        
        [_baseView.homeBtn clickAction:^(UIButton * _Nonnull button) {
            [[ZYRouter router] returnToRoot];
            [ZYMainTabVC shareInstance].selectedIndex = 0;
        }];
    }
    return _baseView;
}

@end
