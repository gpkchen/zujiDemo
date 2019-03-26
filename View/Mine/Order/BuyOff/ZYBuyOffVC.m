//
//  ZYBuyOffVC.m
//  Apollo
//
//  Created by 李明伟 on 2018/5/3.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBuyOffVC.h"
#import "ZYBuyOffView.h"
#import "ZYItemCell.h"
#import "ZYDetailCell.h"
#import "GetOrderBuyOffInfo.h"
#import "ZYBuyOffSuccessVC.h"
#import "PayBuyOffAmount.h"
#import "ZYPaymentService.h"
#import "ZYBuyOffFooter.h"
#import "ListUserCoupon.h"
#import "GetCouponList.h"
#import "GetCouponAmount.h"
#import "ZYFormulaView.h"

@interface ZYBuyOffVC ()<UITableViewDelegate,UITableViewDataSource,ZYPaymentDelegate>

@property (nonatomic , strong) ZYBuyOffView *baseView;
@property (nonatomic , strong) ZYFormulaView *formulaView;
@property (nonatomic , strong) _m_GetOrderBuyOffInfo *info;

@property (nonatomic , assign) int couponCount; //可用优惠券数量
@property (nonatomic , strong) _m_ListUserCoupon *selectedCoupon; //选中的优惠券

@end

@implementation ZYBuyOffVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = self.baseView;
    self.title = @"购买";
    
    if(!_orderId){
        _orderId = self.dicParam[@"orderId"];
    }
    
    [self showLoadingView];
    [self loadDetail:NO];
}

