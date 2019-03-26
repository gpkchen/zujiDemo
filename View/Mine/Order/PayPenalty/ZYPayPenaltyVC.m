//
//  ZYPayPenaltyVC.m
//  Apollo
//
//  Created by 李明伟 on 2018/7/2.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYPayPenaltyVC.h"
#import "ZYPayPenaltyView.h"
#import "ZYItemCell.h"
#import "ZYDetailCell.h"
#import "GetPenaltyOrderInfo.h"
#import "ZYPayPenaltyHeader.h"
#import "ZYPaymentService.h"
#import "ListUserCoupon.h"
#import "GetCouponList.h"
#import "GetCouponAmount.h"

@interface ZYPayPenaltyVC ()<UITableViewDelegate,UITableViewDataSource,ZYPaymentDelegate>

@property (nonatomic , strong) ZYPayPenaltyView *baseView;
@property (nonatomic , strong) _m_GetPenaltyOrderInfo *info;

@property (nonatomic , assign) int couponCount; //可用优惠券数量
@property (nonatomic , strong) _m_ListUserCoupon *selectedCoupon; //选中的优惠券

@end

@implementation ZYPayPenaltyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = self.baseView;
    self.title = @"违约金支付";
    
    if(!_orderId){
        _orderId = self.dicParam[@"orderId"];
    }
    
    [self showLoadingView];
    [self loadDetail:NO];
}

