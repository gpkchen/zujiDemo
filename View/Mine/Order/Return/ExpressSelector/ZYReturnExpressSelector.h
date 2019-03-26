//
//  ZYReturnExpressSelector.h
//  Apollo
//
//  Created by 李明伟 on 2018/11/7.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import "ZYBaseSheet.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZYReturnExpressSelector : ZYBaseSheet

@property (nonatomic , copy) void (^selectionAction)(NSString *code);

@end

NS_ASSUME_NONNULL_END
