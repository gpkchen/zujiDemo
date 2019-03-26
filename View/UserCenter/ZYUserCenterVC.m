//
//  ZYUserCenterVC.m
//  Apollo
//
//  Created by 李明伟 on 2018/7/27.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYUserCenterVC.h"
#import "ZYUserCenterView.h"
#import "ZYFoundCell.h"
#import "AppMyReleaseListInfo.h"
#import "GetHomeInfo.h"
#import "YBImageBrowser.h"
#import "UserDeleteUserRelease.h"
#import "ZYUserCenterHeader.h"
#import "ZYUserCenterFooter.h"

@interface ZYUserCenterVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , assign) BOOL isShowed;

@property (nonatomic , strong) ZYUserCenterView *baseView;
@property (nonatomic , strong) ZYUserCenterHeader *header;
@property (nonatomic , strong) ZYUserCenterFooter *footer;

@property (nonatomic , assign) int page;
@property (nonatomic , strong) _m_GetHomeInfo *info;
@property (nonatomic , strong) NSMutableArray *moments;

@property (nonatomic , assign) BOOL isMine; //是否是本人的个人中心

@end

@implementation ZYUserCenterVC

- (instancetype)init{
    if(self = [super init]){
        self.navigationBarAlpha = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [ZYStatisticsService event:@"usercenter_comein"];
    
    self.view = self.baseView;
    
    if(!_userId){
        _userId = self.dicParam[@"userId"];
    }
    
    _isMine = (_userId && [_userId isEqualToString:[ZYUser user].userId]);
    
    if(_isMine){
        self.baseView.editBtn.hidden = NO;
        self.baseView.editOnBarBtn.hidden = NO;
        self.footer.publishBtn.hidden = NO;
    }else{
        self.baseView.editBtn.hidden = YES;
        self.baseView.editOnBarBtn.hidden = YES;
        self.footer.publishBtn.hidden = YES;
    }
    
    _page = 1;
    [self showLoadingView];
    [self loadUserInfo:NO];
    [self loadMoments:NO];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if(_isShowed){
        [self loadUserInfo:NO];
    }
    _isShowed = YES;
}

#pragma mark - 获取用户信息
- (void)loadUserInfo:(BOOL)showHud{
    _p_GetHomeInfo *param = [_p_GetHomeInfo new];
    param.homepageUserId = _userId;
    [[ZYHttpClient client] post:param
                        showHud:showHud
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            [self hideLoadingView];
                            [self hideErrorView];
                            [self.baseView.tableView.mj_header endRefreshing];
                            if(responseObj.isSuccess){
                                self.info = [_m_GetHomeInfo mj_objectWithKeyValues:responseObj.data];
                                self.header.nicknameLab.text = self.info.nickname;
                                self.header.likeLab.text = [NSString stringWithFormat:@"%d",self.info.userAllZanNum];
                                self.header.publishLab.text = [NSString stringWithFormat:@"%d",self.info.userAllReleaseNum];
                                NSString *avatar = [self.info.avatar imageStyleUrlNoCut:CGSizeMake(160 * UI_H_SCALE, 160 * UI_H_SCALE)];
                                [self.header.portrait loadImage:avatar];
                            }else{
                                [ZYToast showWithTitle:responseObj.message];
                            }
                        } failure:^(NSURLSessionDataTask *task, NSError *error) {
                            [self hideLoadingView];
                            [self hideErrorView];
                            [self.baseView.tableView.mj_header endRefreshing];
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
                                        [weakSelf loadUserInfo:YES];
                                    }];
                                }else if(error.code == ZYHttpErrorCodeNoNet){
                                    [self showNoNetView:^{
                                        [weakSelf loadUserInfo:YES];
                                    }];
                                }else if(error.code == ZYHttpErrorCodeSystemError){
                                    [self showSystemErrorView:^{
                                        [weakSelf loadUserInfo:YES];
                                    }];
                                }
                            }
                        } authFail:^{
                            [self hideLoadingView];
                            [self hideErrorView];
                            [self.baseView.tableView.mj_header endRefreshing];
                        }];
}

