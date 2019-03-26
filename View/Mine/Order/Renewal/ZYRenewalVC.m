//
//  ZYRenewalVC.m
//  Apollo
//
//  Created by 李明伟 on 2018/6/20.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYRenewalVC.h"
#import "ZYRenewalView.h"
#import "ZYItemCell.h"
#import "ZYDetailCell.h"
#import "GetReletOrderInfo.h"
#import "ListUserCoupon.h"
#import "ZYPaymentService.h"
#import "ZYRenewalSuccessVC.h"
#import "GetCouponList.h"
#import "GetCouponAmount.h"

@interface ZYRenewalVC ()<UITableViewDelegate,UITableViewDataSource,ZYPaymentDelegate>

@property (nonatomic , strong) ZYRenewalView *baseView;
@property (nonatomic , strong) _m_GetReletOrderInfo *info;
@property (nonatomic , assign) double payAmount; //需支付金额

@property (nonatomic , assign) int selectedTerm; //选中的期数

@property (nonatomic , assign) int couponCount; //可用优惠券数量
@property (nonatomic , strong) _m_ListUserCoupon *selectedCoupon; //选中的优惠券

@end

@implementation ZYRenewalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = self.baseView;
    self.title = @"续租";
    
    if(!_orderId){
        _orderId = self.dicParam[@"orderId"];
    }
    
    [self showLoadingView];
    [self loadDetail:NO];
}

#pragma mark - ZYPaymentDelegate
- (void)paymentResult:(ZYPaymentResult)result type:(ZYPaymentType)type{
    if(result == ZYPaymentResultFail){
        [ZYToast showWithTitle:@"支付失败！"];
    }else if(result == ZYPaymentResultSuccess){
        void (^block)(void) = self.callBack;
        !block ? : block();
        [[ZYPaymentService service] hideCashier];
        ZYRenewalSuccessVC *vc = [ZYRenewalSuccessVC new];
        vc.orderId = _orderId;
        if(self.info.showRentType == ZYRentTypeLong){
            vc.rent = [NSString stringWithFormat:@"租金:￥%.2f/月",_info.monthPay];
            vc.term = [NSString stringWithFormat:@"续租期限:%d个月",_selectedTerm];
            vc.termSub = @"续租月租金请于次月还款日之前支付";
        }else{
            vc.rent = [NSString stringWithFormat:@"租金:￥%.2f/天",_info.monthPay];
            vc.term = [NSString stringWithFormat:@"续租期限:%d天",_selectedTerm];
            vc.termSub = @"";
        }
        [[ZYRouter router] push:vc completion:^{
            NSMutableArray *vcs = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
            [vcs removeObject:self];
            self.navigationController.viewControllers = vcs;
        }];
    }
}

