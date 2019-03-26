//
//  GetMoneyDetails.h
//  Apollo
//
//  Created by shaxia on 2018/5/12.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseParam.h"

/**赚佣金信息查询参数*/
@interface _p_GetMoneyDetails : ZYBaseParam

@end


/**赚佣金信息查询返回*/
@interface _m_GetMoneyDetails : ZYBaseModel

/**做任务链接*/
@property (nonatomic , copy) NSString *makeJobGetMoneyUrl;
/**邀请好友数量*/
@property (nonatomic , copy) NSString *inviteAmount;
/**累计现金红包*/
@property (nonatomic , copy) NSString *cash;
/**分享标题*/
@property (nonatomic , copy) NSString *shareTitle;
/**分享内容*/
@property (nonatomic , copy) NSString *shareContent;
/**分享链接*/
@property (nonatomic , copy) NSString *shareUrl;
/**分享logo地址*/
@property (nonatomic , copy) NSString *shareImageUrl;
/**红包列表数组*/
@property (nonatomic , strong) NSArray *couponHistoryList;
/**福利数组*/
@property (nonatomic , strong) NSArray *benefitList;

@end



/**红包列表福利*/
@interface _m_GetMoneyDetails_benefit : ZYBaseModel

/**标题*/
@property (nonatomic , copy) NSString *title;
/**图片*/
@property (nonatomic , copy) NSString *imgUrl;
/**详细图片*/
@property (nonatomic , strong) NSArray *benefitDetails;

@end



/**红包列表福利*/
@interface _m_couponHistoryList_list : ZYBaseModel

/**手机号*/
@property (nonatomic , copy) NSString *mobile;

/**金额*/
@property (nonatomic , copy) NSString *amount;

/**类型*/
@property (nonatomic , copy) NSString *type;

/**时间*/
@property (nonatomic , copy) NSString *time;

@end

