//
//  ZYCreateQuotaVC.m
//  Apollo
//
//  Created by 李明伟 on 2018/7/10.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYCreateQuotaVC.h"
#import "ZYCreateQuotaView.h"
#import "ZYDetailCell.h"
#import "ZYCreateQuotaFooter.h"
#import "BookReceive.h"
#import "LivingAuthentication.h"
#import "AuthenticationQuery.h"
#import "LivingCallback.h"
#import "ZYQuotaService.h"
#import "AliUrl.h"
#import <AlipaySDK/AlipaySDK.h>
#import "AliPayCallback.h"

#if !TARGET_IPHONE_SIMULATOR
#import "ZYContactUtils.h"
#endif

@interface ZYCreateQuotaVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) ZYCreateQuotaView *baseView;
@property (nonatomic , strong) ZYCreateQuotaFooter *footer;

@property (nonatomic , strong) _m_AuthenticationQuery *info;

@property (nonatomic , assign) BOOL isContactUploaded; //是否上传过身份证
@property (nonatomic , strong) NSMutableArray *contactsArr; //通讯录

@end

@implementation ZYCreateQuotaVC

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:HuoTi_Auth_Notification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:ZhiMa_Auth_Notification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = self.baseView;
    self.title = @"个人信息认证";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(huotiCallBack:)
                                                 name:HuoTi_Auth_Notification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(zhiMaCallBack:)
                                                 name:ZhiMa_Auth_Notification object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadInfo:NO];
}