#pragma mark - 获取资讯列表
- (void)loadMoments:(BOOL)showHud{
    _p_AppMyReleaseListInfo *param = [_p_AppMyReleaseListInfo new];
    param.page = [NSString stringWithFormat:@"%d",_page];
    param.homepageUserId = _userId;
    [[ZYHttpClient client] post:param
                        showHud:showHud
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            [self.baseView.tableView.mj_footer endRefreshing];
                            if(responseObj.isSuccess){
                                if(1 == self.page){
                                    [self.moments removeAllObjects];
                                }
                                NSArray *arr = responseObj.data[@"rows"];
                                int totalCount = [responseObj.data[@"totalCount"] intValue];
                                
                                for(NSDictionary *dic in arr){
                                    _m_AppMyReleaseListInfo *model = [[_m_AppMyReleaseListInfo alloc] initWithDictionary:dic];
                                    [model countCellHeight];
                                    [self.moments addObject:model];
                                }
                                if(!(1 == self.page && self.moments.count == 0)){
                                    if(self.moments.count >= totalCount){
                                        [self.baseView.tableView.mj_footer endRefreshingWithNoMoreData];
                                    }else{
                                        [self.baseView.tableView.mj_footer resetNoMoreData];
                                    }
                                }
                                [self.baseView.tableView reloadData];
                            }else{
                                [ZYToast showWithTitle:responseObj.message];
                            }
                        } failure:^(NSURLSessionDataTask *task, NSError *error) {
                            [self.baseView.tableView.mj_footer endRefreshing];
                            if(error.code == ZYHttpErrorCodeTimeOut){
                                [ZYToast showWithTitle:ZYHttpErrorMessageNetTimeOut];
                            }else if(error.code == ZYHttpErrorCodeNoNet){
                                [ZYToast showWithTitle:ZYHttpErrorMessageNoNet];
                            }else if(error.code == ZYHttpErrorCodeSystemError){
                                [ZYToast showWithTitle:ZYHttpErrorMessageSystemError];
                            }
                        } authFail:^{
                            [self.baseView.tableView.mj_footer endRefreshing];
                        }];
}

