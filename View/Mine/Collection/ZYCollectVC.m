//
//  ZYCollectVC.m
//  Apollo
//
//  Created by 李明伟 on 2018/11/22.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import "ZYCollectVC.h"
#import "ZYCollectCell.h"
#import "ZYCollectView.h"
#import "FavoriteList.h"
#import "FavoriteDelete.h"

@interface ZYCollectVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic , strong) ZYCollectView *baseView;
@property (nonatomic , strong) UILabel *totalLab;
@property (nonatomic , strong) ZYElasticButton *manageBtn;

@property (nonatomic , strong) NSMutableArray *items;
@property (nonatomic , assign) int page;
@property (nonatomic , assign) BOOL selectedAll;

@property (nonatomic , assign) int totalCount;

@end

@implementation ZYCollectVC

- (instancetype)init{
    if(self = [super init]){
        self.showCustomNavigationBar = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = self.baseView;
    self.title = @"收藏";
    
    [self.customNavigationBar addSubview:self.totalLab];
    [self.totalLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.customNavigationBar).mas_offset(-15 * UI_H_SCALE);
        make.centerY.equalTo(self.customNavigationBar.mas_bottom).mas_offset(-30 * UI_H_SCALE);
    }];
    [self.customNavigationBar.fadeSubViews addObject:self.totalLab];
    
    [self.customNavigationBar addSubview:self.manageBtn];
    [self.manageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.customNavigationBar);
        make.top.equalTo(self.customNavigationBar).mas_offset(STATUSBAR_HEIGHT);
        make.bottom.equalTo(self.customNavigationBar.mas_top).mas_offset(NAVIGATION_BAR_HEIGHT);
        make.width.mas_equalTo(self.manageBtn.width + 30 * UI_H_SCALE);
    }];
    
    _page = 1;
    [self showLoadingView];
    [self loadItems:NO];
}

#pragma mark - 获取收藏列表
- (void)loadItems:(BOOL)showHud{
    _p_FavoriteList *param = [_p_FavoriteList new];
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
                                    [self.items removeAllObjects];
                                }
                                NSArray *arr = responseObj.data[@"rows"];
                                self.totalCount = [responseObj.data[@"totalCount"] intValue];
                                self.totalLab.text = [NSString stringWithFormat:@"共%d件宝贝",self.totalCount];
                                self.totalLab.hidden = NO;
                                [self.items addObjectsFromArray:[_m_FavoriteList mj_objectArrayWithKeyValuesArray:arr]];
                                if(self.items.count >= self.totalCount){
                                    [self.baseView.tableView.mj_footer endRefreshingWithNoMoreData];
                                }else{
                                    [self.baseView.tableView.mj_footer resetNoMoreData];
                                }
                                [self.baseView.tableView reloadData];
                                if(self.selectedAll){
                                    self.baseView.allIV.image = [UIImage imageNamed:@"zy_mine_collection_cb_normal"];
                                    [self.baseView.deleteAllBtn setTitle:@"删除" forState:UIControlStateNormal];
                                    self.selectedAll = NO;
                                }
                                if(!self.items.count){
                                    [self showNoCollectionView:^{
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
                            if(self.items.count){
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
                                        [weakSelf loadItems:YES];
                                    }];
                                }else if(error.code == ZYHttpErrorCodeNoNet){
                                    [self showNoNetView:^{
                                        [weakSelf loadItems:YES];
                                    }];
                                }else if(error.code == ZYHttpErrorCodeSystemError){
                                    [self showSystemErrorView:^{
                                        [weakSelf loadItems:YES];
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

#pragma mark - 删除收藏
- (void)deleteCollection{
    _p_FavoriteDelete *param = [[_p_FavoriteDelete alloc] init];
    NSMutableArray *ids = [NSMutableArray array];
    for(_m_FavoriteList *model in self.items){
        if(model.selected){
            [ids addObject:model.itemId];
        }
    }
    param.itemIds = ids;
    [[ZYHttpClient client] post:param showHud:YES success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
        if (responseObj.success) {
            self.totalCount -= (int)ids.count;
            self.totalLab.text = [NSString stringWithFormat:@"共%d件宝贝",self.totalCount];
            [ZYToast showWithTitle:@"收藏删除成功!"];
            for(int i=(int)self.items.count-1;i>=0;i--){
                _m_FavoriteList *model = self.items[i];
                if(model.selected){
                    [self.items removeObject:model];
                }
            }
            [self.baseView.tableView reloadData];
            if(!self.items.count){
                [self showNoCollectionView:^{
                    [[ZYRouter router] returnToRoot];
                    [ZYMainTabVC shareInstance].selectedIndex = 1;
                }];
            }
            if(self.selectedAll){
                self.baseView.allIV.image = [UIImage imageNamed:@"zy_mine_collection_cb_normal"];
                [self.baseView.deleteAllBtn setTitle:@"删除" forState:UIControlStateNormal];
                self.selectedAll = NO;
            }
        } else {
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


#pragma mark - 选择全部
- (void)toSelectAll:(BOOL)isAll{
    __weak __typeof__(self) weakSelf = self;
    if(isAll){
        [self.items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            _m_FavoriteList *model = weakSelf.items[idx];
            model.selected = YES;
            [weakSelf.baseView.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:idx]
                                                     animated:NO
                                               scrollPosition:UITableViewScrollPositionNone];
        }];
    }else{
        [self.items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            _m_FavoriteList *model = weakSelf.items[idx];
            model.selected = NO;
            [weakSelf.baseView.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:idx]
                                                       animated:NO];
        }];
    }
}

#pragma mark - UITableViewDataSource
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.items.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ZYCollectVCCell";
    ZYCollectCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[ZYCollectCell alloc] initWithReuseIdentifier:identifier];
    }
    _m_FavoriteList *model = self.items[indexPath.section];
    [cell showCellWithModel:model];
    return cell;
}

