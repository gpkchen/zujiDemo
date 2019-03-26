//
//  ZYHttpTask.h
//  Apollo
//
//  Created by 李明伟 on 2018/4/18.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYHttpTask : NSObject

/**请求参数*/
@property (nonatomic , strong) ZYBaseParam *param;
/**是否显示加载动画*/
@property (nonatomic , assign) BOOL showHud;
/**成功回调*/
@property (nonatomic , copy) void (^success)(NSURLSessionDataTask *task, ZYHttpResponse *responseObj);
/**失败回调*/
@property (nonatomic , copy) void (^failure)(NSURLSessionDataTask *task, NSError *error);
/**刷新token彻底失败回调*/
@property (nonatomic , copy) void (^authFail)(void);

@end
