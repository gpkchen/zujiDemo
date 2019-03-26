//
//  ZYOrderListSubVC.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/28.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYOrderListSubVC.h"
#import "ZYOrderListCell.h"
#import "GetOrderList.h"
#import "CancelOrder.h"
#import "ZYPaymentService.h"
#import "ConfirmRecive.h"
#import "ZYRenewalVC.h"
#import "ZYPayPenaltyVC.h"
#import "ZYReturnMenu.h"
#import "ZYServiceMenu.h"

@interface ZYOrderListSubVC ()<UITableViewDelegate , UITableViewDataSource,ZYPaymentDelegate>

@property (nonatomic , strong) ZYTableView *tableView;
@property (nonatomic , strong) ZYReturnMenu *returnMenu;
@property (nonatomic , strong) ZYServiceMenu *serviceMenu;

@property (nonatomic , strong) NSTimer *timer;
@property (nonatomic , assign) int timeCount;

@property (nonatomic , assign) int page;
@property (nonatomic , strong) NSMutableArray *orders;

@property (nonatomic , strong) _m_GetOrderList *payingOrder; //正在支付的订单

@property (nonatomic , assign) BOOL shouldRefresh; //是否需要刷新列表

@end

@implementation ZYOrderListSubVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initRootView];
    
    _page = 1;
    [self showLoadingView];
    [self loadOrders:NO pageSize:[ZYRequestDefaultPageSize intValue]];
    [self startTimer];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if(_shouldRefresh){
        _shouldRefresh = NO;
        [self loadOrders:NO pageSize:(int)self.orders.count];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if(!_orderState){
        _shouldRefresh = YES;
    }
}

- (void)willMoveToParentViewController:(UIViewController *)parent{
    [super willMoveToParentViewController:parent];
    [self stopTimer];
}

