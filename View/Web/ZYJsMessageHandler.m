//
//  ZYJsMessageHandler.m
//  Apollo
//
//  Created by 李明伟 on 2018/10/30.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import "ZYJsMessageHandler.h"
#import "AuditState.h"
#import "ZYShareMenu.h"
#import "ZYOrderDetailVC.h"
#import "ZYBillDetailVC.h"
#import "ZYMallMoreVC.h"

@interface ZYJsMessageHandler()

@property (nonatomic , strong) ZYHud *hud;

@end

@implementation ZYJsMessageHandler

+ (NSArray *)messageNames{
    return @[@"apolloReceiveH5Message"];
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSString *name = message.name;
    id body = message.body;
    NSDictionary *params = nil;
    if([body isKindOfClass:[NSDictionary class]]){
        params = (NSDictionary *)body;
    }else if([body isKindOfClass:[NSString class]]){
        params = [NSDictionary mj_objectWithKeyValues:body];
    }

    if([name isEqualToString:@"apolloReceiveH5Message"]){
        NSString *op = params[@"op"];
        NSString *ak = params[@"ak"];
        NSMutableDictionary *callbackParams = [NSMutableDictionary dictionary];
        [callbackParams setValue:ak forKey:@"ak"];
        [self dealTask:op params:params callbackParams:callbackParams webView:message.webView];
    }
}

#pragma mark - 执行js回调
- (void)jsCallBack:(WKWebView *)webView params:(NSDictionary *)callbackParams{
    NSString *jsCallBack = [NSString stringWithFormat:@"(%@)(%@);", @"apolloNativeCallBack", callbackParams.mj_JSONString];
    [webView evaluateJavaScript:jsCallBack completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        if (error) {
            ZYLog(@"err is %@", error.domain);
        }
    }];
}

