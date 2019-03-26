//
//  ZYExpressCodeInput.h
//  Apollo
//
//  Created by 李明伟 on 2018/11/7.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYExpressCodeInput : UIView

@property (nonatomic , copy) void (^confirmBlock)(NSString *code);

- (void)show;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
