//
//  UIScrollView+ZYExtension.h
//  PodLib
//
//  Created by 李明伟 on 2018/3/27.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

@interface UIScrollView (ZYExtension)

/**设置下拉刷新组件*/
- (void)addRefreshHeaderWithBlock:(MJRefreshComponentRefreshingBlock)block;
/**设置上拉加载组件*/
- (void)addRefreshFooterWithBlock:(MJRefreshComponentRefreshingBlock)block;
- (void)addRefreshFooterWithTitle:(NSString *)title block:(MJRefreshComponentRefreshingBlock)block;

@end
