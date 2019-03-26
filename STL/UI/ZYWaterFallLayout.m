//
//  ZYWaterFallLayout.m
//  Apollo
//
//  Created by 李明伟 on 2018/8/1.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYWaterFallLayout.h"

static const CGFloat kDefaultColunmCount = 3; //默认的列数
static const CGFloat kDefaultColunmMargin = 10; //每一列之间的间距
static const CGFloat kDefaultRowMargin = 10; //每一行之间的间距
static const UIEdgeInsets kDefaultEdgeInsets = {10,10,10,10}; //内边距


@interface ZYWaterFallLayout()

@property (nonatomic, strong) NSMutableArray * attrsArr; //存放所有的布局属性
@property (nonatomic, strong) NSMutableArray *columnHeights; //存放所有列的当前高度
@property (nonatomic, assign) CGFloat contentHeight; //内容的高度

- (NSUInteger)colunmCount;
- (CGFloat)columnMargin;
- (CGFloat)rowMargin;
- (UIEdgeInsets)edgeInsets;

@end

@implementation ZYWaterFallLayout

- (void)prepareLayout{
    [super prepareLayout];
    self.contentHeight = 0;
    // 清除之前计算的所有高度
    [self.columnHeights removeAllObjects];
    // 设置每一列默认的高度
    for (NSInteger i = 0; i < kDefaultColunmCount ; i ++) {
        [self.columnHeights addObject:@(kDefaultEdgeInsets.top)];
    }
    // 清楚之前所有的布局属性
    [self.attrsArr removeAllObjects];
    // 开始创建每一个cell对应的布局属性
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i < count; i++) {
        // 创建位置
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        // 获取indexPath位置上cell对应的布局属性
        UICollectionViewLayoutAttributes * attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attrsArr addObject:attrs];
    }
}

#pragma mark - getter
- (NSMutableArray *)attrsArr{
    if (!_attrsArr) {
        _attrsArr = [NSMutableArray array];
    }
    return _attrsArr;
}

- (NSMutableArray *)columnHeights{
    if (!_columnHeights) {
        _columnHeights = [NSMutableArray array];
    }
    return _columnHeights;
}

#pragma mark - 数据处理
- (NSUInteger)colunmCount{
    if ([self.delegate respondsToSelector:@selector(columnCountInWaterFallLayout:)]) {
        return [self.delegate columnCountInWaterFallLayout:self];
    }else{
        return kDefaultColunmCount;
    }
}

- (CGFloat)columnMargin{
    if ([self.delegate respondsToSelector:@selector(columnMarginInWaterFallLayout:)]) {
        return [self.delegate columnMarginInWaterFallLayout:self];
    }else{
        return kDefaultColunmMargin;
    }
}

- (CGFloat)rowMargin{
    if ([self.delegate respondsToSelector:@selector(rowMarginInWaterFallLayout:)]) {
        return [self.delegate rowMarginInWaterFallLayout:self];
    }else{
        return kDefaultRowMargin;
    }
}

- (UIEdgeInsets)edgeInsets{
    if ([self.delegate respondsToSelector:@selector(edgeInsetdInWaterFallLayout:)]) {
        return [self.delegate edgeInsetdInWaterFallLayout:self];
    }else{
        return kDefaultEdgeInsets;
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    // 创建布局属性
    UICollectionViewLayoutAttributes * attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    //collectionView的宽度
    CGFloat collectionViewW = self.collectionView.frame.size.width;
    // 设置布局属性的frame
    CGFloat cellW = (collectionViewW - self.edgeInsets.left - self.edgeInsets.right - (self.colunmCount - 1) * self.columnMargin) / self.colunmCount;
    CGFloat cellH = [self.delegate waterFallLayout:self heightForItemAtIndexPath:indexPath.item itemWidth:cellW];
    // 找出最短的那一列
    NSInteger destColumn = 0;
    CGFloat minColumnHeight = [self.columnHeights[0] doubleValue];
    for (int i = 1; i < kDefaultColunmCount; i++) {
        // 取得第i列的高度
        CGFloat columnHeight = [self.columnHeights[i] doubleValue];
        if (minColumnHeight > columnHeight) {
            minColumnHeight = columnHeight;
            destColumn = i;
        }
    }
    CGFloat cellX = self.edgeInsets.left + destColumn * (cellW + self.columnMargin);
    CGFloat cellY = minColumnHeight;
    if (cellY != self.edgeInsets.top) {
        
        cellY += self.rowMargin;
    }
    attrs.frame = CGRectMake(cellX, cellY, cellW, cellH);
    // 更新最短那一列的高度
    self.columnHeights[destColumn] = @(CGRectGetMaxY(attrs.frame));
    // 记录内容的高度 - 即最长那一列的高度
    CGFloat maxColumnHeight = [self.columnHeights[destColumn] doubleValue];
    if (self.contentHeight < maxColumnHeight) {
        self.contentHeight = maxColumnHeight;
    }
    return attrs;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.attrsArr;
}

- (CGSize)collectionViewContentSize{
    return CGSizeMake(0, self.contentHeight + self.edgeInsets.bottom);
}

@end
