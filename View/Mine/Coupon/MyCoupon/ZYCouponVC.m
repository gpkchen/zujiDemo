//
//  ZYCouponVC.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/24.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYCouponVC.h"
#import "ZYCouponView.h"
#import "ZYCouponCell.h"
#import "ZYCouponFooter.h"

@interface ZYCouponVC ()<UITableViewDelegate , UITableViewDataSource>

@property (nonatomic , strong) ZYCouponView *baseView;
@property (nonatomic , strong) ZYCouponFooter *footer;
@property (nonatomic , strong) ZYElasticButton *instructionsBtn;
@property (nonatomic , strong) UILabel *totalLab;

@property (nonatomic , assign) BOOL isHistory;

@property (nonatomic , assign) int page;
@property (nonatomic , strong) NSMutableArray *couponArr;

@end

@implementation ZYCouponVC

- (instancetype)init{
    if(self = [super init]){
        self.showCustomNavigationBar= YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(!_status){
        _status = self.dicParam[@"status"];
    }
    _isHistory = ![@"0" isEqualToString:_status];
    
    self.view = self.baseView;
    
    
    if(_isHistory){
        self.title = @"历史失效券";
    }else{
        self.title = @"我的优惠券";
    }
    
    [self.customNavigationBar addSubview:self.totalLab];
    [self.totalLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.customNavigationBar).mas_offset(-15 * UI_H_SCALE);
        make.centerY.equalTo(self.customNavigationBar.mas_bottom).mas_offset(-30 * UI_H_SCALE);
    }];
    [self.customNavigationBar.fadeSubViews addObject:self.totalLab];
    
    [self.customNavigationBar addSubview:self.instructionsBtn];
    [self.instructionsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.customNavigationBar).mas_offset(-15 * UI_H_SCALE);
        make.top.equalTo(self.customNavigationBar).mas_offset(STATUSBAR_HEIGHT);
        make.bottom.equalTo(self.customNavigationBar.mas_top).mas_offset(NAVIGATION_BAR_HEIGHT);
        make.width.mas_equalTo(self.instructionsBtn.width);
    }];
    
    _page = 1;
    [self showLoadingView];
    [self loadCoupons:NO];
}

