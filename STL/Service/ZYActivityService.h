//
//  ZYActivityService.h
//  Apollo
//
//  Created by 李明伟 on 2018/7/17.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(int , ZYActivityScene) {
    ZYActivitySceneLaunch = 1, //app启动
};

/**活动/广告服务*/
@interface ZYActivityService : NSObject

/**加载活动*/
+ (void) loadActivity:(ZYActivityScene)scene;

@end
