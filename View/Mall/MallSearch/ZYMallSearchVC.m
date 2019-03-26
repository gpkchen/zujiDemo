//
//  ZYMallSearchVC.m
//  Apollo
//
//  Created by 李明伟 on 2018/8/1.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYMallSearchVC.h"
#import "ZYMallSearchView.h"
#import "ZYMallSearchTitleView.h"
#import "ZYMallSearchHistoryCell.h"
#import "ZYMallSearchHeader.h"
#import "GetGoodsSearchKeyList.h"
#import "ZYSearchHistoryDB.h"
#import "GetGoodsListByKey.h"
#import "ZYMallSearchItemCell.h"

static NSString * const kHistoryCellIdentifier = @"ZYMallSearchVCHistoryCell";
static NSString * const kItemCellIdentifier = @"ZYMallSearchVCItemCell";
static NSString * const kHeaderIdentifier = @"kHeaderIdentifier";

@interface ZYMallSearchVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITextFieldDelegate>

@property (nonatomic , strong) ZYMallSearchView *baseView;
@property (nonatomic , strong) ZYMallSearchTitleView *titleView;

@property (nonatomic , assign) BOOL isHistoryMode;//是否是显示历史，否显示结果
@property (nonatomic , strong) NSMutableArray *hotList;
@property (nonatomic , strong) NSMutableArray *historyList; //字典：content,width
@property (nonatomic , strong) NSMutableArray *items;

@property (nonatomic , assign) int page;
@property (nonatomic , copy) NSString *searchKey;

@property (nonatomic , assign) BOOL isShowed; //该界面是否显示过

@end

@implementation ZYMallSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isHistoryMode = YES;
    _page = 1;
    
    self.view = self.baseView;
    self.navigationItem.titleView = self.titleView;
    self.rightBarItems = @[[UIImage imageNamed:@"zy_mall_search_btn"]];
    
    [self loadHot];
    [self reloadHistory];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if(!_isShowed){
        _isShowed = YES;
        [self.titleView.textField becomeFirstResponder];
    }
}

- (void)rightBarItemsAction:(int)index{
    [self search];
}

#pragma mark - 刷新历史搜索
- (void)reloadHistory{
    [self.historyList removeAllObjects];
    NSMutableArray *arr = [ZYSearchHistoryDB getHistory:ZYSearchHistoryTypeItem];
    for(NSString *content in arr){
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:content forKey:@"content"];
        CGFloat width = [content boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                              options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName:FONT(14)}
                                              context:nil].size.width + 28 * UI_H_SCALE;
        [dic setValue:@(width) forKey:@"width"];
        [self.historyList addObject:dic];
    }
    [self.baseView.collectionView reloadData];
}

