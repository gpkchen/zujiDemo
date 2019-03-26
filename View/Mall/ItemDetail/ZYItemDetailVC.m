//
//  ZYItemDetailVC.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/23.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYItemDetailVC.h"
#import "ZYItemDetailView.h"
#import "ZYItemDetailUpVC.h"
#import "ZYItemDetailDownVC.h"
#import "ZYItemDetailSkuMenu.h"
#import "ItemDetail.h"
#import "ZYItemDetailDepositAlert.h"
#import "ZYOrderConfirmVC.h"
#import "QYSDK.h"
#import "LivingAuthentication.h"
#import "LivingCallback.h"
#import "ZYServiceMenu.h"
#import "PreOrderRiskVerify.h"
#import "ZYPaymentService.h"
#import "UserAttentionSpike.h"
#import "ZYApnsHelper.h"

static const long long kSetSpikeNoticeRestTime = 210000; //秒杀可设置提醒距离秒杀开始的时间

@interface ZYItemDetailVC ()<ZYPaymentDelegate>

@property (nonatomic , strong) ZYItemDetailView *baseView;
@property (nonatomic , strong) ZYServiceMenu *serviceMenu;

@property (nonatomic , strong) _m_ItemDetail *detail;

@property (nonatomic , strong) ZYItemDetailUpVC *upVC;//上半部分视图控制器
@property (nonatomic , strong) ZYItemDetailDownVC *downVC; //下部分视图控制器

@property (nonatomic , strong) ZYItemDetailDepositAlert *depositAlert; //申请免押额度弹窗
@property (nonatomic , strong) ZYItemDetailSkuMenu *skuMenu; //sku菜单

@property (nonatomic , strong) NSMutableDictionary *skuStorages; //所有有库存的排列组合（key:一级id:二级id，value:@"1"）

@property (nonatomic , strong) NSArray *selectedSkus; //选择的属性
@property (nonatomic , strong) _m_ItemDetail_SkuAttribute_Sub *selectedPeriod; //选择的租期
@property (nonatomic , strong) NSArray *selectedServices; //选择的增值服务
@property (nonatomic , strong) _m_ItemDetail_SkuPrice *selectedSkuPrice; //对应的价格
@property (nonatomic , copy) NSString *fundAuthNo; //支付宝资金授权号

@property (nonatomic , strong) NSTimer *timer; //秒杀倒计时
@property (nonatomic , assign) int timeCount;

@property (nonatomic , assign) long long beginTime; //浏览图文开始时间（用于统计）

@end

@implementation ZYItemDetailVC

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:HuoTi_Auth_Notification object:nil];
}

