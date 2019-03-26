//
//  ZYReturnVC.m
//  Apollo
//
//  Created by 李明伟 on 2018/11/6.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import "ZYReturnVC.h"
#import "ZYReturnView.h"
#import "ZYReturnCell.h"
#import "ZYReturnHeader.h"
#import "ZYReturnFooter.h"
#import "GetMerchantAddressList.h"
#import "ZYReturnExpressSelector.h"
#import "ZYExpressCodeInput.h"
#import "BackItemExpress.h"
#import "ZYLocationUtils.h"

@interface ZYReturnVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) ZYReturnView *baseView;
@property (nonatomic , strong) ZYReturnHeader *header;
@property (nonatomic , strong) ZYReturnFooter *footer;
@property (nonatomic , strong) ZYReturnExpressSelector *expressSelector;
@property (nonatomic , strong) ZYExpressCodeInput *codeInput;

@property (nonatomic , assign) int page;
@property (nonatomic , strong) NSMutableArray *addresses;
@property (nonatomic , copy) NSString *selectedCompanyCode; //快递公司号
@property (nonatomic , copy) NSString *expressCode; //快递单号

@end

@implementation ZYReturnVC

- (instancetype)init{
    if(self = [super init]){
        self.showCustomNavigationBar = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = self.baseView;
    self.title = @"归还";
    
    if(!_orderId){
        _orderId = self.dicParam[@"orderId"];
    }
    if(!_addressUseScene){
        _addressUseScene = self.dicParam[@"addressUseScene"];
    }
    
    if([@"1" isEqualToString:_addressUseScene]){
        self.baseView.mode = 2;
    }
    
    _page = 1;
    [self showLoadingView];
    [self loadData:NO];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

#pragma mark - 获取地址列表
- (void)loadData:(BOOL)showHud{
    _p_GetMerchantAddressList *param = [_p_GetMerchantAddressList new];
    param.page = [NSString stringWithFormat:@"%d",_page];
    param.addressUseScene = _addressUseScene;
    param.orderId = _orderId;
    param.latitude = [ZYLocationUtils utils].userLocation.latitude;
    param.longitude = [ZYLocationUtils utils].userLocation.longitude;
    [[ZYHttpClient client] post:param
                        showHud:showHud
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            [self hideLoadingView];
                            [self hideErrorView];
                            [self.baseView.tableView.mj_header endRefreshing];
                            [self.baseView.tableView.mj_footer endRefreshing];
                            if(responseObj.isSuccess){
                                if(1 == self.page){
                                    [self.addresses removeAllObjects];
                                }
                                NSArray *arr = responseObj.data[@"rows"];
                                int totalCount = [responseObj.data[@"totalCount"] intValue];
                                for(NSDictionary *dic in arr){
                                    _m_GetMerchantAddressList *model = [_m_GetMerchantAddressList mj_objectWithKeyValues:dic];
                                    model.cellHeight = [self countCellHeight:model];
                                    [self.addresses addObject:model];
                                }
                                if([@"1" isEqualToString:self.addressUseScene]){
                                    self.header.title = @"请在租期结束前选择以下任意门店交付商品";
                                }else{
                                    self.header.title = @"请在租期结束前选择以下任意地址寄回商品";
                                }
                                self.header.content = responseObj.data[@"remarks"];
                                if(self.addresses.count >= totalCount){
                                    [self.baseView.tableView.mj_footer endRefreshingWithNoMoreData];
                                }else{
                                    [self.baseView.tableView.mj_footer resetNoMoreData];
                                }
                                
                                BOOL flag = [responseObj.data[@"flag"] boolValue];
                                if([@"2" isEqualToString:self.addressUseScene]){
                                    if(flag){
                                        [self.baseView.mailBtn setTitle:@"已邮寄，修改运单号" forState:UIControlStateNormal];
                                    }else{
                                        [self.baseView.mailBtn setTitle:@"已邮寄，填写运单号" forState:UIControlStateNormal];
                                    }
                                }
                                
                                if(!self.addresses.count){
                                    if([@"1" isEqualToString:self.addressUseScene]){
                                        self.footer.title = @"暂无支持线下归还的门店\n请选择邮寄归还。";
                                    }else if([@"2" isEqualToString:self.addressUseScene]){
                                        self.footer.title = @"暂无支持邮寄归还的门店\n请选择线下归还。";
                                    }
                                    self.baseView.tableView.tableFooterView = self.footer;
                                    if([@"1" isEqualToString:self.addressUseScene]){
                                        self.baseView.mode = 3;
                                    }
                                }else{
                                    self.baseView.tableView.tableFooterView = nil;
                                    if([@"1" isEqualToString:self.addressUseScene]){
                                        self.baseView.mode = 2;
                                    }
                                }
                                self.baseView.tableView.tableHeaderView = self.header;
                                [self.baseView.tableView reloadData];
                                
                                if(!self.baseView.noticeView.isShowed &&
                                   !self.baseView.mailBtn.isHidden &&
                                   [@"2" isEqualToString:self.addressUseScene]){
                                    [self.baseView.noticeView show];
                                }
                            }else{
                                [ZYToast showWithTitle:responseObj.message];
                            }
                        } failure:^(NSURLSessionDataTask *task, NSError *error) {
                            [self hideLoadingView];
                            [self hideErrorView];
                            [self.baseView.tableView.mj_header endRefreshing];
                            [self.baseView.tableView.mj_footer endRefreshing];
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
                            [self.baseView.tableView.mj_footer endRefreshing];
                        }];
}

#pragma mark - 归还商品
- (void)returnItem{
    _p_BackItemExpress *param = [_p_BackItemExpress new];
    param.orderId = _orderId;
    param.expressNo = _expressCode;
    param.companyCode = _selectedCompanyCode;
    [[ZYHttpClient client] post:param
                        showHud:YES
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            if(responseObj.isSuccess){
                                [ZYToast showWithTitle:@"快递单号提交成功"];
                                [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark - 计算cell高度
- (CGFloat)countCellHeight:(_m_GetMerchantAddressList *)model{
    CGFloat addressHeight = [model.completeAddress boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30 * UI_H_SCALE - 19, CGFLOAT_MAX)
                                                                options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                                             attributes:@{NSFontAttributeName:FONT(15)}
                                                                context:nil].size.height;
    if(model.distance){
        return addressHeight + 78 * UI_H_SCALE;
    }else{
        return addressHeight + 60 * UI_H_SCALE;
    }
}

#pragma mark - UITableViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.customNavigationBar.pullY = scrollView.contentOffset.y + scrollView.contentInset.top;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    _m_GetMerchantAddressList *model = self.addresses[indexPath.section];
    return model.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20* UI_H_SCALE;
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
    static NSString *identifier = @"ZYReturnVCCell";
    ZYReturnCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[ZYReturnCell alloc] initWithReuseIdentifier:identifier];
    }
    _m_GetMerchantAddressList *model = self.addresses[indexPath.section];
    [cell showCellWithModel:model];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.addresses.count;
}

#pragma mark - getter
- (ZYReturnView *)baseView{
    if(!_baseView){
        _baseView = [ZYReturnView new];
        _baseView.tableView.delegate = self;
        _baseView.tableView.dataSource = self;
        
        __weak __typeof__(_baseView) weakBaseView = _baseView;
        __weak __typeof__(self) weakSelf = self;
        [_baseView.mailBtn clickAction:^(UIButton * _Nonnull button) {
            [weakBaseView.noticeView dismiss];
            
            if([@"1" isEqualToString:weakSelf.addressUseScene]){
                [[ZYRouter router] goVC:[NSString stringWithFormat:@"ZYReturnVC?orderId=%@&addressUseScene=%@",[weakSelf.orderId URLEncode],@"2"] withCallBack:nil isPush:YES completion:^{
                    NSArray *vcs = self.navigationController.viewControllers;
                    NSMutableArray *tmpVCs = [NSMutableArray arrayWithArray:vcs];
                    [tmpVCs removeObject:self];
                    self.navigationController.viewControllers = tmpVCs;
                }];
            }else{
                [weakSelf.expressSelector show];
            }
        }];
        [_baseView.tableView addRefreshHeaderWithBlock:^{
            weakSelf.page = 1;
            [weakSelf loadData:NO];
        }];
        [_baseView.tableView addRefreshFooterWithBlock:^{
            weakSelf.page++;
            [weakSelf loadData:NO];
        }];
    }
    return _baseView;
}

- (ZYReturnHeader *)header{
    if(!_header){
        _header = [ZYReturnHeader new];
    }
    return _header;
}

- (ZYReturnFooter *)footer{
    if(!_footer){
        _footer = [ZYReturnFooter new];
    }
    return _footer;
}

- (ZYReturnExpressSelector *)expressSelector{
    if(!_expressSelector){
        _expressSelector = [ZYReturnExpressSelector new];
        
        __weak __typeof__(self) weakSelf = self;
        _expressSelector.selectionAction = ^(NSString * _Nonnull code) {
            weakSelf.selectedCompanyCode = code;
            [weakSelf.codeInput show];
        };
    }
    return _expressSelector;
}

- (ZYExpressCodeInput *)codeInput{
    if(!_codeInput){
        _codeInput = [ZYExpressCodeInput new];
        
        __weak __typeof__(self) weakSelf = self;
        _codeInput.confirmBlock = ^(NSString * _Nonnull code) {
            weakSelf.expressCode = code;
            [weakSelf returnItem];
        };
    }
    return _codeInput;
}

- (NSMutableArray *)addresses{
    if(!_addresses){
        _addresses = [NSMutableArray array];
    }
    return _addresses;
}

@end
