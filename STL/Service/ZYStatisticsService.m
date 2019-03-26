//
//  ZYStatisticsService.m
//  Apollo
//
//  Created by 李明伟 on 2018/10/9.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYStatisticsService.h"
#import <UMAnalytics/MobClick.h>

@implementation ZYStatisticsService

+ (void)beginLogPageView:(NSString *)pageName{
#ifdef Archive_Release
    [MobClick beginLogPageView:pageName];
#endif
}

+ (void)endLogPageView:(NSString *)pageName{
#ifdef Archive_Release
    [MobClick endLogPageView:pageName];
#endif
}

+ (void)event:(NSString *)eventId label:(NSString *)label{
#ifdef Archive_Release
    [MobClick event:eventId label:label];
#endif
}

+ (void)event:(NSString *)eventId{
#ifdef Archive_Release
    [MobClick event:eventId];
#endif
}

+ (void)event:(NSString *)eventId durations:(int)millisecond{
#ifdef Archive_Release
    [MobClick event:eventId durations:millisecond];
#endif
}

+ (void)event:(NSString *)eventId label:(NSString *)label durations:(int)millisecond{
#ifdef Archive_Release
    [MobClick event:eventId label:label durations:millisecond];
#endif
}

@end
