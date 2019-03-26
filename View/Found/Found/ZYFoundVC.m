//
//  ZYFoundVC.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/11.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYFoundVC.h"
#import "QYSDK.h"
#import "ZYFoundView.h"
#import "ZYFoundCell.h"
#import "AppFoundPage.h"
#import "ZYFoundTitleView.h"
#import "AppUserReleaseListInfo.h"
#import "ZYFoundReleaseView.h"

@interface ZYFoundVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic , strong) ZYFoundView *baseView;
@property (nonatomic , strong) ZYFoundTitleView *titleView;
@property (nonatomic , strong) ZYFoundReleaseView *releaseView;

@property (nonatomic , assign) int scrollPage;

//推荐
@property (nonatomic , assign) int recommendPage;
@property (nonatomic , strong) NSMutableArray *recommendArr;

//此刻
@property (nonatomic , assign) int momentPage;
@property (nonatomic , strong) NSMutableArray *momentArr;

//埋点
@property (nonatomic , assign) long long beginTime; //浏览开始时间（用于统计）

@end

@implementation ZYFoundVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _scrollPage = 0;
    self.view = self.baseView;
    self.navigationItem.titleView = self.titleView;
    self.rightBarItems = @[[UIImage imageNamed:@"zy_service_normal"]];
    
    _recommendPage = 1;
    _momentPage = 1;
    [self.baseView.recommendTableView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.releaseView show];
    
    _beginTime = [[NSDate date] millisecondSince1970];
    
    //客服消息有无未读
    if([[QYSDK sharedSDK] conversationManager].allUnreadCount > 0){
        self.rightBarItems = @[[UIImage imageNamed:@"zy_service_unread"]];
    }else{
        self.rightBarItems = @[[UIImage imageNamed:@"zy_service_normal"]];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.releaseView hide];
    
    if(_scrollPage == 0){
        //统计
        long long now = [[NSDate date] millisecondSince1970];
        [ZYStatisticsService event:@"found_momentlist" durations:(int)(now - _beginTime)];
    }else{
        //统计
        long long now = [[NSDate date] millisecondSince1970];
        [ZYStatisticsService event:@"found_recommendlist" durations:(int)(now - _beginTime)];
    }
}

- (void)rightBarItemsAction:(int)index{
    [[ZYRouter router] goWithoutHead:[NSString stringWithFormat:@"web?url=%@&swipeToBack=0&alwaysBounceVertical=0&alwaysBounceHorizontal=0",
                                      [[ZYH5Utils formatUrl:ZYH5TypeHelp param:nil] URLEncode]]];
}

#pragma mark - 获取推荐列表
- (void)loadRecommends:(BOOL)showHud{
    _p_AppFoundPage *param = [_p_AppFoundPage new];
    param.page = [NSString stringWithFormat:@"%d",_recommendPage];
    [[ZYHttpClient client] post:param
                        showHud:showHud
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            [self hideErrorView];
                            [self.baseView.recommendTableView.mj_header endRefreshing];
                            [self.baseView.recommendTableView.mj_footer endRefreshing];
                            if(responseObj.isSuccess){
                                if(1 == self.recommendPage){
                                    [self.recommendArr removeAllObjects];
                                }
                                NSArray *arr = responseObj.data[@"rows"];
                                int totalCount = [responseObj.data[@"totalCount"] intValue];
                                for(NSDictionary *dic in arr){
                                    _m_AppFoundPage *model = [[_m_AppFoundPage alloc] initWithDictionary:dic];
                                    [model countCellHeight];
                                    [self.recommendArr addObject:model];
                                }
                                if(self.recommendArr.count >= totalCount){
                                    [self.baseView.recommendTableView.mj_footer endRefreshingWithNoMoreData];
                                }else{
                                    [self.baseView.recommendTableView.mj_footer resetNoMoreData];
                                }
                                [self.baseView.recommendTableView reloadData];
                            }else{
                                [ZYToast showWithTitle:responseObj.message];
                            }
                        } failure:^(NSURLSessionDataTask *task, NSError *error) {
                            [self hideErrorView];
                            [self.baseView.recommendTableView.mj_header endRefreshing];
                            [self.baseView.recommendTableView.mj_footer endRefreshing];
                            
                            __weak __typeof__(self) weakSelf = self;
                            if(self.recommendArr.count){
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
                                        [weakSelf loadRecommends:YES];
                                    }];
                                }else if(error.code == ZYHttpErrorCodeNoNet){
                                    [self showNoNetView:^{
                                        [weakSelf loadRecommends:YES];
                                    }];
                                }else if(error.code == ZYHttpErrorCodeSystemError){
                                    [self showSystemErrorView:^{
                                        [weakSelf loadRecommends:YES];
                                    }];
                                }
                            }
                        } authFail:^{
                            [self hideErrorView];
                            [self.baseView.recommendTableView.mj_header endRefreshing];
                            [self.baseView.recommendTableView.mj_footer endRefreshing];
                        }];
}