#pragma mark - 分发任务
- (void)dealTask:(NSString *)op params:(NSDictionary *)params callbackParams:(NSMutableDictionary *)callbackParams webView:(WKWebView *)webView{
#pragma mark - 获取设备信息
    if([@"deviceInfo" isEqualToString:op]){
        if([params[@"needLogin"] boolValue]){
            [[ZYLoginService service] requireLogin:^{
                [callbackParams setValue:[ZYDeviceUtils utils].uuidForDevice forKey:@"deviceID"];
                [callbackParams setValue:APP_BUILD forKey:@"appVersion"];
                [callbackParams setValue:RequestClient forKey:@"client"];
                if([ZYUser user].userId){
                    [callbackParams setValue:[ZYUser user].userId forKey:@"uid"];
                }
                if([ZYUser user].apiToken){
                    [callbackParams setValue:[ZYUser user].apiToken forKey:@"apiToken"];
                }
                [self jsCallBack:webView params:callbackParams];
            }];
        }else{
            [callbackParams setValue:[ZYDeviceUtils utils].uuidForDevice forKey:@"deviceID"];
            [callbackParams setValue:APP_BUILD forKey:@"appVersion"];
            [callbackParams setValue:RequestClient forKey:@"client"];
            if([ZYUser user].userId){
                [callbackParams setValue:[ZYUser user].userId forKey:@"uid"];
            }
            if([ZYUser user].apiToken){
                [callbackParams setValue:[ZYUser user].apiToken forKey:@"apiToken"];
            }
            [self jsCallBack:webView params:callbackParams];
        }
        return;
    }
    
#pragma mark - 商品详情
    if([@"itemDetail" isEqualToString:op]){
        NSString *itemId = params[@"itemId"];
        if(itemId){
            [[ZYRouter router] goWithoutHead:[NSString stringWithFormat:@"itemDetail?itemId=%@",[itemId URLEncode]]];
        }
        [self jsCallBack:webView params:callbackParams];
        return;
    }
    
#pragma mark - 免押额度
    if([@"limit" isEqualToString:op]){
        [[ZYLoginService service] requireLogin:^{
            _p_AuditState *param = [_p_AuditState new];
            [[ZYHttpClient client] post:param
                                showHud:YES
                                success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                                    if(responseObj.isSuccess){
                                        _m_AuditState *model = [_m_AuditState mj_objectWithKeyValues:responseObj.data];
                                        if(model.status == ZYAuthStateUnAuth){
                                            [[ZYRouter router] goVC:@"ZYCreateQuotaVC"];
                                        }else if(model.status == ZYAuthStateAuthing){
                                            [[ZYRouter router] goVC:@"ZYAuthingVC"];
                                        }else{
                                            [[ZYRouter router] goVC:@"ZYQuotaVC"];
                                        }
                                        [self jsCallBack:webView params:callbackParams];
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
        }];
        return;
    }
    
#pragma mark - 打电话
    if([@"call" isEqualToString:op]){
        NSString *number = params[@"number"];
        if(number){
            [ZYAppUtils openURL:[NSString stringWithFormat:@"telprompt://%@",number]];
        }
        [self jsCallBack:webView params:callbackParams];
        return;
    }
    
#pragma mark - 客服
    if([@"service" isEqualToString:op]){
        [[ZYRouter router] goWithoutHead:@"service"];
        [self jsCallBack:webView params:callbackParams];
        return;
    }
    
#pragma mark - 分享
    if([@"share" isEqualToString:op]){
        NSString *icon = params[@"icon"];
        NSString *title = params[@"title"];
        NSString *content = params[@"content"];
        NSString *url = params[@"url"];
        
        ZYShareMenu *menu = [ZYShareMenu new];
        menu.shareType = ZYShareTypeWeb;
        menu.icon = icon;
        menu.title = title;
        menu.content = content;
        menu.url = url;
        [menu show];
        [self jsCallBack:webView params:callbackParams];
        return;
    }
    
#pragma mark - 订单详情
    if([@"orderDetail" isEqualToString:op]){
        NSString *orderId = params[@"orderId"];
        if(orderId){
            [[ZYLoginService service] requireLogin:^{
                ZYOrderDetailVC *vc = [ZYOrderDetailVC new];
                vc.orderId = orderId;
                [[ZYRouter router] push:vc];
                [self jsCallBack:webView params:callbackParams];
            }];
        }
        return;
    }
    
#pragma mark - 账单详情
    if([@"billDetail" isEqualToString:op]){
        NSString *orderId = params[@"orderId"];
        if(orderId){
            [[ZYLoginService service] requireLogin:^{
                ZYBillDetailVC *vc = [ZYBillDetailVC new];
                vc.orderId = orderId;
                [[ZYRouter router] push:vc];
                [self jsCallBack:webView params:callbackParams];
            }];
        }
        return;
    }
    
#pragma mark - 用户中心
    if([@"userCenter" isEqualToString:op]){
        NSString *userId = params[@"userId"];
        if(userId){
            [[ZYLoginService service] requireLogin:^{
                [[ZYRouter router] goVC:[NSString stringWithFormat:@"ZYUserCenterVC?userId=%@",[userId URLEncode]]];
                [self jsCallBack:webView params:callbackParams];
            }];
        }
        return;
    }
    
#pragma mark - 切换tab
    if([@"tab" isEqualToString:op]){
        NSString *label = params[@"label"];
        if(label){
            int index = 0;
            if([label isEqualToString:@"found"]){
                index = 0;
            }else if([label isEqualToString:@"mall"]){
                index = 1;
            }else if([label isEqualToString:@"share"]){
                index = 2;
            }else if([label isEqualToString:@"mine"]){
                index = 3;
            }
            if(index == 2){
                [[ZYLoginService service] requireLogin:^{
                    [[ZYRouter router] returnToRoot];
                    [ZYMainTabVC shareInstance].selectedIndex = index;
                }];
            }else{
                [[ZYRouter router] returnToRoot];
                [ZYMainTabVC shareInstance].selectedIndex = index;
            }
            [self jsCallBack:webView params:callbackParams];
        }
        return;
    }
    
#pragma mark - 更多商品列表op
    if([@"itemList" isEqualToString:op]){
        NSString *templateId = params[@"templateId"];
        NSString *templateName = params[@"templateName"];
        ZYMallMoreVC *vc = [ZYMallMoreVC new];
        vc.templateId = templateId;
        vc.templateName = templateName;
        [[ZYRouter router] push:vc];
        [self jsCallBack:webView params:callbackParams];
        return;
    }
    
#pragma mark - 显示加载动画
    if([@"showLoading" isEqualToString:op]){
        double duration = [params[@"duration"] doubleValue];
        [self.hud show];
        if(duration){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.hud dismiss];
            });
        }
        [self jsCallBack:webView params:callbackParams];
        return;
    }
    
#pragma mark - 隐藏加载动画
    if([@"hideLoading" isEqualToString:op]){
        [self.hud dismiss];
        [self jsCallBack:webView params:callbackParams];
        return;
    }
    
#pragma mark - 显示Toast
    if([@"showToast" isEqualToString:op]){
        NSString *message = params[@"message"];
        [ZYToast showWithTitle:message];
        [self jsCallBack:webView params:callbackParams];
        return;
    }
    
#pragma mark - 显示提示
    if([@"showNotice" isEqualToString:op]){
        int type = [params[@"type"] intValue];
        NSString *title = params[@"title"];
        NSString *content = params[@"content"];
        if(1 == type){
            [ZYComplexToast showSuccessWithTitle:title detail:content];
        }else if(2 == type){
            [ZYComplexToast showMessageWithTitle:title detail:content];
        }else if(3 == type){
            [ZYComplexToast showFailureWithTitle:title detail:content];
        }
        [self jsCallBack:webView params:callbackParams];
        return;
    }
}

#pragma mark - getter
- (ZYHud *)hud{
    if(!_hud){
        _hud = [ZYHud new];
    }
    return _hud;
}

@end
