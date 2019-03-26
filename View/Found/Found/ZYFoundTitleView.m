//
//  ZYFoundTitleView.m
//  Apollo
//
//  Created by 李明伟 on 2018/7/25.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYFoundTitleView.h"

@interface ZYFoundTitleView ()

@property (nonatomic , strong) UIView *cursor;

@end

@implementation ZYFoundTitleView

- (instancetype)init{
    if(self = [super init]){
        self.backgroundColor = UIColor.whiteColor;
        self.size = CGSizeMake(164 * UI_H_SCALE, NAVIGATION_BAR_HEIGHT - STATUSBAR_HEIGHT);
        
        [self addSubview:self.recommendBtn];
        [self.recommendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self);
            make.right.equalTo(self.mas_centerX);
        }];
        
        [self addSubview:self.momentBtn];
        [self.momentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(self);
            make.left.equalTo(self.mas_centerX);
        }];
        
        [self addSubview:self.cursor];
        self.cursor.centerX = self.width / 4.0;
    }
    return self;
}

#pragma mark - setter
- (void)setSelectedIndex:(int)selectedIndex{
    _selectedIndex = selectedIndex;
    
    if(0 == selectedIndex){
        self.recommendBtn.selected = YES;
        self.momentBtn.selected = NO;
        self.cursor.centerX = self.width / 4.0;
    }else{
        self.recommendBtn.selected = NO;
        self.momentBtn.selected = YES;
        self.cursor.centerX = self.width / 4.0 * 3;
    }
}

#pragma mark - getter
- (ZYElasticButton *)recommendBtn{
    if(!_recommendBtn){
        _recommendBtn = [ZYElasticButton new];
        _recommendBtn.shouldAnimate = NO;
        _recommendBtn.backgroundColor = UIColor.whiteColor;
        [_recommendBtn setTitle:@"推荐" forState:UIControlStateNormal];
        _recommendBtn.font = MEDIUM_FONT(16);
        [_recommendBtn setTitleColor:WORD_COLOR_BLACK forState:UIControlStateNormal];
        [_recommendBtn setTitleColor:WORD_COLOR_BLACK forState:UIControlStateHighlighted];
        [_recommendBtn setTitleColor:MAIN_COLOR_GREEN forState:UIControlStateSelected];
        _recommendBtn.selected = YES;
        
        __weak __typeof__(self) weakSelf = self;
        [_recommendBtn clickAction:^(UIButton * _Nonnull button) {
            if(!button.isSelected){
                button.selected = YES;
                weakSelf.cursor.centerX = weakSelf.width / 4.0;
                weakSelf.momentBtn.selected = NO;
                !weakSelf.action ? : weakSelf.action(0);
            }
        }];
    }
    return _recommendBtn;
}

- (ZYElasticButton *)momentBtn{
    if(!_momentBtn){
        _momentBtn = [ZYElasticButton new];
        _momentBtn.shouldAnimate = NO;
        _momentBtn.backgroundColor = UIColor.whiteColor;
        [_momentBtn setTitle:@"此刻" forState:UIControlStateNormal];
        _momentBtn.font = MEDIUM_FONT(16);
        [_momentBtn setTitleColor:WORD_COLOR_BLACK forState:UIControlStateNormal];
        [_momentBtn setTitleColor:WORD_COLOR_BLACK forState:UIControlStateHighlighted];
        [_momentBtn setTitleColor:MAIN_COLOR_GREEN forState:UIControlStateSelected];
        
        __weak __typeof__(self) weakSelf = self;
        [_momentBtn clickAction:^(UIButton * _Nonnull button) {
            if(!button.isSelected){
                button.selected = YES;
                weakSelf.cursor.centerX = weakSelf.width / 4.0 * 3;
                weakSelf.recommendBtn.selected = NO;
                !weakSelf.action ? : weakSelf.action(1);
            }
        }];
    }
    return _momentBtn;
}

- (UIView *)cursor{
    if(!_cursor){
        _cursor = [UIView new];
        _cursor.backgroundColor = MAIN_COLOR_GREEN;
        _cursor.size = CGSizeMake(4, 4);
        _cursor.bottom = NAVIGATION_BAR_HEIGHT - STATUSBAR_HEIGHT - 6;
        _cursor.cornerRadius = 2;
    }
    return _cursor;
}

#pragma mark - 适配iOS11
- (CGSize)intrinsicContentSize{
    return self.size;
}

@end
