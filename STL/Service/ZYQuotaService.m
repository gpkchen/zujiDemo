//
//  ZYQuotaService.m
//  Apollo
//
//  Created by 李明伟 on 2018/7/11.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYQuotaService.h"
#import "FMDeviceManager.h"
#import "ZYLocationUtils.h"
#import "MachineCredit.h"
#import "UserIdCard.h"
#import "ZYStudentAuthVC.h"

@implementation ZYQuotaService

#pragma mark - 发起运营商认证
+ (void)authOperator{
    NSString * pageConfig = [@"{\"themeColor\":\"#1CBD4C\",\"foreColor\":\"#fff\",\"fontColor\":\"#18191A\"}" URLEncode];
    NSString *state = @"mno";
    _p_UserIdCard *param = [[_p_UserIdCard alloc] init];
    [[ZYHttpClient client] post:param showHud:YES success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
        if (responseObj.success) {
            _m_UserIdCard *model = [_m_UserIdCard mj_objectWithKeyValues:responseObj.data];
            NSString *name = [model.userName URLEncode];
            NSString *idCardNo = [model.idCard tripleDES:kCCDecrypt key:[ZYEnvirUtils utils].protocolEncodeKey];
            NSString *userId = [ZYUser user].userId;
            NSString *mobile = [ZYUser user].mobile;
            NSString *url = [NSString stringWithFormat: @"https://credit.baiqishi.com/clclient/%@/login?partnerId=fintechzh&name=%@&certNo=%@&mobile=%@&backUrl=%@/open/zixingyun/redirect/%@/%@&failUrl=%@/open/zixingyun/redirect/%@/%@&skip=false&pageConfig=%@",state,name,idCardNo,mobile,[ZYEnvirUtils utils].authCallBackUrl,@"operator",userId,[ZYEnvirUtils utils].authCallBackUrl,@"operator",userId,pageConfig];
            [[ZYRouter router] goWithoutHead:[NSString stringWithFormat:@"web?url=%@",[url URLEncode]]];
            
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

#pragma mark - 发起淘宝认证
+ (void)authTaobao:(BOOL)shouldStartAuth{
    NSString * pageConfig = [@"{\"themeColor\":\"#1CBD4C\",\"foreColor\":\"#fff\",\"fontColor\":\"#18191A\"}" URLEncode];
    NSString *state = @"tb";
    _p_UserIdCard *param = [[_p_UserIdCard alloc] init];
    [[ZYHttpClient client] post:param showHud:YES success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
        if (responseObj.success) {
            _m_UserIdCard *model = [_m_UserIdCard mj_objectWithKeyValues:responseObj.data];
            NSString *name = [model.userName URLEncode];
            NSString *idCardNo = [model.idCard tripleDES:kCCDecrypt key:[ZYEnvirUtils utils].protocolEncodeKey];
            NSString *userId = [ZYUser user].userId;
            NSString *mobile = [ZYUser user].mobile;
            NSString *url = [NSString stringWithFormat: @"https://credit.baiqishi.com/clclient/%@/login?partnerId=fintechzh&name=%@&certNo=%@&mobile=%@&backUrl=%@/open/zixingyun/redirect/%@/%@&failUrl=%@/open/zixingyun/redirect/%@/%@&skip=false&pageConfig=%@",state,name,idCardNo,mobile,[ZYEnvirUtils utils].authCallBackUrl,@"taobao",userId,[ZYEnvirUtils utils].authCallBackUrl,@"taobao",userId,pageConfig];
            [[ZYRouter router] goWithoutHead:[NSString stringWithFormat:@"web?url=%@&shouldAuthAlfterTaobao=%@",[url URLEncode],shouldStartAuth?@"1":@"0"]];
            
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

#pragma mark - 发起学生认证
+ (void)authStudent{
    [[ZYRouter router] goVC:@"ZYStudentAuthVC"];
}

#pragma mark - 发起授信
+ (void)startAuthing:(NSString *)flag success:(void(^)(void))success{
    FMDeviceManager_t *manager = [FMDeviceManager sharedManager];
    NSString *blackBox = manager->getDeviceInfo();
    
    NSString *latitude = [ZYLocationUtils utils].userLocation.latitude;
    NSString *longitude = [ZYLocationUtils utils].userLocation.longitude;
    
    _p_MachineCredit *param = [[_p_MachineCredit alloc] init];
    param.deviceFinger = blackBox;
    param.longitude = longitude;
    param.latitude = latitude;
    param.flag = flag;
    
    [[ZYHttpClient client] post:param showHud:YES success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
        
        if (responseObj.success) {
            !success ? : success();
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


@end