#pragma mark - 加载订单详情信息
- (void)loadDetail:(BOOL)showHud{
    _p_GetOrderBuyOffInfo *param = [_p_GetOrderBuyOffInfo new];
    param.orderId = _orderId;
    [[ZYHttpClient client] post:param
                        showHud:showHud
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            [self hideLoadingView];
                            [self hideErrorView];
                            if(responseObj.isSuccess){
                                self.info = [[_m_GetOrderBuyOffInfo alloc] initWithDictionary:responseObj.data];
                                
                                if(self.info.type == ZYBuyOffPayTypePay){
                                    //支付
                                    self.baseView.payBar.isMinLimit = YES;
                                    self.baseView.payBar.priceTitle = @"共计";
                                    self.baseView.payBar.price = self.info.payAmount - self.info.activityDiscountAmount;
                                    [self.baseView.payBar.payBtn setTitle:@"确认支付" forState:UIControlStateNormal];
                                }else{
                                    //退还
                                    self.baseView.payBar.isMinLimit = NO;
                                    self.baseView.payBar.priceTitle = @"可退还";
                                    self.baseView.payBar.price = self.info.backAmount;
                                    [self.baseView.payBar.payBtn setTitle:@"确认购买" forState:UIControlStateNormal];
                                }
                                [self.baseView.tableView reloadData];
                                if(self.info.type == ZYBuyOffPayTypePay){
                                    [self loadCouponCount];
                                }
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
    param.scene = @"2";
    param.orderId = _orderId;
    param.page = @"1";
    param.size = @"1";
    [[ZYHttpClient client] post:param
                        showHud:NO
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            if(responseObj.isSuccess){
                                self.couponCount = [responseObj.data[@"totalCount"] intValue];
                                if(!self.selectedCoupon){
                                    //没有选中的优惠券说明这个接口需要刷新界面，不然计算中价格会刷新
                                    [self.baseView.tableView reloadData];
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

#pragma mark - 发起买断(可退还)
- (void)buy{
    _p_PayBuyOffAmount *param = [_p_PayBuyOffAmount new];
    param.orderId = _orderId;
    param.couponId = _selectedCoupon.couponId;
    [[ZYHttpClient client] post:param
                        showHud:YES
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            if(responseObj.isSuccess){
                                void (^block)(void) = self.callBack;
                                !block ? : block();
                                ZYBuyOffSuccessVC *vc = [ZYBuyOffSuccessVC new];
                                vc.backAmount = self.info.backAmount;
                                [[ZYRouter router] push:vc completion:^{
                                    NSMutableArray *vcs = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
                                    [vcs removeObject:self];
                                    self.navigationController.viewControllers = vcs;
                                }];
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

#pragma mark - 计算价格
- (void)countPrice{
    if(_selectedCoupon){
        _p_GetCouponAmount *param = [_p_GetCouponAmount new];
        param.scene = @"2";
        param.orderId = _orderId;
        param.couponId = _selectedCoupon.couponId;
        [[ZYHttpClient client] post:param
                            showHud:YES
                            success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                                if(responseObj.isSuccess){
                                    _m_GetCouponAmount *model = [_m_GetCouponAmount mj_objectWithKeyValues:responseObj.data];
                                    self.selectedCoupon.countDiscount = model.amount;
                                    if(self.info.isSuperimposed){
                                        self.selectedCoupon.activityDiscount = self.info.activityDiscountAmount;
                                    }else{
                                        self.selectedCoupon.activityDiscount = 0;
                                    }
                                    self.baseView.payBar.price = self.info.payAmount - self.selectedCoupon.countDiscount - self.selectedCoupon.activityDiscount;
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
    }else{
        self.baseView.payBar.price = self.info.payAmount - self.info.activityDiscountAmount;
        [self.baseView.tableView reloadData];
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
        ZYBuyOffSuccessVC *vc = [ZYBuyOffSuccessVC new];
        vc.backAmount = 0;
        [[ZYRouter router] push:vc completion:^{
            NSMutableArray *vcs = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
            [vcs removeObject:self];
            self.navigationController.viewControllers = vcs;
        }];
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
    if(1 == section){
        return 10 * UI_H_SCALE;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(4 == section){
        return ZYBuyOffFooterHeight;
    }
    return 0.01;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(4 == section){
        ZYBuyOffFooter *footer = [ZYBuyOffFooter new];
        footer.type = self.info.type;
        return footer;
    }
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    __weak __typeof__(self) weakSelf = self;
    
    if(2 == indexPath.section){
        [[ZYRouter router] goVC:[NSString stringWithFormat:@"ZYPenaltyVC?orderId=%@",
                                 [_orderId URLEncode]]];
    }else if(4 == indexPath.section && 0 == indexPath.row){
        if(self.info.type == ZYBuyOffPayTypePay){
            [[ZYLoginService service] requireLogin:^{
                NSString *url = url = [NSString stringWithFormat:@"ZYCouponChoiseVC?selectedCouponId=%@&scene=%@&orderId=%@",
                                       [weakSelf.selectedCoupon.couponId URLEncode],
                                       @"2",
                                       [weakSelf.orderId URLEncode]];
                [[ZYRouter router] goVC:url
                           withCallBack:^(_m_ListUserCoupon *model){
                               weakSelf.selectedCoupon = model;
                               //计算总价格
                               [weakSelf countPrice];
                           }];
            }];
        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //违约金和活动优惠为单独section，方便显示j控制
    if(0 == section){
        return 1;
    }
    if(1 == section){
        return 4;
    }
    if(2 == section && _info.penaltyAmount){
        return 1;
    }
    if(3 == section && _info.isHaveActivity && _info.type == ZYBuyOffPayTypePay){
        return 1;
    }
    if(4 == section){
        return 3;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(0 == indexPath.section){
        static NSString *identifier = @"ZYBuyOffVCItemCell";
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
    static NSString *identifier = @"ZYBuyOffVCDetailCell";
    ZYDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[ZYDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.separator.hidden = indexPath.row == 0;
    if(1 == indexPath.section && 0 == indexPath.row){
        cell.titleLab.text = @"商品价值";
        cell.contentLab.text = [NSString stringWithFormat:@"￥%.2f",self.info.marketPrice];
        cell.contentLab.textColor = WORD_COLOR_BLACK;
        cell.showArrow = NO;
    }else if(1 == indexPath.section && 1 == indexPath.row){
        cell.titleLab.text = @"溢价系数";
        cell.contentLab.text = self.info.premium;
        cell.contentLab.textColor = WORD_COLOR_ORANGE;
        cell.showArrow = NO;
    }else if(1 == indexPath.section && 2 == indexPath.row){
        cell.titleLab.text = @"已支付租金";
        cell.contentLab.text = [NSString stringWithFormat:@"￥%.2f",self.info.payBIllAmount];
        cell.contentLab.textColor = WORD_COLOR_BLACK;
        cell.showArrow = NO;
    }else if(1 == indexPath.section && 3 == indexPath.row){
        cell.titleLab.text = @"已支付押金";
        cell.contentLab.text = [NSString stringWithFormat:@"￥%.2f",self.info.payDeposit];
        cell.contentLab.textColor = WORD_COLOR_BLACK;
        cell.showArrow = NO;
    }else if(2 == indexPath.section){
        cell.titleLab.text = @"违约金";
        cell.contentLab.text = [NSString stringWithFormat:@"￥%.2f",_info.penaltyAmount];
        cell.contentLab.textColor = WORD_COLOR_BLACK;
        cell.showArrow = YES;
        cell.separator.hidden = NO;
    }else if(3 == indexPath.section){
        if(!_info.isSuperimposed){
            NSMutableAttributedString *attTitle = [[NSMutableAttributedString alloc] initWithString:@"活动优惠(本活动不可叠加优惠券)"];
            [attTitle addAttribute:NSForegroundColorAttributeName value:WORD_COLOR_GRAY_9B range:NSMakeRange(4, attTitle.length - 4)];
            cell.titleLab.attributedText = attTitle;
        }else{
            cell.titleLab.text = @"活动优惠";
        }
        cell.contentLab.textColor = WORD_COLOR_BLACK;
        if(_selectedCoupon){
            cell.contentLab.text = [NSString stringWithFormat:@"-￥%.2f",_selectedCoupon.activityDiscount];
        }else{
            cell.contentLab.text = [NSString stringWithFormat:@"-￥%.2f",_info.activityDiscountAmount];
        }
        cell.showArrow = NO;
        cell.separator.hidden = NO;
    }else if(4 == indexPath.section && 0 == indexPath.row){
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
        cell.separator.hidden = NO;
    }else if(4 == indexPath.section && 1 == indexPath.row){
        cell.titleLab.text = @"应付总额";
        cell.contentLab.text = [NSString stringWithFormat:@"￥%.2f",self.info.payAmount];
        cell.contentLab.textColor = WORD_COLOR_ORANGE;
        cell.showArrow = NO;
        
//        if(!self.baseView.helpBtn.superview){
            [cell.contentView addSubview:self.baseView.helpBtn];
            [self.baseView.helpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.titleLab.mas_right).mas_offset(10 * UI_H_SCALE);
                make.centerY.equalTo(cell.contentView);
            }];
//        }
    }else if(4 == indexPath.section && 2 == indexPath.row){
        cell.titleLab.text = @"优惠后需支付";
        if(self.info.type == ZYBuyOffPayTypePay){
            if(_selectedCoupon){
                double amount = self.info.payAmount - _selectedCoupon.activityDiscount - _selectedCoupon.countDiscount;
                if(amount < 0){
                    amount = 0;
                }
                cell.contentLab.text = [NSString stringWithFormat:@"￥%.2f",amount];
            }else{
                double amount = self.info.payAmount - _info.activityDiscountAmount;
                if(amount < 0){
                    amount = 0;
                }
                cell.contentLab.text = [NSString stringWithFormat:@"￥%.2f",amount];
            }
        }else{
            cell.contentLab.text = [NSString stringWithFormat:@"￥%.2f",self.info.payAmount];
        }
        cell.contentLab.textColor = WORD_COLOR_ORANGE;
        cell.showArrow = NO;
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //违约金和活动优惠为单独section，方便显示j控制
    return 5;
}

#pragma mark - getter
- (ZYBuyOffView *)baseView{
    if(!_baseView){
        _baseView = [ZYBuyOffView new];
        _baseView.tableView.delegate = self;
        _baseView.tableView.dataSource = self;
        
        __weak __typeof__(self) weakSelf = self;
        __weak __typeof__(_baseView) weakBaseView = _baseView;
        [_baseView.payBar.payBtn clickAction:^(UIButton * _Nonnull button) {
            if(weakSelf.info.type == ZYBuyOffPayTypePay){
                ZYPaymentCommonParam *param = [ZYPaymentCommonParam new];
                param.orderId = weakSelf.orderId;
                param.target = ZYPaymentTargetBuy;
                param.couponId = weakSelf.selectedCoupon.couponId;
                [[ZYPaymentService service] pay:param];
                [ZYPaymentService service].currentDelegate = weakSelf;
            }else{
                [ZYAlert showWithTitle:nil
                               content:@"确定要购买该产品吗？"
                          buttonTitles:@[@"取消",@"确定"]
                          buttonAction:^(ZYAlert *alert, int index) {
                              [alert dismiss];
                              if(1 == index){
                                  [weakSelf buy];
                              }
                          }];
            }
        }];
        [_baseView.helpBtn clickAction:^(UIButton * _Nonnull button) {
            if(weakSelf.info.penaltyAmount){
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

- (ZYFormulaView *)formulaView{
    if(!_formulaView){
        _formulaView = [ZYFormulaView new];
    }
    return _formulaView;
}

@end
