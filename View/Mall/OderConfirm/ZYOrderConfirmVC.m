//
//  ZYOrderConfirmVC.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/23.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYOrderConfirmVC.h"
#import "ZYOrderConfirmView.h"
#import "ZYOrderConfirmAddressCell.h"
#import "ZYItemCell.h"
#import "ZYDetailCell.h"
#import "OrderGetAddress.h"
#import "MerchantAddressList.h"
#import "AddressList.h"
#import "ListUserCoupon.h"
#import "InsertRentOrder.h"
#import "ZYLocationUtils.h"
#import "ZYPaymentService.h"
#import "GetCouponList.h"
#import "GetCouponAmount.h"
#import "GetPreOrderInfo.h"
#import "ZYFormulaView.h"
#import "ZYOrdeerConfirmRefreshView.h"

@interface ZYOrderConfirmVC ()<UITableViewDelegate,UITableViewDataSource,ZYPaymentDelegate>

@property (nonatomic , strong) ZYOrderConfirmView *baseView;
@property (nonatomic , strong) ZYOrdeerConfirmRefreshView *refreshView;
@property (nonatomic , strong) ZYFormulaView *formulaView;

@property (nonatomic , assign) BOOL isMail; //是否是邮寄

@property (nonatomic , strong) _m_OrderGetAddress *addressInfo;
@property (nonatomic , strong) _m_GetPreOrderInfo *confirmInfo;

@property (nonatomic , strong) _m_MerchantAddressList *selectedStore; //选中的门店
@property (nonatomic , strong) _m_AddressList *selectedAddress; //选中的收货地址(主动将省市区拼在详细地址前面)

@property (nonatomic , assign) int couponCount; //可用优惠券数量
@property (nonatomic , strong) _m_ListUserCoupon *selectedCoupon; //选中的优惠券

@property (nonatomic , strong) _m_InsertRentOrder *orderInfo; //创建的订单信息

@property (nonatomic , assign) CGFloat mailAddressCellHeight;
@property (nonatomic , assign) CGFloat storeAddressCellHeight;

@end

@implementation ZYOrderConfirmVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = self.baseView;
    self.title = @"确认订单";
    _isMail = YES;
    
    [self showLoadingView];
    [self loadDetail:NO];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self loadAddress:NO];
}

#pragma mark - 加载默认地址、店铺地址
- (void)loadAddress:(BOOL)showHud{
    _p_OrderGetAddress *param = [_p_OrderGetAddress new];
    param.itemId = _itemId;
    param.latitude = [ZYLocationUtils utils].userLocation.latitude;
    param.longitude = [ZYLocationUtils utils].userLocation.longitude;
    [[ZYHttpClient client] post:param
                        showHud:showHud
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            if(responseObj.isSuccess){
                                self.addressInfo = [[_m_OrderGetAddress alloc] initWithDictionary:responseObj.data];
                                
                                //组装选中的地址
                                if(!self.selectedAddress){
                                    if(self.addressInfo.reciveAddressId){
                                        self.selectedAddress = [_m_AddressList new];
                                        self.selectedAddress.addressId = self.addressInfo.reciveAddressId;
                                        self.selectedAddress.contact = self.addressInfo.contact;
                                        self.selectedAddress.mobile = self.addressInfo.mobile;
                                        self.selectedAddress.address = self.addressInfo.commonAddress;
                                    }else{
                                        self.selectedAddress = nil;
                                    }
                                }
                                if(!self.selectedAddress){
                                    self.mailAddressCellHeight = ZYOrderConfirmAddressCellHeightNoAddress;
                                }else{
                                    CGFloat addressHeight = [self.selectedAddress.address boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 70 * UI_H_SCALE - 14, CGFLOAT_MAX)
                                                                                                options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                                                                             attributes:@{NSFontAttributeName:FONT(13)}
                                                                                                context:nil].size.height;
                                    self.mailAddressCellHeight = 73 * UI_H_SCALE + addressHeight + 20 * UI_H_SCALE;
                                }
                                
                                //组装选中的门店地址
                                if(!self.selectedStore){
                                    if(self.addressInfo.merchantAddressId){
                                        self.selectedStore = [_m_MerchantAddressList new];
                                        self.selectedStore.merchantAddressId = self.addressInfo.merchantAddressId;
                                        self.selectedStore.addressName = self.addressInfo.addressName;
                                        self.selectedStore.telephone = self.addressInfo.telephone;
                                        self.selectedStore.completeAddress = self.addressInfo.completeAddress;
                                        self.selectedStore.distance = self.addressInfo.distance;
                                        self.selectedStore.index = 0;
                                    }else{
                                        self.selectedStore = nil;
                                    }
                                }
                                if(!self.selectedStore){
                                    self.storeAddressCellHeight = ZYOrderConfirmAddressCellHeightNoAddress;
                                }else{
                                    CGFloat addressHeight = [self.selectedStore.completeAddress boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 70 * UI_H_SCALE - 14, CGFLOAT_MAX)
                                                                                                       options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                                                                                    attributes:@{NSFontAttributeName:FONT(13)}
                                                                                                       context:nil].size.height;
                                    if(self.selectedStore.distance){
                                        self.storeAddressCellHeight = 73 * UI_H_SCALE + addressHeight + 42 * UI_H_SCALE;
                                    }else{
                                        self.storeAddressCellHeight = 73 * UI_H_SCALE + addressHeight + 20 * UI_H_SCALE;
                                    }
                                }
                                
                                [self.baseView.tableView reloadData];
                                
                                [self loadCouponCount];
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
                        } authFail:^{
                            
                        }];
}

