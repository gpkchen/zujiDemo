//
//  ZYPaySuccessVC.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/27.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYPaySuccessVC.h"
#import "ZYPaySuccessView.h"
#import "GetCreateOrderInfo.h"
#import "AppActiveInfo.h"

@interface ZYPaySuccessVC ()<SDCycleScrollViewDelegate>

@property (nonatomic , strong) ZYPaySuccessView *baseView;

@property (nonatomic , strong) _m_GetCreateOrderInfo *info;
@property (nonatomic , strong) _m_AppActiveInfo *ad;

@end

@implementation ZYPaySuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = self.baseView;
    self.title = @"下单成功";
    self.shouldShowBackBtn = NO;
    self.rightBarItems = @[@"确定"];
    
    if(!_orderId){
        _orderId = self.dicParam[@"orderId"];
    }
    
    [self showLoadingView];
    [self loadInfo:NO];
}

- (void)rightBarItemsAction:(int)index{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 获取页面信息
- (void)loadInfo:(BOOL)showHud{
    _p_GetCreateOrderInfo *param = [_p_GetCreateOrderInfo new];
    param.orderId = _orderId;
    [[ZYHttpClient client] post:param
                        showHud:showHud
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            [self hideLoadingView];
                            [self hideErrorView];
                            if(responseObj.success){
                                self.info = [[_m_GetCreateOrderInfo alloc] initWithDictionary:responseObj.data];
                                
                                self.baseView.rent = [NSString stringWithFormat:@"租金：￥%@",self.info.rentPrice];
                                self.baseView.term = [NSString stringWithFormat:@"租期：%@",self.info.rentPeriod];
                                self.baseView.deposit = [NSString stringWithFormat:@"已支付押金：￥%@",self.info.deposit];
                                
                                self.baseView.depositSub = @"已支付的押金将于您寄回或买断相关物品后退回至您的账户";
                                if(self.info.rentType == ZYRentTypeLong){
                                    self.baseView.termSub = @"月租金请于次月账单日之前支付";
                                }else{
                                    self.baseView.termSub = @"";
                                }
                                if(self.info.expressType == ZYExpressTypeMail){
                                    self.baseView.subTitleLab.text = @"我们将尽快为你配送";
                                }else{
                                    self.baseView.subTitleLab.text = @"请赶往门店提取你的商品";
                                }
                                [self loadAD];
                            }else{
                                [ZYToast showWithTitle:responseObj.message];
                            }
                        } failure:^(NSURLSessionDataTask *task, NSError *error) {
                            [self hideLoadingView];
                            [self hideErrorView];
                            
                            __weak __typeof__(self) weakSelf = self;
                            if(self.info){
                                if(error.code == ZYHttpErrorCodeTimeOut){
                                    [ZYToast showWithTitle:ZYHttpErrorMessageNetTimeOut];
                                }else if(error.code == ZYHttpErrorCodeNoNet){
                                    [ZYToast showWithTitle:ZYHttpErrorMessageNoNet];
                                }else if(error.code == ZYHttpErrorCodeSystemError){
                                    [ZYToast showWithTitle:ZYHttpErrorMessageSystemError];
                                }
                            }else{
                                if(error.code == ZYHttpErrorCodeTimeOut){
                                    [self showNetTimeOutView:^{
                                        [weakSelf loadInfo:YES];
                                    }];
                                }else if(error.code == ZYHttpErrorCodeNoNet){
                                    [self showNoNetView:^{
                                        [weakSelf loadInfo:YES];
                                    }];
                                }else if(error.code == ZYHttpErrorCodeSystemError){
                                    [self showSystemErrorView:^{
                                        [weakSelf loadInfo:YES];
                                    }];
                                }
                            }
                        } authFail:^{
                            [self hideLoadingView];
                            [self hideErrorView];
                        }];
}

#pragma mark - 加载广告信息
- (void)loadAD{
    _p_AppActiveInfo *param = [_p_AppActiveInfo new];
    param.activeType = @"1";
    param.type = @"1";
    [[ZYHttpClient client] post:param
                        showHud:NO
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            if(responseObj.isSuccess){
                                self.ad = [_m_AppActiveInfo mj_objectWithKeyValues:responseObj.data];
                                if(self.ad.imgUrl){
                                    NSArray *images = @[self.ad.imgUrl];
                                    self.baseView.banner.imageURLStringsGroup = images;
                                }
                            }else{
                                [ZYToast showWithTitle:responseObj.message];
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

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    [[ZYRouter router] go:self.ad.url];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    
}

#pragma mark - getter
- (ZYPaySuccessView *)baseView{
    if(!_baseView){
        _baseView = [ZYPaySuccessView new];
        _baseView.banner.delegate = self;
        
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
