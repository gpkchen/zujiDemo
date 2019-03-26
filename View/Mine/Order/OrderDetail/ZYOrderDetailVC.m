//
//  ZYOrderDetailVC.m
//  Apollo
//
//  Created by 李明伟 on 2018/5/2.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYOrderDetailVC.h"
#import "ZYOrderDetailView.h"
#import "ZYOrderDetailStateCell.h"
#import "ZYOrderDetailAddressCell.h"
#import "ZYItemCell.h"
#import "ZYDetailCell.h"
#import "ZYOrderDetailInfoCell.h"
#import "GetOrderDetail.h"
#import "CancelOrder.h"
#import "ZYPaymentService.h"
#import "ConfirmRecive.h"
#import "CancelExamine.h"
#import "ZYCancelOrderMenu.h"
#import "ZYReturnMenu.h"
#import "ZYServiceMenu.h"
#import "ZYOrderDetailNoticeView.h"
#import "ZYOrderNoAlert.h"
#import "ZYFormulaView.h"

@interface ZYOrderDetailVC ()<UITableViewDelegate,UITableViewDataSource,ZYPaymentDelegate>

@property (nonatomic , strong) ZYOrderDetailView *baseView;
@property (nonatomic , strong) ZYFormulaView *formulaView;
@property (nonatomic , strong) ZYCancelOrderMenu *cancelMenu;
@property (nonatomic , strong) ZYReturnMenu *returnMenu;
@property (nonatomic , strong) ZYServiceMenu *serviceMenu;
@property (nonatomic , strong) ZYOrderDetailNoticeView *notiveView;
@property (nonatomic , strong) ZYOrderNoAlert *orderNoAlert;

@property (nonatomic , strong) NSTimer *timer;
@property (nonatomic , assign) int timeCount;

@property (nonatomic , strong) _m_GetOrderDetail *detail;

@property (nonatomic , assign) BOOL shouldShowBuyOffBtn;
@property (nonatomic , assign) BOOL shouldRefresh; //是否需要刷新列表

@end

@implementation ZYOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = self.baseView;
    self.title = @"订单详情";
    self.rightBarItems = @[self.baseView.billBtn];
    
    if(!_orderId){
        _orderId = self.dicParam[@"orderId"];
    }
    
    [self showLoadingView];
    [self loadDetail:NO];
    [self startTimer];
}

- (void)systemBackButtonClicked{
    [self stopTimer];
    [super systemBackButtonClicked];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if(_shouldRefresh){
        _shouldRefresh = NO;
        [self loadDetail:NO];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.notiveView show];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.notiveView dismiss];
}

- (void)rightBarItemsAction:(int)index{
    [[ZYRouter router] goWithoutHead:[NSString stringWithFormat:@"billDetail?orderId=%@",[_orderId URLEncode]]];
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
    ZYOrderDetailStateCell *cell = [self.baseView.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.timeCount = _timeCount;
    _timeCount++;
}

#pragma mark - 加载订单详情信息
- (void)loadDetail:(BOOL)showHud{
    _p_GetOrderDetail *param = [_p_GetOrderDetail new];
    param.orderId = _orderId;
    [[ZYHttpClient client] post:param
                        showHud:showHud
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            [self hideLoadingView];
                            [self hideErrorView];
                            if(responseObj.isSuccess){
                                self.detail = [[_m_GetOrderDetail alloc] initWithDictionary:responseObj.data];
                                self.detail.localTotalPrice = [self totalPrice:self.detail];
                                self.baseView.detail = self.detail;
                                [self.baseView.tableView reloadData];
                                
                                if(self.detail.isBuyOutBO){
                                    CGRect frame = [self.baseView.tableView rectForSection:5];
                                    CGFloat limit = NAVIGATION_BAR_HEIGHT + frame.origin.y - self.baseView.tableView.contentOffset.y + 47 * UI_H_SCALE;
                                    CGFloat maxY = SCREEN_HEIGHT - DOWN_DANGER_HEIGHT;
                                    if(limit > maxY){
                                        self.shouldShowBuyOffBtn = YES;
                                        self.baseView.buyOffInfoBtn.hidden = NO;
                                    }else{
                                        self.shouldShowBuyOffBtn = NO;
                                        self.baseView.buyOffInfoBtn.hidden = YES;
                                    }
                                }else{
                                    self.shouldShowBuyOffBtn = NO;
                                }
                            }else{
                                [ZYToast showWithTitle:responseObj.message];
                            }
                        } failure:^(NSURLSessionDataTask *task, NSError *error) {
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
                                        [weakSelf loadDetail:YES];
                                    }];
                                }else if(error.code == ZYHttpErrorCodeNoNet){
                                    [self showNoNetView:^{
                                        [weakSelf loadDetail:YES];
                                    }];
                                }else if(error.code == ZYHttpErrorCodeSystemError){
                                    [self showSystemErrorView:^{
                                        [weakSelf loadDetail:YES];
                                    }];
                                }
                            }
                        } authFail:^{
                            [self hideLoadingView];
                            [self hideErrorView];
                        }];
}

