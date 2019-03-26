//
//  ZYReturnVC.h
//  Apollo
//
//  Created by 李明伟 on 2018/11/6.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import "ZYBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZYReturnVC : ZYBaseVC

@property (nonatomic , copy) NSString *orderId;
/**1-上门归还 2-邮寄归还 3-上门自提*/
@property (nonatomic , copy) NSString *addressUseScene;

@end

NS_ASSUME_NONNULL_END
