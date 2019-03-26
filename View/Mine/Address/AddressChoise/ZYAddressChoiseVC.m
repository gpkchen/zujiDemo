//
//  ZYAddressChoiseVC.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/25.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYAddressChoiseVC.h"
#import "ZYAddressChoiseView.h"
#import "ZYAddressChoiseCell.h"
#import "AddressList.h"

@interface ZYAddressChoiseVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) ZYAddressChoiseView *baseView;
@property (nonatomic , strong) NSMutableArray *addresses;

@end

@implementation ZYAddressChoiseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = self.baseView;
    self.title = @"选择收货地址";
    self.rightBarItems = @[@"管理"];
    
    if(!_selectedAddressId){
        _selectedAddressId = self.dicParam[@"selectedAddressId"];
    }
    
    [self showLoadingView];
    [self loadData:NO];
}

- (void)rightBarItemsAction:(int)index{
    __weak __typeof__(self) weakSelf = self;
    [[ZYRouter router] goVC:@"ZYAddressManageVC" withCallBack:^{
        [weakSelf loadData:NO];
    }];
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
                                
                                //检测前个页面选中的地址是否还在
                                if(self.selectedAddressId){
                                    BOOL isExist = NO;
                                    for(_m_AddressList *model in self.addresses){
                                        if([model.addressId isEqualToString:self.selectedAddressId]){
                                            isExist = YES;
                                            break;
                                        }
                                    }
                                    if(!isExist){
                                        void (^callBack)(_m_AddressList *model) = self.callBack;
                                        !callBack ? : callBack(nil);
                                    }
                                }
                                
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

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ZYAddressChoiseCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
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
    
    _m_AddressList *model = self.addresses[indexPath.row];
    void (^callBack)(_m_AddressList *model) = self.callBack;
    !callBack ? : callBack(model);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.addresses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ZYAddressChoiseVCCell";
    ZYAddressChoiseCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[ZYAddressChoiseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell showCellWithModel:self.addresses[indexPath.row]];
    cell.separator.hidden = indexPath.row == 0;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark - getter
- (NSMutableArray *)addresses{
    if(!_addresses){
        _addresses = [NSMutableArray array];
    }
    return _addresses;
}

- (ZYAddressChoiseView *)baseView{
    if(!_baseView){
        _baseView = [ZYAddressChoiseView new];
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
