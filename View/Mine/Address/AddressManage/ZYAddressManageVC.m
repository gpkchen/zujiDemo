//
//  ZYAddressManageVC.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/25.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYAddressManageVC.h"
#import "ZYAddressManageView.h"
#import "ZYAddressManageCell.h"
#import "AddressList.h"
#import "AddressDelete.h"
#import "AddressDefault.h"

@interface ZYAddressManageVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) ZYAddressManageView *baseView;
@property (nonatomic , strong) NSMutableArray *addresses;

@end

@implementation ZYAddressManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = self.baseView;
    self.title = @"我的地址";
    
    [self showLoadingView];
    [self loadData:NO];
}

- (void)systemBackButtonClicked{
    void (^backCallBack)(void) = self.callBack;
    !backCallBack ? : backCallBack();
    [super systemBackButtonClicked];
}

#pragma mark - 获取地址列表
- (void)loadData:(BOOL)showHud{
    _p_AddressList *param = [_p_AddressList new];
    [[ZYHttpClient client] post:param
                        showHud:showHud
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            [self hideLoadingView];
                            [self hideErrorView];
                            [self.baseView.tableView.mj_header endRefreshing];
                            if(responseObj.isSuccess){
                                [self.addresses removeAllObjects];
                                NSArray *arr = responseObj.data[@"cows"];
                                self.addresses = [_m_AddressList mj_objectArrayWithKeyValuesArray:arr];
                                [self.baseView.tableView reloadData];
                                if(!self.addresses.count){
                                    __weak __typeof__(self) weakSelf = self;
                                    [self showNoAddressView:^{
                                        [[ZYRouter router] goVC:@"ZYAddAddressVC" withCallBack:^{
                                            [weakSelf loadData:YES];
                                        }];
                                    }];
                                }
                            }else{
                                [ZYToast showWithTitle:responseObj.message];
                            }
                        } failure:^(NSURLSessionDataTask *task, NSError *error) {
                            [self hideLoadingView];
                            [self hideErrorView];
                            [self.baseView.tableView.mj_header endRefreshing];
                            __weak __typeof__(self) weakSelf = self;
                            if(self.addresses.count){
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
                                }else if(error.code == ZYHttpErrorCodeNoNet){
                                    [self showNoNetView:^{
                                        [weakSelf loadData:YES];
                                    }];
                                }else if(error.code == ZYHttpErrorCodeSystemError){
                                    [self showSystemErrorView:^{
                                        [weakSelf loadData:YES];
                                    }];
                                }
                            }
                        } authFail:^{
                            [self hideLoadingView];
                            [self hideErrorView];
                            [self.baseView.tableView.mj_header endRefreshing];
                        }];
}

#pragma mark - 删除地址
- (void)deleteAddress:(_m_AddressList *)address{
    _p_AddressDelete *param = [_p_AddressDelete new];
    param.addressId = address.addressId;
    [[ZYHttpClient client] post:param
                        showHud:YES
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            if(responseObj.isSuccess){
                                [self loadData:NO];
                                [ZYToast showWithTitle:@"地址删除成功"];
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

#pragma mark - 设为默认地址
- (void)setDefault:(_m_AddressList *)address{
    _p_AddressDefault *param = [_p_AddressDefault new];
    param.addressId = address.addressId;
    [[ZYHttpClient client] post:param
                        showHud:YES
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            if(responseObj.isSuccess){
                                for(_m_AddressList *model in self.addresses){
                                    if([model isEqual:address]){
                                        model.isDefault = YES;
                                    }else{
                                        model.isDefault = NO;
                                    }
                                }
                                [self.baseView.tableView reloadData];
                                [ZYToast showWithTitle:@"设置默认地址成功"];
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

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ZYAddressManageCellHeight;
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
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ZYAddressManageVCCell";
    ZYAddressManageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[ZYAddressManageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    _m_AddressList *model = self.addresses[indexPath.section];
    [cell showCellWithModel:model];
    
    __weak __typeof__(self) weakSelf = self;
    [cell.deleteBtn clickAction:^(UIButton * _Nonnull button) {
        [ZYAlert showWithTitle:nil
                       content:@"确定要删除该地址吗？"
                  buttonTitles:@[@"取消",@"确定"]
                  buttonAction:^(ZYAlert *alert, int index) {
                      if(1 == index){
                          [weakSelf deleteAddress:model];
                      }
                      [alert dismiss];
                  }];
    }];
    [cell.defaultBtn clickAction:^(UIButton * _Nonnull button) {
        if(model.isDefault){
            return;
        }
        [ZYAlert showWithTitle:nil
                       content:@"确定要设置该地址为默认地址吗？"
                  buttonTitles:@[@"取消",@"确定"]
                  buttonAction:^(ZYAlert *alert, int index) {
                      if(1 == index){
                          [weakSelf setDefault:model];
                      }
                      [alert dismiss];
                  }];
    }];
    [cell.editBtn clickAction:^(UIButton * _Nonnull button) {
        [[ZYRouter router] goWithoutHead:[NSString stringWithFormat:@"ZYAddAddressVC?addressId=%@",[model.addressId URLEncode]] withCallBack:^{
            [weakSelf loadData:NO];
        }];
    }];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.addresses.count;
}


#pragma mark - getter
- (NSMutableArray *)addresses{
    if(!_addresses){
        _addresses = [NSMutableArray array];
    }
    return _addresses;
}

- (ZYAddressManageView *)baseView{
    if(!_baseView){
        _baseView = [ZYAddressManageView new];
        _baseView.tableView.delegate = self;
        _baseView.tableView.dataSource = self;
        
        __weak __typeof__(self) weakSelf = self;
        [_baseView.addBtn clickAction:^(UIButton * _Nonnull button) {
            [[ZYRouter router] goVC:@"ZYAddAddressVC" withCallBack:^{
                [weakSelf loadData:NO];
            }];
        }];
        [_baseView.tableView addRefreshHeaderWithBlock:^{
            [weakSelf loadData:NO];
        }];
    }
    return _baseView;
}

@end