- (void)initRootView{
    self.view = [UIView new];
    self.view.frame = CGRectMake(0,
                                 NAVIGATION_BAR_HEIGHT + 40,
                                 SCREEN_WIDTH,
                                 SCREEN_HEIGHT - (NAVIGATION_BAR_HEIGHT + 40));
    self.view.backgroundColor = VIEW_COLOR;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - 分发按钮事件
- (void)buttonAction:(_m_GetOrderList *)model type:(ZYOrderStateAcionType)type{
    __weak __typeof__(self) weakSelf = self;
    switch (type) {
        case ZYOrderStateAcionTypeCancel:{
            //取消订单
            [self cancelOrder:model];
        }
            break;
        case ZYOrderStateAcionTypeLogistics:{
            //查看物流
            NSString *url = nil;
            if(model.status == ZYOrderStateWaitReceipt){
                url = [[ZYH5Utils formatUrl:ZYH5TypeExpress param:[NSString stringWithFormat:@"%@/%@",model.orderId,@"1"]] URLEncode];
            }else if(model.status == ZYOrderStateMailedBack){
                url = [[ZYH5Utils formatUrl:ZYH5TypeExpress param:[NSString stringWithFormat:@"%@/%@",model.orderId,@"2"]] URLEncode];
            }
            [[ZYRouter router] goWithoutHead:[NSString stringWithFormat:@"web?url=%@",url]];
        }
            break;
        case ZYOrderStateAcionTypeReceipt:{
            //确认收货
            [self confirmReceive:model];
        }
            break;
        case ZYOrderStateAcionTypeRepair:{
            //报修
            [[ZYRouter router] goWithoutHead:[NSString stringWithFormat:@"web?url=%@",
                                              [[ZYH5Utils formatUrl:ZYH5TypeRepair param:nil] URLEncode]]];
        }
            break;
        case ZYOrderStateAcionTypePayOrder:{
            //支付订单
            _payingOrder = model;
            ZYPaymentCommonParam *param = [ZYPaymentCommonParam new];
            param.orderId = model.orderId;
            param.billIds = model.billId;
            param.billPayType = @"1";
            param.target = ZYPaymentTargetBill;
            [[ZYPaymentService service] pay:param];
            [ZYPaymentService service].currentDelegate = self;
        }
            break;
        case ZYOrderStateAcionTypeReturn:{
            //归还
            [self.returnMenu show];
            self.returnMenu.orderId = model.orderId;
        }
            break;
        case ZYOrderStateAcionTypeBuy:{
            //购买
            [ZYStatisticsService event:@"orderlist_buy"];
            [[ZYRouter router] goVC:[NSString stringWithFormat:@"ZYBuyOffVC?orderId=%@",model.orderId] withCallBack:^{
                NSUInteger index = [weakSelf.orders indexOfObject:model];
                [weakSelf.orders removeObject:model];
                [weakSelf.tableView deleteSections:[NSIndexSet indexSetWithIndex:index]
                                  withRowAnimation:UITableViewRowAnimationFade];
            }];
        }
            break;
        case ZYOrderStateAcionTypePayBill:{
            //支付账单
            [[ZYRouter router] goVC:[NSString stringWithFormat:@"ZYBillConfirmVC?orderId=%@&billId=%@",
                                     [model.orderId URLEncode],
                                     [model.billId URLEncode]] withCallBack:^{
                weakSelf.shouldRefresh = YES;
            }];
        }
            break;
        case ZYOrderStateAcionTypeRenewal:{
            //续租
            [ZYStatisticsService event:@"orderlist_renewal"];
            [[ZYRouter router] goVC:[NSString stringWithFormat:@"ZYRenewalVC?orderId=%@",
                                     [model.orderId URLEncode]] withCallBack:^{
                weakSelf.shouldRefresh = YES;
            }];
        }
            break;
        case ZYOrderStateAcionTypePayPenalty:{
            //支付违约金
            [[ZYRouter router] goVC:[NSString stringWithFormat:@"ZYPayPenaltyVC?orderId=%@",
                                     [model.orderId URLEncode]] withCallBack:^{
                weakSelf.shouldRefresh = YES;
            }];
        }
            break;
        case ZYOrderStateAcionTypeService:{
            //联系客服
            weakSelf.serviceMenu.phone = model.servicePhone;
            [weakSelf.serviceMenu show];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 取消订单
- (void)cancelOrder:(_m_GetOrderList *)model{
    [ZYAlert showWithTitle:nil
                    content:@"确定取消订单吗？"
               buttonTitles:@[@"取消",@"确定"]
               buttonAction:^(ZYAlert *alert, int index) {
                   [alert dismiss];
                   if(index == 1){
                       _p_CancelOrder *param = [_p_CancelOrder new];
                       param.orderId = model.orderId;
                       [[ZYHttpClient client] post:param
                                           showHud:YES
                                           success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                                               if(responseObj.isSuccess){
                                                   [ZYToast showWithTitle:@"订单取消成功"];
                                                   [self loadOrders:NO pageSize:(int)self.orders.count];
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
                    }] ;
}

#pragma mark - 确认收货
- (void)confirmReceive:(_m_GetOrderList *)model{
    [ZYAlert showWithTitle:nil
                   content:@"确定已经收到宝贝了吗"
              buttonTitles:@[@"取消",@"确定"]
              buttonAction:^(ZYAlert *alert, int index) {
                  [alert dismiss];
                  if(index == 1){
                      _p_ConfirmRecive *param = [_p_ConfirmRecive new];
                      param.orderId = model.orderId;
                      [[ZYHttpClient client] post:param
                                          showHud:YES
                                          success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                                              if(responseObj.isSuccess){
                                                  [ZYToast showWithTitle:@"确认收货成功"];
                                                  [self loadOrders:NO pageSize:(int)self.orders.count];
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

#pragma mark - 获取订单列表
- (void)loadOrders:(BOOL)showHud pageSize:(int)pageSize{
    _p_GetOrderList *param = [_p_GetOrderList new];
    param.status = _orderState;
    param.page = [NSString stringWithFormat:@"%d",_page];
    param.size = [NSString stringWithFormat:@"%d",pageSize];
    [[ZYHttpClient client] post:param
                        showHud:showHud
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            [self hideLoadingView];
                            [self hideErrorView];
                            [self.tableView.mj_header endRefreshing];
                            [self.tableView.mj_footer endRefreshing];
                            if(responseObj.isSuccess){
                                if(1 == self.page){
                                    [self.orders removeAllObjects];
                                }
                                NSArray *arr = responseObj.data[@"rows"];
                                int totalCount = [responseObj.data[@"totalCount"] intValue];
                                for(NSDictionary *dic in arr){
                                    _m_GetOrderList *model = [[_m_GetOrderList alloc] initWithDictionary:dic];
                                    //待支付的状态需要去除倒计时已经结束的订单
                                    if(model.status == ZYOrderStateWaitPay){
                                        if(model.payExpireTime > 0){
                                            [self.orders addObject:model];
                                        }
                                    }else{
                                        [self.orders addObject:model];
                                    }
                                }
                                if(self.orders.count >= totalCount){
                                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                                }else{
                                    [self.tableView.mj_footer resetNoMoreData];
                                }
                                [self.tableView reloadData];
                                if(!self.orders.count){
                                    [self showNoOrderView:^{
                                        [[ZYRouter router] returnToRoot];
                                        [ZYMainTabVC shareInstance].selectedIndex = 1;
                                    }];
                                }
                                if(pageSize != [ZYRequestDefaultPageSize intValue]){
                                    self.page = pageSize / [ZYRequestDefaultPageSize intValue] + 1;
                                }
                            }else{
                                [ZYToast showWithTitle:responseObj.message];
                            }
                        } failure:^(NSURLSessionDataTask *task, NSError *error) {
                            [self hideLoadingView];
                            [self hideErrorView];
                            [self.tableView.mj_header endRefreshing];
                            [self.tableView.mj_footer endRefreshing];
                            
                            __weak __typeof__(self) weakSelf = self;
                            if(self.orders.count){
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
                                        [weakSelf loadOrders:YES pageSize:[ZYRequestDefaultPageSize intValue]];
                                    }];
                                }else if(error.code == ZYHttpErrorCodeNoNet){
                                    [self showNoNetView:^{
                                        [weakSelf loadOrders:YES pageSize:[ZYRequestDefaultPageSize intValue]];
                                    }];
                                }else if(error.code == ZYHttpErrorCodeSystemError){
                                    [self showSystemErrorView:^{
                                        [weakSelf loadOrders:YES pageSize:[ZYRequestDefaultPageSize intValue]];
                                    }];
                                }
                            }
                        } authFail:^{
                            [self hideLoadingView];
                            [self hideErrorView];
                            [self.tableView.mj_header endRefreshing];
                            [self.tableView.mj_footer endRefreshing];
                        }];
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
    NSArray *cells = self.tableView.visibleCells;
    for(ZYOrderListCell *cell in cells){
        cell.timeCount = _timeCount;
    }
    _timeCount++;
}

#pragma mark - ZYPaymentDelegate
- (void)paymentResult:(ZYPaymentResult)result type:(ZYPaymentType)type{
    if(result == ZYPaymentResultFail){
        [ZYToast showWithTitle:@"支付失败！"];
    }else if(result == ZYPaymentResultSuccess){
        [[ZYPaymentService service] hideCashier];
        if(_payingOrder){
            _payingOrder.status = ZYOrderStateWaitDeliver;
            NSUInteger index = [self.orders indexOfObject:_payingOrder];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    _m_GetOrderList *model = self.orders[indexPath.section];
    if(ZYOrderStateDone == model.status ||
       (ZYOrderStateAbnormal == model.status && !model.isPenalty) ||
       ZYOrderStateCanceled == model.status ||
       (ZYExpressTypeSelfLifting == model.expressType && ZYOrderStateWaitReceipt == model.status)){
        return ZYOrderListCellHeightNoButton;
    }
    return ZYOrderListCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10 * UI_H_SCALE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _m_GetOrderList *model = self.orders[indexPath.section];
    [[ZYRouter router] goWithoutHead:[NSString stringWithFormat:@"orderDetail?orderId=%@",[model.orderId URLEncode]]
                        withCallBack:^(ZYOrderStateAcionType type){
                            
                            if(type == ZYOrderStateAcionTypeReturn){
                                self.shouldRefresh = YES;
                            }else if(type == ZYOrderStateAcionTypeCancel){
                                self.shouldRefresh = YES;
                            }else if(type == ZYOrderStateAcionTypeReceipt){
                                self.shouldRefresh = YES;
                            }else if(type == ZYOrderStateAcionTypePayOrder){
                                self.shouldRefresh = YES;
                            }else if(type == ZYOrderStateAcionTypeBuy){
                                self.shouldRefresh = YES;
                            }else if(type == ZYOrderStateAcionTypePayBill){
                                self.shouldRefresh = YES;
                            }else if(type == ZYOrderStateAcionTypeRenewal){
                                self.shouldRefresh = YES;
                            }else if(type == ZYOrderStateAcionTypePayPenalty){
                                self.shouldRefresh = YES;
                            }else if(type == ZYOrderStateAcionTypeCancelExamine){
                                self.shouldRefresh = YES;
                            }
                        }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ZYOrderListVCCell";
    ZYOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[ZYOrderListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    _m_GetOrderList *model = self.orders[indexPath.section];
    [cell showCellWithModel:model];
    __weak __typeof__(self) weakSelf = self;
    cell.buttonAction = ^(_m_GetOrderList *model, ZYOrderStateAcionType type) {
        [weakSelf buttonAction:model type:type];
    };
    cell.orderCloseBlock = ^(_m_GetOrderList *model) {
        NSUInteger index = [weakSelf.orders indexOfObject:model];
        [weakSelf.orders removeObject:model];
        [weakSelf.tableView deleteSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationFade];
    };
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.orders.count;
}

#pragma mark - getter
- (ZYTableView *)tableView{
    if(!_tableView){
        _tableView = [[ZYTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = VIEW_COLOR;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, DOWN_DANGER_HEIGHT, 0);
        _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, DOWN_DANGER_HEIGHT, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        __weak __typeof__(self) weakSelf = self;
        [_tableView addRefreshHeaderWithBlock:^{
            weakSelf.page = 1;
            [weakSelf loadOrders:NO pageSize:[ZYRequestDefaultPageSize intValue]];
        }];
        [_tableView addRefreshFooterWithBlock:^{
            weakSelf.page++;
            [weakSelf loadOrders:NO pageSize:[ZYRequestDefaultPageSize intValue]];
        }];
    }
    return _tableView;
}

- (ZYReturnMenu *)returnMenu{
    if(!_returnMenu){
        _returnMenu = [ZYReturnMenu new];
        
        __weak __typeof__(self) weakSelf = self;
        _returnMenu.buttonAction = ^{
            weakSelf.shouldRefresh = YES;
        };
    }
    return _returnMenu;
}

- (ZYServiceMenu *)serviceMenu{
    if(!_serviceMenu){
        _serviceMenu = [ZYServiceMenu new];
    }
    return _serviceMenu;
}

- (NSMutableArray *)orders{
    if(!_orders){
        _orders = [NSMutableArray array];
    }
    return _orders;
}

@end
