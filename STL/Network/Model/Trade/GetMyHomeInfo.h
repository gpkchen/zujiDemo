//
//  GetMyHomeInfo.h
//  Apollo
//
//  Created by shaxia on 2018/5/14.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseParam.h"

@interface _p_GetMyHomeInfo : ZYBaseParam

@end



@interface _m_GetMyHomeInfo_maps : ZYBaseModel

/**名称*/
@property (nonatomic , copy) NSString *name;
/**数量*/
@property (nonatomic , assign) int num;
/**类型 0: 待付款, 3: 异常, 4: 待发货, 5: 已发货（待收货）, 8：已确认收货（使用中），9：已寄回*/
@property (nonatomic , assign) ZYOrderState status;

@end



@interface _m_GetMyHomeInfo : ZYBaseModel

/**用户头像路径*/
@property (nonatomic , copy) NSString *portraitPath;
/**用户昵称*/
@property (nonatomic , copy) NSString *nickName;
/**未读消息*/
@property (nonatomic , assign) BOOL unRead;
/**未读消息数*/
@property (nonatomic , assign) int unReadNum;
/**是否可提额*/
@property (nonatomic , assign) BOOL canPromote;
/**订单类型*/
@property (nonatomic , copy) NSArray *maps;
/**用户发布内容数量*/
@property (nonatomic , assign) int userAllReleaseNum;
/**用户内容总点赞数*/
@property (nonatomic , assign) int userAllZanNum;

@end
