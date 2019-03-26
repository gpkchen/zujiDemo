//
//  NSDate+ZYExtension.h
//  PodLib
//
//  Created by 李明伟 on 2018/3/26.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ZYExtension)

/**从1970年开始后的毫秒数*/
- (long long)millisecondSince1970;
/**计算这个月有多少天*/
- (NSUInteger)numberOfDaysInCurrentMonth;
/**获取这个月有多少周*/
- (NSUInteger)numberOfWeeksInCurrentMonth;
/**计算这个月最开始的一天*/
- (NSDate *)firstDayOfCurrentMonth;
/**计算这个月最后的一天*/
- (NSDate *)lastDayOfCurrentMonth;
/**上一个月*/
- (NSDate *)dayInThePreviousMonth;
/**下一个月*/
- (NSDate *)dayInTheFollowingMonth;
/**n个月后的今天*/
- (NSDate *)dayInTheFollowingMonth:(NSInteger)month;
/**n个月前的今天*/
- (NSDate *)dayInTheFollowingDay:(NSInteger)day;
/**NSString转NSDate*/
+ (NSDate *)dateFromString:(NSString *)dateString format:(NSString *)format;
/**格式化*/
- (NSString *)format:(NSString *)format;
/**两个之间相差几天*/
+ (NSInteger)getDayNumberOfDay:(NSDate *)day beforDay:(NSDate *)beforday;
/**周日是“1”，周一是“2”...*/
- (NSInteger)getWeekIntValue;
/**截取年值*/
- (NSInteger)getYearValue;
/**截取月值*/
- (NSInteger)getMonthValue;
/**截取天值*/
- (NSInteger)getDayValue;
/**截取时值*/
- (NSInteger)getHourValue;
/**截取分值*/
- (NSInteger)getMinuteValue;

@end
