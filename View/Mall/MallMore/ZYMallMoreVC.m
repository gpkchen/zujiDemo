//
//  ZYMallMoreVC.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/25.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYMallMoreVC.h"
#import "ZYMallMoreView.h"
#import "ZYMallMoreCell.h"
#import "AppListItem.h"

static NSString * const kCellIdentifier = @"ZYMallMoreVCCell";

@interface ZYMallMoreVC ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic , strong) ZYMallMoreView *baseView;

@property (nonatomic , assign) int page;
@property (nonatomic , strong) NSMutableArray *items;

@end

@implementation ZYMallMoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = self.baseView;
    self.title = _templateName;
    
    _page = 1;
    [self showLoadingView];
    [self loadItems:NO];
}

#pragma mark - 获取商品列表
- (void)loadItems:(BOOL)showHud{
    _p_AppListItem *param = [_p_AppListItem new];
    param.templateId = _templateId;
    param.page = [NSString stringWithFormat:@"%d",_page];
    [[ZYHttpClient client] post:param
                        showHud:showHud
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            [self hideLoadingView];
                            [self hideErrorView];
                            [self.baseView.collectionView.mj_header endRefreshing];
                            [self.baseView.collectionView.mj_footer endRefreshing];
                            if(responseObj.isSuccess){
                                if(1 == self.page){
                                    [self.items removeAllObjects];
                                }
                                NSArray *arr = responseObj.data[@"rows"];
                                int totalCount = [responseObj.data[@"totalCount"] intValue];
                                for(NSDictionary *dic in arr){
                                    _m_AppListItem *model = [[_m_AppListItem alloc] initWithDictionary:dic];
                                    [self.items addObject:model];
                                }
                                if(self.items.count >= totalCount){
                                    [self.baseView.collectionView.mj_footer endRefreshingWithNoMoreData];
                                }else{
                                    [self.baseView.collectionView.mj_footer resetNoMoreData];
                                }
                                [self.baseView.collectionView reloadData];
                            }else{
                                [ZYToast showWithTitle:responseObj.message];
                            }
                        } failure:^(NSURLSessionDataTask *task, NSError *error) {
                            [self hideLoadingView];
                            [self hideErrorView];
                            [self.baseView.collectionView.mj_header endRefreshing];
                            [self.baseView.collectionView.mj_footer endRefreshing];
                            
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
                            [self.baseView.collectionView.mj_header endRefreshing];
                            [self.baseView.collectionView.mj_footer endRefreshing];
                        }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZYMallMoreCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    _m_AppListItem *model = self.items[indexPath.row];
    [cell showCellWithModel:model];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 15 * UI_H_SCALE;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((SCREEN_WIDTH - 45 * UI_H_SCALE) / 2.0 , (SCREEN_WIDTH - 45 * UI_H_SCALE) / 2.0 * 1.38);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(15 * UI_H_SCALE, 15 * UI_H_SCALE, 0, 15 * UI_H_SCALE);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    _m_AppListItem *model = self.items[indexPath.row];
    [[ZYRouter router] goWithoutHead:[NSString stringWithFormat:@"itemDetail?itemId=%@",[model.itemId URLEncode]]];
}

#pragma mark - getter
- (ZYMallMoreView *)baseView{
    if(!_baseView){
        _baseView = [ZYMallMoreView new];
        _baseView.collectionView.delegate = self;
        _baseView.collectionView.dataSource = self;
        [_baseView.collectionView registerClass:[ZYMallMoreCell class] forCellWithReuseIdentifier:kCellIdentifier];
        
        __weak __typeof__(self) weakSelf = self;
        [_baseView.collectionView addRefreshHeaderWithBlock:^{
            weakSelf.page = 1;
            [weakSelf loadItems:NO];
        }];
        [_baseView.collectionView addRefreshFooterWithBlock:^{
            weakSelf.page++;
            [weakSelf loadItems:NO];
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

@end
