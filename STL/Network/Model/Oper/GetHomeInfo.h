//
//  GetHomeInfo.h
//  Apollo
//
//  Created by 李明伟 on 2018/7/28.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**用户主页信息查询参数*/
@interface _p_GetHomeInfo : ZYBaseParam

/**用户id*/
@property (nonatomic , copy) NSString *homepageUserId;

@end



/**用户主页信息查询返回*/
@interface _m_GetHomeInfo : ZYBaseModel

/**头像*/
@property (nonatomic , copy) NSString *avatar;
/**昵称*/
@property (nonatomic , copy) NSString *nickname;
/**赞数*/
@property (nonatomic , assign) int userAllZanNum;
/**发布数*/
@property (nonatomic , assign) int userAllReleaseNum;

@end
