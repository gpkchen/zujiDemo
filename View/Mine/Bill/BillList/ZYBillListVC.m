//
//  ZYBillListVC.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/20.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBillListVC.h"
#import "ZYBillListView.h"
#import "ZYBillListCell.h"
#import "ZYBillListPayCell.h"
#import "ZYBillListHeader.h"
#import "GetRepaymentBillList.h"

@interface ZYBillListVC ()<UITableViewDelegate , UITableViewDataSource>

@property (nonatomic , strong) ZYBillListView *baseView;

@property (nonatomic , strong) NSArray *billArr;

@end

@implementation ZYBillListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = self.baseView;
    self.title = @"账单列表";
    
    [self showLoadingView];
    [self loadBills:NO];
}

#pragma mark - 获取账单列表
- (void)loadBills:(BOOL)showHud{
    _p_GetRepaymentBillList *param = [_p_GetRepaymentBillList new];
    [[ZYHttpClient client] post:param
                        showHud:showHud
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            [self hideLoadingView];
                            [self hideErrorView];
                            [self.baseView.tableView.mj_header endRefreshing];
                            if(responseObj.isSuccess){
                                self.billArr = [_m_GetRepaymentBillList mj_objectArrayWithKeyValuesArray:responseObj.data];
                                for(_m_GetRepaymentBillList *order in self.billArr){
                                    for(_m_GetRepaymentBillList_Bill *bill in order.billList){
                                        bill.rentType = order.rentType;
                                    }
                                }
                                [self.baseView.tableView reloadData];
                                if(!self.billArr.count){
                                    [self showNoBillView];
                                }
                            }else{
                                [ZYToast showWithTitle:responseObj.message];
                            }
                        } failure:^(NSURLSessionDataTask *task, NSError *error) {
                            [self hideLoadingView];
                            [self hideErrorView];
                            [self.baseView.tableView.mj_header endRefreshing];
                            
                            __weak __typeof__(self) weakSelf = self;
                            if(self.billArr.count){
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
                                        [weakSelf loadBills:YES];
                                    }];
                                }else if(error.code == ZYHttpErrorCodeNoNet){
                                    [self showNoNetView:^{
                                        [weakSelf loadBills:YES];
                                    }];
                                }else if(error.code == ZYHttpErrorCodeSystemError){
                                    [self showSystemErrorView:^{
                                        [weakSelf loadBills:YES];
                                    }];
                                }
                            }
                        } authFail:^{
                            [self hideLoadingView];
                            [self hideErrorView];
                            [self.baseView.tableView.mj_header endRefreshing];
                        }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    _m_GetRepaymentBillList *model = self.billArr[indexPath.section];
    if(indexPath.row < model.billList.count){
        return ZYBillListCellHeight;
    }
    return ZYBillListPayCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return ZYBillListHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10 * UI_H_SCALE;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    static NSString * identifier = @"ZYBillListVCHeader";
    ZYBillListHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if(!header){
        header = [[ZYBillListHeader alloc] initWithReuseIdentifier:identifier];
    }
    _m_GetRepaymentBillList *model = self.billArr[section];
    [header showHeaderWithModel:model];
    header.isOpened = model.isOpen;
    __weak __typeof__(self) weakSelf = self;
    [header.openBtn clickAction:^(UIButton * _Nonnull button) {
        model.isOpen = !model.isOpen;
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
    }];
    [header.detailBtn clickAction:^(UIButton * _Nonnull button) {
        [[ZYRouter router] goWithoutHead:[NSString stringWithFormat:@"billDetail?orderId=%@",[model.orderId URLEncode]]];
    }];
    [header.payBtn clickAction:^(UIButton * _Nonnull button) {
        [[ZYRouter router] goVC:[NSString stringWithFormat:@"ZYBillConfirmVC?orderId=%@&billId=%@",
                                 [model.orderId URLEncode],
                                 [model.billId URLEncode]] withCallBack:^{
            [weakSelf loadBills:NO];
        }];
    }];
    return header;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footer = [UIView new];
    footer.backgroundColor = VIEW_COLOR;
    return footer;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    _m_GetRepaymentBillList *model = self.billArr[section];
    if(model.isOpen){
        return model.billList.count + 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak __typeof__(self) weakSelf = self;
    _m_GetRepaymentBillList *model = self.billArr[indexPath.section];
    if(indexPath.row < model.billList.count){
        static NSString * identifier = @"ZYBillListVCCell";
        ZYBillListCell *cell = (ZYBillListCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell){
            cell = [[ZYBillListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.separator.hidden = indexPath.row == 0;
        _m_GetRepaymentBillList_Bill *bill = model.billList[indexPath.row];
        [cell showCellWithModel:bill];
        
        return cell;
    }
    
    static NSString * identifier = @"ZYBillListVCPayBtnCell";
    ZYBillListPayCell *cell = (ZYBillListPayCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[ZYBillListPayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if(model.isPayAllBills || model.billStatus == ZYBillStateCanceled){
        cell.payBtn.enabled = NO;
    }else{
        cell.payBtn.enabled = YES;
    }
    [cell.payBtn clickAction:^(UIButton * _Nonnull button) {
        [ZYStatisticsService event:@"billlist_payall"];
        [[ZYRouter router] goVC:[NSString stringWithFormat:@"ZYBillConfirmVC?orderId=%@",
                                 [model.orderId URLEncode]] withCallBack:^{
            [weakSelf loadBills:NO];
        }];
    }];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.billArr.count;
}

#pragma mark - getter
- (ZYBillListView *)baseView{
    if(!_baseView){
        _baseView = [ZYBillListView new];
        _baseView.tableView.delegate = self;
        _baseView.tableView.dataSource = self;
        
        __weak __typeof__(self) weakSelf = self;
        [_baseView.tableView addRefreshHeaderWithBlock:^{
            [weakSelf loadBills:NO];
        }];
    }
    return _baseView;
}

- (NSArray *)billArr{
    if(!_billArr){
        _billArr = [NSArray array];
    }
    return _billArr;
}

@end