#pragma mark - 分发按钮事件
- (void)buttonActionWithType:(ZYOrderStateAcionType)type{
    __weak __typeof__(self) weakSelf = self;
    switch (type) {
        case ZYOrderStateAcionTypeCancel:{
            //取消订单
            [self cancelOrder];
        }
            break;
        case ZYOrderStateAcionTypeLogistics:{
            //查看物流
            NSString *url = nil;
            if(_detail.status == ZYOrderStateWaitReceipt){
                url = [[ZYH5Utils formatUrl:ZYH5TypeExpress param:[NSString stringWithFormat:@"%@/%@",_detail.orderId,@"1"]] URLEncode];
            }else if(_detail.status == ZYOrderStateMailedBack){
                url = [[ZYH5Utils formatUrl:ZYH5TypeExpress param:[NSString stringWithFormat:@"%@/%@",_detail.orderId,@"2"]] URLEncode];
            }
            [[ZYRouter router] goWithoutHead:[NSString stringWithFormat:@"web?url=%@",url]];
        }
            break;
        case ZYOrderStateAcionTypeReceipt:{
            //确认收货
            [self confirmReceive];
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
            ZYPaymentCommonParam *param = [ZYPaymentCommonParam new];
            param.orderId = _detail.orderId;
            param.billIds = _detail.billId;
            param.billPayType = @"1";
            param.target = ZYPaymentTargetBill;
            [[ZYPaymentService service] pay:param];
            [ZYPaymentService service].currentDelegate = self;
        }
            break;
        case ZYOrderStateAcionTypeReturn:{
            //归还
            self.returnMenu.orderId = _orderId;
            [self.returnMenu show];
            void (^callBack)(ZYOrderStateAcionType type) = self.callBack;
            !callBack ? : callBack(ZYOrderStateAcionTypeReturn);
        }
            break;
        case ZYOrderStateAcionTypeBuy:{
            //购买
            [[ZYRouter router] goVC:[NSString stringWithFormat:@"ZYBuyOffVC?orderId=%@",_orderId] withCallBack:^{
                [weakSelf loadDetail:NO];
                
                void (^callBack)(ZYOrderStateAcionType type) = weakSelf.callBack;
                !callBack ? : callBack(ZYOrderStateAcionTypeBuy);
            }];
        }
            break;
        case ZYOrderStateAcionTypePayBill:{
            //支付账单
            [[ZYRouter router] goVC:[NSString stringWithFormat:@"ZYBillConfirmVC?orderId=%@&billId=%@",
                                     [_detail.orderId URLEncode],
                                     [_detail.billId URLEncode]] withCallBack:^{
                weakSelf.shouldRefresh = YES;
                
                void (^callBack)(ZYOrderStateAcionType type) = weakSelf.callBack;
                !callBack ? : callBack(ZYOrderStateAcionTypePayBill);
            }];
            
        }
            break;
        case ZYOrderStateAcionTypeRenewal:{
            //续租
            [[ZYRouter router] goVC:[NSString stringWithFormat:@"ZYRenewalVC?orderId=%@",
                                     [_detail.orderId URLEncode]] withCallBack:^{
                weakSelf.shouldRefresh = YES;
                
                void (^callBack)(ZYOrderStateAcionType type) = weakSelf.callBack;
                !callBack ? : callBack(ZYOrderStateAcionTypeRenewal);
            }];
        }
            break;
        case ZYOrderStateAcionTypePayPenalty:{
            //支付违约金
            [[ZYRouter router] goVC:[NSString stringWithFormat:@"ZYPayPenaltyVC?orderId=%@",
                                     [_detail.orderId URLEncode]] withCallBack:^{
                weakSelf.shouldRefresh = YES;
                
                void (^callBack)(ZYOrderStateAcionType type) = weakSelf.callBack;
                !callBack ? : callBack(ZYOrderStateAcionTypePayPenalty);
            }];
        }
            break;
        case ZYOrderStateAcionTypeService:{
            //联系客服
            weakSelf.serviceMenu.phone = weakSelf.detail.servicePhone;
            [weakSelf.serviceMenu show];
        }
            break;
        case ZYOrderStateAcionTypeCancelExamine:{
            //待发货取消订单
            [weakSelf.cancelMenu show];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 待发货取消订单
- (void)cancelExamine:(NSString *)reason{
    _p_CancelExamine *param = [_p_CancelExamine new];
    param.orderId = self.detail.orderId;
    param.cancelReason = reason;
    [[ZYHttpClient client] post:param
                        showHud:YES
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            if(responseObj.isSuccess){
                                [[ZYRouter router] goVC:@"ZYCancelExamineVC"];
                                self.shouldRefresh = YES;
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

#pragma mark - 取消订单
- (void)cancelOrder{
    __weak __typeof__(self) weakSelf = self;
    [ZYAlert showWithTitle:nil
                   content:@"确定取消订单吗？"
              buttonTitles:@[@"取消",@"确定"]
              buttonAction:^(ZYAlert *alert, int index) {
                  [alert dismiss];
                  if(index == 1){
                      _p_CancelOrder *param = [_p_CancelOrder new];
                      param.orderId = self.detail.orderId;
                      [[ZYHttpClient client] post:param
                                          showHud:YES
                                          success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                                              if(responseObj.isSuccess){
                                                  [ZYToast showWithTitle:@"订单取消成功"];
                                                  [weakSelf loadDetail:YES];
                                                  
                                                  void (^callBack)(ZYOrderStateAcionType type) = self.callBack;
                                                  !callBack ? : callBack(ZYOrderStateAcionTypeCancel);
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

#pragma mark - 确认收货
- (void)confirmReceive{
    __weak __typeof__(self) weakSelf = self;
    [ZYAlert showWithTitle:nil
                   content:@"确定已经收到宝贝了吗"
              buttonTitles:@[@"取消",@"确定"]
              buttonAction:^(ZYAlert *alert, int index) {
                  [alert dismiss];
                  if(index == 1){
                      _p_ConfirmRecive *param = [_p_ConfirmRecive new];
                      param.orderId = weakSelf.detail.orderId;
                      [[ZYHttpClient client] post:param
                                          showHud:YES
                                          success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                                              if(responseObj.isSuccess){
                                                  [ZYToast showWithTitle:@"确认收货成功"];
                                                  [weakSelf loadDetail:YES];
                                                  
                                                  void (^callBack)(ZYOrderStateAcionType type) = self.callBack;
                                                  !callBack ? : callBack(ZYOrderStateAcionTypeReceipt);
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

#pragma mark - 计算总价格
- (double)totalPrice:(_m_GetOrderDetail *)detail{
    double price = detail.needPayDeposit;
    if(detail.rentType == ZYRentTypeLong){
        price += detail.monthPay;
    }else{
        price += detail.monthPay * detail.periods;
    }
    for(NSDictionary *dic in detail.addedList){
        price += [dic[@"serivcePrice"] doubleValue];
    }
    price = price - detail.couponPrice - detail.activityAmount;
    if(price < 0){
        price = 0;
    }
    return price;
}

#pragma mark - ZYPaymentDelegate
- (void)paymentResult:(ZYPaymentResult)result type:(ZYPaymentType)type{
    if(result == ZYPaymentResultFail){
        [ZYToast showWithTitle:@"支付失败！"];
    }else if(result == ZYPaymentResultSuccess){
        [[ZYPaymentService service] hideCashier];
        [self loadDetail:YES];
        
        void (^callBack)(ZYOrderStateAcionType type) = self.callBack;
        !callBack ? : callBack(ZYOrderStateAcionTypePayOrder);
    }
}

#pragma mark - UITableViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(self.shouldShowBuyOffBtn){
        CGRect frame = [self.baseView.tableView rectForSection:5];
        CGFloat limit = NAVIGATION_BAR_HEIGHT + frame.origin.y - self.baseView.tableView.contentOffset.y + 47 * UI_H_SCALE;
        CGFloat maxY = SCREEN_HEIGHT - DOWN_DANGER_HEIGHT;
        if(limit <= maxY){
            self.baseView.buyOffInfoBtn.hidden = YES;
        }else{
            self.baseView.buyOffInfoBtn.hidden = NO;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(0 == indexPath.section){
        return ZYOrderDetailStateCellHeight;
    }
    if(1 == indexPath.section){
        return ZYOrderDetailAddressCellHeight;
    }
    if(2 == indexPath.section){
        return ZYItemCellHeight;
    }
    if(3 == indexPath.section || 4 == indexPath.section){
        return ZYDetailCellHeight;
    }
    if((5 == indexPath.section || 6 == indexPath.section || 7 == indexPath.section || 8 == indexPath.section) && self.detail.isBuyOutBO){
        return ZYDetailCellHeight;
    }
    if (_detail.status == ZYOrderStateDone || _detail.status == ZYOrderStateUsing || _detail.status == ZYOrderStateMailedBack || _detail.status == ZYOrderStateAbnormal) {
        return ZYOrderDetailInfoCellHeight_returnData;
    } else {
        return ZYOrderDetailInfoCellHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(0 == section){
        return 0.01;
    }
    if(self.detail.isBuyOutBO){
        if(5 == section){
            return 47 * UI_H_SCALE;
        }
        if(6 == section){
            return 0.01;
        }
        if(7 == section){
            return 0.01;
        }
        if(8 == section){
            return 0.01;
        }
        return 10 * UI_H_SCALE;
    }
    return 10 * UI_H_SCALE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(self.detail.isBuyOutBO){
        if(9 == section){
            return 10 * UI_H_SCALE;
        }
    }else{
        if(5 == section){
            return 10 * UI_H_SCALE;
        }
    }
    return 0.01;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(5 == section && self.detail.isBuyOutBO){
        UIView *header = [UIView new];
        header.backgroundColor = VIEW_COLOR;
        UILabel *lab = [UILabel new];
        lab.textColor = HexRGB(0x4a4a4a);
        lab.text = @"已买断详情";
        lab.font = SEMIBOLD_FONT(18);
        [header addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(header).mas_offset(15 * UI_H_SCALE);
            make.centerY.equalTo(header.mas_top).mas_offset(28.5 * UI_H_SCALE);
        }];
        return header;
    }
    return [UIView new];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(2 == indexPath.section && 0 == indexPath.row){
        if(_detail.itemId){
            [[ZYRouter router] goVC:[NSString stringWithFormat:@"ZYItemDetailVC?itemId=%@",[_detail.itemId URLEncode]]];
        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(0 == section){
        return 1;
    }
    if(1 == section){
        return 1;
    }
    if(2 == section){
        return 1;
    }
    if(3 == section){
        return 3;
    }
    if(4 == section){
        if(_detail.isHaveActivity){
            return 5 + _detail.addedList.count;
        }
        return 4 + _detail.addedList.count;
    }
    if(self.detail.isBuyOutBO){
        if(5 == section){
            return 4;
        }
        if(6 == section && self.detail.penaltyAmountBO){
            return 1;
        }
        if(7 == section && self.detail.isHaveActivityBO){
            return 1;
        }
        if(8 == section){
            return 3;
        }
        if(9 == section){
            return 1;
        }
        return 0;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak __typeof__(self) weakSelf = self;
    if(0 == indexPath.section){
        static NSString *identifier = @"ZYOrderDetailVCStateCell";
        ZYOrderDetailStateCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell){
            cell = [[ZYOrderDetailStateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell showCellWithModel:_detail];
        cell.orderCloseBlock = ^(_m_GetOrderDetail *model) {
            weakSelf.detail.status = ZYOrderStateCanceled;
            [weakSelf.baseView.tableView reloadData];
        };
        return cell;
    }
    if(1 == indexPath.section){
        static NSString *identifier = @"ZYOrderDetailVCAddressCell";
        ZYOrderDetailAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell){
            cell = [[ZYOrderDetailAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell showCellWithModel:_detail];
        return cell;
    }
    if(2 == indexPath.section){
        static NSString *identifier = @"ZYOrderDetailVCItemCell";
        ZYItemCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell){
            cell = [[ZYItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        NSString *url = [_detail.imageUrl imageStyleUrl:CGSizeMake((ZYItemCellHeight - 30 * UI_H_SCALE) * 2, (ZYItemCellHeight - 30 * UI_H_SCALE) * 2)];
        [cell.itemIV loadImage:url];
        cell.titleLab.text = _detail.title;
        cell.skuLab.text = [NSString stringWithFormat:@"规格:%@",_detail.goodsSkuNames];
        cell.priceLab.text = [NSString stringWithFormat:@"￥%@",_detail.rentPrice];
        return cell;
    }
    if(3 == indexPath.section || 4 == indexPath.section){
        static NSString *identifier = @"ZYOrderDetailVCDetailCell";
        ZYDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell){
            cell = [[ZYDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.separator.hidden = indexPath.row == 0;
        if(indexPath.section == 3 && indexPath.row == 0){
            //押金
            cell.titleLab.text = @"押金";
            cell.contentLab.text = [NSString stringWithFormat:@"￥%.2f",_detail.deposit];
            cell.contentLab.textColor = WORD_COLOR_BLACK;
        }else if(indexPath.section == 3 && indexPath.row == 1){
            //减免押金
            cell.titleLab.text = @"减免押金";
            cell.contentLab.text = [NSString stringWithFormat:@"-￥%.2f",_detail.orderLimit];
            cell.contentLab.textColor = WORD_COLOR_ORANGE;
        }else if(indexPath.section == 3 && indexPath.row == 2){
            //押金总额
            cell.titleLab.text = @"";
            cell.contentLab.textColor = WORD_COLOR_ORANGE;
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"押金：￥%.2f",_detail.needPayDeposit]];
            [str addAttribute:NSForegroundColorAttributeName value:WORD_COLOR_BLACK range:NSMakeRange(0, 3)];
            cell.contentLab.attributedText = str;
        }else if(indexPath.section == 4 && indexPath.row == 0){
            //月租金
            if(_detail.rentType == ZYRentTypeLong){
                cell.titleLab.text = @"月租金";
            }else{
                cell.titleLab.text = @"日租金";
            }
            cell.contentLab.text = [NSString stringWithFormat:@"￥%.2f",_detail.monthPay];
            cell.contentLab.textColor = WORD_COLOR_BLACK;
        }else if(indexPath.section == 4 && indexPath.row == 1){
            //租期
            cell.titleLab.text = @"租期";
            cell.contentLab.text = _detail.rentPeriod;
            cell.contentLab.textColor = WORD_COLOR_BLACK;
        }else if(indexPath.section == 4 && indexPath.row >= 2 && indexPath.row < 2 + _detail.addedList.count){
            //增值服务
            NSDictionary *service = _detail.addedList[indexPath.row - 2];
            cell.titleLab.text = [NSString stringWithFormat:@"%@（只需首期支付）",service[@"serivceName"]];
            cell.contentLab.text = [NSString stringWithFormat:@"￥%.2f",[service[@"serivcePrice"] doubleValue]];
            cell.contentLab.textColor = WORD_COLOR_BLACK;
        }else if(indexPath.section == 4 && ((indexPath.row == 2 + _detail.addedList.count && _detail.isHaveActivity) || (indexPath.row == 1 + _detail.addedList.count && !_detail.isHaveActivity))){
            //活动优惠
            if(!_detail.isSuperimposed){
                NSMutableAttributedString *attTitle = [[NSMutableAttributedString alloc] initWithString:@"活动优惠（本活动不可叠加优惠券）"];
                [attTitle addAttribute:NSForegroundColorAttributeName value:WORD_COLOR_GRAY_9B range:NSMakeRange(4, attTitle.length - 4)];
                cell.titleLab.attributedText = attTitle;
            }else{
                cell.titleLab.text = @"活动优惠";
            }
            cell.contentLab.text = [NSString stringWithFormat:@"-￥%.2f",_detail.activityAmount];
            cell.contentLab.textColor = WORD_COLOR_BLACK;
        }else if(indexPath.section == 4 && ((indexPath.row == 3 + _detail.addedList.count && _detail.isHaveActivity) || (indexPath.row == 2 + _detail.addedList.count && !_detail.isHaveActivity))){
            //优惠券
            cell.titleLab.text = @"优惠券";
            cell.contentLab.text = [NSString stringWithFormat:@"-￥%.2f",_detail.couponPrice];
            cell.contentLab.textColor = WORD_COLOR_ORANGE;
        }else if(indexPath.section == 4 && ((indexPath.row == 4 + _detail.addedList.count && _detail.isHaveActivity) || (indexPath.row == 3 + _detail.addedList.count && !_detail.isHaveActivity))){
            //首月租金
            cell.titleLab.text = @"";
            cell.contentLab.textColor = WORD_COLOR_ORANGE;
            double rent = _detail.monthPay;
            if(_detail.rentType == ZYRentTypeShort){
                rent = _detail.monthPay * _detail.periods;
            }
            for(NSDictionary *service in _detail.addedList){
                rent += [service[@"serivcePrice"] doubleValue];
            }
            if(_detail.couponPrice){
                rent = rent - _detail.couponPrice;
                if(rent < 0){
                    rent = 0;
                }
            }
            if(_detail.activityAmount){
                rent = rent - _detail.activityAmount;
                if(rent < 0){
                    rent = 0;
                }
            }
            if(_detail.rentType == ZYRentTypeLong){
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"首月租金：￥%.2f",rent]];
                [str addAttribute:NSForegroundColorAttributeName value:WORD_COLOR_BLACK range:NSMakeRange(0, 5)];
                cell.contentLab.attributedText = str;
            }else{
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"总租金：￥%.2f",rent]];
                [str addAttribute:NSForegroundColorAttributeName value:WORD_COLOR_BLACK range:NSMakeRange(0, 4)];
                cell.contentLab.attributedText = str;
            }
        }
        return cell;
    }
    if((5 == indexPath.section || 6 == indexPath.section || 7 == indexPath.section || 8 == indexPath.section) && self.detail.isBuyOutBO){
        static NSString *identifier = @"ZYOrderDetailVCBuyOffInfoCell";
        ZYDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell){
            cell = [[ZYDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.separator.hidden = indexPath.row == 0;
        if(5 == indexPath.section && indexPath.row == 0){
            cell.titleLab.text = @"商品价值";
            cell.contentLab.text = [NSString stringWithFormat:@"¥%.2f",self.detail.goodsValueBO];
            cell.contentLab.textColor = WORD_COLOR_BLACK;
        }else if(5 == indexPath.section && indexPath.row == 1){
            cell.titleLab.text = @"溢价系数";
            cell.contentLab.text = self.detail.premiumCoefficientBO;
            cell.contentLab.textColor = WORD_COLOR_ORANGE;
        }else if(5 == indexPath.section && indexPath.row == 2){
            cell.titleLab.text = @"已支付租金";
            cell.contentLab.text = [NSString stringWithFormat:@"¥%.2f",self.detail.hasPayBO];
            cell.contentLab.textColor = WORD_COLOR_BLACK;
        }else if(5 == indexPath.section && indexPath.row == 3){
            cell.titleLab.text = @"已支付押金";
            cell.contentLab.text = [NSString stringWithFormat:@"¥%.2f",self.detail.hasDepositBO];
            cell.contentLab.textColor = WORD_COLOR_BLACK;
        }else if(6 == indexPath.section && indexPath.row == 0){
            cell.separator.hidden = NO;
            cell.titleLab.text = @"违约金";
            cell.contentLab.text = [NSString stringWithFormat:@"¥%.2f",self.detail.penaltyAmountBO];
            cell.contentLab.textColor = WORD_COLOR_BLACK;
        }else if(7 == indexPath.section && indexPath.row == 0){
            cell.separator.hidden = NO;
            if(self.detail.isSuperimposedBO){
                cell.titleLab.text = @"活动优惠";
            }else{
                NSMutableAttributedString *attTitle = [[NSMutableAttributedString alloc] initWithString:@"活动优惠(本活动不可叠加优惠券)"];
                [attTitle addAttribute:NSForegroundColorAttributeName value:WORD_COLOR_GRAY_9B range:NSMakeRange(4, attTitle.length - 4)];
                cell.titleLab.attributedText = attTitle;
            }
            cell.contentLab.text = [NSString stringWithFormat:@"¥%.2f",self.detail.activityDiscountBO];
            cell.contentLab.textColor = WORD_COLOR_BLACK;
        }else if(8 == indexPath.section && indexPath.row == 0){
            cell.separator.hidden = NO;
            cell.titleLab.text = @"优惠券";
            cell.contentLab.text = [NSString stringWithFormat:@"-¥%.2f",self.detail.couponBO];
            cell.contentLab.textColor = WORD_COLOR_BLACK;
        }else if(8 == indexPath.section && indexPath.row == 1){
            cell.titleLab.text = @"应付总额";
            cell.contentLab.text = [NSString stringWithFormat:@"¥%.2f",self.detail.shouldPayAmountBO];
            cell.contentLab.textColor = WORD_COLOR_ORANGE;
            
            [cell.contentView addSubview:self.baseView.helpBtn];
            [self.baseView.helpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.titleLab.mas_right).mas_offset(10 * UI_H_SCALE);
                make.centerY.equalTo(cell.contentView);
            }];
            
        }else if(8 == indexPath.section && indexPath.row == 2){
            if(self.detail.hasPayAmountBO >= 0){
                cell.titleLab.text = @"优惠后已支付";
                cell.contentLab.text = [NSString stringWithFormat:@"¥%.2f",self.detail.hasPayAmountBO];
            }else{
                cell.titleLab.text = @"已退还";
                cell.contentLab.text = [NSString stringWithFormat:@"¥%.2f",-self.detail.hasPayAmountBO];
            }
            
            cell.contentLab.textColor = WORD_COLOR_ORANGE;
        }
        return cell;
    }
    static NSString *identifier = @"ZYOrderDetailVCInfoCell";
    ZYOrderDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[ZYOrderDetailInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell showCellWithModel:_detail];
    [cell.cpBtn clickAction:^(UIButton * _Nonnull button) {
        UIPasteboard *pab = [UIPasteboard generalPasteboard];
        [pab setString:weakSelf.orderId];
//        [ZYToast showWithTitle:@"订单编号复制成功"];
        [weakSelf.orderNoAlert show];
    }];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(self.detail.isBuyOutBO){
        return 10;
    }
    return 6;
}

#pragma mark - getter
- (ZYOrderDetailView *)baseView{
    if(!_baseView){
        _baseView = [ZYOrderDetailView new];
        _baseView.tableView.delegate = self;
        _baseView.tableView.dataSource = self;
        
        __weak __typeof__(self) weakSelf = self;
        __weak __typeof__(_baseView) weakBaseView = _baseView;
        _baseView.buttonAction = ^(ZYOrderStateAcionType type) {
            [weakSelf buttonActionWithType:type];
        };
        [_baseView.buyOffInfoBtn clickAction:^(UIButton * _Nonnull button) {
            [weakBaseView.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:5]
                                          atScrollPosition:UITableViewScrollPositionTop
                                                  animated:YES];
        }];
        
        [_baseView.helpBtn clickAction:^(UIButton * _Nonnull button) {
            if(weakSelf.detail.penaltyAmountBO){
                weakSelf.formulaView.formula = @"应付总额=商品价值*溢价系数+违约金-已支付租金-已支付押金，已支付租金足够抵扣买断金额时不予叠加优惠";
            }else{
                weakSelf.formulaView.formula = @"应付总额=商品价值*溢价系数-已支付租金-已支付押金，已支付租金足够抵扣买断金额时不予叠加优惠";
            }
            CGRect frame = [weakBaseView convertRect:weakBaseView.helpBtn.frame fromView:weakBaseView.helpBtn.superview];
            [weakSelf.formulaView showAtPoint:CGPointMake(CGRectGetMidX(frame),
                                                          CGRectGetMaxY(frame) + 4)];
        }];
    }
    return _baseView;
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

- (ZYCancelOrderMenu *)cancelMenu{
    if(!_cancelMenu){
        _cancelMenu = [ZYCancelOrderMenu new];
        
        __weak __typeof__(self) weakSelf = self;
        _cancelMenu.confirmBlock = ^(NSString *reason) {
            [weakSelf cancelExamine:reason];
        };
    }
    return _cancelMenu;
}

- (ZYServiceMenu *)serviceMenu{
    if(!_serviceMenu){
        _serviceMenu = [ZYServiceMenu new];
    }
    return _serviceMenu;
}

- (ZYOrderDetailNoticeView *)notiveView{
    if(!_notiveView){
        _notiveView = [ZYOrderDetailNoticeView new];
    }
    return _notiveView;
}

- (ZYOrderNoAlert *)orderNoAlert{
    if(!_orderNoAlert){
        _orderNoAlert = [ZYOrderNoAlert new];
    }
    return _orderNoAlert;
}

- (ZYFormulaView *)formulaView{
    if(!_formulaView){
        _formulaView = [ZYFormulaView new];
    }
    return _formulaView;
}

@end
