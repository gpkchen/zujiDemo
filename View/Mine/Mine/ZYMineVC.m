//
//  ZYMineVC.m
//  Apollo
//
//  Created by 李明伟 on 2018/9/4.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYMineVC.h"
#import "ZYMineView.h"
#import "ZYMineCell.h"
#import "ZYMineHeader.h"
#import "GetMyHomeInfo.h"
#import "AuditStatus.h"
#import "ZYMineQuotaDetailView.h"

@interface ZYMineVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) ZYMineView *baseView;
@property (nonatomic , strong) ZYMineHeader *header;
@property (nonatomic , strong) ZYMineQuotaDetailView *quotaDetailView;
@property (nonatomic , strong) NSArray *titles;

@property (nonatomic , strong) _m_GetMyHomeInfo *mineInfo;
@property (nonatomic , strong) _m_AuditStatus *authInfo;

@end

@implementation ZYMineVC

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:ZYMobileLoginSuccessNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:ZYLogoutNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:ZYTokenAuthFailNotification
                                                  object:nil];
}

- (instancetype)init{
    if(self = [super init]){
        self.navigationBarAlpha = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = self.baseView;
    
    //注册登录成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(logined:)
                                                 name:ZYMobileLoginSuccessNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(logouted:)
                                                 name:ZYLogoutNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(logouted:)
                                                 name:ZYTokenAuthFailNotification
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if([ZYUser user].isUserLogined){
        //加载页面基础数据
        [self loadMineInfo];
        //加载授信信息
        [self loadQuotaInfo];
    }else{
        self.header.mineInfo = nil;
        self.header.authInfo = nil;
        [self.baseView.tableView reloadData];
    }
}

#pragma mark - 登录成功通知
- (void)logined:(NSNotification *)notification{
    //加载页面基础数据
    [self loadMineInfo];
    //加载授信信息
    [self loadQuotaInfo];
}

#pragma mark - 退出登录成功通知
- (void)logouted:(NSNotification *)notification{
    self.authInfo = nil;
    self.mineInfo = nil;
    self.header.authInfo = nil;
    self.header.mineInfo = nil;
    [self.baseView.tableView reloadData];
}

#pragma mark - 加载我的页面基础数据
- (void)loadMineInfo{
    _p_GetMyHomeInfo *param = [[_p_GetMyHomeInfo alloc] init];
    [[ZYHttpClient client] post:param showHud:NO success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
        if (responseObj.success) {
            self.mineInfo = [_m_GetMyHomeInfo mj_objectWithKeyValues:responseObj.data];
            
            ZYUser *user = [ZYUser user];
            user.nickname = self.mineInfo.nickName;
            user.portraitPath = self.mineInfo.portraitPath;
            [user save];
            
            self.header.mineInfo = self.mineInfo;
            
            [self.baseView.tableView reloadData];
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
    } authFail:^{
        [self logouted:nil];
    }];
}

#pragma mark - 加载页面信息
- (void)loadQuotaInfo{
    _p_AuditStatus *param = [_p_AuditStatus new];
    [[ZYHttpClient client] post:param
                        showHud:NO
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            if (responseObj.success) {
                                self.authInfo = [_m_AuditStatus mj_objectWithKeyValues:responseObj.data];
                                self.header.authInfo = self.authInfo;
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

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ZYMineCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return ZYMineHeaderHeight;
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
    
    if(0 == indexPath.row){
        //账单
        [[ZYLoginService service] requireLogin:^{
            [[ZYRouter router] goVC:@"ZYBillListVC"];
        }];
    }else if(1 == indexPath.row){
        //信息
        [[ZYLoginService service] requireLogin:^{
            [[ZYRouter router] goWithoutHead:[NSString stringWithFormat:@"web?url=%@&alwaysBounceHorizontal=0",
                                              [[ZYH5Utils formatUrl:ZYH5TypeMessage param:nil] URLEncode]]];
        }];
    }else if(2 == indexPath.row){
        //优惠券
        [[ZYLoginService service] requireLogin:^{
            [[ZYRouter router] goVC:@"ZYCouponVC?status=0"];
        }];
    }else if(3 == indexPath.row){
        //收藏
        [[ZYLoginService service] requireLogin:^{
            [[ZYRouter router] goVC:@"ZYCollectVC"];
        }];
    }else if(4 == indexPath.row){
        //我的地址
        [[ZYLoginService service] requireLogin:^{
            [[ZYRouter router] goVC:@"ZYAddressManageVC"];
        }];
    }else if(5 == indexPath.row){
        //联系客服
        [[ZYRouter router] goWithoutHead:[NSString stringWithFormat:@"web?url=%@&swipeToBack=0&alwaysBounceVertical=0&alwaysBounceHorizontal=0",
                                          [[ZYH5Utils formatUrl:ZYH5TypeHelp param:nil] URLEncode]]];
    }else if(6 == indexPath.row){
        //设置
        [[ZYRouter router] goVC:@"ZYSetVC"];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ZYMineVCell";
    ZYMineCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[ZYMineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.separator.hidden = indexPath.row == 0;
    cell.title = self.titles[indexPath.row];
    
    if(1 == indexPath.row){
        if([ZYUser user].isUserLogined){
            cell.num = self.mineInfo.unReadNum;
        }else{
            cell.num = 0;
        }
    }else{
        cell.num = 0;
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark - getter
- (ZYMineView *)baseView{
    if(!_baseView){
        _baseView = [ZYMineView new];
        _baseView.tableView.delegate = self;
        _baseView.tableView.dataSource = self;
    }
    return _baseView;
}

- (ZYMineHeader *)header{
    if(!_header){
        _header = [ZYMineHeader new];
        
        __weak __typeof__(self) weakSelf = self;
        __weak __typeof__(_header) weakHeader = _header;
        [_header.nicknameLab tapped:^(UITapGestureRecognizer *gesture) {
            if([ZYUser user].isUserLogined){
                [[ZYLoginService service] requireLogin:^{
                    [[ZYRouter router] goWithoutHead:[NSString stringWithFormat:@"userCenter?userId=%@",[[ZYUser user].userId URLEncode]]];
                }];
            }else{
                [[ZYRouter router] goWithoutHead:@"login"];
            }
        } delegate:nil];
        [_header.userCenterLab tapped:^(UITapGestureRecognizer *gesture) {
            [[ZYLoginService service] requireLogin:^{
                [[ZYRouter router] goWithoutHead:[NSString stringWithFormat:@"userCenter?userId=%@",[[ZYUser user].userId URLEncode]]];
            }];
        } delegate:nil];
        [_header.portrait tapped:^(UITapGestureRecognizer *gesture) {
            [[ZYLoginService service] requireLogin:^{
                [[ZYRouter router] goWithoutHead:[NSString stringWithFormat:@"userCenter?userId=%@",[[ZYUser user].userId URLEncode]]];
            }];
        } delegate:nil];
        [_header.authBtn clickAction:^(UIButton * _Nonnull button) {
            switch (weakSelf.authInfo.status) {
                case ZYAuthStateUnAuth:
                case ZYAuthStateCanceled:
                case ZYAuthStateAuthing:
                case ZYAuthStateImprove:
                    [[ZYRouter router] goWithoutHead:@"limit"];
                    break;
                case ZYAuthStateAuthed:{
                    if(!weakSelf.authInfo.writeOperator ||
                       !weakSelf.authInfo.studentIdCard ||
                       (!weakSelf.authInfo.writeTaobao && !weakSelf.authInfo.taoBaoSwitch)){
                        [[ZYRouter router] goWithoutHead:@"limit"];
                    }else{
                        [ZYMainTabVC shareInstance].selectedIndex = 1;
                    }
                }
                    break;
                    
                default:
                    break;
            }
        }];
        [_header.allOrderLab tapped:^(UITapGestureRecognizer *gesture) {
            [[ZYLoginService service] requireLogin:^{
                [[ZYRouter router] goVC:@"ZYOrderListVC"];
            }];
        } delegate:nil];
        for(ZYMineOrderBtn *btn in self.header.orderBtns){
            [btn clickAction:^(UIButton * _Nonnull button) {
                [[ZYLoginService service] requireLogin:^{
                    [[ZYRouter router] goVC:[NSString stringWithFormat:@"ZYOrderListVC?orderState=%d",btn.orderState]];
                }];
            }];
        }
        [_header.quotaHelpBtn clickAction:^(UIButton * _Nonnull button) {
            weakSelf.quotaDetailView.amount = weakSelf.authInfo.tempLimit;
            weakSelf.quotaDetailView.limit = weakSelf.authInfo.tempLimitEffective;
            weakSelf.quotaDetailView.explain = weakSelf.authInfo.tempLimitExplain;
            [weakSelf.quotaDetailView showAtPoint:CGPointMake(weakHeader.quotaHelpBtn.centerX,
                                                              weakHeader.quotaHelpBtn.bottom - 4 - weakSelf.baseView.tableView.contentOffset.y)];
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

- (NSArray *)titles{
    if(!_titles){
        _titles = @[@"账单",@"消息",@"优惠券",@"收藏",@"地址",@"联系客服",@"设置"];
    }
    return _titles;
}

@end
