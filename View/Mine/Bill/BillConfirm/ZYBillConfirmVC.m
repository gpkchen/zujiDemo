//
//  ZYBillConfirmVC.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/28.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBillConfirmVC.h"
#import "ZYBillConfirmView.h"
#import "ZYBillConfirmItemCell.h"
#import "ZYDetailCell.h"
#import "ListUserCoupon.h"
#import "GetPayBillInfo.h"
#import "ZYPaymentService.h"
#import "GetCouponList.h"
#import "GetCouponAmount.h"

@interface ZYBillConfirmVC ()<UITableViewDelegate,UITableViewDataSource,ZYPaymentDelegate>

@property (nonatomic , strong) ZYBillConfirmView *baseView;

@property (nonatomic , strong) _m_GetPayBillInfo *info;

@property (nonatomic , assign) int couponCount; //可用优惠券数量
@property (nonatomic , strong) _m_ListUserCoupon *selectedCoupon; //选中的优惠券

@end

@implementation ZYBillConfirmVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = self.baseView;
    self.title = @"确认支付";
    
    if(!_orderId){
        _orderId = self.dicParam[@"orderId"];
    }
    if(!_billId){
        _billId = self.dicParam[@"billId"];
    }
    
    [self showLoadingView];
    [self loadInfo:NO];
}

