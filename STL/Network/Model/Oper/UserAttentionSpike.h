//
//  UserAttentionSpike.h
//  Apollo
//
//  Created by 李明伟 on 2018/12/6.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface _p_UserAttentionSpike : ZYBaseParam

/**宝贝ID*/
@property (nonatomic , copy) NSString *itemId;
/**0-取消关注 1-关注*/
@property (nonatomic , copy) NSString *status;
/**活动配置id*/
@property (nonatomic , copy) NSString *activityConfigureId;

@end

NS_ASSUME_NONNULL_END
