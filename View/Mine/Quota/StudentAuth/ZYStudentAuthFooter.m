//
//  ZYStudentAuthFooter.m
//  Apollo
//
//  Created by 李明伟 on 2018/7/18.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYStudentAuthFooter.h"

@interface ZYStudentAuthFooter()

@property (nonatomic , strong) UILabel *cardTitleLab;

@end

@implementation ZYStudentAuthFooter

- (instancetype)init{
    if(self = [super init]){
        self.backgroundColor = VIEW_COLOR;
        
        [self addSubview:self.cardIV];
        [self.cardIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).mas_offset(15 * UI_H_SCALE);
            make.right.equalTo(self).mas_offset(-15 * UI_H_SCALE);
            make.top.equalTo(self).mas_offset(20 * UI_H_SCALE);
            make.height.mas_equalTo(200 * UI_H_SCALE);
        }];
        
        [self addSubview:self.cardTitleLab];
        [self.cardTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self.cardIV.mas_bottom).mas_offset(20 * UI_H_SCALE);
        }];
        
        [self addSubview:self.submitBtn];
        [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).mas_offset(15 * UI_H_SCALE);
            make.right.equalTo(self).mas_offset(-15 * UI_H_SCALE);
            make.top.equalTo(self.cardIV.mas_bottom).mas_offset(60 * UI_H_SCALE);
            make.height.mas_equalTo(49 * UI_H_SCALE);
        }];
    }
    return self;
}

#pragma mark - getter
- (UIImageView *)cardIV{
    if(!_cardIV){
        _cardIV = [UIImageView new];
        _cardIV.userInteractionEnabled = YES;
        _cardIV.contentMode = UIViewContentModeScaleAspectFill;
        _cardIV.clipsToBounds = YES;
        _cardIV.cornerRadius = 10;
        _cardIV.image = [UIImage imageNamed:@"zy_quota_studentcard_back"];
    }
    return _cardIV;
}

- (UILabel *)cardTitleLab{
    if(!_cardTitleLab){
        _cardTitleLab = [UILabel new];
        _cardTitleLab.textColor = WORD_COLOR_BLACK;
        _cardTitleLab.font = FONT(16);
        _cardTitleLab.text = @"请上传学生证正面";
    }
    return _cardTitleLab;
}

- (ZYElasticButton *)submitBtn{
    if(!_submitBtn){
        _submitBtn = [ZYElasticButton new];
        _submitBtn.shouldRound = YES;
        [_submitBtn setBackgroundColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateNormal];
        [_submitBtn setBackgroundColor:BTN_COLOR_HEIGHTLIGHT_GREEN forState:UIControlStateHighlighted];
        _submitBtn.font = FONT(18);
        [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    }
    return _submitBtn;
}

@end
