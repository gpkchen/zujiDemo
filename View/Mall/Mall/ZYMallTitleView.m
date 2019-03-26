//
//  ZYMallTitleView.m
//  Apollo
//
//  Created by 李明伟 on 2018/8/1.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYMallTitleView.h"

@interface ZYMallTitleView()

@property (nonatomic , strong) UIImageView *searchIV;
@property (nonatomic , strong) UILabel *searchLab;

@end

@implementation ZYMallTitleView

- (instancetype)init{
    if(self = [super init]){
        self.backgroundColor = UIColor.whiteColor;
        self.size = CGSizeMake(SCREEN_WIDTH - 80 * UI_H_SCALE, NAVIGATION_BAR_HEIGHT - STATUSBAR_HEIGHT);
        
        [self addSubview:self.searchBtn];
        [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(280 * UI_H_SCALE, 30));
            make.left.centerY.equalTo(self);
        }];
        
        [self.searchBtn addSubview:self.searchIV];
        [self.searchIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.searchBtn);
            make.left.equalTo(self.searchBtn).mas_offset(10 * UI_H_SCALE);
        }];
        
        [self.searchBtn addSubview:self.searchLab];
        [self.searchLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.searchBtn);
            make.left.equalTo(self.searchBtn).mas_offset(36 * UI_H_SCALE);
        }];
    }
    return self;
}

#pragma mark - getter
- (ZYElasticButton *)searchBtn{
    if(!_searchBtn){
        _searchBtn = [ZYElasticButton new];
        _searchBtn.shouldAnimate = NO;
        _searchBtn.backgroundColor = VIEW_COLOR;
        _searchBtn.shouldRound = YES;
    }
    return _searchBtn;
}

- (UIImageView *)searchIV{
    if(!_searchIV){
        _searchIV = [UIImageView new];
        _searchIV.image = [UIImage imageNamed:@"zy_mall_search"];
    }
    return _searchIV;
}

- (UILabel *)searchLab{
    if(!_searchLab){
        _searchLab = [UILabel new];
        _searchLab.textColor = HexRGB(0xcccccc);
        _searchLab.font = FONT(14);
        _searchLab.text = @"搜索你想要";
    }
    return _searchLab;
}

#pragma mark - 适配iOS11
- (CGSize)intrinsicContentSize{
    return self.size;
}

@end