#pragma mark - UITableViewDelegate
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak __typeof__(self) weakSelf = self;
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                      title:@"删除收藏"
                                                                    handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath)
                                    {
                                        _m_FavoriteList *model = weakSelf.items[indexPath.section];
                                        model.selected = YES;
                                        [ZYAlert showWithTitle:nil
                                                       content:@"确定要删除此收藏吗？"
                                                  buttonTitles:@[@"取消",@"确定"]
                                                  buttonAction:^(ZYAlert *alert, int index) {
                                                      [alert dismiss];
                                                      if(1 == index){
                                                          [weakSelf deleteCollection];
                                                      }
                                                  }];
                                    }];
    action.backgroundColor = WORD_COLOR_ORANGE;
    return @[action];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.customNavigationBar.pullY = self.baseView.tableView.contentOffset.y + self.baseView.tableView.scrollIndicatorInsets.top;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ZYCollectCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20 * UI_H_SCALE;
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
    _m_FavoriteList *model = self.items[indexPath.section];
    if(tableView.isEditing){
        model.selected = !model.selected;
        if(self.selectedAll){
            self.baseView.allIV.image = [UIImage imageNamed:@"zy_mine_collection_cb_normal"];
            [self.baseView.deleteAllBtn setTitle:@"删除" forState:UIControlStateNormal];
            self.selectedAll = NO;
        }
    }else{
        [[ZYRouter router] goWithoutHead:[NSString stringWithFormat:@"itemDetail?itemId=%@",[model.itemId URLEncode]]];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    _m_FavoriteList *model = self.items[indexPath.section];
    if(tableView.isEditing){
        model.selected = !model.selected;
        if(self.selectedAll){
            self.baseView.allIV.image = [UIImage imageNamed:@"zy_mine_collection_cb_normal"];
            [self.baseView.deleteAllBtn setTitle:@"删除" forState:UIControlStateNormal];
            self.selectedAll = NO;
        }
    }
}

