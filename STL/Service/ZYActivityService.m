//
//  ZYActivityService.m
//  Apollo
//
//  Created by 李明伟 on 2018/7/17.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYActivityService.h"
#import "AppActiveInfo.h"
#import "ZYActivityAlert.h"

@implementation ZYActivityService

+ (void) loadActivity:(ZYActivityScene)scene{
    _p_AppActiveInfo *param = [_p_AppActiveInfo new];
    param.activeType = @"3";
    if(scene == ZYActivitySceneLaunch){
        param.type = @"1";
    }
    [[ZYHttpClient client] post:param
                        showHud:NO
                        success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                            if(responseObj.isSuccess){
                                _m_AppActiveInfo *model = [_m_AppActiveInfo mj_objectWithKeyValues:responseObj.data];
                                if(model.imgUrl){
                                    ZYActivityAlert *alert = [ZYActivityAlert new];
                                    [alert showWithModel:model];
                                }
                            }
                        } failure:nil authFail:nil];
}

@end