#pragma mark - 获取页面信息
- (void)loadInfo:(BOOL)showHud{
    _p_AuthenticationQuery *param = [[_p_AuthenticationQuery alloc] init];
    [[ZYHttpClient client] post:param showHud:showHud success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
        [self hideLoadingView];
        [self hideErrorView];
        if (responseObj.success) {
            self.info = [_m_AuthenticationQuery mj_objectWithKeyValues:responseObj.data];
            if(self.info.idcardStatus &&
               self.info.faceStatus &&
               self.info.urgent1Status &&
               self.info.idcard &&
               ((self.info.zhimaStatus && !self.info.taoBaoSwitch) || (self.info.taoBaoStatus && self.info.taoBaoSwitch))){
                self.footer.createBtn.enabled = YES;
            }else{
                self.footer.createBtn.enabled = NO;
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

#pragma mark - 发起授信
- (void)startAuthing{
    NSString *idcard = [self.info.idcard tripleDES:kCCDecrypt key:[ZYEnvirUtils utils].protocolEncodeKey];
    if(![idcard isAdult]){
        [ZYToast showWithTitle:@"机有服务暂不对未满18周岁人群开放，敬请谅解"];
        return;
    }
    [ZYQuotaService startAuthing:@"1" success:^{
        void (^callBack)(NSString *authStatus) = self.callBack;
        !callBack ? : callBack([NSString stringWithFormat:@"%d",ZYAuthStateAuthing]);
        [[ZYRouter router] goVC:@"ZYAuthingVC"
                   withCallBack:nil
                         isPush:YES
                     completion:^{
                         NSMutableArray *vcs = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
                         [vcs removeObject:self];
                         self.navigationController.viewControllers = vcs;
                     }];
    }];
}

#pragma mark - 活体认证回调
- (void)huotiCallBack:(NSNotification *)notification{
    if(!self.isVisiable){
        return;
    }
    NSString *resultStr = [notification.userInfo[@"resultStr"] componentsSeparatedByString:@"&"][0];
    NSDictionary *biz_content = [[resultStr componentsSeparatedByString:@"="][1] toDictionary];
    
    NSString *signStr = [notification.userInfo[@"resultStr"] componentsSeparatedByString:@"&"][1];
    NSString *sign = [signStr componentsSeparatedByString:@"="][1];
    
    if (![biz_content[@"passed"] isEqualToString:@"true"]) {
        [ZYToast showWithTitle:biz_content[@"failed_reason"]];
        return;
    }
    
    _p_LivingCallback *param = [[_p_LivingCallback alloc] init];
    param.biz_content = biz_content;
    param.sign = sign;
    [[ZYHttpClient client] post:param showHud:YES success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
        if (responseObj.success) {
            [self loadInfo:YES];
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

#pragma mark - 芝麻认证回调
- (void)zhiMaCallBack:(NSNotification *)notification{
    if(!self.isVisiable){
        return;
    }
    NSDictionary *resultDic = notification.userInfo[@"resultDic"];
    if ([resultDic[@"resultStatus"] isEqualToString:@"4000"]) {
        [ZYToast showWithTitle:@"系统异常！"];
        return;
    } else if ([resultDic[@"resultStatus"] isEqualToString:@"6001"]) {
        [ZYToast showWithTitle:@"您已中途取消！"];
        return;
    } else if ([resultDic[@"resultStatus"] isEqualToString:@"6002"])  {
        [ZYToast showWithTitle:@"网络连接出错！"];
        return;
    } else if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]){
        
        NSString *signStr = [resultDic[@"result"] componentsSeparatedByString:@"&"][3];
        NSString *sign = [signStr componentsSeparatedByString:@"="][1];
        
        NSLog(@"%@",sign);
        
        _p_AliPayCallback *param = [[_p_AliPayCallback alloc] init];
        param.authCode = sign;
        
        [[ZYHttpClient client] post:param showHud:YES success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
            
            if (responseObj.isSuccess) {
                [self loadInfo:YES];
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
        
    } else {
        [ZYToast showWithTitle:@"未知错误,请重试！"];
    }
    
}


#pragma mark - 上传通讯录
- (void)uploadBookReceive{
    if(!self.contactsArr.count){
        return;
    }
    _p_BookReceive *param = [[_p_BookReceive alloc] init];
    param.bookList = [NSArray arrayWithArray:self.contactsArr];
    param.totalNum  =  [NSString stringWithFormat:@"%lu",(unsigned long)self.contactsArr.count];
    [[ZYHttpClient client] post:param showHud:NO success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
        if (responseObj.success) {
            self.isContactUploaded = YES;
        }
    } failure:nil authFail:nil];
}

#pragma mark - 查询活体认证地址
- (void)loadHuoTiUrl{
    _p_LivingAuthentication *param = [[_p_LivingAuthentication alloc] init];
    [[ZYHttpClient client] post:param showHud:YES success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
        if (responseObj.success) {
            _m_LivingAuthentication *model = [_m_LivingAuthentication mj_objectWithKeyValues:responseObj.data];
            NSString *gotoString = [NSString stringWithFormat:@"alipays://platformapi/startapp?appId=20000067&url=%@",[model.url URLEncode]];
            if ([ZYAppUtils isInstallAliPay]) {
                [ZYAppUtils openURL:gotoString];
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

#pragma mark - 加载芝麻认证参数
- (void)loadZhiMaUrl{
    _p_AliUrl *param = [[_p_AliUrl alloc] init];
    [[ZYHttpClient client] post:param showHud:YES success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
        if (responseObj.success) {
            _m_AliUrl *model = [_m_AliUrl mj_objectWithKeyValues:responseObj.data];
            [[AlipaySDK defaultService] auth_V2WithInfo:model.url fromScheme:URLScheme callback:^(NSDictionary *resultDic) {
                //回调在AppDelegate
                NSLog(@"然而并不走这里：%@",resultDic);
            }];
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

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ZYCreateQuotaVCCell";
    ZYDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[ZYDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.titleLab.textColor = WORD_COLOR_BLACK;
        cell.contentLab.textColor = WORD_COLOR_GRAY;
        cell.showArrow = YES;
    }
    
    cell.separator.hidden = indexPath.row == 0;
    if(0 == indexPath.section && 0 == indexPath.row){
        cell.titleLab.text = @"身份证识别";
        if(self.info.idcardStatus){
            cell.contentLab.text = @"已识别";
        }else{
            cell.contentLab.text = @"未识别";
        }
    }else if(0 == indexPath.section && 1 == indexPath.row){
        cell.titleLab.text = @"紧急联系人";
        if(self.info.urgent1Status){
            cell.contentLab.text = @"已添加";
        }else{
            cell.contentLab.text = @"未添加";
        }
    }else if(1 == indexPath.section && 0 == indexPath.row){
        cell.titleLab.text = @"人脸识别";
        if(self.info.faceStatus){
            cell.contentLab.text = @"已识别";
        }else{
            cell.contentLab.text = @"未识别";
        }
    }else if(1 == indexPath.section && 1 == indexPath.row){
        if(self.info.taoBaoSwitch){
            cell.titleLab.text = @"淘宝认证";
            if(self.info.taoBaoStatus){
                cell.contentLab.text = @"已认证";
            }else{
                cell.contentLab.text = @"未认证";
            }
        }else{
            cell.titleLab.text = @"芝麻认证";
            if(self.info.zhimaStatus){
                cell.contentLab.text = @"已认证";
            }else{
                cell.contentLab.text = @"未认证";
            }
        }
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ZYDetailCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(0 == section){
        return 0.01;
    }
    return 10 * UI_H_SCALE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(1 == section){
        return ZYCreateQuotaFooterHeight;
    }
    return 0.01;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(1 == section){
        return self.footer;
    }
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(0 == indexPath.section && 0 == indexPath.row){
        [[ZYRouter router] goVC:@"ZYIdcardScanVC"];
    }else if(0 == indexPath.section && 1 == indexPath.row){
        [self addContact];
    }else if(1 == indexPath.section && 0 == indexPath.row){
        if(!_info.idcardStatus){
            [ZYToast showWithTitle:@"请先完成身份证识别"];
            return;
        }
        [self loadHuoTiUrl];
    }else if(1 == indexPath.section && 1 == indexPath.row){
        if(!_info.taoBaoSwitch){
            if(!_info.idcardStatus){
                [ZYToast showWithTitle:@"请先完成身份证识别"];
                return;
            }
            [self loadZhiMaUrl];
        }else{
            if(!_info.idcardStatus){
                [ZYToast showWithTitle:@"请先完成身份证识别"];
                return;
            }
            [ZYQuotaService authTaobao:NO];
        }
    }
}

#pragma mark - 选择紧急联系人
- (void)addContact{
#if !TARGET_IPHONE_SIMULATOR
    [ZYContactUtils isAuthAddressBookWithRequire:YES success:^{
        [self.contactsArr removeAllObjects];
        [[ZYContactUtils utils] enumerateAllContactInfo:^(ZYContact *contact) {
            NSString *name = @"";
            if(contact.lastName){
                name = [name stringByAppendingString:contact.lastName];
            }
            if(contact.middleName){
                name = [name stringByAppendingString:contact.middleName];
            }
            if(contact.firstName){
                name = [name stringByAppendingString:contact.firstName];
            }
            
            for(NSString *phone in contact.phones){
                NSString *tmpPhone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
                [self.contactsArr addObject:@{@"bookName":name,@"bookMobile":tmpPhone}];
            }
        }];
        [self uploadBookReceive];
        [[ZYContactUtils utils] showWithViewController:self pickBlock:^(NSString *givenName, NSString *familyName, NSString *phone) {
            NSString *name = @"";
            if(familyName){
                name = [name stringByAppendingString:familyName];
            }
            if(givenName){
                name = [name stringByAppendingString:givenName];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSString *url = [NSString stringWithFormat:@"ZYAddContactVC?contactName=%@&contactMobile=%@",[name URLEncode],[phone URLEncode]];
                [[ZYRouter router] goVC:url];
            });
        }];
    }];
#endif
}

#pragma mark - getter
- (ZYCreateQuotaView *)baseView{
    if(!_baseView){
        _baseView = [ZYCreateQuotaView new];
        _baseView.tableView.delegate = self;
        _baseView.tableView.dataSource = self;
    }
    return _baseView;
}

- (ZYCreateQuotaFooter *)footer{
    if(!_footer){
        _footer = [ZYCreateQuotaFooter new];
        
        __weak __typeof__(self) weakSelf = self;
        [_footer.createBtn clickAction:^(UIButton * _Nonnull button) {
            [weakSelf startAuthing];
        }];
    }
    return _footer;
}

- (NSMutableArray *)contactsArr{
    if (!_contactsArr) {
        _contactsArr = [NSMutableArray array];
    }
    return _contactsArr;
}

@end
