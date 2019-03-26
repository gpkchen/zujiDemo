//
//  ZYPublishMomentView.m
//  Apollo
//
//  Created by 李明伟 on 2018/7/24.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYPublishMomentView.h"

@implementation ZYPublishMomentView

- (instancetype)init{
    if(self = [super init]){
        self.backgroundColor = VIEW_COLOR;
        
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).mas_offset(NAVIGATION_BAR_HEIGHT);
            make.left.right.equalTo(self);
            make.bottom.equalTo(self).mas_offset(-48 * UI_H_SCALE - DOWN_DANGER_HEIGHT);
        }];
        
        [self addSubview:self.publishBtn];
        self.publishBtn.size = CGSizeMake(SCREEN_WIDTH, 48 * UI_H_SCALE);
        self.publishBtn.left = 0;
        self.publishBtn.bottom = SCREEN_HEIGHT - DOWN_DANGER_HEIGHT;
    }
    return self;
}

#pragma mark - getter
- (ZYCollectionView *)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _collectionView = [[ZYCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = VIEW_COLOR;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.alwaysBounceVertical = YES;
    }
    return _collectionView;
}

- (ZYElasticButton *)publishBtn{
    if(!_publishBtn){
        _publishBtn = [ZYElasticButton new];
        [_publishBtn setBackgroundColor:HexRGB(0x7EDCA6) forState:UIControlStateNormal];
        [_publishBtn setBackgroundColor:HexRGB(0x7EDCA6) forState:UIControlStateHighlighted];
        _publishBtn.font = FONT(16);
        [_publishBtn setTitle:@"发布" forState:UIControlStateNormal];
        [_publishBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _publishBtn.shouldAnimate = NO;
    }
    return _publishBtn;
}

@end
