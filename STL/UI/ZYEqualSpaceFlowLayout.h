//
//  ZYEqualSpaceFlowLayout.h
//  Apollo
//
//  Created by 李明伟 on 2018/8/1.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(int,ZYEqualSpaceFlowLayoutAlignType){
    ZYEqualSpaceFlowLayoutAlignTypeLeft,
    ZYEqualSpaceFlowLayoutAlignTypeCenter,
    ZYEqualSpaceFlowLayoutAlignTypeRight
};

@protocol ZYEqualSpaceFlowLayoutDelegate<UICollectionViewDelegateFlowLayout>

/**固定行距*/
- (CGFloat)lineSpacingForCollectionView:(UICollectionView *)collectionView;
/**固定列距*/
- (CGFloat)interitemSpacingForCollectionView:(UICollectionView *)collectionView;

@end

/**UICollectionView等间距布局*/
@interface ZYEqualSpaceFlowLayout : UICollectionViewFlowLayout

@property (nonatomic , weak) id<ZYEqualSpaceFlowLayoutDelegate> delegate;
/**固定行距*/
@property (nonatomic , assign) CGFloat lineSpacing;
/**固定列距*/
@property (nonatomic , assign) CGFloat interitemSpacing;
/**cell对齐方式*/
@property (nonatomic , assign) ZYEqualSpaceFlowLayoutAlignType alignType;

@end
