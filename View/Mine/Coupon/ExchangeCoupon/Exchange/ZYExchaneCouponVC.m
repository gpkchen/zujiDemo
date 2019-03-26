//
//  ZYExchaneCouponVC.m
//  Apollo
//
//  Created by 李明伟 on 2018/10/8.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYExchaneCouponVC.h"
#import "ZYExchangeCouponView.h"
#import "ExchangeCoupon.h"
#import "ZYExchangeCouponResultVC.h"
#import "ListUserCoupon.h"

@interface ZYExchaneCouponVC ()<UIScrollViewDelegate>

@property (nonatomic , strong) ZYExchangeCouponView *baseView;

@end

@implementation ZYExchaneCouponVC

- (instancetype)init{
    if(self = [super init]){
        self.showCustomNavigationBar = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = self.baseView;
    self.title = @"兑换优惠券";
    self.customNavigationBar.minHeight = NAVIGATION_BAR_HEIGHT + 20;
}

#pragma mark - 兑换优惠券
- (void)exchange{
    _p_ExchangeCoupon *param = [_p_ExchangeCoupon new];
    param.redeemCode = self.baseView.codeText.text;
    [[ZYHttpClient client] post:param
                        showHud:YES success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            if(responseObj.success){
                                _m_ListUserCoupon *model = [[_m_ListUserCoupon alloc] initWithDictionary:responseObj.data];
                                ZYExchangeCouponResultVC *vc = [ZYExchangeCouponResultVC new];
                                vc.coupon = model;
                                [[ZYRouter router] push:vc];
                            }else{
                                self.baseView.errorLab.hidden = NO;
                                self.baseView.errorLab.text = responseObj.message;
                            }
                        } failure:^(NSURLSessionDataTask *task, NSError *error) {
                            if(error.code == ZYHttpErrorCodeTimeOut){
                                [ZYToast showWithTitle:ZYHttpErrorMessageNetTimeOut];
                            }else if(error.code == ZYHttpErrorCodeNoNet){
                                [ZYToast showWithTitle:ZYHttpErrorMessageNoNet];
                            }else if(error.code == ZYHttpErrorCodeSystemError){
                                [ZYToast showWithTitle:ZYHttpErrorMessageSystemError];
                            }
                        } authFail:nil];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.baseView endEditing:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.customNavigationBar.pullY = scrollView.contentOffset.y;
}

#pragma mark - 监控输入框
- (void)codeChanged:(UITextField *)textField{
    self.baseView.errorLab.hidden = YES;
    if(textField.text.length == 8){
        self.baseView.exchangeBtn.enabled = YES;
    }else{
        self.baseView.exchangeBtn.enabled = NO;
    }
}

#pragma mark - getter
- (ZYExchangeCouponView *)baseView{
    if(!_baseView){
        _baseView = [ZYExchangeCouponView new];
        _baseView.scrollView.delegate = self;
        [_baseView.codeText addTarget:self
                               action:@selector(codeChanged:)
                     forControlEvents:UIControlEventEditingChanged];
        
        __weak __typeof__(self) weakSelf = self;
        __weak __typeof__(_baseView) weakBaseView = _baseView;
        [_baseView.exchangeBtn clickAction:^(UIButton * _Nonnull button) {
            [weakBaseView endEditing:YES];
            [weakSelf exchange];
        }];
        [_baseView.ruleBtn clickAction:^(UIButton * _Nonnull button) {
            [[ZYRouter router] goWithoutHead:[NSString stringWithFormat:@"web?url=%@",
                                              [[ZYH5Utils formatUrl:ZYH5TypeExchangeCouponRule param:nil] URLEncode]]];
        }];
    }
    return _baseView;
}

@end
