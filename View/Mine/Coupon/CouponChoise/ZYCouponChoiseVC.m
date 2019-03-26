//
//  ZYCouponChoiseVC.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/28.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYCouponChoiseVC.h"
#import "ZYCouponChoiseView.h"
#import "ZYCouponCell.h"
#import "GetCouponList.h"
#import "ZYCouponFooter.h"
#import "ZYCouponChoiseCancelCell.h"

@interface ZYCouponChoiseVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) ZYCouponChoiseView *baseView;
@property (nonatomic , strong) ZYCouponFooter *footer;
@property (nonatomic , strong) ZYElasticButton *instructionsBtn;
@property (nonatomic , strong) UILabel *totalLab;

@property (nonatomic , assign) int page;
@property (nonatomic , strong) NSMutableArray *couponArr;

@end

@implementation ZYCouponChoiseVC

- (instancetype)init{
    if(self = [super init]){
        self.showCustomNavigationBar = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = self.baseView;
    self.title = @"选择优惠券";
    self.rightBarItems = @[@"使用说明"];
    
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
    
    if(!_itemId){
        _itemId = self.dicParam[@"itemId"];
    }
    if(!_categoryId){
        _categoryId = self.dicParam[@"categoryId"];
    }
    if(!_selectedCouponId){
        _selectedCouponId = self.dicParam[@"selectedCouponId"];
    }
    if(!_scene){
        _scene = self.dicParam[@"scene"];
    }
    if(!_priceId){
        _priceId = self.dicParam[@"priceId"];
    }
    if(!_serviceIds){
        _serviceIds = self.dicParam[@"serviceIds"];
    }
    if(!_billIds){
        _billIds = self.dicParam[@"billIds"];
    }
    if(!_billPayType){
        _billPayType = self.dicParam[@"billPayType"];
    }
    if(!_orderId){
        _orderId = self.dicParam[@"orderId"];
    }
    if(!_rentPeriod){
        _rentPeriod = self.dicParam[@"rentPeriod"];
    }
    
    _page = 1;
    [self showLoadingView];
    [self loadCoupons:NO];
}

- (void)rightBarItemsAction:(int)index{
    [[ZYRouter router] goWithoutHead:[NSString stringWithFormat:@"web?url=%@",
                                      [[ZYH5Utils formatUrl:ZYH5TypeCoupon param:nil] URLEncode]]];
}

#pragma mark - 获取优惠券列表
- (void)loadCoupons:(BOOL)showHud{
    _p_GetCouponList *param = [_p_GetCouponList new];
    param.page = [NSString stringWithFormat:@"%d",_page];
    param.scene = _scene;
    param.itemId = _itemId;
    param.categoryId = _categoryId;
    param.priceId = _priceId;
    param.serviceIds = _serviceIds;
    param.billIds = _billIds;
    param.billPayType = _billPayType;
    param.orderId = _orderId;
    param.rentPeriod = _rentPeriod;
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
                                    self.baseView.tableView.tableFooterView = self.footer;
                                    [self.baseView.tableView.mj_footer endRefreshingWithNoMoreData];
                                }else{
                                    self.baseView.tableView.tableFooterView = nil;
                                    [self.baseView.tableView.mj_footer resetNoMoreData];
                                }
                                [self.baseView.tableView reloadData];
                                if(!self.couponArr.count){
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
    if(0 == indexPath.section){
        return ZYCouponChoiseCancelCellHeight;
    }
    _m_ListUserCoupon *model = self.couponArr[indexPath.section-1];
    if(model.isOpen){
        return model.cellOpenHeight;
    }
    return model.cellNormalHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section < 2){
        return 0.01;
    }
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
    
    _m_ListUserCoupon *model = nil;
    if(indexPath.section > 0){
        model = self.couponArr[indexPath.section - 1];
    }
    void (^callBack)(_m_ListUserCoupon *model) = self.callBack;
    !callBack ? : callBack(model);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(0 == indexPath.section){
        static NSString *identifier = @"ZYCouponChoiseVCCancelCell";
        ZYCouponChoiseCancelCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell){
            cell = [[ZYCouponChoiseCancelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        if([NSString isBlank:_selectedCouponId]){
            cell.choosed = YES;
        }else{
            cell.choosed = NO;
        }
        return cell;
    }
    static NSString *identifier = @"ZYCouponChoiseVCCell";
    ZYCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[ZYCouponCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    _m_ListUserCoupon *model = self.couponArr[indexPath.section - 1];
    [cell showChooseCellWithModel:model];
    [cell.openBtn clickAction:^(UIButton * _Nonnull button) {
        model.isOpen = !model.isOpen;
        [tableView reloadData];
    }];
    if([_selectedCouponId isEqualToString:model.couponId]){
        cell.choosed = YES;
    }else{
        cell.choosed = NO;
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.couponArr.count + 1;
}

#pragma mark - getter
- (ZYCouponChoiseView *)baseView{
    if(!_baseView){
        _baseView = [ZYCouponChoiseView new];
        _baseView.tableView.delegate = self;
        _baseView.tableView.dataSource = self;
        
        __weak __typeof__(self) weakSelf = self;
        [_baseView.tableView addRefreshHeaderWithBlock:^{
            weakSelf.page = 1;
            [weakSelf loadCoupons:NO];
        }];
        [_baseView.tableView addRefreshFooterWithTitle:@"" block:^{
            weakSelf.page++;
            [weakSelf loadCoupons:NO];
        }];
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

- (NSMutableArray *)couponArr {
    if(!_couponArr){
        _couponArr = [NSMutableArray array];
    }
    return _couponArr;
}

@end