#pragma mark - 获取此刻列表
- (void)loadMoments:(BOOL)showHud{
    _p_AppUserReleaseListInfo *param = [_p_AppUserReleaseListInfo new];
    param.page = [NSString stringWithFormat:@"%d",_momentPage];
    [[ZYHttpClient client] post:param
                        showHud:showHud
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            [self hideErrorView];
                            [self.baseView.momentTableView.mj_header endRefreshing];
                            [self.baseView.momentTableView.mj_footer endRefreshing];
                            if(responseObj.isSuccess){
                                if(1 == self.momentPage){
                                    [self.momentArr removeAllObjects];
                                }
                                NSArray *arr = responseObj.data[@"rows"];
                                int totalCount = [responseObj.data[@"totalCount"] intValue];
                                for(NSDictionary *dic in arr){
                                    _m_AppUserReleaseListInfo *model = [[_m_AppUserReleaseListInfo alloc] initWithDictionary:dic];
                                    [model countCellHeight];
                                    [self.momentArr addObject:model];
                                }
                                if(self.momentArr.count >= totalCount){
                                    [self.baseView.momentTableView.mj_footer endRefreshingWithNoMoreData];
                                }else{
                                    [self.baseView.momentTableView.mj_footer resetNoMoreData];
                                }
                                [self.baseView.momentTableView reloadData];
                            }else{
                                [ZYToast showWithTitle:responseObj.message];
                            }
                        } failure:^(NSURLSessionDataTask *task, NSError *error) {
                            [self hideErrorView];
                            [self.baseView.momentTableView.mj_header endRefreshing];
                            [self.baseView.momentTableView.mj_footer endRefreshing];
                            
                            __weak __typeof__(self) weakSelf = self;
                            if(self.momentArr.count){
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
                                        [weakSelf loadMoments:YES];
                                    }];
                                }else if(error.code == ZYHttpErrorCodeNoNet){
                                    [self showNoNetView:^{
                                        [weakSelf loadMoments:YES];
                                    }];
                                }else if(error.code == ZYHttpErrorCodeSystemError){
                                    [self showSystemErrorView:^{
                                        [weakSelf loadMoments:YES];
                                    }];
                                }
                            }
                        } authFail:^{
                            [self hideErrorView];
                            [self.baseView.recommendTableView.mj_header endRefreshing];
                            [self.baseView.recommendTableView.mj_footer endRefreshing];
                        }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ZYFoundVCCell";
    ZYFoundCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        if([tableView isEqual:self.baseView.recommendTableView]){
            //推荐
            cell = [[ZYFoundCell alloc] initWithReuseIdentifier:identifier type:ZYFoundCellTypeRecomend];
        }else{
            //此刻
            cell = [[ZYFoundCell alloc] initWithReuseIdentifier:identifier type:ZYFoundCellTypeMoment];
        }
    }
    if([tableView isEqual:self.baseView.recommendTableView]){
        //推荐
        _m_AppFoundPage *model = self.recommendArr[indexPath.section];
        [cell showRecommend:model];
    }else{
        //此刻
        _m_AppUserReleaseListInfo *model = self.momentArr[indexPath.section];
        [cell showMoment:model];
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if([tableView isEqual:self.baseView.recommendTableView]){
        //推荐
        return self.recommendArr.count;
    }else{
        //此刻
        return self.momentArr.count;
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if([scrollView isEqual:self.baseView.scrollView]){
        if(self.baseView.scrollView.contentOffset.x == 0){
            if(_scrollPage != 0){
                
                //统计
                long long now = [[NSDate date] millisecondSince1970];
                [ZYStatisticsService event:@"found_momentlist" durations:(int)(now - _beginTime)];
                _beginTime = now;
                
                _scrollPage = 0;
                if(!self.recommendArr.count){
                    [self.baseView.recommendTableView.mj_header beginRefreshing];
                }
                self.titleView.selectedIndex = 0;
            }
        }else if(self.baseView.scrollView.contentOffset.x == SCREEN_WIDTH){
            if(_scrollPage != 1){
                
                //统计
                long long now = [[NSDate date] millisecondSince1970];
                [ZYStatisticsService event:@"found_recommendlist" durations:(int)(now - _beginTime)];
                _beginTime = now;
                
                _scrollPage = 1;
                if(!self.momentArr.count){
                    [self.baseView.momentTableView.mj_header beginRefreshing];
                }
                self.titleView.selectedIndex = 1;
            }
        }
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([tableView isEqual:self.baseView.recommendTableView]){
        //推荐
        _m_AppFoundPage *model = self.recommendArr[indexPath.section];
        return model.cellHeight;
    }else{
        //此刻
        _m_AppUserReleaseListInfo *model = self.momentArr[indexPath.section];
        return model.cellHeight;
    }
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
    if([tableView isEqual:self.baseView.recommendTableView]){
        //推荐
        _m_AppFoundPage *model = self.recommendArr[indexPath.section];
        if(model.source == ZYArticleSourceOfficial){
            [[ZYRouter router] goVC:[NSString stringWithFormat:@"ZYFoundDetailVC?url=%@&sourceId=%@&source=%d",
                                     [[ZYH5Utils formatUrl:ZYH5TypeFoundDetail param:model.sourceId] URLEncode],
                                     [model.sourceId URLEncode],
                                     model.source] withCallBack:^(BOOL isLike,int likeNum, NSMutableArray *avatars){
                model.isZan = isLike ? 1 : 2;
                model.zanAmount = likeNum;
                model.zanAvatars = avatars;
                [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
            }];
        }else if(model.source == ZYArticleSourceUser){
            [[ZYRouter router] goVC:[NSString stringWithFormat:@"ZYFoundDetailVC?url=%@&sourceId=%@&source=%d",
                                     [[ZYH5Utils formatUrl:ZYH5TypeUserPublishDetail param:model.sourceId] URLEncode],
                                     [model.sourceId URLEncode],
                                     model.source] withCallBack:^(BOOL isLike,int likeNum, NSMutableArray *avatars){
                model.isZan = isLike ? 1 : 2;
                model.zanAmount = likeNum;
                model.zanAvatars = avatars;
                [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
            }];
        }
    }else{
        //此刻
        _m_AppUserReleaseListInfo *model = self.momentArr[indexPath.section];
        [[ZYRouter router] goVC:[NSString stringWithFormat:@"ZYFoundDetailVC?url=%@&sourceId=%@&source=%d",
                                 [[ZYH5Utils formatUrl:ZYH5TypeUserPublishDetail param:model.userReleaseId] URLEncode],
                                 [model.userReleaseId URLEncode],
                                 ZYArticleSourceUser] withCallBack:^(BOOL isLike,int likeNum, NSMutableArray *avatars){
            model.isZan = isLike ? 1 : 2;
            model.zanAmount = likeNum;
            model.zanAvatars = avatars;
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
        }];
    }
}

#pragma mark - getter
- (ZYFoundView *)baseView{
    if(!_baseView){
        _baseView = [ZYFoundView new];
        
        _baseView.recommendTableView.delegate = self;
        _baseView.recommendTableView.dataSource = self;
        
        _baseView.momentTableView.delegate = self;
        _baseView.momentTableView.dataSource = self;
        
        _baseView.scrollView.delegate = self;
        
        __weak __typeof__(self) weakSelf = self;
        
        [_baseView.recommendTableView addRefreshHeaderWithBlock:^{
            weakSelf.recommendPage = 1;
            [weakSelf loadRecommends:NO];
        }];
        [_baseView.recommendTableView addRefreshFooterWithBlock:^{
            weakSelf.recommendPage++;
            [weakSelf loadRecommends:NO];
        }];
        
        [_baseView.momentTableView addRefreshHeaderWithBlock:^{
            weakSelf.momentPage = 1;
            [weakSelf loadMoments:NO];
        }];
        [_baseView.momentTableView addRefreshFooterWithBlock:^{
            weakSelf.momentPage++;
            [weakSelf loadMoments:NO];
        }];
    }
    return _baseView;
}

- (ZYFoundTitleView *)titleView{
    if(!_titleView){
        _titleView = [ZYFoundTitleView new];
        
        __weak __typeof__(self) weakSelf = self;
        _titleView.action = ^(int index) {
            if(index == 0){
                
                //统计
                long long now = [[NSDate date] millisecondSince1970];
                [ZYStatisticsService event:@"found_momentlist" durations:(int)(now - weakSelf.beginTime)];
                weakSelf.beginTime = now;
                [ZYStatisticsService event:@"found_recommend"];
                
                weakSelf.scrollPage = 0;
                [weakSelf.baseView.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
                if(!weakSelf.recommendArr.count){
                    [weakSelf.baseView.recommendTableView.mj_header beginRefreshing];
                }
            }else{
                
                //统计
                long long now = [[NSDate date] millisecondSince1970];
                [ZYStatisticsService event:@"found_recommendlist" durations:(int)(now - weakSelf.beginTime)];
                weakSelf.beginTime = now;
                [ZYStatisticsService event:@"found_moment"];
                
                weakSelf.scrollPage = 1;
                [weakSelf.baseView.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
                if(!weakSelf.momentArr.count){
                    [weakSelf.baseView.momentTableView.mj_header beginRefreshing];
                }
            }
        };
    }
    return _titleView;
}

- (ZYFoundReleaseView *)releaseView{
    if(!_releaseView){
        _releaseView = [ZYFoundReleaseView new];
        [_releaseView tapped:^(UITapGestureRecognizer *gesture) {
            [ZYStatisticsService event:@"found_publish"];
            [[ZYLoginService service] requireLogin:^{
                [[ZYRouter router] goVC:@"ZYPublishMomentVC"];
            }];
        } delegate:nil];
    }
    return _releaseView;
}

- (NSMutableArray *)recommendArr{
    if(!_recommendArr){
        _recommendArr = [NSMutableArray new];
    }
    return _recommendArr;
}

- (NSMutableArray *)momentArr{
    if(!_momentArr){
        _momentArr = [NSMutableArray new];
    }
    return _momentArr;
}

@end
