//
//  ZYAuthingVC.m
//  Apollo
//
//  Created by 李明伟 on 2018/7/9.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYAuthingVC.h"
#import "ZYAuthingView.h"
#import "ZYAuthingCell.h"
#import "ZYAuthingHeader.h"
#import "ZYAuthingMoreHeader.h"
#import "AuditStatus.h"
#import "ZYQuotaService.h"

@interface ZYAuthingVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) ZYAuthingView *baseView;
@property (nonatomic , strong) ZYAuthingHeader *header;
@property (nonatomic , strong) ZYAuthingMoreHeader *moreHeader;

@property (nonatomic , strong) NSMutableArray *authArr;

@property (nonatomic , strong) _m_AuditStatus *info;

@end

@implementation ZYAuthingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = self.baseView;
    self.title = @"实名认证";
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self loadInfo:NO];
}

#pragma mark - 加载页面信息
- (void)loadInfo:(BOOL)showHud{
    _p_AuditStatus *param = [_p_AuditStatus new];
    [[ZYHttpClient client] post:param
                        showHud:showHud
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            [self hideLoadingView];
                            [self hideErrorView];
                            if (responseObj.success) {
                                self.info = [_m_AuditStatus mj_objectWithKeyValues:responseObj.data];
                                
                                [self.authArr removeAllObjects];
                                if(!self.info.studentIdCard){
                                    [self.authArr addObject:@{@"title":@"在校学生认证",
                                                              @"detail":@"花费15s平均获得1000额度",
                                                              @"image":@"zy_quota_student_logo",
                                                              @"type":@"student",
                                                              }];
                                }
                                if(!self.info.writeOperator){
                                    [self.authArr addObject:@{@"title":@"运营商认证",
                                                              @"detail":@"花费30s平均获得2000额度",
                                                              @"image":@"zy_quota_operator_logo",
                                                              @"type":@"operator"
                                                              }];
                                }
                                if(!self.info.writeTaobao && !self.info.taoBaoSwitch){
                                    [self.authArr addObject:@{@"title":@"淘宝认证",
                                                              @"detail":@"花费20s平均获得3000额度",
                                                              @"image":@"zy_quota_taobao_logo",
                                                              @"type":@"taobao"
                                                              }];
                                }
                                
                                [self.baseView.tableView reloadData];
                            } else {
                                [ZYToast showWithTitle:responseObj.message];
                            }
                        } failure:^(NSURLSessionDataTask *task, NSError *error) {
                            [self hideLoadingView];
                            [self hideErrorView];
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
                                        [weakSelf loadInfo:YES];
                                    }];
                                }else if(error.code == ZYHttpErrorCodeNoNet){
                                    [self showNoNetView:^{
                                        [weakSelf loadInfo:YES];
                                    }];
                                }else if(error.code == ZYHttpErrorCodeSystemError){
                                    [self showSystemErrorView:^{
                                        [weakSelf loadInfo:YES];
                                    }];
                                }
                            }
                        } authFail:^{
                            [self hideLoadingView];
                            [self hideErrorView];
                        }];
}

#pragma mark - 运营商、淘宝认证
- (void)auth:(NSString *)plantform{
    if ([plantform isEqualToString:@"operator"]) {
        [ZYQuotaService authOperator];
    } else if([plantform isEqualToString:@"taobao"]){
        [ZYQuotaService authTaobao:YES];
    } else if([plantform isEqualToString:@"student"]){
        [ZYQuotaService authStudent];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(0 == section){
        return 0;
    }
    return self.authArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ZYQuotaVCCell";
    ZYAuthingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[ZYAuthingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    __weak __typeof__(self) weakSelf = self;
    NSDictionary *dic = self.authArr[indexPath.row];
    cell.logoIV.image = [UIImage imageNamed:dic[@"image"]];
    cell.titleLab.text = dic[@"title"];
    cell.detailLab.text = dic[@"detail"];
    [cell.authBtn clickAction:^(UIButton * _Nonnull button) {
        [weakSelf auth:dic[@"type"]];
    }];
    cell.separator.hidden = indexPath.row == 0;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if((_info.writeOperator && _info.studentIdCard && _info.taoBaoSwitch) ||
       (_info.writeOperator && _info.studentIdCard && (!_info.taoBaoSwitch && _info.writeTaobao))){
        return 1;
    }
    return 2;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ZYAuthingCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(0 == section){
        return ZYAuthingHeaderHeight;
    }
    return ZYAuthingMoreHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(0 == section){
        return self.header;
    }
    return self.moreHeader;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - getter
- (NSMutableArray *)authArr{
    if(!_authArr){
        _authArr = [NSMutableArray array];
    }
    return _authArr;
}

- (ZYAuthingView *)baseView{
    if(!_baseView){
        _baseView = [ZYAuthingView new];
        _baseView.tableView.delegate = self;
        _baseView.tableView.dataSource = self;
    }
    return _baseView;
}

- (ZYAuthingHeader *)header{
    if(!_header){
        _header = [ZYAuthingHeader new];
        [_header.wanderingBtn clickAction:^(UIButton * _Nonnull button) {
            [[ZYRouter router] returnToRoot];
            [ZYMainTabVC shareInstance].selectedIndex = 0;
        }];
    }
    return _header;
}

- (ZYAuthingMoreHeader *)moreHeader{
    if(!_moreHeader){
        _moreHeader = [ZYAuthingMoreHeader new];
    }
    return _moreHeader;
}

@end
