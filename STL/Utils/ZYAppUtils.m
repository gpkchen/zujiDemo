//
//  ZYAppUtils.m
//  PodLib
//
//  Created by 李明伟 on 2018/3/28.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYAppUtils.h"
#import <UIKit/UIKit.h>
#import "GetAppVersionInfo.h"
#import "ZYUpdateAlert.h"
#import "AppBottomButtonInfo.h"

@interface ZYAppUtils ()

@property (nonatomic , strong) ZYUpdateAlert *updateAlert;

@end

@implementation ZYAppUtils

+ (instancetype) utils{
    static ZYAppUtils *_instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instance = [[ZYAppUtils alloc] init];
    });
    
    return _instance;
}

+ (void) openURL:(NSString *)url{
    NSURL *toUrl = [NSURL URLWithString:url];
    if([[UIApplication sharedApplication] canOpenURL:toUrl]){
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:toUrl
                                               options:@{}
                                     completionHandler:^(BOOL success) {
                                         
                                     }];
        } else {
            [[UIApplication sharedApplication] openURL:toUrl];
        }
    }
}



+(BOOL) isInstallAliPay{
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipays://"]]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"是否下载并安装支付宝完成认证?"
                                              cancelButtonTitle:@"暂不"
                                              otherButtonTitles:@[@"好的"]
                                                    clickAction:^(NSInteger index) {
                                                        if(1 == index){
                                                            [self openURL:AliPayAppUrl];
                                                        }
                                                    }];
        [alert show];
        return NO;
    }

    return YES;
}

+ (void)checkTabbarImages{
    _p_AppBottomButtonInfo *param = [_p_AppBottomButtonInfo new];
    [[ZYHttpClient client] post:param
                        showHud:NO
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            if(responseObj.isSuccess){
                                _m_AppBottomButtonInfo *model = [_m_AppBottomButtonInfo mj_objectWithKeyValues:responseObj.data];
                                ZYUser *user = [ZYUser user];
                                user.bottomImageUrl = model.bottomImageUrl;
                                if(model.defaultImages.count > 0 && model.checkedImages.count > 0){
                                    user.foundImg = model.defaultImages[0][@"imageUrl"];
                                    user.foundImgSelected = model.checkedImages[0][@"imageUrl"];
                                }else{
                                    user.foundImg = nil;
                                    user.foundImgSelected = nil;
                                }
                                if(model.defaultImages.count > 1 && model.checkedImages.count > 1){
                                    user.mallImg = model.defaultImages[1][@"imageUrl"];
                                    user.mallImgSelected = model.checkedImages[1][@"imageUrl"];
                                }else{
                                    user.mallImg = nil;
                                    user.mallImgSelected = nil;
                                }
                                if(model.defaultImages.count > 2 && model.checkedImages.count > 2){
                                    user.shareImg = model.defaultImages[2][@"imageUrl"];
                                    user.shareImgSelected = model.checkedImages[2][@"imageUrl"];
                                }else{
                                    user.shareImg = nil;
                                    user.shareImgSelected = nil;
                                }
                                if(model.defaultImages.count > 3 && model.checkedImages.count >3){
                                    user.mineImg = model.defaultImages[3][@"imageUrl"];
                                    user.mineImgSelected = model.checkedImages[3][@"imageUrl"];
                                }else{
                                    user.mineImg = nil;
                                    user.mineImgSelected = nil;
                                }
                                [user save];
                            }
                        } failure:nil authFail:nil];
}

- (void)checkUpdate{
    _p_GetAppVersionInfo *param = [_p_GetAppVersionInfo new];
    [[ZYHttpClient client] post:param
                        showHud:NO
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            if(responseObj.isSuccess){
                                _m_GetAppVersionInfo *model = [[_m_GetAppVersionInfo alloc] initWithDictionary:responseObj.data];
                                __weak __typeof__(self) weakSelf = self;
                                if(self.updateAlert.isShowed){
                                    [self.updateAlert dismissWithBlock:^{
                                        [weakSelf.updateAlert showWithModel:model];
                                    }];
                                }else{
                                    [self.updateAlert showWithModel:model];
                                }
                            }
                        }
                        failure:nil
                        authFail:nil];
}



#pragma mark - getter
- (ZYUpdateAlert *)updateAlert{
    if(!_updateAlert){
        _updateAlert = [ZYUpdateAlert new];
    }
    return _updateAlert;
}

@end
