//
//  ZYItemDetailUpActivityCell.h
//  Apollo
//
//  Created by 李明伟 on 2018/10/17.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import "ZYBaseTableCell.h"

NS_ASSUME_NONNULL_BEGIN

#define ZYItemDetailUpActivityCellHeight (50 * UI_H_SCALE)

@interface ZYItemDetailUpActivityCell : ZYBaseTableCell

/**活动名称*/
@property (nonatomic , copy) NSString *activityName;
/**活动有效期*/
@property (nonatomic , copy) NSString *effectiveTime;

@end

NS_ASSUME_NONNULL_END
