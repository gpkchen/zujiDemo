//
//  ZYLocalRouterRule.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/20.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYLocalRouterRule.h"
#import "ZYLoginAlert.h"
#import "ZYWebVC.h"
#import "ZYMallMoreVC.h"
#import "ZYItemDetailVC.h"
#import "QYSDK.h"
#import "ZYRouterManager.h"
#import "ZYShareMenu.h"
#import "FavoriteInsert.h"
#import "FavoriteDelete.h"
#import "ZYOrderDetailVC.h"
#import "ZYBillDetailVC.h"
#import "AuditState.h"
#import "ZYEnvirUtils.h"

@implementation ZYLocalRouterRule

#pragma mark - 必要实现
- (NSArray *) targets{
    return @[@"login",
             @"web",
             @"tab",
             @"itemList",
             @"itemDetail",
             @"limit",
             @"call",
             @"service",
             @"share",
             @"addFavorite",
             @"deleteFavorite",
             @"orderDetail",
             @"billDetail",
             @"userCenter",
             @"newsDetail",
             @"activity"];
}

- (void) redirect:(ZYProtocol *)protocol completion:(void(^)(void))completion{
    
    
    if(!protocol.target){
        ZYLog(@"协议出错:协议目标为空!");
        return;
    }
    BOOL isExist = NO;
    for(NSString *target in [self targets]){
        if([target isEqualToString:protocol.target]){
            isExist = YES;
            break;
        }
    }
    if(!isExist){
        ZYLog(@"协议出错:协议目标“%@”不存在!",protocol.target);
        return;
    }
    
#pragma mark - 登录
    if([@"login" isEqualToString:protocol.target]){
        NSString *redirectUrl = protocol.params[@"redirectUrl"];
        ZYLoginAlert *alert = [ZYLoginAlert new];
        alert.completeBlock = ^(BOOL isCancel) {
            void (^callBack)(BOOL isCancel) = protocol.callBack;
            !callBack ? : callBack(isCancel);
            if(redirectUrl){
                [[ZYRouter router] go:redirectUrl withCallBack:nil isPush:YES completion:completion];
            }
        };
        [alert show];
        return;
    }
    
#pragma mark - 网页
    if([@"web" isEqualToString:protocol.target]){
        NSString *url = protocol.params[@"url"];
        BOOL needLogin = [protocol.params[@"needLogin"] boolValue];
        BOOL voidBack = [protocol.params[@"voidBack"] boolValue];
        BOOL swipeToBack = YES;
        if(protocol.params[@"swipeToBack"]){
            swipeToBack = [protocol.params[@"swipeToBack"] boolValue];
        }
        BOOL alwaysBounceVertical = YES;
        if(protocol.params[@"alwaysBounceVertical"]){
            alwaysBounceVertical = [protocol.params[@"alwaysBounceVertical"] boolValue];
        }
        BOOL alwaysBounceHorizontal = NO;
        if(protocol.params[@"alwaysBounceHorizontal"]){
            alwaysBounceHorizontal = [protocol.params[@"alwaysBounceHorizontal"] boolValue];
        }
    
        BOOL shouldAuthAlfterTaobao = [protocol.params[@"shouldAuthAlfterTaobao"] boolValue];
        
        if(needLogin){
            if([ZYUser user].silenceLoginAbility){
                [[ZYLoginService service] tokenLogin:YES
                                            complete:^(BOOL success) {
                                                ZYWebVC *vc = [ZYWebVC new];
                                                vc.url = url;
                                                vc.voidBack = voidBack;
                                                vc.shouldSwipeToBack = swipeToBack;
                                                vc.alwaysBounceHorizontal = alwaysBounceHorizontal;
                                                vc.alwaysBounceVertical = alwaysBounceVertical;
                                                vc.shouldAuthAlfterTaobao = shouldAuthAlfterTaobao;
                                                [[ZYRouter router] push:vc completion:completion];
                                            }];
            }else{
                [[ZYRouter router] goWithoutHead:@"login" withCallBack:^(BOOL isCanceled){
                    if(!isCanceled){
                        ZYWebVC *vc = [ZYWebVC new];
                        vc.url = url;
                        vc.voidBack = voidBack;
                        vc.shouldSwipeToBack = swipeToBack;
                        vc.alwaysBounceHorizontal = alwaysBounceHorizontal;
                        vc.alwaysBounceVertical = alwaysBounceVertical;
                        vc.shouldAuthAlfterTaobao = shouldAuthAlfterTaobao;
                        [[ZYRouter router] push:vc completion:completion];
                    }
                }];
            }
        }else{
            ZYWebVC *vc = [ZYWebVC new];
            vc.url = url;
            vc.voidBack = voidBack;
            vc.shouldSwipeToBack = swipeToBack;
            vc.alwaysBounceHorizontal = alwaysBounceHorizontal;
            vc.alwaysBounceVertical = alwaysBounceVertical;
            vc.shouldAuthAlfterTaobao = shouldAuthAlfterTaobao;
            [[ZYRouter router] push:vc completion:completion];
        }
        return;
    }
    
#pragma mark - 切换tab
    if([@"tab" isEqualToString:protocol.target]){
        NSString *label = protocol.params[@"label"];
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
        }
        return;
    }
    
