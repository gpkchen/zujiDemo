//
//  ZYMomentsDB.h
//  Apollo
//
//  Created by 李明伟 on 2018/7/25.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYMoment.h"

/**发布资讯库表管理*/
@interface ZYMomentsDB : NSObject

+ (void)saveMoment:(ZYMoment *)moment;
+ (ZYMoment *)readMoment;

@end
