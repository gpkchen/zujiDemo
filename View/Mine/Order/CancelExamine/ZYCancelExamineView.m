//
//  ZYCancelExamineView.m
//  Apollo
//
//  Created by 李明伟 on 2018/10/8.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYCancelExamineView.h"

@interface ZYCancelExamineView()

@property (nonatomic , strong) UIView *contentView;
@property (nonatomic , strong) UIView *backView;
@property (nonatomic , strong) UIImageView *iconIV;
@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) UILabel *contentLab;

@end

@implementation ZYCancelExamineView

- (instancetype)init{
    if(self = [super init]){
        self.backgroundColor = VIEW_COLOR;
        
        [self addSubview:self.scrollView];
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).mas_offset(UIEdgeInsetsMake(NAVIGATION_BAR_HEIGHT, 0, 0, 0));
        }];
        
        [self.scrollView addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.scrollView);
            make.width.equalTo(self.scrollView);
        }];
        
        [self.contentView addSubview:self.backView];
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.contentView);
            make.height.mas_equalTo(200 * UI_H_SCALE);
        }];
        
        [self.backView addSubview:self.iconIV];
        [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.backView);
            make.top.equalTo(self.backView).mas_offset(30 * UI_H_SCALE);
        }];
        
        [self.backView addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.backView);
            make.centerY.equalTo(self.iconIV.mas_bottom).mas_offset(21 * UI_H_SCALE);
        }];
        
        [self.backView addSubview:self.contentLab];
        [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.backView);
            make.centerY.equalTo(self.iconIV.mas_bottom).mas_offset(47 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.detailBtn];
        [self.detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.top.equalTo(self.backView.mas_bottom).mas_offset(30 * UI_H_SCALE);
            make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH - 55 * UI_H_SCALE) / 2.0, 44 * UI_H_SCALE));
        }];
        
        [self.contentView addSubview:self.homeBtn];
        [self.homeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
            make.top.equalTo(self.backView.mas_bottom).mas_offset(30 * UI_H_SCALE);
            make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH - 55 * UI_H_SCALE) / 2.0, 44 * UI_H_SCALE));
        }];
        
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.detailBtn).mas_offset(30 * UI_H_SCALE);
        }];
    }
    return self;
}

#pragma mark - getter
- (ZYScrollView *)scrollView{
    if(!_scrollView){
        _scrollView = [ZYScrollView new];
        _scrollView.backgroundColor = VIEW_COLOR;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.alwaysBounceVertical = YES;
    }
    return _scrollView;
}

- (UIView *)contentView{
    if(!_contentView){
        _contentView = [UIView new];
        _contentView.backgroundColor = VIEW_COLOR;
    }
    return _contentView;
}

- (UIView *)backView{
    if(!_backView){
        _backView = [UIView new];
        _backView.backgroundColor = UIColor.whiteColor;
    }
    return _backView;
}

- (UIImageView *)iconIV{
    if(!_iconIV){
        _iconIV = [UIImageView new];
        _iconIV.image = [UIImage imageNamed:@"zy_mall_pay_success_icon"];
    }
    return _iconIV;
}

- (UILabel *)titleLab{
    if(!_titleLab){
        _titleLab = [UILabel new];
        _titleLab.textColor = WORD_COLOR_BLACK;
        _titleLab.font = FONT(16);
        _titleLab.text = @"成功提交";
    }
    return _titleLab;
}

- (UILabel *)contentLab{
    if(!_contentLab){
        _contentLab = [UILabel new];
        _contentLab.textColor = WORD_COLOR_GRAY;
        _contentLab.font = FONT(14);
        _contentLab.text = @"工作人员将在核对信息后，为你取消";
    }
    return _contentLab;
}

- (ZYElasticButton *)detailBtn{
    if(!_detailBtn){
        _detailBtn = [ZYElasticButton new];
        _detailBtn.backgroundColor = VIEW_COLOR;
        _detailBtn.borderColor = BTN_COLOR_NORMAL_GREEN;
        _detailBtn.borderWidth = 1;
        _detailBtn.shouldRound = YES;
        _detailBtn.font = FONT(16);
        [_detailBtn setTitleColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateNormal];
        [_detailBtn setTitleColor:BTN_COLOR_HEIGHTLIGHT_GREEN forState:UIControlStateHighlighted];
        [_detailBtn setTitle:@"查看详情" forState:UIControlStateNormal];
    }
    return _detailBtn;
}

- (ZYElasticButton *)homeBtn{
    if(!_homeBtn){
        _homeBtn = [ZYElasticButton new];
        _homeBtn.shouldRound = YES;
        _homeBtn.font = FONT(16);
        [_homeBtn setBackgroundColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateNormal];
        [_homeBtn setBackgroundColor:BTN_COLOR_HEIGHTLIGHT_GREEN forState:UIControlStateHighlighted];
        [_homeBtn setTitle:@"返回首页" forState:UIControlStateNormal];
    }
    return _homeBtn;
}

@end
