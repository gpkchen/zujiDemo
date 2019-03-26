//
//  ZYCustomNavigationBar.m
//  Apollo
//
//  Created by 李明伟 on 2018/11/5.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import "ZYCustomNavigationBar.h"

@interface ZYCustomNavigationBar()

@property (nonatomic , strong) ZYElasticButton *backBtn;
@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) UIView *line;

@property (nonatomic , assign) CGPoint maxTitleCenter; //标题最下方的中心点
@property (nonatomic , assign) CGPoint minTitleCenter; //标题最上方的中心点

@end

@implementation ZYCustomNavigationBar

- (instancetype)init{
    if(self = [super init]){
        _maxHeight = CNBMaxHeight;
        _minHeight = CNBMinHeight;
        _maxTitleFontSize = CNBTitleLabDefaultMaxFontSize;
        _minTitleFontSize = CNBTitleLabDefaultMinFontSize;
        _minTitleCenter = CGPointMake(SCREEN_WIDTH / 2, STATUSBAR_HEIGHT + (NAVIGATION_BAR_HEIGHT - STATUSBAR_HEIGHT) / 2);
        self.backgroundColor = UIColor.whiteColor;
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, _maxHeight);
        
        [self addSubview:self.backBtn];
        [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self).mas_offset(STATUSBAR_HEIGHT);
            make.size.mas_equalTo(CGSizeMake(self.backBtn.width + 30 * UI_H_SCALE,NAVIGATION_BAR_HEIGHT - STATUSBAR_HEIGHT));
        }];
        
        [self addSubview:self.line];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(LINE_HEIGHT);
        }];
    }
    return self;
}

#pragma mark - setter
- (void)setMaxTitleFontSize:(CGFloat)maxTitleFontSize{
    _maxTitleFontSize = maxTitleFontSize;
    self.titleLab.font = SEMIBOLD_FONT(maxTitleFontSize);
    
    if(_title){
        [self.titleLab sizeToFit];
        _maxTitleCenter = CGPointMake(15 * UI_H_SCALE + self.titleLab.width / 2,
                                      NAVIGATION_BAR_HEIGHT + self.titleLab.height / 2);
        self.titleLab.center = _maxTitleCenter;
    }
}

- (void)setMaxHeight:(CGFloat)maxHeight{
    _maxHeight = maxHeight;
    self.height = maxHeight;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    
    if(_title){
        if(self.titleLab.text){
            //已经显示了标题了
            CGPoint center = self.titleLab.center;
            self.titleLab.text = title;
            [self.titleLab sizeToFit];
            _maxTitleCenter = CGPointMake(15 * UI_H_SCALE + self.titleLab.width / 2,
                                          NAVIGATION_BAR_HEIGHT + self.titleLab.height / 2);
            self.titleLab.center = center;
        }else{
            //还没显示过标题
            self.titleLab.text = title;
            [self.titleLab sizeToFit];
            _maxTitleCenter = CGPointMake(15 * UI_H_SCALE + self.titleLab.width / 2,
                                          NAVIGATION_BAR_HEIGHT + self.titleLab.height / 2);
            self.titleLab.center = _maxTitleCenter;
        }
        if(!self.titleLab.superview){
            [self addSubview:self.titleLab];
        }
    }
}

- (void)setPullY:(CGFloat)pullY{
    _pullY = pullY;
    
    if(pullY <= 0){
        self.titleLab.font = SEMIBOLD_FONT(_maxTitleFontSize);
        [self.titleLab sizeToFit];
        [UIView animateWithDuration:CNBAnimationDuration animations:^{
            self.height = self.maxHeight;
            self.titleLab.center = self.maxTitleCenter;
            for(UIView *subView in self.fadeSubViews){
                subView.alpha = 1;
            }
            [self layoutIfNeeded];
        }];
        !_animationBlock ? : _animationBlock(0);
        
    }else if(pullY > 0 && pullY < self.maxHeight - self.minHeight){
        CGFloat rate = pullY / (self.maxHeight - self.minHeight);
        
        CGFloat fontSize = _maxTitleFontSize - (_maxTitleFontSize - _minTitleFontSize) * rate;
        self.titleLab.font = SEMIBOLD_FONT(fontSize);
        [self.titleLab sizeToFit];
        CGFloat x = _maxTitleCenter.x + (_minTitleCenter.x - _maxTitleCenter.x) * rate;
        CGFloat y = _maxTitleCenter.y - (_maxTitleCenter.y - _minTitleCenter.y) * rate;
        [UIView animateWithDuration:CNBAnimationDuration
                         animations:^{
                             self.height = self.maxHeight - pullY;
                             self.titleLab.center = CGPointMake(x,y);
                             for(UIView *subView in self.fadeSubViews){
                                 subView.alpha = 1 - rate;
                             }
                             [self layoutIfNeeded];
                         }];
        !_animationBlock ? : _animationBlock(rate);
        
    }else{
        self.titleLab.font = SEMIBOLD_FONT(_minTitleFontSize);
        [self.titleLab sizeToFit];
        [UIView animateWithDuration:CNBAnimationDuration
                         animations:^{
                             self.height = self.minHeight;
                             self.titleLab.center = self.minTitleCenter;
                             for(UIView *subView in self.fadeSubViews){
                                 subView.alpha = 0;
                             }
                             [self layoutIfNeeded];
                         }];
        !_animationBlock ? : _animationBlock(1);
    }
}

#pragma mark - getter
- (ZYElasticButton *)backBtn{
    if(!_backBtn){
        _backBtn = [ZYElasticButton new];
        _backBtn.backgroundColor = self.backgroundColor;
        [_backBtn setImage:[UIImage imageNamed:@"zy_cusnavigation_back_btn"] forState:UIControlStateNormal];
        [_backBtn setImage:[UIImage imageNamed:@"zy_cusnavigation_back_btn"] forState:UIControlStateHighlighted];
        [_backBtn sizeToFit];
        
        __weak __typeof__(self) weakSelf = self;
        [_backBtn clickAction:^(UIButton * _Nonnull button) {
            if(weakSelf.backAction){
                weakSelf.backAction();
            }else{
                [[ZYRouter router] back];
            }
        }];
    }
    return _backBtn;
}

- (UILabel *)titleLab{
    if(!_titleLab){
        _titleLab = [UILabel new];
        _titleLab.textColor = UIColor.blackColor;
        _titleLab.font = SEMIBOLD_FONT(_maxTitleFontSize);
    }
    return _titleLab;
}

- (UIView *)line{
    if(!_line){
        _line = [UIView new];
        _line.backgroundColor = LINE_COLOR;
    }
    return _line;
}

- (NSMutableArray *)fadeSubViews{
    if(!_fadeSubViews){
        _fadeSubViews = [NSMutableArray array];
    }
    return _fadeSubViews;
}

@end
