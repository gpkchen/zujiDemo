//
//  ZYMineQuotaDetailView.m
//  Apollo
//
//  Created by 李明伟 on 2018/10/15.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import "ZYMineQuotaDetailView.h"

@interface ZYMineQuotaDetailView()

@property (nonatomic , strong) UIImageView *arrowIV;
@property (nonatomic , strong) UIView *backView;
@property (nonatomic , strong) UILabel *tmpQuotaLab;
@property (nonatomic , strong) UILabel *timeLab;
@property (nonatomic , strong) UIView *line;
@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) UILabel *detailLab;

@end

@implementation ZYMineQuotaDetailView

- (instancetype)init{
    if(self = [super init]){
        self.backgroundColor = UIColor.clearColor;
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        __weak __typeof__(self) weakSelf = self;
        [self tapped:^(UITapGestureRecognizer *gesture) {
            [weakSelf dismiss];
        } delegate:nil];
        
        [self addSubview:self.backView];
        [self addSubview:self.arrowIV];
        
        [self.backView addSubview:self.tmpQuotaLab];
        [self.tmpQuotaLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.backView).mas_offset(20 * UI_H_SCALE);
            make.centerY.equalTo(self.backView.mas_top).mas_offset(36 * UI_H_SCALE);
        }];
        
        [self.backView addSubview:self.timeLab];
        [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.backView).mas_offset(20 * UI_H_SCALE);
            make.centerY.equalTo(self.backView.mas_top).mas_offset(60 * UI_H_SCALE);
        }];
        
        [self.backView addSubview:self.line];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.backView).mas_offset(20 * UI_H_SCALE);
            make.right.equalTo(self.backView).mas_offset(-20 * UI_H_SCALE);
            make.top.equalTo(self.backView).mas_offset(86 * UI_H_SCALE);
            make.height.mas_equalTo(1);
        }];
        
        [self.backView addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.backView).mas_offset(20 * UI_H_SCALE);
            make.centerY.equalTo(self.backView.mas_top).mas_offset(110 * UI_H_SCALE);
        }];
        
        [self.backView addSubview:self.detailLab];
        [self.detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.backView).mas_offset(20 * UI_H_SCALE);
            make.right.equalTo(self.backView).mas_offset(-20 * UI_H_SCALE);
            make.top.equalTo(self.titleLab.mas_bottom).mas_offset(4);
        }];
    }
    return self;
}

#pragma mark - public
- (void)showAtPoint:(CGPoint)point{
    if(!self.superview){
        
        self.tmpQuotaLab.text = [NSString stringWithFormat:@"临时额度：%.2f（元）",_amount];
        self.timeLab.text = [NSString stringWithFormat:@"有效期至：%@",_limit];
        if(_explain.length){
            self.detailLab.text = _explain;
        }
        self.arrowIV.centerX = point.x;
        self.arrowIV.top = point.y;
        self.backView.top =  self.arrowIV.bottom;
        CGSize detailSize = [self.detailLab sizeThatFits:CGSizeMake(SCREEN_WIDTH - 70 * UI_H_SCALE, CGFLOAT_MIN)];
        self.backView.height = detailSize.height + 150 * UI_H_SCALE;
        
        self.backView.alpha = 0;
        self.arrowIV.alpha = 0;
        [SCREEN addSubview:self];
        [UIView animateWithDuration:0.25
                         animations:^{
                             self.backView.alpha = 1;
                             self.arrowIV.alpha = 1;
                         }];
    }
}

- (void)dismiss{
    if(self.superview){
        [UIView animateWithDuration:0.25
                         animations:^{
                             self.backView.alpha = 0;
                             self.arrowIV.alpha = 0;
                         } completion:^(BOOL finished) {
                             [self removeFromSuperview];
                         }];
    }
}

#pragma mark - getter
- (UIImageView *)arrowIV{
    if(!_arrowIV){
        _arrowIV = [UIImageView new];
        _arrowIV.image = [UIImage imageNamed:@"zy_mine_quota_help_arrow"];
        _arrowIV.size = _arrowIV.image.size;
    }
    return _arrowIV;
}

- (UIView *)backView{
    if(!_backView){
        _backView = [UIView new];
        _backView.backgroundColor = UIColor.whiteColor;
        _backView.cornerRadius = 8;
        _backView.layer.shadowColor = [UIColor blackColor].CGColor;
        _backView.layer.shadowOpacity = 0.1;
        _backView.layer.shadowOffset = CGSizeMake(0, 5);
        _backView.layer.shadowRadius = 5;
        _backView.frame = CGRectMake(15 * UI_H_SCALE, 0, SCREEN_WIDTH - 30 * UI_H_SCALE, 180 * UI_H_SCALE);
    }
    return _backView;
}

- (UILabel *)tmpQuotaLab{
    if(!_tmpQuotaLab){
        _tmpQuotaLab = [UILabel new];
        _tmpQuotaLab.textColor = HexRGB(0x2ECC71);
        _tmpQuotaLab.font = MEDIUM_FONT(16);
    }
    return _tmpQuotaLab;
}

- (UILabel *)timeLab{
    if(!_timeLab){
        _timeLab = [UILabel new];
        _timeLab.font = FONT(14);
        _timeLab.textColor = WORD_COLOR_GRAY_9B;
    }
    return _timeLab;
}

- (UIView *)line{
    if(!_line){
        _line = [UIView new];
        _line.backgroundColor = LINE_COLOR;
    }
    return _line;
}

- (UILabel *)titleLab{
    if(!_titleLab){
        _titleLab = [UILabel new];
        _titleLab.font = MEDIUM_FONT(14);
        _titleLab.textColor = WORD_COLOR_BLACK;
        _titleLab.text = @"临时额度说明";
    }
    return _titleLab;
}

- (UILabel *)detailLab{
    if(!_detailLab){
        _detailLab = [UILabel new];
        _detailLab.textColor = WORD_COLOR_GRAY_9B;
        _detailLab.font = FONT(14);
        _detailLab.numberOfLines = 0;
        _detailLab.text = @"临时额度为系统基于你的资料和历史的信用行为而临时增加的额度，在有效期内可以无条件使用，超过有效期后作废，恢复到之前的额度。";
    }
    return _detailLab;
}

@end
