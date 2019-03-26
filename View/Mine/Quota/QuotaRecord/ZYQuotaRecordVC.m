
//
//  ZYQuotaRecordVC.m
//  Apollo
//
//  Created by 李明伟 on 2018/10/31.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import "ZYQuotaRecordVC.h"
#import "ZYQuotaRecordView.h"
#import "LimitRecord.h"
#import "ZYQuotaRecordCell.h"
#import "ZYQuotaVC.h"
#import "ZYMineVC.h"

@interface ZYQuotaRecordVC ()<UITableViewDelegate , UITableViewDataSource>

@property (nonatomic , strong) ZYQuotaRecordView *baseView;

@property (nonatomic , assign) int page;
@property (nonatomic , strong) NSMutableArray *records;

@end

@implementation ZYQuotaRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = self.baseView;
    self.title = @"变更记录";
    self.rightBarItems = @[self.baseView.instructionBtn];
    
    _page = 1;
    [self showLoadingView];
    [self loadRecords:NO];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:UIColor.clearColor]];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:NAVIGATIONBAR_SHADOW_COLOR]];
}

- (void)rightBarItemsAction:(int)index{
    [[ZYRouter router] goWithoutHead:[NSString stringWithFormat:@"web?url=%@",
                                      [[ZYH5Utils formatUrl:ZYH5TypeLimitRecord param:nil] URLEncode]]];
}

#pragma mark - 去认证
- (void)goAuth{
    NSArray *vcs = self.navigationController.viewControllers;
    for(UIViewController *vc in vcs){
        if([vc isKindOfClass:[ZYMineVC class]]){
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    [[ZYRouter router] returnToRoot];
    [ZYMainTabVC shareInstance].selectedIndex = 3;
}

#pragma mark - 获取记录列表
- (void)loadRecords:(BOOL)showHud{
    _p_LimitRecord *param = [_p_LimitRecord new];
    param.page = [NSString stringWithFormat:@"%d",_page];
    [[ZYHttpClient client] post:param
                        showHud:showHud
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            [self hideLoadingView];
                            [self hideErrorView];
                            [self.baseView.tableView.mj_header endRefreshing];
                            [self.baseView.tableView.mj_footer endRefreshing];
                            if(responseObj.isSuccess){
                                if(1 == self.page){
                                    [self.records removeAllObjects];
                                }
                                NSArray *arr = responseObj.data[@"rows"];
                                int totalCount = [responseObj.data[@"totalCount"] intValue];
                                NSString *authAmount = responseObj.data[@"limit"];
                                if(![NSString isBlank:authAmount]){
                                    self.baseView.authAmount = [authAmount doubleValue];
                                }
                                NSString *creditAmount = responseObj.data[@"availableLimit"];
                                if(![NSString isBlank:creditAmount]){
                                    self.baseView.creditAmount = [creditAmount doubleValue];
                                }
                                for(NSDictionary *dic in arr){
                                    _m_LimitRecord *model = [[_m_LimitRecord alloc] initWithDictionary:dic];
                                    model.cellHeight = [self countCellHeight:model];
                                    [self.records addObject:model];
                                }
                                if(self.records.count >= totalCount){
                                    [self.baseView.tableView.mj_footer endRefreshingWithNoMoreData];
                                }else{
                                    [self.baseView.tableView.mj_footer resetNoMoreData];
                                }
                                [self.baseView.tableView reloadData];
                                if(!self.records.count){
                                    __weak __typeof__(self) weakSelf = self;
                                    [self showNoLimitRecordView:^{
                                        [weakSelf goAuth];
                                    }];
                                    [self.baseView bringSubviewToFront:self.baseView.amountBack];
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
                            if(self.records.count){
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
                                        [weakSelf loadRecords:YES];
                                    }];
                                }else if(error.code == ZYHttpErrorCodeNoNet){
                                    [self showNoNetView:^{
                                        [weakSelf loadRecords:YES];
                                    }];
                                }else if(error.code == ZYHttpErrorCodeSystemError){
                                    [self showSystemErrorView:^{
                                        [weakSelf loadRecords:YES];
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

#pragma mark - 计算cell高度
- (CGFloat)countCellHeight:(_m_LimitRecord *)model{
    CGFloat contentHeight = [model.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30 * UI_H_SCALE, CGFLOAT_MAX)
                                                        options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:@{NSFontAttributeName:FONT(14)}
                                                        context:nil].size.height;
    return contentHeight + 43 * UI_H_SCALE + 37 * UI_H_SCALE;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    _m_LimitRecord *model = self.records[indexPath.row];
    return model.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
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
    return self.records.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ZYQuotaRecordVCCell";
    ZYQuotaRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[ZYQuotaRecordCell alloc] initWithReuseIdentifier:identifier];
    }
    cell.separator.hidden = indexPath.row == 0;
    [cell showCellWithModel:self.records[indexPath.row]];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark - getter
- (ZYQuotaRecordView *)baseView{
    if(!_baseView){
        _baseView = [ZYQuotaRecordView new];
        
        _baseView.tableView.delegate = self;
        _baseView.tableView.dataSource = self;
        
        __weak __typeof__(self) weakSelf = self;
        [_baseView.tableView addRefreshHeaderWithBlock:^{
            weakSelf.page = 1;
            [weakSelf loadRecords:NO];
        }];
        [_baseView.tableView addRefreshFooterWithBlock:^{
            weakSelf.page++;
            [weakSelf loadRecords:NO];
        }];
    }
    return _baseView;
}

- (NSMutableArray *)records{
    if(!_records){
        _records = [NSMutableArray array];
    }
    return _records;
}

@end