#pragma mark - 获取优惠券列表
- (void)loadCoupons:(BOOL)showHud{
    _p_ListUserCoupon *param = [_p_ListUserCoupon new];
    param.page = [NSString stringWithFormat:@"%d",_page];
    param.status = _status;
    [[ZYHttpClient client] post:param
                        showHud:showHud
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            [self hideLoadingView];
                            [self hideErrorView];
                            [self.baseView.tableView.mj_header endRefreshing];
                            [self.baseView.tableView.mj_footer endRefreshing];
                            if(responseObj.isSuccess){
                                if(1 == self.page){
                                    [self.couponArr removeAllObjects];
                                }
                                NSArray *arr = responseObj.data[@"rows"];
                                int totalCount = [responseObj.data[@"totalCount"] intValue];
                                self.totalLab.text = [NSString stringWithFormat:@"共%d张优惠券",totalCount];
                                self.totalLab.hidden = NO;
                                for(NSDictionary *dic in arr){
                                    _m_ListUserCoupon *model = [[_m_ListUserCoupon alloc] initWithDictionary:dic];
                                    [self.couponArr addObject:model];
                                }
                                if(self.couponArr.count >= totalCount){
                                    if(!self.isHistory){
                                        self.baseView.tableView.tableFooterView = self.footer;
                                    }
                                    [self.baseView.tableView.mj_footer endRefreshingWithNoMoreData];
                                }else{
                                    if(!self.isHistory){
                                        self.baseView.tableView.tableFooterView = nil;
                                    }
                                    [self.baseView.tableView.mj_footer resetNoMoreData];
                                }
                                [self.baseView.tableView reloadData];
                                if(!self.couponArr.count && self.isHistory){
                                    [self showNoCouponView:^{
                                        [[ZYRouter router] returnToRoot];
                                        [ZYMainTabVC shareInstance].selectedIndex = 1;
                                    }];
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
                            if(self.couponArr.count){
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
                                        [weakSelf loadCoupons:YES];
                                    }];
                                }else if(error.code == ZYHttpErrorCodeNoNet){
                                    [self showNoNetView:^{
                                        [weakSelf loadCoupons:YES];
                                    }];
                                }else if(error.code == ZYHttpErrorCodeSystemError){
                                    [self showSystemErrorView:^{
                                        [weakSelf loadCoupons:YES];
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

#pragma mark - UITableViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.customNavigationBar.pullY = scrollView.contentOffset.y + scrollView.scrollIndicatorInsets.top;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    _m_ListUserCoupon *model = self.couponArr[indexPath.section];
    if(model.isOpen){
        return model.cellOpenHeight;
    }
    return model.cellNormalHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15 * UI_H_SCALE;
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
    static NSString *identifier = @"ZYCouponVCCell";
    ZYCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[ZYCouponCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    _m_ListUserCoupon *model = self.couponArr[indexPath.section];
    if(_isHistory){
        [cell showHistoryCellWithModel:model];
    }else{
        [cell showCellWithModel:model];
    }
    
    [cell.openBtn clickAction:^(UIButton * _Nonnull button) {
        model.isOpen = !model.isOpen;
        [tableView reloadData];
    }];
    [cell.useBtn clickAction:^(UIButton * _Nonnull button) {
        [[ZYRouter router] returnToRoot];
        [ZYMainTabVC shareInstance].selectedIndex = 1;
    }];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.couponArr.count;
}


#pragma mark - getter
- (ZYCouponView *)baseView{
    if(!_baseView){
        _baseView = [ZYCouponView new];
        _baseView.tableView.delegate = self;
        _baseView.tableView.dataSource = self;
        
        __weak __typeof__(self) weakSelf = self;
        [_baseView.exchangeBtn clickAction:^(UIButton * _Nonnull button) {
            [[ZYRouter router] goVC:@"ZYExchaneCouponVC"];
        }];
        [_baseView.tableView addRefreshHeaderWithBlock:^{
            weakSelf.page = 1;
            [weakSelf loadCoupons:NO];
        }];
        if(_isHistory){
            [_baseView.tableView addRefreshFooterWithBlock:^{
                weakSelf.page++;
                [weakSelf loadCoupons:NO];
            }];
        }else{
            [_baseView.tableView addRefreshFooterWithTitle:@"" block:^{
                weakSelf.page++;
                [weakSelf loadCoupons:NO];
            }];
        }
    }
    return _baseView;
}

- (ZYCouponFooter *)footer{
    if(!_footer){
        _footer = [ZYCouponFooter new];
        
        [_footer.historyLab tapped:^(UITapGestureRecognizer *gesture) {
            [[ZYRouter router] goVC:@"ZYCouponVC?status=3"];
        } delegate:nil];
    }
    return _footer;
}

- (NSMutableArray *)couponArr{
    if(!_couponArr){
        _couponArr = [NSMutableArray array];
    }
    return _couponArr;
}

- (ZYElasticButton *)instructionsBtn{
    if(!_instructionsBtn){
        _instructionsBtn = [ZYElasticButton new];
        _instructionsBtn.font = FONT(15);
        [_instructionsBtn setTitle:@"使用说明" forState:UIControlStateNormal];
        [_instructionsBtn setTitleColor:WORD_COLOR_BLACK forState:UIControlStateNormal];
        [_instructionsBtn setTitleColor:WORD_COLOR_BLACK forState:UIControlStateHighlighted];
        [_instructionsBtn sizeToFit];
        
        [_instructionsBtn clickAction:^(UIButton * _Nonnull button) {
            [[ZYRouter router] goWithoutHead:[NSString stringWithFormat:@"web?url=%@",
                                              [[ZYH5Utils formatUrl:ZYH5TypeCoupon param:nil] URLEncode]]];
        }];
    }
    return _instructionsBtn;
}

- (UILabel *)totalLab{
    if(!_totalLab){
        _totalLab = [UILabel new];
        _totalLab.textColor = WORD_COLOR_GRAY_9B;
        _totalLab.font = FONT(15);
        _totalLab.hidden = YES;
    }
    return _totalLab;
}

@end
