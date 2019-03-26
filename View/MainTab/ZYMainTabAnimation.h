//
//  ZYMainTabAnimation.h
//  Apollo
//
//  Created by 李明伟 on 2018/10/10.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYMainTabAnimation : NSObject<UIViewControllerAnimatedTransitioning>

/**是否向左，NO为向右*/
@property (nonatomic , assign) BOOL isLeft;

@end

NS_ASSUME_NONNULL_END