#pragma mark - 删除资讯
- (void)deleteMoment:(_m_AppMyReleaseListInfo *)model{
    _p_UserDeleteUserRelease *param = [_p_UserDeleteUserRelease new];
    param.userReleaseId = model.userReleaseId;
    [[ZYHttpClient client] post:param
                        showHud:YES
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            if(responseObj.isSuccess){
                                NSUInteger index = [self.moments indexOfObject:model];
                                [self.moments removeObject:model];
                                [self.baseView.tableView deleteSections:[NSIndexSet indexSetWithIndex:index + 1] withRowAnimation:UITableViewRowAnimationFade];
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

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(0 == section){
        return 0;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ZYUserCenterVCCell";
    ZYFoundCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[ZYFoundCell alloc] initWithReuseIdentifier:identifier type:ZYFoundCellTypeUserCenter];
    }
    
    __weak __typeof__(self) weakSelf = self;
    _m_AppMyReleaseListInfo *model = self.moments[indexPath.section - 1];
    [cell showUserCenterMoment:model];
    
    if(_isMine){
        cell.moreBtn.hidden = NO;
        [cell.moreBtn clickAction:^(UIButton * _Nonnull button) {
            ZYSheetMenu *menu = [ZYSheetMenu new];
            menu.cancelBtnStyle = ZYSheetMenuCancelBtnStyleFull;
            menu.dateArr = @[@"删除"];
            [menu selectionAction:^(NSUInteger index) {
                [[ZYLoginService service] requireLogin:^{
                    [ZYAlert showWithTitle:@"确认删除？"
                                   content:@"删除后不可恢复记录，确定删除？"
                              buttonTitles:@[@"取消",@"删除"]
                              buttonAction:^(ZYAlert *alert, int index) {
                                  if(1 == index){
                                      [weakSelf deleteMoment:model];
                                  }
                                  [alert dismiss];
                              }];
                }];
            }];
            [menu show];
        }];
    }else{
        cell.moreBtn.hidden = YES;
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.moments.count + 1;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset = scrollView.contentOffset.y;
    CGFloat target = ZYUserCenterHeaderHeight - NAVIGATION_BAR_HEIGHT;
    if(offset < 0){
        self.baseView.navigationBar.alpha = 0;
    }else if(offset < target){
        self.baseView.navigationBar.alpha = offset / target;
    }else{
        self.baseView.navigationBar.alpha = 1;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    _m_AppMyReleaseListInfo *model = self.moments[indexPath.section - 1];
    return model.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(0 == section){
        return ZYUserCenterHeaderHeight;
    }
    if(1 == section){
        return 0.01;
    }
    return 10 * UI_H_SCALE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(0 == section && !self.moments.count){
        return ZYUserCenterFooterHeight;
    }
    return 0.01;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(0 == section){
        return self.header;
    }
    UIView *header = [UIView new];
    header.backgroundColor = VIEW_COLOR;
    return header;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(0 == section && !self.moments.count){
        return self.footer;
    }
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _m_AppMyReleaseListInfo *model = self.moments[indexPath.section - 1];
    [[ZYRouter router] goVC:[NSString stringWithFormat:@"ZYFoundDetailVC?url=%@&sourceId=%@&source=%d",
                             [[ZYH5Utils formatUrl:ZYH5TypeUserPublishDetail param:model.userReleaseId] URLEncode],
                             [model.userReleaseId URLEncode],
                             ZYArticleSourceUser]];
}

#pragma mark - getter
- (ZYUserCenterView *)baseView{
    if(!_baseView){
        _baseView = [ZYUserCenterView new];
        _baseView.tableView.delegate = self;
        _baseView.tableView.dataSource = self;
        
        __weak __typeof__(self) weakSelf = self;
        [_baseView.backBtn clickAction:^(UIButton * _Nonnull button) {
            [weakSelf systemBackButtonClicked];
        }];
        [_baseView.editBtn clickAction:^(UIButton * _Nonnull button) {
            [[ZYRouter router] goVC:@"ZYUserInfoVC"];
        }];
        [_baseView.backOnBarBtn clickAction:^(UIButton * _Nonnull button) {
            [weakSelf systemBackButtonClicked];
        }];
        [_baseView.editOnBarBtn clickAction:^(UIButton * _Nonnull button) {
            [[ZYRouter router] goVC:@"ZYUserInfoVC"];
        }];
        [_baseView.tableView addRefreshHeaderWithBlock:^{
            weakSelf.page = 1;
            [weakSelf loadMoments:NO];
            [weakSelf loadUserInfo:NO];
        }];
        [_baseView.tableView addRefreshFooterWithBlock:^{
            if(!(1 == weakSelf.page && weakSelf.moments.count == 0)){
                weakSelf.page++;
                [weakSelf loadMoments:NO];
            }else{
                [weakSelf.baseView.tableView.mj_footer endRefreshing];
            }
        }];
    }
    return _baseView;
}

- (ZYUserCenterHeader *)header{
    if(!_header){
        _header = [ZYUserCenterHeader new];
        
        __weak __typeof__(self) weakSelf = self;
        __weak __typeof__(_header) weakHeader = _header;
        [_header.portrait tapped:^(UITapGestureRecognizer *gesture) {
            NSMutableArray *tempArr = [NSMutableArray array];
            YBImageBrowserModel *model = [YBImageBrowserModel new];
            model.url = [NSURL URLWithString:weakSelf.info.avatar];
            model.sourceImageView = weakHeader.portrait;
            model.previewModel = [YBImageBrowserModel new];
            model.previewModel.image = weakHeader.portrait.image;
            [tempArr addObject:model];
            
            YBImageBrowser *browser = [YBImageBrowser new];
            browser.dataArray = tempArr;
            browser.currentIndex = 0;
            [browser show];
        } delegate:nil];
    }
    return _header;
}

- (ZYUserCenterFooter *)footer{
    if(!_footer){
        _footer = [ZYUserCenterFooter new];
        
        [_footer.publishBtn clickAction:^(UIButton * _Nonnull button) {
            [[ZYRouter router] returnToRoot];
            [ZYMainTabVC shareInstance].selectedIndex = 0;
        }];
    }
    return _footer;
}

- (NSMutableArray *)moments{
    if(!_moments){
        _moments = [NSMutableArray array];
    }
    return _moments;
}

@end