#pragma mark - 加载下单信息
- (void)loadDetail:(BOOL)showHud{
    _p_GetPreOrderInfo *param = [_p_GetPreOrderInfo new];
    param.priceId = _priceId;
    param.serviceIds = _serviceIds;
    param.itemId = _itemId;
    param.fundAuthNo = _fundAuthNo;
    [[ZYHttpClient client] post:param
                        showHud:showHud
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            [self hideLoadingView];
                            [self hideErrorView];
                            if(responseObj.isSuccess){
                                if(self.refreshView.superview){
                                    [self.refreshView removeFromSuperview];
                                }
                                self.confirmInfo = [[_m_GetPreOrderInfo alloc] initWithDictionary:responseObj.data];
                                [self.baseView.tableView reloadData];
                                [self countTotalPrice];
                            }else if(responseObj.code == 3101){
                                //支付宝回调没到位
                                [self.view addSubview:self.refreshView];
                            }else{
                                [ZYToast showWithTitle:responseObj.message];
                            }
                        } failure:^(NSURLSessionDataTask *task, NSError *error) {
                            [self hideLoadingView];
                            [self hideErrorView];
                            
                            __weak __typeof__(self) weakSelf = self;
                            if(self.confirmInfo){
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

#pragma mark - 计算总价格
- (void)countTotalPrice{
    __block double rent = _confirmInfo.monthPay;
    if(_confirmInfo.rentType == ZYRentTypeShort){
        rent = _confirmInfo.monthPay * _confirmInfo.periods;
    }
    for(NSDictionary *service in _confirmInfo.addedPriceList){
        rent += [service[@"price"] doubleValue];
    }
    if(_selectedCoupon){
        _p_GetCouponAmount *param = [_p_GetCouponAmount new];
        param.scene = @"0";
        param.itemId = _itemId;
        param.categoryId = _categoryId;
        param.priceId = _priceId;
        param.serviceIds = _serviceIds;
        param.couponId = _selectedCoupon.couponId;
        [[ZYHttpClient client] post:param
                            showHud:YES
                            success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                                if(responseObj.isSuccess){
                                    _m_GetCouponAmount *model = [_m_GetCouponAmount mj_objectWithKeyValues:responseObj.data];
                                    self.selectedCoupon.countDiscount = model.amount;
                                    if(self.confirmInfo.isSuperimposed){
                                        self.selectedCoupon.activityDiscount = self.confirmInfo.activityDiscountAmount;
                                    }else{
                                        self.selectedCoupon.activityDiscount = 0;
                                    }
                                    rent = rent - self.selectedCoupon.countDiscount - self.selectedCoupon.activityDiscount;
                                    if(rent < 0){
                                        rent = 0;
                                    }
                                    [self.baseView.tableView reloadData];
                                    self.baseView.payBar.price = self.confirmInfo.needPayDeposit + rent;
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
        rent = rent - _confirmInfo.activityDiscountAmount;
        self.baseView.payBar.price = self.confirmInfo.needPayDeposit + rent;
    }
}

#pragma mark - 加载可用优惠券数量
- (void)loadCouponCount{
    _p_GetCouponList *param = [_p_GetCouponList new];
    param.scene = @"0";
    param.itemId = _itemId;
    param.categoryId = _categoryId;
    param.priceId = _priceId;
    param.serviceIds = _serviceIds;
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

#pragma mark - 创建订单
- (void)createOrder{
    if(_isMail && !_selectedAddress){
        [ZYToast showWithTitle:@"请先选择收货地址"];
        return;
    }
    if(!_isMail && !_selectedStore){
        [ZYToast showWithTitle:@"请先选择门店地址"];
        return;
    }
    if(!self.baseView.footer.protocolCB.isSelected){
        [ZYToast showWithTitle:@"请先阅读并同意《机有用户租赁服务协议》"];
        return;
    }
    _p_InsertRentOrder *param = [_p_InsertRentOrder new];
    param.priceId = _priceId;
    param.itemId = _itemId;
    param.serviceIds = _serviceIds;
    param.couponId = _selectedCoupon.couponId;
    param.longitude = [ZYLocationUtils utils].userLocation.longitude;
    param.latitude = [ZYLocationUtils utils].userLocation.latitude;
    param.fundAuthNo = _fundAuthNo;
    if(_isMail){
        param.addressId = _selectedAddress.addressId;
        param.expressType = [NSString stringWithFormat:@"%d",ZYExpressTypeMail];
    }else{
        param.expressType = [NSString stringWithFormat:@"%d",ZYExpressTypeSelfLifting];
        param.storeAddress = _selectedStore.completeAddress;
        param.storeName = _selectedStore.addressName;
        param.storeMobile = _selectedStore.telephone;
    }
    
    [[ZYHttpClient client] post:param
                        showHud:YES
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            if(responseObj.isSuccess){
                                self.orderInfo = [[_m_InsertRentOrder alloc] initWithDictionary:responseObj.data];
                                ZYPaymentCommonParam *param = [ZYPaymentCommonParam new];
                                param.orderId = self.orderInfo.orderId;
                                param.billIds = self.orderInfo.billId;
                                param.billPayType = @"1";
                                param.target = ZYPaymentTargetBill;
                                [[ZYPaymentService service] pay:param];
                                [ZYPaymentService service].currentDelegate = self;
                                
                                void (^callback)(void) = self.callBack;
                                !callback ? : callback();
                                
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

#pragma mark - ZYPaymentDelegate
- (void)paymentResult:(ZYPaymentResult)result type:(ZYPaymentType)type{
    if(result == ZYPaymentResultGiveUp){
        
        [[ZYPaymentService service] hideCashier];
        NSString *url = [NSString stringWithFormat:@"orderDetail?orderId=%@",[_orderInfo.orderId URLEncode]];
        [[ZYRouter router] goWithoutHead:url withCallBack:nil isPush:YES completion:^{
            NSMutableArray *mVCs = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
            [mVCs removeObject:self];
            self.navigationController.viewControllers = mVCs;
        }];
    }else if(result == ZYPaymentResultFail){
        [ZYToast showWithTitle:@"支付失败！"];
    }else if(result == ZYPaymentResultSuccess){
        [[ZYPaymentService service] hideCashier];
        NSString *url = [NSString stringWithFormat:@"ZYPaySuccessVC?orderId=%@",[_orderInfo.orderId URLEncode]];
        [[ZYRouter router] goVC:url withCallBack:nil isPush:YES completion:^{
            NSMutableArray *mVCs = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
            [mVCs removeObject:self];
            self.navigationController.viewControllers = mVCs;
        }];
    }else if(result == ZYPaymentResultCancel){
        
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(0 == indexPath.section){
        if(_isMail){
            return _mailAddressCellHeight;
        }
        return _storeAddressCellHeight;
    }
    if(1 == indexPath.section){
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
    if(3 == section){
        return ZYOrderConfirmFooterHeight;
    }
    return 0.01;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(3 == section){
        return self.baseView.footer;
    }
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak __typeof__(self) weakSelf = self;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(0 == indexPath.section){
        [[ZYLoginService service] requireLogin:^{
            if(self.isMail){
                NSString *addressId = nil;
                if(self.selectedAddress){
                    addressId = self.selectedAddress.addressId;
                }
                NSString *url = @"ZYAddressChoiseVC";
                if(addressId){
                    url = [url stringByAppendingString:[NSString stringWithFormat:@"?selectedAddressId=%@",[addressId URLEncode]]];
                }
                [[ZYRouter router] goVC:url withCallBack:^(_m_AddressList *model){
                    weakSelf.selectedAddress = model;
                    NSString *tmpAddress = @"";
                    if(model.provinceName){
                        tmpAddress = [tmpAddress stringByAppendingString:model.provinceName];
                    }
                    if(model.cityName){
                        tmpAddress = [tmpAddress stringByAppendingString:model.cityName];
                    }
                    if(model.districtName){
                        tmpAddress = [tmpAddress stringByAppendingString:model.districtName];
                    }
                    if(model.address){
                        tmpAddress = [tmpAddress stringByAppendingString:model.address];
                    }
                    weakSelf.selectedAddress.address = tmpAddress;
                    [weakSelf.baseView.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
                }];
            }else{
                NSString *storeId = nil;
                if(self.selectedStore){
                    storeId = self.selectedStore.merchantAddressId;
                }
                NSString *url = @"ZYStoreChoiseVC";
                url = [url stringByAppendingString:[NSString stringWithFormat:@"?itemId=%@&addressUseScene=%@",[self.itemId URLEncode],@"3"]];
                if(storeId){
                    url = [url stringByAppendingString:[NSString stringWithFormat:@"&selectedStoreId=%@",[storeId URLEncode]]];
                }
                [[ZYRouter router] goVC:url withCallBack:^(_m_MerchantAddressList *model){
                    weakSelf.selectedStore = model;
                    [weakSelf.baseView.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
                }];
            }
        }];
    }else if(indexPath.section == 3 && ((indexPath.row == 3 + _confirmInfo.addedPriceList.count && _confirmInfo.isHaveActivity) || (indexPath.row == 2 + _confirmInfo.addedPriceList.count && !_confirmInfo.isHaveActivity))){
        [[ZYLoginService service] requireLogin:^{
            NSString *url = nil;
            if(weakSelf.serviceIds){
                url = [NSString stringWithFormat:@"ZYCouponChoiseVC?itemId=%@&categoryId=%@&selectedCouponId=%@&scene=%@&priceId=%@&serviceIds=%@",
                       [weakSelf.itemId URLEncode],
                       [weakSelf.categoryId URLEncode],
                       [weakSelf.selectedCoupon.couponId URLEncode],
                       @"0",
                       [weakSelf.priceId URLEncode],
                       [weakSelf.serviceIds URLEncode]];
            }else{
                url = [NSString stringWithFormat:@"ZYCouponChoiseVC?itemId=%@&categoryId=%@&selectedCouponId=%@&scene=%@&priceId=%@",
                       [weakSelf.itemId URLEncode],
                       [weakSelf.categoryId URLEncode],
                       [weakSelf.selectedCoupon.couponId URLEncode],
                       @"0",
                       [weakSelf.priceId URLEncode]];
            }
            [[ZYRouter router] goVC:url
                       withCallBack:^(_m_ListUserCoupon *model){
                           weakSelf.selectedCoupon = model;
                           //计算总价格
                           [weakSelf countTotalPrice];
                       }];
        }];
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
        return 3;
    }
    if(_confirmInfo.isHaveActivity){
        return 5 + _confirmInfo.addedPriceList.count;
    }
    return 4 + _confirmInfo.addedPriceList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak __typeof__(self) weakSelf = self;
    if(0 == indexPath.section){
        static NSString *identifier = @"ZYOrderConfirmVCAddressCell";
        ZYOrderConfirmAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell){
            cell = [[ZYOrderConfirmAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        if(self.selectedStore){
            cell.selfLiftingBtn.hidden = NO;
        }else{
            cell.selfLiftingBtn.hidden = YES;
        }
        if(_isMail){
            [cell selectBtn:cell.mailBtn];
            [cell showCellWithAddressModel:_selectedAddress];
        }else{
            [cell selectBtn:cell.selfLiftingBtn];
            [cell showCellWithStoreModel:_selectedStore];
        }
        
        [cell.mailBtn clickAction:^(UIButton * _Nonnull button) {
            weakSelf.isMail = YES;
            [tableView reloadData];
        }];
        [cell.selfLiftingBtn clickAction:^(UIButton * _Nonnull button) {
            weakSelf.isMail = NO;
            [tableView reloadData];
        }];
        return cell;
    }
    if(1 == indexPath.section){
        static NSString *identifier = @"ZYOrderConfirmVCItemCell";
        ZYItemCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell){
            cell = [[ZYItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        NSString *url = _confirmInfo.imageUrl;
        url = [url imageStyleUrl:CGSizeMake((ZYItemCellHeight - 30 * UI_H_SCALE) * 2, (ZYItemCellHeight - 30 * UI_H_SCALE) * 2)];
        [cell.itemIV loadImage:url];
        cell.titleLab.text = _confirmInfo.title;
        cell.skuLab.text = _confirmInfo.goodsSkuNames;
        cell.priceLab.text = _confirmInfo.rentPrice;
        
        return cell;
    }
    
    static NSString *identifier = @"ZYOrderConfirmVCDetailCell";
    ZYDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[ZYDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.separator.hidden = indexPath.row == 0;
    if(indexPath.section == 2 && indexPath.row == 0){
        //押金
        cell.titleLab.text = @"押金";
        cell.contentLab.text = [NSString stringWithFormat:@"￥%.2f",_confirmInfo.deposit];
        cell.contentLab.textColor = WORD_COLOR_BLACK;
        cell.showArrow = NO;
    }else if(indexPath.section == 2 && indexPath.row == 1){
        //减免押金
        cell.titleLab.text = @"减免押金";
        cell.contentLab.text = [NSString stringWithFormat:@"-￥%.2f",_confirmInfo.reductionDeposit];
        cell.contentLab.textColor = WORD_COLOR_ORANGE;
        cell.showArrow = NO;
    }else if(indexPath.section == 2 && indexPath.row == 2){
        //押金总额
        cell.titleLab.text = @"";
        cell.contentLab.textColor = WORD_COLOR_ORANGE;
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"押金：￥%.2f",_confirmInfo.payDeposit]];
        [str addAttribute:NSForegroundColorAttributeName value:WORD_COLOR_BLACK range:NSMakeRange(0, 3)];
        cell.contentLab.attributedText = str;
        cell.showArrow = NO;
        
        [cell.contentView addSubview:self.baseView.helpBtn];
        [self.baseView.helpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell.contentLab.mas_left).mas_offset(-10 * UI_H_SCALE);
            make.centerY.equalTo(cell.contentView);
        }];
        
    }else if(indexPath.section == 3 && indexPath.row == 0){
        //月租金
        if(_confirmInfo.rentType == ZYRentTypeLong){
            cell.titleLab.text = @"月租金";
        }else{
            cell.titleLab.text = @"日租金";
        }
        cell.contentLab.text = [NSString stringWithFormat:@"￥%.2f",_confirmInfo.monthPay];
        cell.contentLab.textColor = WORD_COLOR_BLACK;
        cell.showArrow = NO;
    }else if(indexPath.section == 3 && indexPath.row == 1){
        //租期
        cell.titleLab.text = @"租期";
        cell.contentLab.text = _confirmInfo.rentPeriod;
        cell.contentLab.textColor = WORD_COLOR_BLACK;
        cell.showArrow = NO;
    }else if(indexPath.section == 3 && indexPath.row >= 2 && indexPath.row < 2 + _confirmInfo.addedPriceList.count){
        //增值服务
        NSDictionary *service = _confirmInfo.addedPriceList[indexPath.row - 2];
        
        NSString *name = service[@"name"];
        NSMutableAttributedString *attTitle = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@(只需首期支付)",name]];
        [attTitle addAttribute:NSForegroundColorAttributeName value:WORD_COLOR_GRAY_9B range:NSMakeRange(name.length, 8)];
        cell.titleLab.attributedText = attTitle;
        
        cell.contentLab.text = [NSString stringWithFormat:@"￥%.2f",[service[@"price"] doubleValue]];
        cell.contentLab.textColor = WORD_COLOR_BLACK;
        cell.showArrow = NO;
    }else if(indexPath.section == 3 && indexPath.row == 2 + _confirmInfo.addedPriceList.count && _confirmInfo.isHaveActivity){
        //活动优惠
        if(!_confirmInfo.isSuperimposed){
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
            cell.contentLab.text = [NSString stringWithFormat:@"-￥%.2f",_confirmInfo.activityDiscountAmount];
        }
        cell.showArrow = NO;
    }else if(indexPath.section == 3 && ((indexPath.row == 3 + _confirmInfo.addedPriceList.count && _confirmInfo.isHaveActivity) || (indexPath.row == 2 + _confirmInfo.addedPriceList.count && !_confirmInfo.isHaveActivity))){
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
    }else if(indexPath.section == 3 && ((indexPath.row == 4 + _confirmInfo.addedPriceList.count && _confirmInfo.isHaveActivity) || (indexPath.row == 3 + _confirmInfo.addedPriceList.count && !_confirmInfo.isHaveActivity))){
        //首月租金
        
        cell.contentLab.textColor = WORD_COLOR_ORANGE;
        double rent = _confirmInfo.monthPay;
        if(_confirmInfo.rentType == ZYRentTypeShort){
            rent = _confirmInfo.monthPay * _confirmInfo.periods;
        }
        for(NSDictionary *service in _confirmInfo.addedPriceList){
            rent += [service[@"price"] doubleValue];
        }
        if(_selectedCoupon){
            rent = rent - _selectedCoupon.countDiscount - _selectedCoupon.activityDiscount;
        }else{
            rent = rent - _confirmInfo.activityDiscountAmount;
        }
        if(rent < 0){
            rent = 0;
        }
        if(_confirmInfo.rentType == ZYRentTypeLong){
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"首月租金：￥%.2f",rent]];
            [str addAttribute:NSForegroundColorAttributeName value:WORD_COLOR_BLACK range:NSMakeRange(0, 5)];
            cell.contentLab.attributedText = str;
        }else{
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"总租金：￥%.2f",rent]];
            [str addAttribute:NSForegroundColorAttributeName value:WORD_COLOR_BLACK range:NSMakeRange(0, 4)];
            cell.contentLab.attributedText = str;
        }
        cell.titleLab.text = @"";
        cell.showArrow = NO;
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

#pragma mark - getter
- (ZYOrderConfirmView *)baseView{
    if(!_baseView){
        _baseView = [ZYOrderConfirmView new];
        _baseView.tableView.delegate = self;
        _baseView.tableView.dataSource = self;
        
        __weak __typeof__(self) weakSelf = self;
        __weak __typeof__(_baseView) weakBaseView = _baseView;
        [_baseView.payBar.payBtn clickAction:^(UIButton * _Nonnull button) {
            [ZYStatisticsService event:@"order_confirm"];
            [[ZYLoginService service] requireLogin:^{
                [weakSelf createOrder];
            }];
        }];
        [_baseView.helpBtn clickAction:^(UIButton * _Nonnull button) {
            weakSelf.formulaView.formula = @"押金为免押额度不足时需要缴纳的保证金，当订单完结时，该保证金会原路返还到你的资金账户。";
            CGRect frame = [weakBaseView convertRect:weakBaseView.helpBtn.frame fromView:weakBaseView.helpBtn.superview];
            [weakSelf.formulaView showAtPoint:CGPointMake(CGRectGetMidX(frame),
                                                          CGRectGetMaxY(frame) + 4)];
        }];
        [_baseView.footer.protocolLab tapped:^(UITapGestureRecognizer *gesture) {
            [[ZYRouter router] goWithoutHead:[NSString stringWithFormat:@"web?url=%@",
                                              [[ZYH5Utils formatUrl:ZYH5TypeServiceAgreement param:weakSelf.itemId] URLEncode]]];
        } delegate:nil];
    }
    return _baseView;
}

- (ZYOrdeerConfirmRefreshView *)refreshView{
    if(!_refreshView){
        _refreshView = [ZYOrdeerConfirmRefreshView new];
        
        __weak __typeof__(self) weakSelf = self;
        [_refreshView.refreshBtn clickAction:^(UIButton * _Nonnull button) {
            [weakSelf loadDetail:YES];
        }];
    }
    return _refreshView;
}

- (ZYFormulaView *)formulaView{
    if(!_formulaView){
        _formulaView = [ZYFormulaView new];
    }
    return _formulaView;
}

@end