#pragma mark - 发起搜索
- (void)search{
    [self.titleView endEditing:YES];
    NSString *content = self.titleView.textField.text;
    if([content stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0){
        [ZYToast showWithTitle:@"请输入搜索内容"];
        return;
    }
    [ZYSearchHistoryDB saveHistory:content type:ZYSearchHistoryTypeItem];
    [self reloadHistory];
    
    _searchKey = content;
    _page = 1;
    [self loadItems:YES];
}

#pragma mark - 显示搜索历史
- (void)showHistory{
    [self hideErrorView];
    _isHistoryMode = YES;
    self.baseView.layout.sectionInset = UIEdgeInsetsMake(0, 15 * UI_H_SCALE, 20 * UI_H_SCALE, 15 * UI_H_SCALE);
    self.baseView.layout.lineSpacing = 10 * UI_H_SCALE;
    self.baseView.layout.interitemSpacing = 10 * UI_H_SCALE;
    self.baseView.collectionView.backgroundColor = UIColor.whiteColor;
    [self.baseView.collectionView reloadData];
    self.baseView.collectionView.mj_header = nil;
    self.baseView.collectionView.mj_footer = nil;
    [self loadHot];
    [self reloadHistory];
}

#pragma mark - 显示搜索结果
- (void)showSearchResult{
    __weak __typeof__(self) weakSelf = self;
    [self.baseView.collectionView addRefreshHeaderWithBlock:^{
        weakSelf.page = 1;
        [weakSelf loadItems:NO];
    }];
    [self.baseView.collectionView addRefreshFooterWithBlock:^{
        weakSelf.page++;
        [weakSelf loadItems:NO];
    }];
    
    _isHistoryMode = NO;
    self.baseView.layout.sectionInset = UIEdgeInsetsMake(10 * UI_H_SCALE, 15 * UI_H_SCALE, 0, 15 * UI_H_SCALE);
    self.baseView.layout.lineSpacing = 15 * UI_H_SCALE;
    self.baseView.layout.interitemSpacing = (SCREEN_WIDTH - 30 * UI_H_SCALE - 2 * ZYMallSearchItemCellSize.width);
    self.baseView.collectionView.backgroundColor = VIEW_COLOR;
    [self.baseView.collectionView reloadData];
}

#pragma mark - 获取热门搜索
- (void)loadHot{
    _p_GetGoodsSearchKeyList *param = [_p_GetGoodsSearchKeyList new];
    [[ZYHttpClient client] post:param
                        showHud:NO
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            if(responseObj.isSuccess){
                                [self.hotList removeAllObjects];
                                NSArray *arr = responseObj.data;
                                for(NSDictionary *dic in arr){
                                    _m_GetGoodsSearchKeyList *model = [_m_GetGoodsSearchKeyList mj_objectWithKeyValues:dic];
                                    model.width = [model.value boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                                                            options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                                                         attributes:@{NSFontAttributeName:FONT(14)}
                                                                            context:nil].size.width + 28 * UI_H_SCALE;
                                    [self.hotList addObject:model];
                                }
                                [self.baseView.collectionView reloadData];
                            }
                        } failure:nil authFail:nil];
}

#pragma mark - 获取商品列表
- (void)loadItems:(BOOL)showHud{
    _p_GetGoodsListByKey *param = [_p_GetGoodsListByKey new];
    param.page = [NSString stringWithFormat:@"%d",_page];
    param.searchValue = _searchKey;
    [[ZYHttpClient client] post:param
                        showHud:showHud
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            [self.baseView.collectionView.mj_header endRefreshing];
                            [self.baseView.collectionView.mj_footer endRefreshing];
                            if(responseObj.isSuccess){
                                if(1 == self.page){
                                    [self.items removeAllObjects];
                                }
                                NSArray *arr = responseObj.data[@"rows"];
                                int totalCount = [responseObj.data[@"totalCount"] intValue];
                                for(NSDictionary *dic in arr){
                                    _m_GetGoodsListByKey *model = [[_m_GetGoodsListByKey alloc] initWithDictionary:dic];
                                    [self.items addObject:model];
                                }
                                if(self.items.count >= totalCount){
                                    [self.baseView.collectionView.mj_footer endRefreshingWithNoMoreData];
                                }else{
                                    [self.baseView.collectionView.mj_footer resetNoMoreData];
                                }
                                if(self.isHistoryMode){
                                    [self showSearchResult];
                                }else{
                                    [self.baseView.collectionView reloadData];
                                }
                                if(!self.items.count){
                                    [self showNoSearchResultView];
                                }else{
                                    [self hideErrorView];
                                }
                            }else{
                                [ZYToast showWithTitle:responseObj.message];
                            }
                        } failure:^(NSURLSessionDataTask *task, NSError *error) {
                            [self.baseView.collectionView.mj_header endRefreshing];
                            [self.baseView.collectionView.mj_footer endRefreshing];
                            
                            if(error.code == ZYHttpErrorCodeTimeOut){
                                [ZYToast showWithTitle:ZYHttpErrorMessageNetTimeOut];
                            }else if(error.code == ZYHttpErrorCodeNoNet){
                                [ZYToast showWithTitle:ZYHttpErrorMessageNoNet];
                            }else if(error.code == ZYHttpErrorCodeSystemError){
                                [ZYToast showWithTitle:ZYHttpErrorMessageSystemError];
                            }
                        } authFail:^{
                            [self.baseView.collectionView.mj_header endRefreshing];
                            [self.baseView.collectionView.mj_footer endRefreshing];
                        }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self search];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self showHistory];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if(_isHistoryMode){
        return 2;
    }
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(_isHistoryMode){
        if(0 == section){
            return self.hotList.count;
        }
        return self.historyList.count;
    }
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(_isHistoryMode){
        ZYMallSearchHistoryCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:kHistoryCellIdentifier forIndexPath:indexPath];
        if(0 == indexPath.section){
            _m_GetGoodsSearchKeyList *model = self.hotList[indexPath.row];
            cell.title = model.value;
        }else{
            NSDictionary *dic = self.historyList[indexPath.row];
            cell.title = dic[@"content"];
        }
        return cell;
    }
    ZYMallSearchItemCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:kItemCellIdentifier forIndexPath:indexPath];
    _m_GetGoodsListByKey *model = self.items[indexPath.row];
    [cell showCellWithModel:model];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if([kind isEqualToString:UICollectionElementKindSectionHeader]){
        ZYMallSearchHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderIdentifier forIndexPath:indexPath];
        if(0 == indexPath.section){
            header.titleLab.text = @"热门搜索";
            header.line.hidden = YES;
            header.clearBtn.hidden = YES;
        }else{
            header.titleLab.text = @"历史搜索";
            header.line.hidden = NO;
            header.clearBtn.hidden = NO;
            
            __weak __typeof__(self) weakSelf = self;
            [header.clearBtn clickAction:^(UIButton * _Nonnull button) {
                [ZYSearchHistoryDB removeAllHistory:ZYSearchHistoryTypeItem];
                [weakSelf reloadHistory];
            }];
        }
        return header;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if(_isHistoryMode){
        return CGSizeMake(SCREEN_WIDTH, 56 * UI_H_SCALE);
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(_isHistoryMode){
        if(0 == indexPath.section){
            _m_GetGoodsSearchKeyList *model = self.hotList[indexPath.row];
            return CGSizeMake(model.width, ZYMallSearchHistoryCellHeight);
        }else{
            NSDictionary *dic = self.historyList[indexPath.row];
            NSNumber *width = dic[@"width"];
            return CGSizeMake(width.floatValue, ZYMallSearchHistoryCellHeight);
        }
    }
    return ZYMallSearchItemCellSize;
}

