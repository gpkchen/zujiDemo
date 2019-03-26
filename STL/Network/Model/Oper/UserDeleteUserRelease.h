//
//  UserDeleteUserRelease.h
//  Apollo
//
//  Created by 李明伟 on 2018/7/30.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**用户删除发布内容接口参数*/
@interface _p_UserDeleteUserRelease : ZYBaseParam

/**发布内容id*/
@property (nonatomic , copy) NSString *userReleaseId;

@end
