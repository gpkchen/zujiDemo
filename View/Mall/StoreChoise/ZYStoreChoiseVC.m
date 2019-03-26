//
//  ZYStoreChoiseVC.m
//  Apollo
//
//  Created by 李明伟 on 2018/5/11.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYStoreChoiseVC.h"
#import "ZYStoreChoiseView.h"
#import "ZYStoreChoiseCell.h"
#import "MerchantAddressList.h"
#import "ZYLocationUtils.h"

@interface ZYStoreChoiseVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) ZYStoreChoiseView *baseView;

@property (nonatomic , assign) int page;
@property (nonatomic , strong) NSMutableArray *storeArr;

@end

@implementation ZYStoreChoiseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = self.baseView;
    self.title = @"选择门店地址";
    
    if(!_selectedStoreId){
        _selectedStoreId = self.dicParam[@"selectedStoreId"];
    }
    if(!_itemId){
        _itemId = self.dicParam[@"itemId"];
    }
    if(!_addressUseScene){
        _addressUseScene = self.dicParam[@"addressUseScene"];
    }
    
    _page = 1;
    [self showLoadingView];
    [self loadStore:NO];
}

#pragma mark - 获取门店列表
- (void)loadStore:(BOOL)showHud{
    _p_MerchantAddressList *param = [_p_MerchantAddressList new];
    param.page = [NSString stringWithFormat:@"%d",_page];
    param.itemId = _itemId;
    param.addressUseScene = _addressUseScene;
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
                                    [self.storeArr removeAllObjects];
                                }
                                NSArray *arr = responseObj.data[@"rows"];
                                int totalCount = [responseObj.data[@"totalCount"] intValue];
                                
                                BOOL isExist = NO;
                                for(NSDictionary *dic in arr){
                                    _m_MerchantAddressList *model = [[_m_MerchantAddressList alloc] initWithDictionary:dic];
                                    model.cellHeight = [self countCellHeight:model];
                                    model.index = (int)[arr indexOfObject:dic];
                                    [self.storeArr addObject:model];
                                    
                                    if(self.selectedStoreId){
                                        if([model.merchantAddressId isEqualToString:self.selectedStoreId]){
                                            isExist = YES;
                                        }
                                    }
                                }
                                
                                //检测前个页面选中的地址是否还在
                                if(self.selectedStoreId){
                                    if(!isExist){
                                        void (^callBack)(_m_MerchantAddressList *model) = self.callBack;
                                        !callBack ? : callBack(nil);
                                    }
                                }
                                
                                if(self.storeArr.count >= totalCount){
                                    [self.baseView.tableView.mj_footer endRefreshingWithNoMoreData];
                                }else{
                                    [self.baseView.tableView.mj_footer resetNoMoreData];
                                }
                                [self.baseView.tableView reloadData];
                                if(!self.storeArr.count){
                                    [self showNoStoreView];
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
                            if(self.storeArr.count){
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
                                        [weakSelf loadStore:YES];
                                    }];
                                }else if(error.code == ZYHttpErrorCodeNoNet){
                                    [self showNoNetView:^{
                                        [weakSelf loadStore:YES];
                                    }];
                                }else if(error.code == ZYHttpErrorCodeSystemError){
                                    [self showSystemErrorView:^{
                                        [weakSelf loadStore:YES];
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
- (CGFloat)countCellHeight:(_m_MerchantAddressList *)model{
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    _m_MerchantAddressList *model = self.storeArr[indexPath.section];
    return model.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(0 == section){
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
    
    _m_MerchantAddressList *model = self.storeArr[indexPath.section];
    void (^callBack)(_m_MerchantAddressList *model) = self.callBack;
    !callBack ? : callBack(model);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ZYStoreChoiseVCCell";
    ZYStoreChoiseCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[ZYStoreChoiseCell alloc] initWithReuseIdentifier:identifier];
    }
    _m_MerchantAddressList *model = self.storeArr[indexPath.section];
    if([model.merchantAddressId isEqualToString:_selectedStoreId]){
        cell.selectionIV.image = [UIImage imageNamed:@"zy_selection_selected"];
    }else{
        cell.selectionIV.image = [UIImage imageNamed:@"zy_selection_normal"];
    }
    [cell showCellWithModel:model];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.storeArr.count;
}

#pragma mark - getter
- (ZYStoreChoiseView *)baseView{
    if(!_baseView){
        _baseView = [ZYStoreChoiseView new];
        _baseView.tableView.delegate = self;
        _baseView.tableView.dataSource = self;
        
        __weak __typeof__(self) weakSelf = self;
        [_baseView.tableView addRefreshHeaderWithBlock:^{
            weakSelf.page = 1;
            [weakSelf loadStore:NO];
        }];
        [_baseView.tableView addRefreshFooterWithBlock:^{
            weakSelf.page++;
            [weakSelf loadStore:NO];
        }];
    }
    return _baseView;
}

- (NSMutableArray *)storeArr{
    if(!_storeArr){
        _storeArr = [NSMutableArray array];
    }
    return _storeArr;
}

@end
