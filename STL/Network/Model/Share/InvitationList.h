//
//  InvitationList.h
//  Apollo
//
//  Created by shaxia on 2018/5/8.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseParam.h"

/**邀请列表参数*/
@interface _p_InvitationList : ZYBaseParam



@end


/**邀请列表返回*/
@interface _m_InvitationList : ZYBaseModel

/**邀请总人数*/
@property (nonatomic , copy) NSString *totalPerson;

/**总交易人数*/
@property (nonatomic , copy) NSString *totalTrade;

/**列表*/
@property (nonatomic , copy) NSArray    *list;


@end

@interface _m_InvitationList_list : ZYBaseModel

/**手机号*/
@property (nonatomic , copy) NSString *mobile;

/**邀请时间*/
@property (nonatomic , copy) NSString *inviteTime;

/**邀请状态 0:已经下单 1：未下单*/
@property (nonatomic , copy) NSString *status;


@end

