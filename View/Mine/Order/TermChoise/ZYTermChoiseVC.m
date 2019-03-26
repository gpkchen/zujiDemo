//
//  ZYTermChoiseVC.m
//  Apollo
//
//  Created by 李明伟 on 2018/6/20.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYTermChoiseVC.h"
#import "ZYTermChoiseView.h"
#import "ZYTermChoiseCell.h"
#import "GetReletPeriod.h"

@interface ZYTermChoiseVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) ZYTermChoiseView *baseView;
@property (nonatomic , strong) NSMutableArray *terms;

@end

@implementation ZYTermChoiseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(!_rentType){
        _rentType = self.dicParam[@"rentType"];
        _selectedTerm = [self.dicParam[@"selectedTerm"] intValue];
    }
    self.view = self.baseView;
    self.title = @"选择租期";
    
    [self showLoadingView];
    [self loadTerms:NO];
}

- (void)loadTerms:(BOOL)showHud{
    _p_GetReletPeriod *param = [_p_GetReletPeriod new];
    param.rentType = _rentType;
    [[ZYHttpClient client] post:param showHud:showHud success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
        [self hideLoadingView];
        [self hideErrorView];
        [self.baseView.tableView.mj_header endRefreshing];
        if(responseObj.isSuccess){
            [self.terms removeAllObjects];
            self.terms = [_m_GetReletPeriod mj_objectArrayWithKeyValuesArray:responseObj.data];
            [self.baseView.tableView reloadData];
        }else{
            [ZYToast showWithTitle:responseObj.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideLoadingView];
        [self hideErrorView];
        [self.baseView.tableView.mj_header endRefreshing];
        
        __weak __typeof__(self) weakSelf = self;
        if(self.terms.count){
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
                    [weakSelf loadTerms:YES];
                }];
            }else if(error.code == ZYHttpErrorCodeNoNet){
                [self showNoNetView:^{
                    [weakSelf loadTerms:YES];
                }];
            }else if(error.code == ZYHttpErrorCodeSystemError){
                [self showSystemErrorView:^{
                    [weakSelf loadTerms:YES];
                }];
            }
        }
    } authFail:^{
        [self hideLoadingView];
        [self hideErrorView];
        [self.baseView.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ZYTermChoiseCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
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
    
    _m_GetReletPeriod *model = self.terms[indexPath.row];
    void (^callBack)(int term) = self.callBack;
    !callBack ? : callBack(model.rentPeriod);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.terms.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ZYTermChoiseVCCell";
    ZYTermChoiseCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[ZYTermChoiseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.separator.hidden = indexPath.row == 0;
    _m_GetReletPeriod *model = self.terms[indexPath.row];
    if([_rentType intValue] == ZYRentTypeLong){
        cell.titleLab.text = [NSString stringWithFormat:@"%d个月",model.rentPeriod];
    }else{
        cell.titleLab.text = [NSString stringWithFormat:@"%d天",model.rentPeriod];
    }
    if(model.rentPeriod == _selectedTerm){
        cell.isSelectedTerm = YES;
    }else{
        cell.isSelectedTerm = NO;
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark - getter
- (ZYTermChoiseView *)baseView{
    if(!_baseView){
        _baseView = [ZYTermChoiseView new];
        _baseView.tableView.delegate = self;
        _baseView.tableView.dataSource = self;
        
        __weak __typeof__(self) weakSelf = self;
        [_baseView.tableView addRefreshHeaderWithBlock:^{
            [weakSelf loadTerms:NO];
        }];
    }
    return _baseView;
}

- (NSMutableArray *)terms{
    if(!_terms){
        _terms = [NSMutableArray new];
    }
    return _terms;
}

@end