#pragma mark - 加载续租详情信息
- (void)loadDetail:(BOOL)showHud{
    _p_GetReletOrderInfo *param = [_p_GetReletOrderInfo new];
    param.orderId = _orderId;
    [[ZYHttpClient client] post:param
                        showHud:showHud
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            [self hideLoadingView];
                            [self hideErrorView];
                            if(responseObj.isSuccess){
                                self.info = [[_m_GetReletOrderInfo alloc] initWithDictionary:responseObj.data];
                                self.selectedTerm = self.info.defaultPeriod;
                                [self countAmount];
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

#pragma mark - 加载可用优惠券数量
- (void)loadCouponCount{
    _p_GetCouponList *param = [_p_GetCouponList new];
    param.scene = @"3";
    param.orderId = _orderId;
    param.rentPeriod = [NSString stringWithFormat:@"%d",_selectedTerm];
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

#pragma mark - 计算金额
- (void)countAmount{
    if(_info.showRentType == ZYRentTypeLong){
        [self loadCouponAmount:_info.monthPay + _info.penaltyAmount];
    }else{
        [self loadCouponAmount:_info.monthPay * _selectedTerm + _info.penaltyAmount];
    }
}

#pragma mark - 获取优惠券可优惠金额
- (void)loadCouponAmount:(double)beforeAmount{
    if(_selectedCoupon){
        _p_GetCouponAmount *param = [_p_GetCouponAmount new];
        param.scene = @"3";
        param.orderId = _orderId;
        param.rentPeriod = [NSString stringWithFormat:@"%d",_selectedTerm];
        param.couponId = _selectedCoupon.couponId;
        [[ZYHttpClient client] post:param
                            showHud:YES
                            success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                                if(responseObj.isSuccess){
                                    _m_GetCouponAmount *model = [_m_GetCouponAmount mj_objectWithKeyValues:responseObj.data];
                                    self.selectedCoupon.countDiscount = model.amount;
                                    double amount = beforeAmount - self.selectedCoupon.countDiscount;
                                    if(amount < 0){
                                        amount = 0;
                                    }
                                    [self.baseView.tableView reloadData];
                                    self.baseView.payBar.price = amount;
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
        self.baseView.payBar.price = beforeAmount;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(0 == indexPath.section){
        return ZYItemCellHeight;
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
    
    if(1 == indexPath.section && 1 == indexPath.row){
        [[ZYRouter router] goVC:[NSString stringWithFormat:@"ZYTermChoiseVC?rentType=%d&selectedTerm=%d",
                                 self.info.showRentType,self.selectedTerm] withCallBack:^(int term){
            self.selectedTerm = term;
            self.selectedCoupon = nil;
            [self countAmount];
            [self.baseView.tableView reloadData];
            [self loadCouponCount];
        }];
    }else if(1 == indexPath.section && 2 == indexPath.row){
        [[ZYRouter router] goVC:[NSString stringWithFormat:@"ZYCouponChoiseVC?selectedCouponId=%@&orderId=%@&rentPeriod=%d&scene=%d",
                                 [_selectedCoupon.couponId URLEncode],
                                 [_orderId URLEncode],
                                 _selectedTerm,
                                 3]
                   withCallBack:^(_m_ListUserCoupon *model){
                       self.selectedCoupon = model;
                       [self countAmount];
                   }];
    }else if(1 == indexPath.section && 3 == indexPath.row && _info.penaltyAmount){
        [[ZYRouter router] goVC:[NSString stringWithFormat:@"ZYPenaltyVC?orderId=%@",
                                 [_orderId URLEncode]]];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(0 == section){
        return 1;
    }
    if(_info.penaltyAmount){
        return 5;
    }
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(0 == indexPath.section){
        static NSString *identifier = @"ZYRenewalVCItemCell";
        ZYItemCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell){
            cell = [[ZYItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        NSString *url = [_info.imageUrl imageStyleUrl:CGSizeMake((ZYItemCellHeight - 30 * UI_H_SCALE) * 2, (ZYItemCellHeight - 30 * UI_H_SCALE) * 2)];
        [cell.itemIV loadImage:url];
        cell.titleLab.text = _info.title;
        cell.skuLab.text = [NSString stringWithFormat:@"规格:%@",_info.goodsSkuNames];
        cell.priceLab.text = [NSString stringWithFormat:@"￥%@",_info.rentPrice];
        return cell;
    }
    static NSString *identifier = @"ZYRenewalVCDetailCell";
    ZYDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[ZYDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.separator.hidden = indexPath.row == 0;
    if(0 == indexPath.row){
        if(_info.showRentType == ZYRentTypeLong){
            cell.titleLab.text = @"月租金";
        }else{
            cell.titleLab.text = @"日租金";
        }
        cell.titleLab.textColor = WORD_COLOR_BLACK;
        cell.contentLab.text = [NSString stringWithFormat:@"￥%.2f",_info.monthPay];
        cell.showArrow = NO;
    }else if(1 == indexPath.row){
        cell.titleLab.text = @"租期";
        cell.titleLab.textColor = WORD_COLOR_BLACK;
        if(_info.showRentType == ZYRentTypeLong){
            cell.contentLab.text = [NSString stringWithFormat:@"%d个月",_selectedTerm];
        }else{
            cell.contentLab.text = [NSString stringWithFormat:@"%d天",_selectedTerm];
        }
        cell.showArrow = YES;
    }else if(2 == indexPath.row){
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
    }else if(3 == indexPath.row){
        if(_info.penaltyAmount){
            cell.titleLab.text = @"违约金";
            cell.titleLab.textColor = WORD_COLOR_BLACK;
            cell.contentLab.text = [NSString stringWithFormat:@"￥%.2f",_info.penaltyAmount];
            cell.showArrow = YES;
        }else{
            cell.titleLab.textColor = WORD_COLOR_ORANGE;
            if(_info.showRentType == ZYRentTypeLong){
                double amount = _info.monthPay - _selectedCoupon.countDiscount;
                if(amount < 0){
                    amount = 0;
                }
                cell.contentLab.text = [NSString stringWithFormat:@"￥%.2f",amount];
                cell.titleLab.text = @"首月租金";
            }else{
                double amount = _info.monthPay * _selectedTerm  - _selectedCoupon.countDiscount;
                if(amount < 0){
                    amount = 0;
                }
                cell.contentLab.text = [NSString stringWithFormat:@"￥%.2f",amount];
                cell.titleLab.text = @"总租金";
            }
            cell.showArrow = NO;
        }
    }else if(4 == indexPath.row){
        cell.titleLab.textColor = WORD_COLOR_ORANGE;
        if(_info.showRentType == ZYRentTypeLong){
            double amount = _info.monthPay - _selectedCoupon.countDiscount;
            if(amount < 0){
                amount = 0;
            }
            cell.contentLab.text = [NSString stringWithFormat:@"￥%.2f",amount];
            cell.titleLab.text = @"首月租金";
        }else{
            double amount = _info.monthPay * _selectedTerm  - _selectedCoupon.countDiscount;
            if(amount < 0){
                amount = 0;
            }
            cell.contentLab.text = [NSString stringWithFormat:@"￥%.2f",amount];
            cell.titleLab.text = @"总租金";
        }
        cell.showArrow = NO;
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

#pragma mark - getter
- (ZYRenewalView *)baseView{
    if(!_baseView){
        _baseView = [ZYRenewalView new];
        _baseView.tableView.delegate = self;
        _baseView.tableView.dataSource = self;
        
        __weak __typeof__(self) weakSelf = self;
        [_baseView.payBar.payBtn clickAction:^(UIButton * _Nonnull button) {
            ZYPaymentCommonParam *param = [ZYPaymentCommonParam new];
            param.orderId = weakSelf.orderId;
            param.couponId = weakSelf.selectedCoupon.couponId;
            param.rentPeriod = [NSString stringWithFormat:@"%d",weakSelf.selectedTerm];
            param.target = ZYPaymentTargetRenewal;
            [[ZYPaymentService service] pay:param];
            [ZYPaymentService service].currentDelegate = weakSelf;
        }];
    }
    return _baseView;
}

@end