#pragma mark - 加载付款信息
- (void)loadInfo:(BOOL)showHud{
    _p_GetPayBillInfo *param = [_p_GetPayBillInfo new];
    param.orderId = _orderId;
    param.billIds = _billId;
    if(_billId){
        param.payBillType = @"1";
    }else{
        param.payBillType = @"2";
    }
    [[ZYHttpClient client] post:param
                        showHud:showHud
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            [self hideLoadingView];
                            [self hideErrorView];
                            if(responseObj.isSuccess){
                                self.info = [_m_GetPayBillInfo mj_objectWithKeyValues:responseObj.data];
                                
                                [self countTotalPrice];
                                
                                [self.baseView.tableView reloadData];
                                [self loadCouponCount];
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

#pragma mark - 加载可用优惠券数量
- (void)loadCouponCount{
    _p_GetCouponList *param = [_p_GetCouponList new];
    param.scene = @"1";
    param.billIds = _info.billIds;
    if(_billId){
        param.billPayType = @"1";
    }else{
        param.billPayType = @"2";
    }
    param.orderId = _orderId;
    param.page = @"1";
    param.size = @"1";
    [[ZYHttpClient client] post:param
                        showHud:NO
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            if(responseObj.isSuccess){
                                self.couponCount = [responseObj.data[@"totalCount"] intValue];
                                [self.baseView.tableView reloadData];
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

#pragma mark - 计算总金额
- (void)countTotalPrice{
    if(_selectedCoupon){
        _p_GetCouponAmount *param = [_p_GetCouponAmount new];
        param.scene = @"1";
        param.billIds = self.info.billIds;
        if(_billId){
            param.billPayType = @"1";
        }else{
            param.billPayType = @"2";
        }
        param.orderId = _orderId;
        param.couponId = _selectedCoupon.couponId;
        [[ZYHttpClient client] post:param
                            showHud:YES
                            success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                                if(responseObj.isSuccess){
                                    _m_GetCouponAmount *model = [_m_GetCouponAmount mj_objectWithKeyValues:responseObj.data];
                                    self.selectedCoupon.countDiscount = model.amount;
                                    double price = self.info.payAllAmount;
                                    if(self.selectedCoupon.countDiscount >= price){
                                        price = 0;
                                    }else{
                                        price = price - self.selectedCoupon.countDiscount;
                                    }
                                    [self.baseView.tableView reloadData];
                                    self.baseView.payBar.price = price;
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
    }else{
        [self.baseView.tableView reloadData];
        self.baseView.payBar.price = self.info.payAllAmount;
    }
}

#pragma mark - ZYPaymentDelegate
- (void)paymentResult:(ZYPaymentResult)result type:(ZYPaymentType)type{
    if(result == ZYPaymentResultFail){
        [ZYToast showWithTitle:@"支付失败！"];
    }else if(result == ZYPaymentResultSuccess){
        [[ZYPaymentService service] hideCashier];
        void (^block)(void) = self.callBack;
        !block ? : block();
        [self.navigationController popViewControllerAnimated:YES];
    }else if(result == ZYPaymentResultCancel){
        
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(0 == indexPath.section){
        return ZYBillConfirmItemCellHeight;
    }
    return ZYDetailCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(0 == section){
        return 0.01;
    }
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
    
    __weak __typeof__(self) weakSelf = self;
    if(_info.overdueAmount){
        if(1 == indexPath.section && 3 == indexPath.row){
            [[ZYRouter router] goVC:[NSString stringWithFormat:@"ZYPenaltyVC?orderId=%@&billIds=%@&payBillType=%@",
                                     [_orderId URLEncode],
                                     [_info.billIds URLEncode],
                                     _billId ? @"1" : @"2"]];
        }else if(1 == indexPath.section && 5 == indexPath.row){
            [[ZYRouter router] goVC:[NSString stringWithFormat:@"ZYCouponChoiseVC?selectedCouponId=%@&scene=%@&billIds=%@&billPayType=%@&orderId=%@",
                                     [weakSelf.selectedCoupon.couponId URLEncode],
                                     @"1",
                                     [weakSelf.info.billIds URLEncode],
                                     weakSelf.billId ? @"1" : @"2",
                                     [weakSelf.orderId URLEncode]]
                       withCallBack:^(_m_ListUserCoupon *model){
                           weakSelf.selectedCoupon = model;
                           //计算总价格
                           [weakSelf countTotalPrice];
                       }];
        }
    }else{
        if(1 == indexPath.section && 4 == indexPath.row){
            [[ZYRouter router] goVC:[NSString stringWithFormat:@"ZYCouponChoiseVC?selectedCouponId=%@&scene=%@&billIds=%@&billPayType=%@&orderId=%@",
                                     [weakSelf.selectedCoupon.couponId URLEncode],
                                     @"1",
                                     [weakSelf.info.billIds URLEncode],
                                     weakSelf.billId ? @"1" : @"2",
                                     [weakSelf.orderId URLEncode]]
                       withCallBack:^(_m_ListUserCoupon *model){
                           weakSelf.selectedCoupon = model;
                           //计算总价格
                           [weakSelf countTotalPrice];
                       }];
        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(0 == section){
        return 1;
    }
    if(_info.overdueAmount){
        return 6;
    }
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(0 == indexPath.section){
        static NSString *identifier = @"ZYBillConfirmVCItemCell";
        ZYBillConfirmItemCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell){
            cell = [[ZYBillConfirmItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell showCellWithModel:_info];
        return cell;
    }
    static NSString *identifier = @"ZYBillConfirmVCDetailCell";
    ZYDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[ZYDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.separator.hidden = indexPath.row == 0;
    if(0 == indexPath.row){
        //期数
        cell.titleLab.text = @"期数";
        cell.contentLab.text = _info.rentPeriods;
        cell.showArrow = NO;
    }else if(1 == indexPath.row){
        //账单日
        cell.titleLab.text = @"账单日";
        cell.contentLab.text = _info.repaymentDate;
        cell.showArrow = NO;
    }else if(2 == indexPath.row){
        //状态
        cell.titleLab.text = @"状态";
        if(_info.status == ZYBillStateOverdue){
            cell.contentLab.text = @"已逾期";
        }else if(_info.status == ZYBillStateWaitPay){
            cell.contentLab.text = @"未支付";
        }else if(_info.status == ZYBillStatePayedOverdue || _info.status == ZYBillStatePayedNormal){
            cell.contentLab.text = @"已支付";
        }else if(_info.status == ZYBillStateCanceled){
            cell.contentLab.text = @"已取消";
        }
        cell.showArrow = NO;
    }else{
        if(_info.overdueAmount){
            if(3 == indexPath.row){
                //逾期天数
                cell.titleLab.text = @"违约金";
                cell.contentLab.text = [NSString stringWithFormat:@"￥%.2f",_info.overdueAmount];
                cell.showArrow = YES;
            }else if(4 == indexPath.row){
                //月租金
                cell.titleLab.text = @"月租金";
                cell.contentLab.text = [NSString stringWithFormat:@"￥%.2f",_info.payAmount];
                cell.showArrow = NO;
            }else if(5 == indexPath.row){
                //优惠券
                cell.titleLab.text = @"优惠券";
                if(_selectedCoupon){
                    cell.contentLab.textColor = WORD_COLOR_ORANGE;
                    cell.contentLab.text = [NSString stringWithFormat:@"-￥%.2f",_selectedCoupon.countDiscount];
                }else{
                    if(_couponCount){
                        cell.contentLab.textColor = WORD_COLOR_ORANGE;
                        cell.contentLab.text = [NSString stringWithFormat:@"有%d张可用优惠券",_couponCount];
                    }else{
                        cell.contentLab.textColor = WORD_COLOR_BLACK;
                        cell.contentLab.text = @"暂无优惠券可用";
                    }
                }
                cell.showArrow = YES;
            }
        }else{
            if(3 == indexPath.row){
                //月租金
                cell.titleLab.text = @"月租金";
                cell.contentLab.text = [NSString stringWithFormat:@"￥%.2f",_info.payAmount];
                cell.showArrow = NO;
            }else if(4 == indexPath.row){
                //优惠券
                cell.titleLab.text = @"优惠券";
                if(_selectedCoupon){
                    cell.contentLab.textColor = WORD_COLOR_ORANGE;
                    cell.contentLab.text = [NSString stringWithFormat:@"-￥%.2f",_selectedCoupon.countDiscount];
                }else{
                    if(_couponCount){
                        cell.contentLab.textColor = WORD_COLOR_ORANGE;
                        cell.contentLab.text = [NSString stringWithFormat:@"有%d张可用优惠券",_couponCount];
                    }else{
                        cell.contentLab.textColor = WORD_COLOR_BLACK;
                        cell.contentLab.text = @"暂无优惠券可用";
                    }
                }
                cell.showArrow = YES;
            }
        }
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

#pragma mark - getter
- (ZYBillConfirmView *)baseView{
    if(!_baseView){
        _baseView = [ZYBillConfirmView new];
        _baseView.tableView.delegate = self;
        _baseView.tableView.dataSource = self;
        
        __weak __typeof__(self) weakSelf = self;
        [_baseView.payBar.payBtn clickAction:^(UIButton * _Nonnull button) {
            ZYPaymentCommonParam *param = [ZYPaymentCommonParam new];
            param.orderId = weakSelf.orderId;
            param.billIds = weakSelf.info.billIds;
            if(weakSelf.selectedCoupon){
                param.couponId = weakSelf.selectedCoupon.couponId;
            }
            if(weakSelf.billId){
                param.billPayType = @"1";
            }else{
                param.billPayType = @"2";
            }
            param.target = ZYPaymentTargetBill;
            [[ZYPaymentService service] pay:param];
            [ZYPaymentService service].currentDelegate = weakSelf;
        }];
    }
    return _baseView;
}

@end
