//
//  ZYQuotaVC.m
//  Apollo
//
//  Created by 李明伟 on 2018/7/9.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYQuotaVC.h"
#import "ZYQuotaView.h"
#import "ZYQuotaHeader.h"
#import "ZYQuotaCell.h"
#import "AuditStatus.h"
#import "ZYQuotaService.h"
#import "ZYMineQuotaDetailView.h"

@interface ZYQuotaVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) ZYQuotaView *baseView;
@property (nonatomic , strong) ZYQuotaHeader *header;
@property (nonatomic , strong) ZYMineQuotaDetailView *quotaDetailView;

@property (nonatomic , strong) _m_AuditStatus *info;
@property (nonatomic , strong) NSMutableArray *authArr;

@end

@implementation ZYQuotaVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = self.baseView;
    self.title = @"免押额度";
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
                                self.header.authInfo = self.info;
                                
                                [self.authArr removeAllObjects];
                                [self.authArr addObject:@{@"title":@"在校学生认证",
                                                          @"detail":@"花费15s平均获得1000额度",
                                                          @"image":@"zy_quota_student_logo",
                                                          @"type":@"student",
                                                          @"state":self.info.studentIdCard ? @"1" : @"0"
                                                          }];
                                [self.authArr addObject:@{@"title":@"运营商认证",
                                                          @"detail":@"花费30s平均获得2000额度",
                                                          @"image":@"zy_quota_operator_logo",
                                                          @"type":@"operator",
                                                          @"state":self.info.writeOperator ? @"1" : @"0"
                                                          }];
                                if(!self.info.taoBaoSwitch){
                                    [self.authArr addObject:@{@"title":@"淘宝认证",
                                                              @"detail":@"花费20s平均获得3000额度",
                                                              @"image":@"zy_quota_taobao_logo",
                                                              @"type":@"taobao",
                                                              @"state":self.info.writeTaobao ? @"1" : @"0"
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
    return self.authArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ZYQuotaVCCell";
    ZYQuotaCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[ZYQuotaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    __weak __typeof__(self) weakSelf = self;
    NSDictionary *dic = self.authArr[indexPath.row];
    cell.logoIV.image = [UIImage imageNamed:dic[@"image"]];
    cell.titleLab.text = dic[@"title"];
    cell.detailLab.text = dic[@"detail"];
    BOOL state = [dic[@"state"] boolValue];
    if(state){
        cell.authBtn.enabled = NO;
        cell.authBtn.borderColor = BTN_COLOR_DISABLE;
    }else{
        cell.authBtn.enabled = YES;
        cell.authBtn.borderColor = BTN_COLOR_NORMAL_GREEN;
    }
    [cell.authBtn clickAction:^(UIButton * _Nonnull button) {
        [weakSelf auth:dic[@"type"]];
    }];
    cell.separator.hidden = indexPath.row == 0;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ZYQuotaCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return ZYQuotaHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.header;
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

- (ZYQuotaView *)baseView{
    if(!_baseView){
        _baseView = [ZYQuotaView new];
        _baseView.tableView.delegate = self;
        _baseView.tableView.dataSource = self;
    }
    return _baseView;
}

- (ZYQuotaHeader *)header{
    if(!_header){
        _header = [ZYQuotaHeader new];
        
        __weak __typeof__(self) weakSelf = self;
        __weak __typeof__(_header) weakHeader = _header;
        [_header.quotaHelpBtn clickAction:^(UIButton * _Nonnull button) {
            weakSelf.quotaDetailView.amount = weakSelf.info.tempLimit;
            weakSelf.quotaDetailView.limit = weakSelf.info.tempLimitEffective;
            weakSelf.quotaDetailView.explain = weakSelf.info.tempLimitExplain;
            [weakSelf.quotaDetailView showAtPoint:CGPointMake(weakHeader.quotaHelpBtn.centerX,
                                                              weakHeader.quotaHelpBtn.bottom - 4 + NAVIGATION_BAR_HEIGHT - weakSelf.baseView.tableView.contentOffset.y)];
        }];
        [_header.recordBtn clickAction:^(UIButton * _Nonnull button) {
            [[ZYLoginService service] requireLogin:^{
                [[ZYRouter router] goVC:@"ZYQuotaRecordVC"];
            }];
        }];
        [_header.instructionBtn clickAction:^(UIButton * _Nonnull button) {
            [[ZYRouter router] goWithoutHead:[NSString stringWithFormat:@"web?url=%@",
                                              [[ZYH5Utils formatUrl:ZYH5TypeLimitRecord param:nil] URLEncode]]];
        }];
    }
    return _header;
}

- (ZYMineQuotaDetailView *)quotaDetailView{
    if(!_quotaDetailView){
        _quotaDetailView = [ZYMineQuotaDetailView new];
    }
    return _quotaDetailView;
}

@end
