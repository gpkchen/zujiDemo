//
//  ZYWaterFallLayout.h
//  Apollo
//
//  Created by 李明伟 on 2018/8/1.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZYWaterFallLayout;
@protocol ZYWaterFallLayoutDeleaget<NSObject>

@required
/**每个item的高度*/
- (CGFloat)waterFallLayout:(ZYWaterFallLayout *)waterFallLayout heightForItemAtIndexPath:(NSUInteger)indexPath itemWidth:(CGFloat)itemWidth;

@optional
/**有多少列*/
- (NSUInteger)columnCountInWaterFallLayout:(ZYWaterFallLayout *)waterFallLayout;
/**每列之间的间距*/
- (CGFloat)columnMarginInWaterFallLayout:(ZYWaterFallLayout *)waterFallLayout;
/**每行之间的间距*/
- (CGFloat)rowMarginInWaterFallLayout:(ZYWaterFallLayout *)waterFallLayout;
/**每个item的内边距*/
- (UIEdgeInsets)edgeInsetdInWaterFallLayout:(ZYWaterFallLayout *)waterFallLayout;

@end


/**UICollectionView瀑布流布局*/
@interface ZYWaterFallLayout : UICollectionViewLayout

/** 代理 */
@property (nonatomic, weak) id<ZYWaterFallLayoutDeleaget> delegate;

@end
