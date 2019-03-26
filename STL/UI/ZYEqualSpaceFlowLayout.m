//
//  ZYEqualSpaceFlowLayout.m
//  Apollo
//
//  Created by 李明伟 on 2018/8/1.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYEqualSpaceFlowLayout.h"

const static CGFloat kDefaultLineSpacing = 10; //默认固定行距
const static CGFloat kDefaultInteritemSpacing = 10; //固定列距

@interface ZYEqualSpaceFlowLayout()

@property (nonatomic , assign) CGFloat sumCellWidth;

@end

@implementation ZYEqualSpaceFlowLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    if(!_lineSpacing){
        if(_delegate && [_delegate respondsToSelector:@selector(lineSpacingForCollectionView:)]){
            _lineSpacing = [_delegate lineSpacingForCollectionView:self.collectionView];
        }else{
            _lineSpacing = kDefaultLineSpacing;
        }
    }
    if(!_interitemSpacing){
        if(_delegate && [_delegate respondsToSelector:@selector(interitemSpacingForCollectionView:)]){
            _interitemSpacing = [_delegate interitemSpacingForCollectionView:self.collectionView];
        }else{
            _interitemSpacing = kDefaultInteritemSpacing;
        }
    }
    
    self.minimumInteritemSpacing = _interitemSpacing;
    self.minimumLineSpacing = _lineSpacing;
    
    NSArray * layoutAttributes_t = [super layoutAttributesForElementsInRect:rect];
    NSArray * layoutAttributes = [[NSArray alloc]initWithArray:layoutAttributes_t copyItems:YES];
    //用来临时存放一行的Cell数组
    NSMutableArray * layoutAttributesTemp = [[NSMutableArray alloc]init];
    for (NSUInteger index = 0; index < layoutAttributes.count ; index++) {
        
        UICollectionViewLayoutAttributes *currentAttr = layoutAttributes[index]; // 当前cell的位置信息
        UICollectionViewLayoutAttributes *previousAttr = index == 0 ? nil : layoutAttributes[index-1]; // 上一个cell 的位置信
        UICollectionViewLayoutAttributes *nextAttr = index + 1 == layoutAttributes.count ? nil : layoutAttributes[index+1];//下一个cell 位置信息
        
        //加入临时数组
        [layoutAttributesTemp addObject:currentAttr];
        _sumCellWidth += currentAttr.frame.size.width;
        
        CGFloat previousY = previousAttr == nil ? 0 : CGRectGetMaxY(previousAttr.frame);
        CGFloat currentY = CGRectGetMaxY(currentAttr.frame);
        CGFloat nextY = nextAttr == nil ? 0 : CGRectGetMaxY(nextAttr.frame);
        //如果当前cell是单独一行
        if (currentY != previousY && currentY != nextY){
            if ([currentAttr.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
                [layoutAttributesTemp removeAllObjects];
                _sumCellWidth = 0.0;
            }else if ([currentAttr.representedElementKind isEqualToString:UICollectionElementKindSectionFooter]){
                [layoutAttributesTemp removeAllObjects];
                _sumCellWidth = 0.0;
            }else{
                [self setCellFrameWith:layoutAttributesTemp];
            }
        }
        //如果下一个cell在本行，这开始调整Frame位置
        else if( currentY != nextY) {
            [self setCellFrameWith:layoutAttributesTemp];
        }
    }
    return layoutAttributes;
}
//调整属于同一行的cell的位置frame
-(void)setCellFrameWith:(NSMutableArray*)layoutAttributes{
    CGFloat nowWidth = 0.0;
    switch (_alignType) {
        case ZYEqualSpaceFlowLayoutAlignTypeLeft:
            nowWidth = self.sectionInset.left;
            for (UICollectionViewLayoutAttributes * attributes in layoutAttributes) {
                CGRect nowFrame = attributes.frame;
                nowFrame.origin.x = nowWidth;
                attributes.frame = nowFrame;
                nowWidth += nowFrame.size.width + _interitemSpacing;
            }
            _sumCellWidth = 0.0;
            [layoutAttributes removeAllObjects];
            break;
            
        case ZYEqualSpaceFlowLayoutAlignTypeCenter:
            nowWidth = (self.collectionView.frame.size.width - _sumCellWidth - ((layoutAttributes.count - 1) * _interitemSpacing)) / 2;
            for (UICollectionViewLayoutAttributes * attributes in layoutAttributes) {
                CGRect nowFrame = attributes.frame;
                nowFrame.origin.x = nowWidth;
                attributes.frame = nowFrame;
                nowWidth += nowFrame.size.width + _interitemSpacing;
            }
            _sumCellWidth = 0.0;
            [layoutAttributes removeAllObjects];
            break;
            
        case ZYEqualSpaceFlowLayoutAlignTypeRight:
            nowWidth = self.collectionView.frame.size.width - self.sectionInset.right;
            for (NSInteger index = layoutAttributes.count - 1 ; index >= 0 ; index-- ) {
                UICollectionViewLayoutAttributes * attributes = layoutAttributes[index];
                CGRect nowFrame = attributes.frame;
                nowFrame.origin.x = nowWidth - nowFrame.size.width;
                attributes.frame = nowFrame;
                nowWidth = nowWidth - nowFrame.size.width - _interitemSpacing;
            }
            _sumCellWidth = 0.0;
            [layoutAttributes removeAllObjects];
            break;
    }
}
@end
