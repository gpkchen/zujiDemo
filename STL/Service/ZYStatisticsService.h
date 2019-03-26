//
//  ZYStatisticsService.h
//  Apollo
//
//  Created by 李明伟 on 2018/10/9.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYStatisticsService : NSObject

+ (void)beginLogPageView:(NSString *)pageName;
+ (void)endLogPageView:(NSString *)pageName;

+ (void)event:(NSString *)eventId label:(NSString *)label;
+ (void)event:(NSString *)eventId;

+ (void)event:(NSString *)eventId durations:(int)millisecond;
+ (void)event:(NSString *)eventId label:(NSString *)label durations:(int)millisecond;

@end

NS_ASSUME_NONNULL_END
