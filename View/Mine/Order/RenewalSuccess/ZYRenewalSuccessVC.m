//
//  ZYRenewalSuccessVC.m
//  Apollo
//
//  Created by 李明伟 on 2018/6/27.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYRenewalSuccessVC.h"
#import "ZYRenewalSuccessView.h"

@interface ZYRenewalSuccessVC ()

@property (nonatomic , strong) ZYRenewalSuccessView *baseView;

@end

@implementation ZYRenewalSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = self.baseView;
    self.title = @"续租成功";
}

#pragma mark - setter
- (void)setRent:(NSString *)rent{
    _rent = rent;
    self.baseView.rent = rent;
}

- (void)setTerm:(NSString *)term{
    _term = term;
    self.baseView.term = term;
}

- (void)setTermSub:(NSString *)termSub{
    _termSub = termSub;
    self.baseView.termSub = termSub;
}

#pragma mark - getter
- (ZYRenewalSuccessView *)baseView{
    if(!_baseView){
        _baseView = [ZYRenewalSuccessView new];
        
        __weak __typeof__(self) weakSelf = self;
        [_baseView.orderBtn clickAction:^(UIButton * _Nonnull button) {
            [[ZYRouter router] goWithoutHead:[NSString stringWithFormat:@"orderDetail?orderId=%@",[weakSelf.orderId URLEncode]]];
        }];
        [_baseView.homeBtn clickAction:^(UIButton * _Nonnull button) {
            [[ZYRouter router] returnToRoot];
            [ZYMainTabVC shareInstance].selectedIndex = 0;
        }];
    }
    return _baseView;
}


@end
