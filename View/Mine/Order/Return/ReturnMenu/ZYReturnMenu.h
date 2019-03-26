//
//  ZYReturnMenu.h
//  Apollo
//
//  Created by 李明伟 on 2018/11/6.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import "ZYBaseSheet.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZYReturnMenu : ZYBaseSheet

@property (nonatomic , copy) NSString *orderId;

/**按钮回调*/
@property (nonatomic , copy) void (^buttonAction)(void);

@end

NS_ASSUME_NONNULL_END
