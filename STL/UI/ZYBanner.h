//
//  ZYBanner.h
//  PodLib
//
//  Created by 李明伟 on 2018/3/28.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZYBanner;

/**Banner操作代理*/
@protocol ZYBannerDelegate <NSObject>
@optional
/**
 *  选中banner某一cell时触发的回调
 *
 *  @param banner Banner对象
 *  @param index      cell下标
 */
- (void) banner:(ZYBanner *)banner didSelectCellAtIndex:(NSUInteger)index;
/**
 *  banner滚动时回调
 *
 *  @param banner Banner对象
 *  @param index  下标
 */
- (void) banner:(ZYBanner *)banner didScrollToIndex:(NSUInteger)index;

@end


/**Banner数据源代理*/
@protocol ZYBannerDataSource <NSObject>
@required
/**
 *  cell数代理
 *
 *  @param banner Banner对象
 *
 *  @return cell数
 */
- (NSUInteger)numOfCellInBanner:(ZYBanner *)banner;
/**
 *  cell样式代理
 *
 *  @param banner Banner对象
 *  @param index      cell下标
 *
 *  @return cell样式
 */
- (UIView *)banner:(ZYBanner *)banner viewForCellAtIndex:(NSUInteger)index;
@end

/**banner控件*/
@interface ZYBanner : UIView

@property (nonatomic , weak) id<ZYBannerDelegate> delegate;
@property (nonatomic , weak) id<ZYBannerDataSource> dataSource;

/**
 *  刷新banner方法
 */
- (void)reloadData;

@end