#pragma mark - 加载违约金详情信息
- (void)loadDetail:(BOOL)showHud{
    _p_GetPenaltyOrderInfo *param = [_p_GetPenaltyOrderInfo new];
    param.orderId = _orderId;
    [[ZYHttpClient client] post:param
                        showHud:showHud
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            [self hideLoadingView];
                            [self hideErrorView];
                            if(responseObj.isSuccess){
                                self.info = [[_m_GetPenaltyOrderInfo alloc] initWithDictionary:responseObj.data];
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
    param.scene = @"5";
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

#pragma mark - 计算金额
- (void)countAmount{
    if(_selectedCoupon){
        _p_GetCouponAmount *param = [_p_GetCouponAmount new];
        param.scene = @"5";
        param.orderId = _orderId;
        param.couponId = _selectedCoupon.couponId;
        [[ZYHttpClient client] post:param
                            showHud:YES
                            success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                                if(responseObj.isSuccess){
                                    _m_GetCouponAmount *model = [_m_GetCouponAmount mj_objectWithKeyValues:responseObj.data];
                                    self.selectedCoupon.countDiscount = model.amount;
                                    [self.baseView.tableView reloadData];
                                    self.baseView.payBar.price = self.info.payPenaltyAmount + self.info.checkPenaltyAmount - model.amount;
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
        self.baseView.payBar.price = self.info.payPenaltyAmount + self.info.checkPenaltyAmount;
    }
}

#pragma mark - ZYPaymentDelegate
- (void)paymentResult:(ZYPaymentResult)result type:(ZYPaymentType)type{
    if(result == ZYPaymentResultFail){
        [ZYToast showWithTitle:@"支付失败！"];
    }else if(result == ZYPaymentResultSuccess){
        void (^block)(void) = self.callBack;
        !block ? : block();
        [[ZYPaymentService service] hideCashier];
        [ZYToast showWithTitle:@"违约金支付成功！"];
        [self.navigationController popViewControllerAnimated:YES];
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
    if(1 == section && self.info.payPenaltyAmount){
        return ZYPayPenaltyHeaderHeight;
    }
    if(2 == section && (self.info.checkPenaltyAmountWay || self.info.reductionCheckAmount)){
        return ZYPayPenaltyHeaderHeight;
    }
    if(3 == section){
        return 10 * UI_H_SCALE;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(3 == section){
        return ZYPayPenaltyFooterHeight;
    }
    return 0.01;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(0 == section){
        return [UIView new];
    }
    if(1 == section && self.info.payPenaltyAmount){
        ZYPayPenaltyHeader *header = [ZYPayPenaltyHeader new];
        header.titleLab.text = @"逾期违约金";
        return header;
    }
    if(2 == section && (self.info.checkPenaltyAmountWay || self.info.reductionCheckAmount)){
        ZYPayPenaltyHeader *header = [ZYPayPenaltyHeader new];
        header.titleLab.text = @"商品损坏/遗失/异常违约金";
        return header;
    }
    return [UIView new];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(3 == section){
        return self.baseView.footer;
    }
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 3){
        [[ZYRouter router] goVC:[NSString stringWithFormat:@"ZYCouponChoiseVC?selectedCouponId=%@&orderId=%@&scene=%d",
                                 [_selectedCoupon.couponId URLEncode],
                                 [_orderId URLEncode],
                                 5]
                   withCallBack:^(_m_ListUserCoupon *model){
                       self.selectedCoupon = model;
                       [self countAmount];
                   }];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(0 == section){
        return 1;
    }
    if(1 == section && self.info.payPenaltyAmount){
        if(self.info.reductionAmount){
            return 5;
        }
        return 4;
    }
    if(2 == section){
        if(self.info.checkPenaltyAmountWay || self.info.reductionCheckAmount){
            if(self.info.reductionCheckAmount){
                return 2;
            }
            if(self.info.checkPenaltyAmountWay){
                return 1;
            }
        }
        return 0;
    }
    if(3 == section){
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(0 == indexPath.section){
        static NSString *identifier = @"ZYPenaltyVCItemCell";
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
    static NSString *identifier = @"ZYPenaltyVCDetailCell";
    ZYDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[ZYDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.separator.hidden = indexPath.row == 0;
    if(1 == indexPath.section && 0 == indexPath.row){
        cell.titleLab.text = @"商品价值";
        cell.titleLab.textColor = WORD_COLOR_BLACK;
        cell.contentLab.text = [NSString stringWithFormat:@"￥%.2f",_info.marketPrice];
        cell.contentLab.textColor = WORD_COLOR_BLACK;
        cell.showArrow = NO;
    }else if(1 == indexPath.section && 1 == indexPath.row){
        cell.titleLab.text = @"违约金/天";
        cell.titleLab.textColor = WORD_COLOR_BLACK;
        cell.contentLab.text = _info.penaltyAmountWay;
        cell.contentLab.textColor = WORD_COLOR_BLACK;
        cell.showArrow = NO;
    }else if(1 == indexPath.section && 2 == indexPath.row){
        cell.titleLab.text = @"逾期天数";
        cell.titleLab.textColor = WORD_COLOR_BLACK;
        cell.contentLab.text = [NSString stringWithFormat:@"%d天",_info.overdueDays];
        cell.contentLab.textColor = WORD_COLOR_BLACK;
        cell.showArrow = NO;
    }else if(1 == indexPath.section && 3 == indexPath.row){
        if(self.info.reductionAmount){
            cell.titleLab.text = @"减免";
            cell.titleLab.textColor = WORD_COLOR_BLACK;
            cell.contentLab.text = [NSString stringWithFormat:@"￥%.2f",_info.reductionAmount];
            cell.contentLab.textColor = WORD_COLOR_BLACK;
            cell.showArrow = NO;
        }else{
            cell.titleLab.text = @"应付逾期违约金";
            cell.titleLab.textColor = WORD_COLOR_ORANGE;
            cell.contentLab.text = _info.payPenaltyAmountWay;
            cell.contentLab.textColor = WORD_COLOR_ORANGE;
            cell.showArrow = NO;
        }
    }else if(1 == indexPath.section && 4 == indexPath.row){
        cell.titleLab.text = @"应付逾期违约金";
        cell.titleLab.textColor = WORD_COLOR_ORANGE;
        cell.contentLab.text = _info.payPenaltyAmountWay;
        cell.contentLab.textColor = WORD_COLOR_ORANGE;
        cell.showArrow = NO;
    }else if(2 == indexPath.section && 0 == indexPath.row){
        if(self.info.reductionCheckAmount){
            cell.titleLab.text = @"减免";
            cell.titleLab.textColor = WORD_COLOR_BLACK;
            cell.contentLab.text = [NSString stringWithFormat:@"￥%.2f",_info.reductionCheckAmount];
            cell.contentLab.textColor = WORD_COLOR_BLACK;
            cell.showArrow = NO;
        }else{
            cell.titleLab.text = @"应付异常违约金";
            cell.titleLab.textColor = WORD_COLOR_ORANGE;
            cell.contentLab.text = _info.checkPenaltyAmountWay;
            cell.contentLab.textColor = WORD_COLOR_ORANGE;
            cell.showArrow = NO;
        }
    }else if(2 == indexPath.section && 1 == indexPath.row){
        cell.titleLab.text = @"应付异常违约金";
        cell.titleLab.textColor = WORD_COLOR_ORANGE;
        cell.contentLab.text = _info.checkPenaltyAmountWay;
        cell.contentLab.textColor = WORD_COLOR_ORANGE;
        cell.showArrow = NO;
    }else if(3 == indexPath.section && 0 == indexPath.row){
        cell.titleLab.text = @"优惠券";
        cell.titleLab.textColor = WORD_COLOR_BLACK;
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
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

#pragma mark - getter
- (ZYPayPenaltyView *)baseView{
    if(!_baseView){
        _baseView = [ZYPayPenaltyView new];
        _baseView.tableView.delegate = self;
        _baseView.tableView.dataSource = self;
        
        __weak __typeof__(self) weakSelf = self;
        [_baseView.payBar.payBtn clickAction:^(UIButton * _Nonnull button) {
            ZYPaymentCommonParam *param = [ZYPaymentCommonParam new];
            param.orderId = weakSelf.orderId;
            param.target = ZYPaymentTargetPenalty;
            param.couponId = weakSelf.selectedCoupon.couponId;
            [[ZYPaymentService service] pay:param];
            [ZYPaymentService service].currentDelegate = weakSelf;
        }];
    }
    return _baseView;
}

@end
