//
//  ZYMallSearchView.m
//  Apollo
//
//  Created by 李明伟 on 2018/8/1.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYMallSearchView.h"

@implementation ZYMallSearchView

- (instancetype)init{
    if(self = [super init]){
        self.backgroundColor = VIEW_COLOR;
        
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).mas_offset(UIEdgeInsetsMake(NAVIGATION_BAR_HEIGHT, 0, 0, 0));
        }];
    }
    return self;
}

#pragma mark - getter
- (ZYCollectionView *)collectionView{
    if(!_collectionView){
        _collectionView = [[ZYCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, DOWN_DANGER_HEIGHT, 0);
        _collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, DOWN_DANGER_HEIGHT, 0);
    }
    return _collectionView;
}

- (ZYEqualSpaceFlowLayout *)layout{
    if(!_layout){
        _layout = [ZYEqualSpaceFlowLayout new];
        _layout.lineSpacing = 10 * UI_H_SCALE;
        _layout.interitemSpacing = 10 * UI_H_SCALE;
        _layout.sectionInset = UIEdgeInsetsMake(0, 15 * UI_H_SCALE, 20 * UI_H_SCALE, 15 * UI_H_SCALE);
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _layout;
}

@end