#pragma mark - 管理按钮事件
- (void)manageAction{
    [self.baseView.tableView setEditing:!self.baseView.tableView.isEditing animated:YES];
    if(self.baseView.tableView.isEditing){
        self.baseView.allIV.image = [UIImage imageNamed:@"zy_mine_collection_cb_normal"];
        self.selectedAll = NO;
        [self.baseView.deleteAllBtn setTitle:@"删除" forState:UIControlStateNormal];
        for(_m_FavoriteList *model in self.items){
            model.selected = NO;
        }
        [self.manageBtn setTitle:@"取消" forState:UIControlStateNormal];
        self.baseView.toolBar.hidden = NO;
        self.baseView.tableView.frame = CGRectMake(0, CNBMinHeight, SCREEN_WIDTH, SCREEN_HEIGHT - CNBMinHeight - DOWN_DANGER_HEIGHT - self.baseView.toolBar.height);
        self.baseView.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(CNBMaxHeight - CNBMinHeight, 0, 0, 0);
    }else{
        [self.manageBtn setTitle:@"管理" forState:UIControlStateNormal];
        self.baseView.toolBar.hidden = YES;
        self.baseView.tableView.frame = CGRectMake(0, CNBMinHeight, SCREEN_WIDTH, SCREEN_HEIGHT - CNBMinHeight);
        self.baseView.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(CNBMaxHeight - CNBMinHeight, 0, DOWN_DANGER_HEIGHT, 0);
    }
}

#pragma mark - getter
- (ZYCollectView *)baseView{
    if(!_baseView){
        _baseView = [ZYCollectView new];
        _baseView.tableView.delegate = self;
        _baseView.tableView.dataSource = self;
        
        __weak __typeof__(self) weakSelf = self;
        __weak __typeof__(_baseView) weakBaseView = _baseView;
        [_baseView.tableView addRefreshHeaderWithBlock:^{
            weakSelf.page = 1;
            [weakSelf loadItems:NO];
        }];
        [_baseView.tableView addRefreshFooterWithBlock:^{
            weakSelf.page++;
            [weakSelf loadItems:NO];
        }];
        [_baseView.allBtn clickAction:^(UIButton * _Nonnull button) {
            weakSelf.selectedAll = !weakSelf.selectedAll;
            if(weakSelf.selectedAll){
                [weakSelf toSelectAll:YES];
                [weakSelf.baseView.deleteAllBtn setTitle:@"删除全部" forState:UIControlStateNormal];
                weakBaseView.allIV.image = [UIImage imageNamed:@"zy_mine_collection_cb_selected"];
            }else{
                [weakSelf toSelectAll:NO];
                [weakSelf.baseView.deleteAllBtn setTitle:@"删除" forState:UIControlStateNormal];
                weakBaseView.allIV.image = [UIImage imageNamed:@"zy_mine_collection_cb_normal"];
            }
        }];
        [_baseView.deleteAllBtn clickAction:^(UIButton * _Nonnull button) {
            BOOL isSelectAny = NO;
            for(_m_FavoriteList *model in weakSelf.items){
                if(model.selected){
                    isSelectAny = YES;
                }
            }
            if(!isSelectAny){
                [ZYToast showWithTitle:@"请选择要删除的收藏"];
                return;
            }
            [ZYAlert showWithTitle:nil
                           content:@"确定要删除这些收藏吗？"
                      buttonTitles:@[@"取消",@"确定"]
                      buttonAction:^(ZYAlert *alert, int index) {
                          [alert dismiss];
                          if(1 == index){
                              [weakSelf deleteCollection];
                          }
                      }];
        }];
    }
    return _baseView;
}

- (NSMutableArray *)items{
    if(!_items){
        _items = [NSMutableArray array];
    }
    return _items;
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

- (ZYElasticButton *)manageBtn{
    if(!_manageBtn){
        _manageBtn = [ZYElasticButton new];
        [_manageBtn setTitle:@"管理" forState:UIControlStateNormal];
        [_manageBtn setTitleColor:WORD_COLOR_BLACK forState:UIControlStateNormal];
        [_manageBtn setTitleColor:WORD_COLOR_BLACK forState:UIControlStateHighlighted];
        _manageBtn.font = FONT(15);
        [_manageBtn sizeToFit];
        
        __weak __typeof__(self) weakSelf = self;
        [_manageBtn clickAction:^(UIButton * _Nonnull button) {
            [weakSelf manageAction];
        }];
    }
    return _manageBtn;
}

@end
