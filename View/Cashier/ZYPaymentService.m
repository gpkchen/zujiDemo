//
//  ZYPaymentService.m
//  Apollo
//
//  Created by 李明伟 on 2018/5/16.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYPaymentService.h"
#import "ZYCashier.h"
#import "PayBills.h"
#import "PayBuyOffAmount.h"
#import "PayReletAmount.h"
#import "PayPenaltyAmount.h"

@interface ZYPaymentService ()

@property (nonatomic , strong) ZYCashier *cashier;
@property (nonatomic , strong) ZYPaymentCommonParam *commonParam;

@end

@implementation ZYPaymentService

+ (instancetype)service{
    static ZYPaymentService *_instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instance = [[ZYPaymentService alloc] init];
    });
    
    return _instance;
}

#pragma mark - 隐藏收银台
- (void)hideCashier{
    [self.cashier dismiss:nil];
}

#pragma mark - 发起支付
- (void)pay:(ZYPaymentCommonParam *)param{
    _commonParam = param;
    [self.cashier show];
}

#pragma mark - 发起支付
- (void)pay:(ZYPaymentType)type orderInfo:(NSString *)orderInfo{
    if(ZYPaymentTypeAlipay == type){
        [[AlipaySDK defaultService] payOrder:orderInfo fromScheme:URLScheme callback:^(NSDictionary *resultDic) {
            ZYLog(@"支付宝支付结果：%@",resultDic);
            //web方式会执行该回调，原生支付宝app走的是appdelegate的协议
            int orderState = [resultDic[@"resultStatus"] intValue];
            [self alipayResult:orderState];
        }];
    }else{
        //调起微信支付
        NSData *jsonData = [orderInfo dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        PayReq* req             = [[PayReq alloc] init];
        req.partnerId           = dic[@"partnerid"];
        req.prepayId            = dic[@"prepayid"];
        req.nonceStr            = dic[@"noncestr"];
        req.timeStamp           = [dic[@"timestamp"] intValue];
        req.package             = dic[@"packageValue"];
        req.sign                = dic[@"sign"];
        req.type = 3;
        [WXApi sendReq:req];
    }
}

#pragma mark - 处理支付宝支付结果
- (void)alipayResult:(int)orderState{
    switch (orderState) {
        case 9000: //成功
            [self payResult:ZYPaymentTypeAlipay result:ZYPaymentResultSuccess];
            break;
        case 8000://订单正在处理中
            [self payResult:ZYPaymentTypeAlipay result:ZYPaymentResultDealing];
            break;
        case 4000://订单支付失败
            [self payResult:ZYPaymentTypeAlipay result:ZYPaymentResultFail];
            break;
        case 5000://重复请求
            [self payResult:ZYPaymentTypeAlipay result:ZYPaymentResultFail];
            break;
        case 6001://用户中途取消
            [self payResult:ZYPaymentTypeAlipay result:ZYPaymentResultCancel];
            break;
        case 6002://网络连接出错
            [self payResult:ZYPaymentTypeAlipay result:ZYPaymentResultFail];
            break;
        case 6004://订单正在处理中
            [self payResult:ZYPaymentTypeAlipay result:ZYPaymentResultDealing];
            break;
            
        default:
            break;
    }
}

#pragma mark - 处理支付结果
- (void)payResult:(ZYPaymentType)type result:(ZYPaymentResult)result{
    if(_currentDelegate && [_currentDelegate respondsToSelector:@selector(paymentResult:type:)]){
        [_currentDelegate paymentResult:result type:type];
    }
}


#pragma mark - WXApiDelegate
-(void) onReq:(BaseReq*)req{
    
}

-(void) onResp:(BaseResp*)resp{
    if([resp isKindOfClass:[PayResp class]]){
        ZYLog(@"微信支付结果：retcode = %d, retstr = %@", resp.errCode,resp.errStr);
        //支付返回结果，实际支付结果需要去微信服务器端查询
        switch (resp.errCode) {
            case WXSuccess:
                [self payResult:ZYPaymentTypeAlipay result:ZYPaymentResultSuccess];
                break;
            case WXErrCodeCommon:
                [self payResult:ZYPaymentTypeAlipay result:ZYPaymentResultFail];
                break;
            case WXErrCodeUserCancel:
                [self payResult:ZYPaymentTypeAlipay result:ZYPaymentResultCancel];
                break;
            case WXErrCodeSentFail:
                [self payResult:ZYPaymentTypeAlipay result:ZYPaymentResultFail];
                break;
            case WXErrCodeAuthDeny:
                [self payResult:ZYPaymentTypeAlipay result:ZYPaymentResultFail];
                break;
            case WXErrCodeUnsupport:
                [self payResult:ZYPaymentTypeAlipay result:ZYPaymentResultFail];
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - 支付
- (void)selectPaymentType:(ZYPaymentType)payType{
    if(_commonParam.target == ZYPaymentTargetBill){
        [self payBill:payType];
    }else if(_commonParam.target == ZYPaymentTargetBuy){
        [self buy:payType];
    }else if(_commonParam.target == ZYPaymentTargetRenewal){
        [self renewal:payType];
    }else if(_commonParam.target == ZYPaymentTargetPenalty){
        [self payPenalty:payType];
    }
}

#pragma mark - 支付订单 21支付宝 11微信
- (void)payBill:(ZYPaymentType)payType{
    _p_PayBills *param = [_p_PayBills new];
    param.orderId = _commonParam.orderId;
    param.billIds = _commonParam.billIds;
    param.billPayType = _commonParam.billPayType;
    param.couponId = _commonParam.couponId;
    param.payType = [NSString stringWithFormat:@"%d",payType];
    [[ZYHttpClient client] post:param
                        showHud:YES
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            if(responseObj.isSuccess){
                                NSString *orderStr = responseObj.data[@"orderInfo"];
                                [self pay:payType orderInfo:orderStr];
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
}

#pragma mark - 买断 21支付宝 11微信
- (void)buy:(ZYPaymentType)payType{
    _p_PayBuyOffAmount *param = [_p_PayBuyOffAmount new];
    param.orderId = _commonParam.orderId;
    param.payType = [NSString stringWithFormat:@"%d",payType];
    param.couponId = _commonParam.couponId;
    [[ZYHttpClient client] post:param
                        showHud:YES
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            if(responseObj.isSuccess){
                                NSString *orderStr = responseObj.data[@"orderInfo"];
                                [self pay:payType orderInfo:orderStr];
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
}

#pragma mark - 续租 21支付宝 11微信
- (void)renewal:(ZYPaymentType)payType{
    _p_PayReletAmount *param = [_p_PayReletAmount new];
    param.orderId = _commonParam.orderId;
    param.couponId = _commonParam.couponId;
    param.rentPeriod = _commonParam.rentPeriod;
    param.payChannel = [NSString stringWithFormat:@"%d",payType];
    [[ZYHttpClient client] post:param
                        showHud:YES
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            if(responseObj.isSuccess){
                                NSString *orderStr = responseObj.data[@"orderInfo"];
                                [self pay:payType orderInfo:orderStr];
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
}

#pragma mark - 支付违约金 21支付宝 11微信
- (void)payPenalty:(ZYPaymentType)payType{
    _p_PayPenaltyAmount *param = [_p_PayPenaltyAmount new];
    param.orderId = _commonParam.orderId;
    param.payChannel = [NSString stringWithFormat:@"%d",payType];
    param.couponId = _commonParam.couponId;
    [[ZYHttpClient client] post:param
                        showHud:YES
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            if(responseObj.isSuccess){
                                NSString *orderStr = responseObj.data[@"orderInfo"];
                                [self pay:payType orderInfo:orderStr];
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
}


#pragma mark - getter
- (ZYCashier *)cashier{
    if(!_cashier){
        _cashier = [ZYCashier new];
        
        __weak __typeof__(self) weakSelf = self;
        _cashier.patchViewTapAction = ^{
            [weakSelf payResult:ZYPaymentTypeNone result:ZYPaymentResultGiveUp];
        };
        _cashier.action = ^(ZYPaymentType paymentType) {
            [weakSelf selectPaymentType:paymentType];
        };
    }
    return _cashier;
}

@end