#pragma mark - 更多商品列表
    if([@"itemList" isEqualToString:protocol.target]){
        NSString *templateId = protocol.params[@"templateId"];
        NSString *templateName = protocol.params[@"templateName"];
        ZYMallMoreVC *vc = [ZYMallMoreVC new];
        vc.templateId = templateId;
        vc.templateName = templateName;
        [[ZYRouter router] push:vc completion:completion];
        return;
    }
    
#pragma mark - 商品详情
    if([@"itemDetail" isEqualToString:protocol.target]){
        NSString *itemId = protocol.params[@"itemId"];
        ZYItemDetailVC *vc = [ZYItemDetailVC new];
        vc.itemId = itemId;
        [[ZYRouter router] push:vc completion:completion];
        return;
    }
    
#pragma mark - 免押额度
    if([@"limit" isEqualToString:protocol.target]){
        [[ZYLoginService service] requireLogin:^{
            [self loadAuthState:protocol.callBack];
        }];
        return;
    }
    
#pragma mark - 打电话
    if([@"call" isEqualToString:protocol.target]){
        NSString *number = [protocol.params objectForKey:@"number"];
        if(number){
            [ZYAppUtils openURL:[NSString stringWithFormat:@"telprompt://%@",number]];
        }
        return;
    }
    