- (instancetype)init{
    if(self = [super init]){
        self.navigationBarAlpha = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = self.baseView;
    
    self.shouldShowBackBtn = YES;
    [self overrideBackBtn];
    
    [self addChildViewController:self.upVC];
    [self.baseView addSubview:self.upVC.view];
    self.upVC.view.frame = CGRectMake(0,
                                      0,
                                      SCREEN_WIDTH,
                                      SCREEN_HEIGHT - (ZYItemDetailToolBarHeight + DOWN_DANGER_HEIGHT));
    
    [self addChildViewController:self.downVC];
    [self.baseView addSubview:self.downVC.view];
    self.downVC.view.frame = CGRectMake(0,
                                        SCREEN_HEIGHT - (ZYItemDetailToolBarHeight + DOWN_DANGER_HEIGHT),
                                        SCREEN_WIDTH,
                                        SCREEN_HEIGHT - (ZYItemDetailToolBarHeight + DOWN_DANGER_HEIGHT) - NAVIGATION_BAR_HEIGHT);
    
    [self.baseView bringSubviewToFront:self.baseView.backBtn];
    [self.baseView bringSubviewToFront:self.baseView.toolBar];
    
    if(!_itemId){
        _itemId = self.dicParam[@"itemId"];
    }
    
    [self showLoadingView];
    [self loadData:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(huotiCallBack:)
                                                 name:HuoTi_Auth_Notification
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //客服消息有无未读
    if([[QYSDK sharedSDK] conversationManager].allUnreadCount > 0){
        self.baseView.serviceIcon.image = [UIImage imageNamed:@"zy_service_unread"];
    }else{
        self.baseView.serviceIcon.image = [UIImage imageNamed:@"zy_service_normal"];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if(_beginTime > 0){
        [ZYStatisticsService event:@"item_detail" durations:(int)([[NSDate date] millisecondSince1970] - _beginTime)];
        _beginTime = 0;
    }
    
    [self.upVC pause];
}

- (void)willMoveToParentViewController:(UIViewController *)parent{
    [super willMoveToParentViewController:parent];
    [self stopTimer];
}

#pragma mark - 关注/取消关注秒杀
- (void)focusSpike{
    [ZYApnsHelper checkNotificationAuthority:^(BOOL hasAuthority) {
        if(!hasAuthority){
            [ZYApnsHelper askNotificationAuthority];
        }else{
            _p_UserAttentionSpike *param = [_p_UserAttentionSpike new];
            param.itemId = self.itemId;
            param.status = self.detail.isFocusSpike ? @"0" : @"1";
            param.activityConfigureId = self.detail.activityConfigureId;
            [[ZYHttpClient client] post:param
                                showHud:YES
                                success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                                    if(responseObj.isSuccess){
                                        self.detail.isFocusSpike = !self.detail.isFocusSpike;
                                        if(self.detail.isFocusSpike){
                                            [ZYComplexToast showSuccessWithTitle:@"设置提醒成功" detail:@"请注意消息通知哦"];
                                        }else{
                                            [ZYComplexToast showMessageWithTitle:@"抢租提醒已取消" detail:@"期待你参加下次活动～"];
                                        }
                                        [self setUpRentBtn];
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
    }];
}

#pragma mark - 获取商品详情
- (void)loadData:(BOOL)showHud{
    _p_ItemDetail *param = [_p_ItemDetail new];
    param.itemId = _itemId;
    [[ZYHttpClient client] post:param
                        showHud:showHud
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            [self.upVC.tableView.mj_header endRefreshing];
                            [self hideLoadingView];
                            [self hideErrorView];
                            if(responseObj.isSuccess){
                                self.selectedSkus = nil;
                                self.selectedPeriod = nil;
                                self.selectedServices = nil;
                                self.selectedSkuPrice = nil;
                                self.upVC.selectedSkuTitle = nil;
                                self.fundAuthNo = nil;
                                self.detail = [[_m_ItemDetail alloc] initWithDictionary:responseObj.data];
//                                self.detail.videoUrl = @"http://hd.yinyuetai.com/uploads/videos/common/1859096_hd_32710146ADB1F13729FB554327B83560.flv";
                                self.detail.itemId = self.itemId;
                                self.detail.skuPriceList = [_m_ItemDetail_SkuPrice mj_objectArrayWithKeyValuesArray:self.detail.skuPriceList];
                                self.detail.serviceList = [_m_ItemDetail_Service mj_objectArrayWithKeyValuesArray:self.detail.serviceList];
                                NSArray *skuArr = self.detail.skuAttributeList;
                                NSMutableArray *skuAtt = [NSMutableArray array];
                                for(NSDictionary *dic in skuArr){
                                    _m_ItemDetail_SkuAttribute *sku = [[_m_ItemDetail_SkuAttribute alloc] initWithDictionary:dic];
                                    NSMutableArray *skuValueAtt = [NSMutableArray array];
                                    for(NSDictionary *valueDic in sku.valueList){
                                        _m_ItemDetail_SkuAttribute_Sub *skuValue = [[_m_ItemDetail_SkuAttribute_Sub alloc] initWithDictionary:valueDic];
                                        [skuValueAtt addObject:skuValue];
                                    }
                                    sku.valueList = skuValueAtt;
                                    [skuAtt addObject:sku];
                                }
                                self.detail.skuAttributeList = skuAtt;
                                _m_ItemDetail_SkuAttribute *period = [[_m_ItemDetail_SkuAttribute alloc] initWithDictionary:responseObj.data[@"rentPeriod"]];
                                NSMutableArray *skuValueAtt = [NSMutableArray array];
                                for(NSDictionary *valueDic in period.valueList){
                                    _m_ItemDetail_SkuAttribute_Sub *skuValue = [[_m_ItemDetail_SkuAttribute_Sub alloc] initWithDictionary:valueDic];
                                    [skuValueAtt addObject:skuValue];
                                }
                                period.valueList = skuValueAtt;
                                self.detail.rentPeriod = period;
                                self.title = self.detail.title;
                                if(self.detail.collectionStatus){
                                    //已收藏
                                    self.baseView.collectionIcon.image = [UIImage imageNamed:@"zy_mall_item_detail_collection_selected"];
                                }else{
                                    //未收藏
                                    self.baseView.collectionIcon.image = [UIImage imageNamed:@"zy_mall_item_detail_collection_normal"];
                                }
                                //总库存
                                
                                self.baseView.collectionBtn.enabled = YES;
                                self.baseView.serviceBtn.enabled = YES;
                                
                                self.upVC.detail = self.detail;
                                self.downVC.url = [ZYH5Utils formatUrl:ZYH5TypeItemDetail param:self.itemId];
                                [self combineStorage];
                                
                                if(self.detail.activityType == 2){
                                    //秒杀
                                    self.timeCount = 0;
                                    [self startTimer];
                                }
                                
                                [self setUpRentBtn];
                                
                            }else{
                                [ZYToast showWithTitle:responseObj.message];
                                self.baseView.rentBtn.enabled = NO;
                                self.baseView.collectionBtn.enabled = NO;
                                self.baseView.serviceBtn.enabled = NO;
                            }
                        } failure:^(NSURLSessionDataTask *task, NSError *error) {
                            [self.upVC.tableView.mj_header endRefreshing];
                            [self hideLoadingView];
                            [self hideErrorView];
                            
                            __weak __typeof__(self) weakSelf = self;
                            if(self.detail){
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
                                        [weakSelf loadData:YES];
                                    }];
                                    [self.baseView bringSubviewToFront:self.baseView.backBtn];
                                }else if(error.code == ZYHttpErrorCodeNoNet){
                                    [self showNoNetView:^{
                                        [weakSelf loadData:YES];
                                    }];
                                    [self.baseView bringSubviewToFront:self.baseView.backBtn];
                                }else if(error.code == ZYHttpErrorCodeSystemError){
                                    [self showSystemErrorView:^{
                                        [weakSelf loadData:YES];
                                    }];
                                    [self.baseView bringSubviewToFront:self.baseView.backBtn];
                                }
                            }
                        } authFail:^{
                            [self.upVC.tableView.mj_header endRefreshing];
                            [self hideLoadingView];
                            [self hideErrorView];
                            
                        }];
}

#pragma mark - 设置立即租按钮状态
- (void)setUpRentBtn{
    NSUInteger totalStorage = 0;
    for(_m_ItemDetail_SkuPrice *skuPrice in self.detail.skuPriceList){
        totalStorage += skuPrice.storage;
    }
    if(totalStorage <= 0){
        //已售罄
        self.baseView.rentBtn.enabled = NO;
        [self.baseView.rentBtn setBackgroundColor:BTN_COLOR_DISABLE forState:UIControlStateDisabled];
        [self.baseView.rentBtn setTitleColor:WORD_COLOR_GRAY_AB forState:UIControlStateDisabled];
        [self.baseView.rentBtn setTitle:@"已售罄" forState:UIControlStateDisabled];
    }else if(self.detail.status){
        if(ZYItemStateUnSelling == self.detail.status){
            //已下架
            self.baseView.rentBtn.enabled = NO;
            [self.baseView.rentBtn setBackgroundColor:BTN_COLOR_DISABLE forState:UIControlStateDisabled];
            [self.baseView.rentBtn setTitleColor:WORD_COLOR_GRAY_AB forState:UIControlStateDisabled];
            [self.baseView.rentBtn setTitle:@"已下架" forState:UIControlStateDisabled];
        }else if(ZYItemStateToSell == self.detail.status){
            //即将上架
            self.baseView.rentBtn.enabled = NO;
            [self.baseView.rentBtn setBackgroundColor:BTN_COLOR_DISABLE forState:UIControlStateDisabled];
            [self.baseView.rentBtn setTitleColor:WORD_COLOR_GRAY_AB forState:UIControlStateDisabled];
            [self.baseView.rentBtn setTitle:@"即将上架" forState:UIControlStateDisabled];
        }
    }else if(self.detail.activityType == 2){
        //秒杀活动
        long long spikeStartRestTime = self.detail.spikeStartRestTime - _timeCount * 1000;
        if(spikeStartRestTime >= kSetSpikeNoticeRestTime){
            if(self.detail.isFocusSpike){
                self.baseView.rentBtn.enabled = YES;
                [self.baseView.rentBtn setTitle:@"取消提醒" forState:UIControlStateNormal];
            }else{
                self.baseView.rentBtn.enabled = YES;
                [self.baseView.rentBtn setTitle:@"设置提醒" forState:UIControlStateNormal];
            }
        }else if(spikeStartRestTime < kSetSpikeNoticeRestTime && spikeStartRestTime > 0){
            self.baseView.rentBtn.enabled = NO;
            [self.baseView.rentBtn setBackgroundColor:BTN_COLOR_DISABLE_GREEN forState:UIControlStateDisabled];
            [self.baseView.rentBtn setTitleColor:UIColor.whiteColor forState:UIControlStateDisabled];
            [self.baseView.rentBtn setTitle:@"即将开抢" forState:UIControlStateDisabled];
        }else{
            self.baseView.rentBtn.enabled = YES;
            [self.baseView.rentBtn setTitle:@"立即抢租" forState:UIControlStateNormal];
        }
    }else{
        //已上架
        [self.baseView.rentBtn setTitle:@"立即租" forState:UIControlStateNormal];
        self.baseView.rentBtn.enabled = YES;
    }
}

#pragma mark - 开始倒计时
- (void)startTimer{
    [self stopTimer];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1
                                              target:self
                                            selector:@selector(timerRun)
                                            userInfo:nil
                                             repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

#pragma mark - 关闭倒计时
- (void)stopTimer{
    if(_timer){
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark - 倒计时
- (void)timerRun{
    self.upVC.timeCount = _timeCount;
    [self setUpRentBtn];
    if(self.detail.spikeEndRestTime - _timeCount * 1000 <= 0){
        [self loadData:NO];
    }
    
    _timeCount++;
}


#pragma mark - 组装sku属性标题
- (void)initSkuTitles{
    NSString *titles = nil;
    if(_selectedSkuPrice){
        for(_m_ItemDetail_SkuAttribute_Sub *skuValue in _selectedSkus){
            if(!titles){
                titles = skuValue.name;
            }else{
                titles = [titles stringByAppendingString:[NSString stringWithFormat:@"/%@",skuValue.name]];
            }
        }
    }
    self.upVC.selectedSkuTitle = titles;
}

#pragma mark - 排列组合库存属性
- (void)combineStorage{
    [self.skuStorages removeAllObjects];
    //将所有sku属性path分解为数组,并将每个数组排列组合（库存不为0，那么该数组中每个排列组合库存都不为0）
    for(_m_ItemDetail_SkuPrice *skuPrice in _detail.skuPriceList){
        if(skuPrice.storage){
            NSArray *paths = [skuPrice.path componentsSeparatedByString:@";"];
            paths = [[paths reverseObjectEnumerator] allObjects];
            for (int i = 0; i < paths.count; i++){
                [self combine:(int)paths.count index:i + 1 paths:paths temp:@""];
            }
        }
    }
}

#pragma mark -表示从n个元素中取出k个元素的取法数
- (void)combine:(int)n index:(int)k paths:(NSArray *)arr temp:(NSString *)str{
    for(int i = n; i >= k; i--){
        if(k > 1){
            if([@"" isEqualToString:str]){
                [self combine:i-1 index:k-1 paths:arr temp:[arr objectAtIndex:i-1]];
            }else{
                [self combine:i-1 index:k-1 paths:arr temp:[NSString stringWithFormat:@"%@;%@",str,[arr objectAtIndex:i-1]]];
            }
        }else{
            if([@"" isEqualToString:str]){
                NSString *ids = [arr objectAtIndex:i-1];
                if(!self.skuStorages[ids]){
                    [self.skuStorages setValue:@"1" forKey:ids];
                }
                
            }else{
                NSString *ids = [NSString stringWithFormat:@"%@;%@",str,[arr objectAtIndex:i-1]];
                if(!self.skuStorages[ids]){
                    [self.skuStorages setValue:@"1" forKey:ids];
                }
            }
        }
    }
}

#pragma mark - 刷新页面
- (void)refresh{
    [self loadData:NO];
    self.selectedSkus = nil;
    self.selectedPeriod = nil;
    self.selectedServices = nil;
    self.selectedSkuPrice = nil;
    [self.skuMenu reset];
    self.upVC.selectedSkuTitle = nil;
}

#pragma mark - 显示详情
- (void)showDetail{
    self.navigationController.navigationBar.hidden = NO;
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.navigationBarAlpha = 1;
                         self.upVC.view.frame = CGRectMake(0,
                                                           -SCREEN_HEIGHT - (ZYItemDetailToolBarHeight + DOWN_DANGER_HEIGHT) + NAVIGATION_BAR_HEIGHT,
                                                           SCREEN_WIDTH,
                                                           SCREEN_HEIGHT - (ZYItemDetailToolBarHeight + DOWN_DANGER_HEIGHT));
                         self.downVC.view.frame = CGRectMake(0,
                                                             NAVIGATION_BAR_HEIGHT,
                                                             SCREEN_WIDTH,
                                                             SCREEN_HEIGHT - (ZYItemDetailToolBarHeight + DOWN_DANGER_HEIGHT) - NAVIGATION_BAR_HEIGHT);
                     } completion:^(BOOL finished) {
                         self.beginTime = [[NSDate date] millisecondSince1970];
                     }];
    
    [self.upVC pause];
}

#pragma mark - 不显示详情
- (void)unshowDetail{
    if(_beginTime > 0){
        [ZYStatisticsService event:@"item_detail" durations:(int)([[NSDate date] millisecondSince1970] - _beginTime)];
        _beginTime = 0;
    }
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.navigationBarAlpha = 0;
                         self.upVC.view.frame = CGRectMake(0,
                                                           0,
                                                           SCREEN_WIDTH,
                                                           SCREEN_HEIGHT - (ZYItemDetailToolBarHeight + DOWN_DANGER_HEIGHT));
                         self.downVC.view.frame = CGRectMake(0,
                                                             SCREEN_HEIGHT - (ZYItemDetailToolBarHeight + DOWN_DANGER_HEIGHT),
                                                             SCREEN_WIDTH,
                                                             SCREEN_HEIGHT - (ZYItemDetailToolBarHeight + DOWN_DANGER_HEIGHT) - NAVIGATION_BAR_HEIGHT);
                     } completion:^(BOOL finished) {
                         self.navigationController.navigationBar.hidden = YES;
                     }];
}

#pragma mark - 下单前风控查询
- (void)checkRisk{
    NSString *serviceIds = nil;
    for(_m_ItemDetail_Service *service in self.selectedServices){
        if(serviceIds){
            serviceIds = [serviceIds stringByAppendingString:[NSString stringWithFormat:@",%@",service.serviceId]];
        }else{
            serviceIds = service.serviceId;
        }
    }
    _p_PreOrderRiskVerify *param = [_p_PreOrderRiskVerify new];
    param.priceId = self.selectedSkuPrice.priceId;
    param.serviceIds = serviceIds;
    [[ZYHttpClient client] post:param
                        showHud:YES
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            if(responseObj.isSuccess){
                                _m_PreOrderRiskVerify *model = [_m_PreOrderRiskVerify mj_objectWithKeyValues:responseObj.data];
                                self.fundAuthNo = model.fundAuthNo;
                                [self dealRisk:model];
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

#pragma mark - 处理风控逻辑
- (void)dealRisk:(_m_PreOrderRiskVerify *)model{
    if(model.abnormalOrderType){
        //有非正常订单
        if(1 == model.abnormalOrderType){
            //有异常订单
            [ZYAlert showWithTitle:nil
                           content:@"你还有异常订单未处理哦，快去处理再来下单吧~"
                      buttonTitles:@[@"去处理"]
                      buttonAction:^(ZYAlert *alert, int index) {
                          [alert dismiss];
                          [[ZYRouter router] goWithoutHead:[NSString stringWithFormat:@"orderDetail?orderId=%@",[model.abnormalOrderId URLEncode]]];
                      }];
        }else if(2 == model.abnormalOrderType){
            //有逾期订单
            [ZYAlert showWithTitle:nil
                           content:@"你还有逾期账单未支付哦，快去支付再来下单吧～"
                      buttonTitles:@[@"去支付"]
                      buttonAction:^(ZYAlert *alert, int index) {
                          [alert dismiss];
                          [[ZYRouter router] goWithoutHead:[NSString stringWithFormat:@"orderDetail?orderId=%@",[model.abnormalOrderId URLEncode]]];
                      }];
        }else if(3 == model.abnormalOrderType){
            //有到期未归还订单
            [ZYAlert showWithTitle:nil
                           content:@"你还有到期未归还的订单哦，快去归还再来下单吧～"
                      buttonTitles:@[@"去支付"]
                      buttonAction:^(ZYAlert *alert, int index) {
                          [alert dismiss];
                          [[ZYRouter router] goWithoutHead:[NSString stringWithFormat:@"orderDetail?orderId=%@",[model.abnormalOrderId URLEncode]]];
                      }];
        }
    }else{
        //没有非正常订单
        if(model.surplusLimit >= model.deposit){
            //用户可用额度大于等于押金
            if(model.isLoanControl){
                //触发贷中风控
                [self loadHuoTiUrl];
            }else{
                //没有触发贷中风控
                [self goPlaceOrder];
            }
        }else{
            //用户可用额度小于押金
            if(model.isOverMaxNum){
                //大于等于最大租赁件数
                if(model.isCredited){
                    //授信过
                    [self goPlaceOrder];
                }else{
                    //没授信过
                    [self.depositAlert show];
                }
            }else{
                //小于最大租赁件数
                [[ZYPaymentService service] pay:ZYPaymentTypeAlipay orderInfo:model.alipayInfo];
                [ZYPaymentService service].currentDelegate = self;
            }
        }
    }
}

#pragma mark - ZYPaymentDelegate
- (void)paymentResult:(ZYPaymentResult)result type:(ZYPaymentType)type{
    if(result == ZYPaymentResultFail){
        [ZYToast showWithTitle:@"授权失败！"];
    }else if(result == ZYPaymentResultSuccess){
        [self goPlaceOrder];
    }
}

#pragma mark - 去下单
- (void)goPlaceOrder{
    ZYOrderConfirmVC *vc = [ZYOrderConfirmVC new];
    vc.fundAuthNo = self.fundAuthNo;
    vc.priceId = self.selectedSkuPrice.priceId;
    vc.itemId = self.itemId;
    NSString *serviceIds = nil;
    for(_m_ItemDetail_Service *service in self.selectedServices){
        if(serviceIds){
            serviceIds = [serviceIds stringByAppendingString:[NSString stringWithFormat:@",%@",service.serviceId]];
        }else{
            serviceIds = service.serviceId;
        }
    }
    vc.serviceIds = serviceIds;
    vc.categoryId = self.detail.categoryId;
    __weak __typeof__(self) weakSelf = self;
    vc.callBack = ^{
        [weakSelf refresh];
    };
    [[ZYRouter router] push:vc];
}

#pragma mark - 查询活体认证地址
- (void)loadHuoTiUrl{
    _p_LivingAuthentication *param = [[_p_LivingAuthentication alloc] init];
    [[ZYHttpClient client] post:param showHud:YES success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
        if (responseObj.success) {
            _m_LivingAuthentication *model = [_m_LivingAuthentication mj_objectWithKeyValues:responseObj.data];
            NSString *gotoString = [NSString stringWithFormat:@"alipays://platformapi/startapp?appId=20000067&url=%@",[model.url URLEncode]];
            if ([ZYAppUtils isInstallAliPay]) {
                [ZYAppUtils openURL:gotoString];
            }
        } else {
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

#pragma mark - 活体认证回调
- (void)huotiCallBack:(NSNotification *)notification{
    if(!self.isVisiable){
        return;
    }
    NSString *resultStr = [notification.userInfo[@"resultStr"] componentsSeparatedByString:@"&"][0];
    NSDictionary *biz_content = [[resultStr componentsSeparatedByString:@"="][1] toDictionary];
    
    NSString *signStr = [notification.userInfo[@"resultStr"] componentsSeparatedByString:@"&"][1];
    NSString *sign = [signStr componentsSeparatedByString:@"="][1];
    
    if (![biz_content[@"passed"] isEqualToString:@"true"]) {
        [ZYToast showWithTitle:biz_content[@"failed_reason"]];
        return;
    }
    
    _p_LivingCallback *param = [[_p_LivingCallback alloc] init];
    param.biz_content = biz_content;
    param.sign = sign;
    [[ZYHttpClient client] post:param showHud:YES success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
        if (responseObj.success) {
            [self goPlaceOrder];
        } else {
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

#pragma mark - 确认订单逻辑
- (void) goConfirm{
    if(!self.selectedSkuPrice){
        self.skuMenu.detail = self.detail;
        self.skuMenu.skuStorages = self.skuStorages;
        [self.skuMenu show];
    }else{
        [[ZYLoginService service] requireLogin:^{
            [self checkRisk];
        }];
    }
}

#pragma mark - getter
- (NSMutableDictionary *)skuStorages{
    if(!_skuStorages){
        _skuStorages = [NSMutableDictionary dictionary];
    }
    return _skuStorages;
}

- (ZYItemDetailView *)baseView{
    if(!_baseView){
        _baseView = [ZYItemDetailView new];
        
        __weak __typeof__(self) weakSelf = self;
        //返回按钮
        [_baseView.backBtn clickAction:^(UIButton * _Nonnull button) {
            [weakSelf systemBackButtonClicked];
        }];
        //立即租按钮
        [_baseView.rentBtn clickAction:^(UIButton * _Nonnull button) {
            [ZYStatisticsService event:@"item_rent"];
            if(weakSelf.detail.activityType == 2){
                //秒杀活动
                long long spikeStartRestTime = weakSelf.detail.spikeStartRestTime - weakSelf.timeCount * 1000;
                if(spikeStartRestTime >= kSetSpikeNoticeRestTime){
                    [[ZYLoginService service] requireLogin:^{
                        [weakSelf focusSpike];
                    }];
                }else{
                    [weakSelf goConfirm];
                }
            }else{
                //已上架
                [weakSelf goConfirm];
            }
        }];
        //客服按钮
        [_baseView.serviceBtn clickAction:^(UIButton * _Nonnull button) {
            [ZYStatisticsService event:@"item_service"];
            weakSelf.serviceMenu.phone = weakSelf.detail.servicePhone;
            [weakSelf.serviceMenu show];
        }];
        //收藏按钮
        [_baseView.collectionBtn clickAction:^(UIButton * _Nonnull button) {
            if(weakSelf.detail.collectionStatus){
                //已收藏
                [[ZYRouter router] goWithoutHead:[NSString stringWithFormat:@"deleteFavorite?itemId=%@",[weakSelf.itemId URLEncode]] withCallBack:^{
                    weakSelf.baseView.collectionIcon.image = [UIImage imageNamed:@"zy_mall_item_detail_collection_normal"];
                    weakSelf.detail.collectionStatus = NO;
                }];
            }else{
                //未收藏
                [[ZYRouter router] goWithoutHead:[NSString stringWithFormat:@"addFavorite?itemId=%@",[weakSelf.itemId URLEncode]] withCallBack:^{
                    weakSelf.baseView.collectionIcon.image = [UIImage imageNamed:@"zy_mall_collection_selected"];
                    weakSelf.detail.collectionStatus = YES;
                }];
            }
        }];
    }
    return _baseView;
}

- (ZYServiceMenu *)serviceMenu{
    if(!_serviceMenu){
        _serviceMenu = [ZYServiceMenu new];
    }
    return _serviceMenu;
}

- (ZYItemDetailUpVC *)upVC{
    if(!_upVC){
        _upVC = [ZYItemDetailUpVC new];
        
        __weak __typeof__(self) weakSelf =self;
        _upVC.scrollBlock = ^{
            [weakSelf showDetail];
        };
        _upVC.skuAction = ^{
            weakSelf.skuMenu.detail = weakSelf.detail;
            weakSelf.skuMenu.skuStorages = weakSelf.skuStorages;
            [weakSelf.skuMenu show];
        };
        [_upVC.tableView addRefreshHeaderWithBlock:^{
            [weakSelf loadData:NO];
        }];
        _upVC.collectionAction = ^{
            [[ZYRouter router] goWithoutHead:[NSString stringWithFormat:@"addFavorite?itemId=%@",[weakSelf.itemId URLEncode]] withCallBack:^{
                weakSelf.baseView.collectionIcon.image = [UIImage imageNamed:@"zy_mall_collection_selected"];
                weakSelf.detail.collectionStatus = YES;
            }];
        };
        _upVC.rentAction = ^{
            if(weakSelf.detail.activityType == 2){
                //秒杀活动
                long long spikeStartRestTime = weakSelf.detail.spikeStartRestTime - weakSelf.timeCount * 1000;
                if(spikeStartRestTime >= kSetSpikeNoticeRestTime){
                    [[ZYLoginService service] requireLogin:^{
                        [weakSelf focusSpike];
                    }];
                }else{
                    [weakSelf goConfirm];
                }
            }else{
                //已上架
                [weakSelf goConfirm];
            }
        };
    }
    return _upVC;
}

- (ZYItemDetailDownVC *)downVC{
    if(!_downVC){
        _downVC = [ZYItemDetailDownVC new];
        
        __weak __typeof__(self) weakSelf =self;
        _downVC.scrollBlock = ^{
            [weakSelf unshowDetail];
        };
    }
    return _downVC;
}

- (ZYItemDetailSkuMenu *)skuMenu{
    if(!_skuMenu){
        _skuMenu = [ZYItemDetailSkuMenu new];
        __weak __typeof__(self) weakSelf = self;
        __weak __typeof__(_skuMenu) menu = _skuMenu;
        _skuMenu.rentAction = ^{
            if(!weakSelf.selectedSkuPrice){
                [ZYToast showWithTitle:@"请选择产品参数"];
                return;
            }
            [menu dismiss:^{
                [weakSelf goConfirm];
            }];
        };
        _skuMenu.selectionAction = ^(NSArray *skus, _m_ItemDetail_SkuAttribute_Sub *period, NSArray *services, _m_ItemDetail_SkuPrice *skuPrice) {
            weakSelf.selectedSkus = skus;
            weakSelf.selectedPeriod = period;
            weakSelf.selectedServices = services;
            weakSelf.selectedSkuPrice = skuPrice;
            
            [weakSelf initSkuTitles];
        };
    }
    return _skuMenu;
}

- (ZYItemDetailDepositAlert *)depositAlert{
    if(!_depositAlert){
        _depositAlert = [ZYItemDetailDepositAlert new];
        
        __weak __typeof__(self) weakSelf = self;
        _depositAlert.applyBlock = ^(BOOL isCancel){
            if(isCancel){
                [weakSelf goPlaceOrder];
            }else{
                [[ZYRouter router] goVC:@"limit" withCallBack:^(NSString *authStatus){
                    weakSelf.detail.authStatus = authStatus;
                    weakSelf.upVC.detail = weakSelf.detail;
                }];
            }
        };
    }
    return _depositAlert;
}

@end