#pragma mark - UICollectionViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.titleView endEditing:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(_isHistoryMode){
        if(0 == indexPath.section){
            _m_GetGoodsSearchKeyList *model = self.hotList[indexPath.row];
            self.titleView.textField.text = model.value;
            [self search];
        }else{
            NSDictionary *dic = self.historyList[indexPath.row];
            self.titleView.textField.text = dic[@"content"];
            [self search];
        }
    }else{
        _m_GetGoodsListByKey *model = self.items[indexPath.row];
        [[ZYRouter router] goWithoutHead:[NSString stringWithFormat:@"itemDetail?itemId=%@",[model.itemId URLEncode]]];
    }
}


#pragma mark - getter
- (ZYMallSearchView *)baseView{
    if(!_baseView){
        _baseView = [ZYMallSearchView new];
        _baseView.collectionView.delegate = self;
        _baseView.collectionView.dataSource = self;
        [_baseView.collectionView registerClass:[ZYMallSearchHistoryCell class]
                     forCellWithReuseIdentifier:kHistoryCellIdentifier];
        [_baseView.collectionView registerClass:[ZYMallSearchHeader class]
                     forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                            withReuseIdentifier:kHeaderIdentifier];
        [_baseView.collectionView registerClass:[ZYMallSearchItemCell class]
                     forCellWithReuseIdentifier:kItemCellIdentifier];
    }
    return _baseView;
}

- (ZYMallSearchTitleView *)titleView{
    if(!_titleView){
        _titleView = [ZYMallSearchTitleView new];
        _titleView.textField.delegate = self;
    }
    return _titleView;
}

- (NSMutableArray *)hotList{
    if(!_hotList){
        _hotList = [NSMutableArray array];
    }
    return _hotList;
}

- (NSMutableArray *)historyList{
    if(!_historyList){
        _historyList = [NSMutableArray array];
    }
    return _historyList;
}

- (NSMutableArray *)items{
    if(!_items){
        _items = [NSMutableArray array];
    }
    return _items;
}

@end