#pragma mark - 客服
    if([@"service" isEqualToString:protocol.target]){
        [[ZYLoginService service] requireLogin:^{
            QYUserInfo *userInfo = [[QYUserInfo alloc] init];
            userInfo.userId = [ZYUser user].userId;
            NSMutableArray *array = [NSMutableArray new];
            if([ZYUser user].nickname){
                NSMutableDictionary *dictRealName = [NSMutableDictionary new];
                [dictRealName setObject:@"real_name" forKey:@"key"];
                [dictRealName setObject:[ZYUser user].nickname forKey:@"value"];
                [array addObject:dictRealName];
            }
            if([ZYUser user].mobile){
                NSMutableDictionary *dictMobilePhone = [NSMutableDictionary new];
                [dictMobilePhone setObject:@"mobile_phone" forKey:@"key"];
                [dictMobilePhone setObject:[ZYUser user].mobile forKey:@"value"];
                [dictMobilePhone setObject:@(NO) forKey:@"hidden"];
                [array addObject:dictMobilePhone];
            }
            NSData *data = [NSJSONSerialization dataWithJSONObject:array
                                                           options:0
                                                             error:nil];
            if (data){
                userInfo.data = [[NSString alloc] initWithData:data
                                                      encoding:NSUTF8StringEncoding];
            }
            
            [[QYSDK sharedSDK] setUserInfo:userInfo];
            QYSource *source = [[QYSource alloc] init];
            source.title =  @"机有客服";
            source.urlString = @"https://8.163.com/";
            QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
            [QYCustomUIConfig sharedInstance].autoShowKeyboard = NO;
            [QYCustomUIConfig sharedInstance].customerHeadImageUrl = [ZYUser user].portraitPath;
            sessionViewController.sessionTitle = @"机有客服";
            sessionViewController.source = source;
            
            UIImage *leftBtnImg = [UIImage imageNamed:@"zy_navigation_back_btn"];
            UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            leftBtn.frame = CGRectMake(0, 0, 40, NAVIGATION_BAR_HEIGHT - STATUSBAR_HEIGHT);
            [leftBtn setImage:leftBtnImg
                     forState:UIControlStateNormal];
            [leftBtn setImage:leftBtnImg
                     forState:UIControlStateHighlighted];
            [leftBtn addTarget:self
                        action:@selector(onBack:)
              forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
            sessionViewController.navigationItem.leftBarButtonItems = @[leftItem];
            
//            [[ZYRouter router] present:sessionViewController completion:completion];
            [[ZYRouter router] push:sessionViewController];
        }];
        return;
    }
    
#pragma mark - 分享
    if([@"share" isEqualToString:protocol.target]){
        NSString *icon = protocol.params[@"icon"];
        NSString *title = protocol.params[@"title"];
        NSString *content = protocol.params[@"content"];
        NSString *url = protocol.params[@"url"];
        
        ZYShareMenu *menu = [ZYShareMenu new];
        menu.shareType = ZYShareTypeWeb;
        menu.icon = icon;
        menu.title = title;
        menu.content = content;
        menu.url = url;
        [menu show];
        return;
    }
    
#pragma mark - 添加收藏
    if([@"addFavorite" isEqualToString:protocol.target]){
        NSString *itemId = protocol.params[@"itemId"];
        [[ZYLoginService service] requireLogin:^{
            _p_FavoriteInsert *param = [_p_FavoriteInsert new];
            param.itemId = itemId;
            [[ZYHttpClient client] post:param
                                showHud:YES
                                success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                                    if (responseObj.isSuccess) {
                                        [ZYToast showWithTitle:@"收藏成功！"];
                                        void (^callBack)(void) = protocol.callBack;
                                        !callBack ? : callBack();
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
    
#pragma mark - 删除收藏
    if([@"deleteFavorite" isEqualToString:protocol.target]){
        NSString *itemId = protocol.params[@"itemId"];
        [[ZYLoginService service] requireLogin:^{
            _p_FavoriteDelete *param = [_p_FavoriteDelete new];
            param.itemIds = @[itemId];
            [[ZYHttpClient client] post:param
                                showHud:YES
                                success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                                    if (responseObj.isSuccess) {
                                        [ZYToast showWithTitle:@"取消收藏成功！"];
                                        void (^callBack)(void) = protocol.callBack;
                                        !callBack ? : callBack();
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
    
#pragma mark - 订单详情
    if([@"orderDetail" isEqualToString:protocol.target]){
        NSString *orderId = protocol.params[@"orderId"];
        if(orderId){
            [[ZYLoginService service] requireLogin:^{
                ZYOrderDetailVC *vc = [ZYOrderDetailVC new];
                vc.orderId = orderId;
                [[ZYRouter router] push:vc completion:completion];
            }];
        }
        return;
    }
    
#pragma mark - 账单详情
    if([@"billDetail" isEqualToString:protocol.target]){
        NSString *orderId = protocol.params[@"orderId"];
        if(orderId){
            [[ZYLoginService service] requireLogin:^{
                ZYBillDetailVC *vc = [ZYBillDetailVC new];
                vc.orderId = orderId;
                [[ZYRouter router] push:vc completion:completion];
            }];
        }
        return;
    }
    
#pragma mark - 用户中心
    if([@"userCenter" isEqualToString:protocol.target]){
        NSString *userId = protocol.params[@"userId"];
        if(userId){
            [[ZYRouter router] goVC:[NSString stringWithFormat:@"ZYUserCenterVC?userId=%@",[userId URLEncode]]];
        }
        return;
    }
    
#pragma mark - 活动H5跳转
    if([@"activity" isEqualToString:protocol.target]){
        BOOL needLogin = [protocol.params[@"needLogin"] boolValue];
        BOOL voidBack = [protocol.params[@"voidBack"] boolValue];
        BOOL swipeToBack = YES;
        if(protocol.params[@"swipeToBack"]){
            swipeToBack = [protocol.params[@"swipeToBack"] boolValue];
        }
        BOOL alwaysBounceVertical = YES;
        if(protocol.params[@"alwaysBounceVertical"]){
            alwaysBounceVertical = [protocol.params[@"alwaysBounceVertical"] boolValue];
        }
        BOOL alwaysBounceHorizontal = NO;
        if(protocol.params[@"alwaysBounceHorizontal"]){
            alwaysBounceHorizontal = [protocol.params[@"alwaysBounceHorizontal"] boolValue];
        }
        if(needLogin){
            if([ZYUser user].silenceLoginAbility){
                [[ZYLoginService service] tokenLogin:YES
                                            complete:^(BOOL success) {
                                                NSString *url = protocol.params[@"url"];
                                                url = [NSString stringWithFormat:@"%@%@%@",[ZYEnvirUtils utils].h5Prefix,[ZYH5Utils formatJson],url];
                                                ZYWebVC *vc = [ZYWebVC new];
                                                vc.url = url;
                                                vc.shouldSwipeToBack = swipeToBack;
                                                vc.alwaysBounceHorizontal = alwaysBounceHorizontal;
                                                vc.alwaysBounceVertical = alwaysBounceVertical;
                                                [[ZYRouter router] push:vc completion:^{
                                                    !completion ? : completion();
                                                    if(!voidBack){
                                                        return;
                                                    }
                                                    if([ZYRouterManager manager].navigationController.viewControllers.count > 1){
                                                        NSMutableArray *vcs = [NSMutableArray arrayWithArray:[ZYRouterManager manager].navigationController.viewControllers];
                                                        NSUInteger count = vcs.count - 2;
                                                        UIViewController *lastVC = vcs[count];
                                                        if([lastVC isKindOfClass:[ZYWebVC class]]){
                                                            [vcs removeObject:lastVC];
                                                            [ZYRouterManager manager].navigationController.viewControllers = vcs;
                                                        }
                                                    }
                                                }];
                                            }];
            }else{
                [[ZYRouter router] goWithoutHead:@"login" withCallBack:^(BOOL isCanceled){
                    if(!isCanceled){
                        NSString *url = protocol.params[@"url"];
                        url = [NSString stringWithFormat:@"%@%@%@",[ZYEnvirUtils utils].h5Prefix,[ZYH5Utils formatJson],url];
                        ZYWebVC *vc = [ZYWebVC new];
                        vc.url = url;
                        vc.shouldSwipeToBack = swipeToBack;
                        vc.alwaysBounceHorizontal = alwaysBounceHorizontal;
                        vc.alwaysBounceVertical = alwaysBounceVertical;
                        [[ZYRouter router] push:vc completion:^{
                            !completion ? : completion();
                            if(!voidBack){
                                return;
                            }
                            if([ZYRouterManager manager].navigationController.viewControllers.count > 1){
                                NSMutableArray *vcs = [NSMutableArray arrayWithArray:[ZYRouterManager manager].navigationController.viewControllers];
                                NSUInteger count = vcs.count - 2;
                                UIViewController *lastVC = vcs[count];
                                if([lastVC isKindOfClass:[ZYWebVC class]]){
                                    [vcs removeObject:lastVC];
                                    [ZYRouterManager manager].navigationController.viewControllers = vcs;
                                }
                            }
                        }];
                    }
                }];
            }
        }else{
            NSString *url = protocol.params[@"url"];
            url = [NSString stringWithFormat:@"%@%@%@",[ZYEnvirUtils utils].h5Prefix,[ZYH5Utils formatJson],url];
            ZYWebVC *vc = [ZYWebVC new];
            vc.url = url;
            vc.shouldSwipeToBack = swipeToBack;
            vc.alwaysBounceHorizontal = alwaysBounceHorizontal;
            vc.alwaysBounceVertical = alwaysBounceVertical;
            [[ZYRouter router] push:vc completion:^{
                !completion ? : completion();
                if(!voidBack){
                    return;
                }
                if([ZYRouterManager manager].navigationController.viewControllers.count > 1){
                    NSMutableArray *vcs = [NSMutableArray arrayWithArray:[ZYRouterManager manager].navigationController.viewControllers];
                    NSUInteger count = vcs.count - 2;
                    UIViewController *lastVC = vcs[count];
                    if([lastVC isKindOfClass:[ZYWebVC class]]){
                        [vcs removeObject:lastVC];
                        [ZYRouterManager manager].navigationController.viewControllers = vcs;
                    }
                }
            }];
        }
        return;
    }
}

- (void)onBack:(id *)sender{
    [[ZYRouterManager manager].navigationController popViewControllerAnimated:YES];
}

#pragma mark - 查询授信状态
- (void)loadAuthState:(id)callback{
    _p_AuditState *param = [_p_AuditState new];
    [[ZYHttpClient client] post:param
                        showHud:YES
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            if(responseObj.isSuccess){
                                _m_AuditState *model = [_m_AuditState mj_objectWithKeyValues:responseObj.data];
                                if(model.status == ZYAuthStateUnAuth){
                                    [[ZYRouter router] goVC:@"ZYCreateQuotaVC" withCallBack:callback];
                                }else if(model.status == ZYAuthStateAuthing){
                                    [[ZYRouter router] goVC:@"ZYAuthingVC" withCallBack:callback];
                                    void (^tmpCallBack)(NSString *authStatus) = callback;
                                    !tmpCallBack ? : tmpCallBack([NSString stringWithFormat:@"%d",ZYAuthStateAuthing]);
                                }else{
                                    [[ZYRouter router] goVC:@"ZYQuotaVC" withCallBack:callback];
                                    void (^tmpCallBack)(NSString *authStatus) = callback;
                                    !tmpCallBack ? : tmpCallBack([NSString stringWithFormat:@"%d",ZYAuthStateAuthed]);
                                }
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

@end
