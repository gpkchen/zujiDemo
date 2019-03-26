//
//  ZYBillDetailVC.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/28.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBillDetailVC.h"
#import "ZYBillDetailView.h"
#import "ZYBillDetailCell.h"
#import "ZYBillDetailItemCell.h"
#import "GetOrderBillDetail.h"

@interface ZYBillDetailVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) ZYBillDetailView *baseView;

@property (nonatomic , strong) _m_GetOrderBillDetail *detail; //数据源

@end

@implementation ZYBillDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = self.baseView;
    self.title = @"账单详情";
    
    if(!_orderId){
        _orderId = self.dicParam[@"orderId"];
    }
    
    [self showLoadingView];
    [self loadDetail:NO];
}

#pragma mark - 加载账单详情信息
- (void)loadDetail:(BOOL)showHud{
    _p_GetOrderBillDetail *param = [_p_GetOrderBillDetail new];
    param.orderId = _orderId;
    [[ZYHttpClient client] post:param
                        showHud:showHud
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            [self hideLoadingView];
                            [self hideErrorView];
                            if(responseObj.isSuccess){
                                self.detail = [_m_GetOrderBillDetail mj_objectWithKeyValues:responseObj.data];
                                for(_m_GetOrderBillDetail_Bill *bill in self.detail.billList){
                                    bill.rentType = self.detail.rentType;
                                }
                                if(self.detail.isPayAllBills){
                                    self.baseView.payBtn.enabled = NO;
                                }else{
                                    self.baseView.payBtn.enabled = YES;
                                }
                                [self.baseView.tableView reloadData];
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

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(0 == indexPath.section){
        return ZYBillDetailItemCellHeight;
    }
    return ZYBillDetailCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(0 == section){
        return 0.01;
    }
    return ZYBillDetailHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(0 == section){
        return 10 * UI_H_SCALE;
    }
    return 0.01;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(1 == section){
        [self.baseView.header showHeaderWithModel:_detail];
        return self.baseView.header;
    }
    return [UIView new];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(0 == section){
        return 1;
    }
    return _detail.billList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak __typeof__(self) weakSelf = self;
    if(0 == indexPath.section){
        static NSString *identifier = @"ZYBillDetailVCItemCell";
        ZYBillDetailItemCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell){
            cell = [[ZYBillDetailItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell showCellWithModel:_detail];
        return cell;
    }
    static NSString *identifier = @"ZYBillDetailVCBillCell";
    ZYBillDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[ZYBillDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.separator.hidden = indexPath.row == 0;
    _m_GetOrderBillDetail_Bill *bill = self.detail.billList[indexPath.row];
    [cell showCellWithModel:bill];
    [cell.payBtn clickAction:^(UIButton * _Nonnull button) {
        [[ZYRouter router] goVC:[NSString stringWithFormat:@"ZYBillConfirmVC?orderId=%@&billId=%@",
                                 [weakSelf.orderId URLEncode],
                                 [bill.billId URLEncode]] withCallBack:^{
            [weakSelf loadDetail:NO];
        }];
    }];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

#pragma mark - getter
- (ZYBillDetailView *)baseView{
    if(!_baseView){
        _baseView = [ZYBillDetailView new];
        _baseView.tableView.delegate = self;
        _baseView.tableView.dataSource = self;
        
        __weak __typeof__(self) weakSelf = self;
        [_baseView.payBtn clickAction:^(UIButton * _Nonnull button) {
            [[ZYRouter router] goVC:[NSString stringWithFormat:@"ZYBillConfirmVC?orderId=%@",
                                     [weakSelf.orderId URLEncode]] withCallBack:^{
                [weakSelf loadDetail:NO];
            }];
        }];
    }
    return _baseView;
}

@end
