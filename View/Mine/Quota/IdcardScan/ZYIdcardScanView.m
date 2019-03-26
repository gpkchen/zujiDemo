//
//  ZYIdcardScanView.m
//  Apollo
//
//  Created by 李明伟 on 2018/7/10.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYIdcardScanView.h"

@interface ZYIdcardScanView()

@property (nonatomic , strong) ZYScrollView *scrollView;
@property (nonatomic , strong) UIView *contentView;
@property (nonatomic , strong) UILabel *topTipLabel;
@property (nonatomic , strong) UIView *topBack;
@property (nonatomic , strong) UILabel *frontLab;
@property (nonatomic , strong) UILabel *backLab;

@end

@implementation ZYIdcardScanView

- (instancetype)init{
    if(self = [super init]){
        self.backgroundColor = UIColor.whiteColor;
        
        [self addSubview:self.scrollView];
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).mas_offset(UIEdgeInsetsMake(NAVIGATION_BAR_HEIGHT, 0, 0, 0));
        }];
        
        [self.scrollView addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.scrollView);
            make.width.equalTo(self.scrollView);
        }];
        
        [self.contentView addSubview:self.topBack];
        [self.contentView addSubview:self.topTipLabel];
        
        [self.topTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_top).mas_offset(30 * UI_H_SCALE);
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
        }];
        
        [self.topBack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.contentView);
            make.bottom.equalTo(self.topTipLabel).mas_offset(10 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.frontIV];
        [self.frontIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
            make.top.equalTo(self.topBack.mas_bottom).mas_offset(10 * UI_H_SCALE);
            make.height.mas_equalTo(200 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.backIV];
        [self.backIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
            make.top.equalTo(self.frontIV.mas_bottom).mas_offset(48 * UI_H_SCALE);
            make.height.mas_equalTo(200 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.frontLab];
        [self.frontLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.centerY.equalTo(self.frontIV.mas_bottom).mas_offset(20 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.backLab];
        [self.backLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.centerY.equalTo(self.backIV.mas_bottom).mas_offset(20 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.submitBtn];
        [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
            make.top.equalTo(self.backIV.mas_bottom).mas_offset(47 * UI_H_SCALE);
            make.height.mas_offset(49 * UI_H_SCALE);
        }];
        
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.submitBtn.mas_bottom).mas_offset(20 * UI_H_SCALE);
        }];
    }
    return self;
}

#pragma mark - getter
- (ZYScrollView *)scrollView{
    if(!_scrollView){
        _scrollView = [ZYScrollView new];
        _scrollView.backgroundColor = UIColor.whiteColor;
        _scrollView.contentInset = UIEdgeInsetsMake(0, 0, DOWN_DANGER_HEIGHT, 0);
    }
    return _scrollView;
}

- (UIView *)contentView{
    if(!_contentView){
        _contentView = [UIView new];
        _contentView.backgroundColor = UIColor.whiteColor;
    }
    return _contentView;
}

- (UILabel *)topTipLabel{
    if(!_topTipLabel){
        _topTipLabel = [[UILabel alloc] init];
        _topTipLabel.text = @"为确保你上传的身份证图片真实有效清晰，请拍摄原件，切勿翻拍保存的身份证图片";
        _topTipLabel.textColor = WORD_COLOR_BLACK;
        _topTipLabel.numberOfLines = 2;
        _topTipLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _topTipLabel.font = FONT(14);
    }
    return _topTipLabel;
}

- (UIView *)topBack{
    if(!_topBack){
        _topBack = [UIView new];
        _topBack.backgroundColor = HexRGB(0xF5E5CB);
    }
    return _topBack;
}

- (UIImageView *)frontIV{
    if(!_frontIV){
        _frontIV = [UIImageView new];
        _frontIV.userInteractionEnabled = YES;
//        _frontIV.contentMode = UIViewContentModeScaleAspectFill;
        _frontIV.clipsToBounds = YES;
        _frontIV.cornerRadius = 10;
        _frontIV.image = [UIImage imageNamed:@"zy_quota_idcard_front"];
    }
    return _frontIV;
}

- (UIImageView *)backIV{
    if(!_backIV){
        _backIV = [UIImageView new];
        _backIV.userInteractionEnabled = YES;
//        _backIV.contentMode = UIViewContentModeScaleAspectFill;
        _backIV.clipsToBounds = YES;
        _backIV.cornerRadius = 10;
        _backIV.image = [UIImage imageNamed:@"zy_quota_idcard_back"];
    }
    return _backIV;
}

- (UILabel *)frontLab{
    if(!_frontLab){
        _frontLab = [UILabel new];
        _frontLab.textColor = WORD_COLOR_BLACK;
        _frontLab.font = FONT(16);
        _frontLab.text = @"请上传身份证人像面";
    }
    return _frontLab;
}

- (UILabel *)backLab{
    if(!_backLab){
        _backLab = [UILabel new];
        _backLab.textColor = WORD_COLOR_BLACK;
        _backLab.font = FONT(16);
        _backLab.text = @"请上传身份证国徽面";
    }
    return _backLab;
}

- (ZYElasticButton *)submitBtn{
    if(!_submitBtn){
        _submitBtn = [ZYElasticButton new];
        [_submitBtn setBackgroundColor:BTN_COLOR_HEIGHTLIGHT_GREEN forState:UIControlStateHighlighted];
        [_submitBtn setBackgroundColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateNormal];
        [_submitBtn setFont:FONT(18)];
        [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _submitBtn.shouldRound = YES;
    }
    return _submitBtn;
}

@end
