//
//  ZYUserCenterHeader.m
//  Apollo
//
//  Created by 李明伟 on 2018/7/27.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYUserCenterHeader.h"

@interface ZYUserCenterHeader()

@property (nonatomic , strong) UIImageView *back;
@property (nonatomic , strong) UILabel *likeTitleLab;
@property (nonatomic , strong) UILabel *publishTitleLab;

@end

@implementation ZYUserCenterHeader

- (instancetype)init{
    if(self = [super init]){
        self.backgroundColor = UIColor.whiteColor;
        
        [self addSubview:self.back];
        [self.back mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self addSubview:self.portrait];
        [self.portrait mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).mas_offset(15 * UI_H_SCALE);
            make.top.equalTo(self).mas_offset(75 * UI_H_SCALE + FRINGE_TOP_EXTRA_HEIGHT);
            make.size.mas_equalTo(CGSizeMake(80 * UI_H_SCALE, 80 * UI_H_SCALE));
        }];
        
        [self addSubview:self.nicknameLab];
        [self.nicknameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.portrait.mas_right).mas_offset(12 * UI_H_SCALE);
            make.right.equalTo(self).mas_offset(-15 * UI_H_SCALE);
            make.centerY.equalTo(self.mas_top).mas_offset(98.5 * UI_H_SCALE + FRINGE_TOP_EXTRA_HEIGHT);
        }];
        
        [self addSubview:self.publishTitleLab];
        [self.publishTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nicknameLab);
            make.centerY.equalTo(self.mas_top).mas_offset(134.5 * UI_H_SCALE + FRINGE_TOP_EXTRA_HEIGHT);
        }];
        
        [self addSubview:self.publishLab];
        [self.publishLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.publishTitleLab);
            make.left.equalTo(self.publishTitleLab.mas_right).mas_offset(10 * UI_H_SCALE);
        }];
        
        [self addSubview:self.likeTitleLab];
        [self.likeTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.publishTitleLab);
            make.left.equalTo(self.publishLab.mas_right).mas_offset(21 * UI_H_SCALE);
        }];
        
        [self addSubview:self.likeLab];
        [self.likeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.likeTitleLab);
            make.left.equalTo(self.likeTitleLab.mas_right).mas_offset(10 * UI_H_SCALE);
        }];
    }
    return self;
}

#pragma mark - getter
- (UIImageView *)back{
    if(!_back){
        _back = [UIImageView new];
        _back.backgroundColor = UIColor.whiteColor;
        _back.image = [UIImage imageNamed:@"zy_usercenter_back"];
    }
    return _back;
}

- (UIImageView *)portrait{
    if(!_portrait){
        _portrait = [UIImageView new];
        _portrait.cornerRadius = 40 * UI_H_SCALE;
        _portrait.contentMode = UIViewContentModeScaleAspectFill;
        _portrait.clipsToBounds = YES;
        _portrait.borderColor = UIColor.whiteColor;
        _portrait.borderWidth = 1;
        _portrait.userInteractionEnabled = YES;
    }
    return _portrait;
}

- (UILabel *)nicknameLab{
    if(!_nicknameLab){
        _nicknameLab = [UILabel new];
        _nicknameLab.font = SEMIBOLD_FONT(24);
        _nicknameLab.textColor = UIColor.whiteColor;
    }
    return _nicknameLab;
}

- (UILabel *)likeTitleLab{
    if(!_likeTitleLab){
        _likeTitleLab = [UILabel new];
        _likeTitleLab.textColor = UIColor.whiteColor;
        _likeTitleLab.font = FONT(12);
        _likeTitleLab.text = @"赞";
    }
    return _likeTitleLab;
}

- (UILabel *)publishTitleLab{
    if(!_publishTitleLab){
        _publishTitleLab = [UILabel new];
        _publishTitleLab.textColor = UIColor.whiteColor;
        _publishTitleLab.font = FONT(12);
        _publishTitleLab.text = @"发布";
    }
    return _publishTitleLab;
}

- (UILabel *)likeLab{
    if(!_likeLab){
        _likeLab = [UILabel new];
        _likeLab.textColor = UIColor.whiteColor;
        _likeLab.font = SEMIBOLD_FONT(14);
        _likeLab.text = @"0";
    }
    return _likeLab;
}

- (UILabel *)publishLab{
    if(!_publishLab){
        _publishLab = [UILabel new];
        _publishLab.textColor = UIColor.whiteColor;
        _publishLab.font = SEMIBOLD_FONT(14);
        _publishLab.text = @"0";
    }
    return _publishLab;
}

@end
