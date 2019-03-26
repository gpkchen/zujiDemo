//
//  ZYItemDetailUpSpikeCell.m
//  Apollo
//
//  Created by 李明伟 on 2018/12/3.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import "ZYItemDetailUpSpikeCell.h"
#import "ItemDetail.h"

@interface ZYItemDetailUpSpikeCell()

@property (nonatomic , strong) CAGradientLayer *gradientLayer;//颜色渐变图层
@property (nonatomic , strong) UILabel *nameLab;

@property (nonatomic , strong) UILabel *timeTitleLab;
@property (nonatomic , strong) UILabel *hourLab;
@property (nonatomic , strong) UILabel *minuteLab;
@property (nonatomic , strong) UILabel *secondLab;
@property (nonatomic , strong) UILabel *colonLab1;
@property (nonatomic , strong) UILabel *colonLab2;

@property (nonatomic , strong) UIView *processBack;
@property (nonatomic , strong) UIView *process;

@property (nonatomic , strong) UILabel *startTimeLab;
@property (nonatomic , strong) UILabel *numLab;

@property (nonatomic , strong) _m_ItemDetail *detail;

@end

@implementation ZYItemDetailUpSpikeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.self.backgroundColor = HexRGB(0xFFE4B1);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView.layer addSublayer:self.gradientLayer];
        
        [self.contentView addSubview:self.nameLab];
        [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.size.mas_equalTo(CGSizeMake(80 * UI_H_SCALE, 30 * UI_H_SCALE));
        }];
        
        [self.contentView addSubview:self.timeTitleLab];
        [self.timeTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(270 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView.mas_top).mas_offset(14.5 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.hourLab];
        [self.hourLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(270 * UI_H_SCALE);
            make.bottom.equalTo(self.contentView).mas_offset(-6 * UI_H_SCALE);
            make.size.mas_equalTo(CGSizeMake(24 * UI_H_SCALE, 16 * UI_H_SCALE));
        }];
        
        [self.contentView addSubview:self.minuteLab];
        [self.minuteLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.hourLab.mas_right).mas_offset(9 * UI_H_SCALE);
            make.bottom.equalTo(self.hourLab);
            make.size.mas_equalTo(CGSizeMake(24 * UI_H_SCALE, 16 * UI_H_SCALE));
        }];
        
        [self.contentView addSubview:self.secondLab];
        [self.secondLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.minuteLab.mas_right).mas_offset(9 * UI_H_SCALE);
            make.bottom.equalTo(self.hourLab);
            make.size.mas_equalTo(CGSizeMake(24 * UI_H_SCALE, 16 * UI_H_SCALE));
        }];
        
        [self.contentView addSubview:self.colonLab1];
        [self.colonLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.hourLab).mas_offset(-2);
            make.centerX.equalTo(self.hourLab.mas_right).mas_offset(4.5 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.colonLab2];
        [self.colonLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.colonLab1);
            make.centerX.equalTo(self.minuteLab.mas_right).mas_offset(4.5 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.processBack];
        [self.processBack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).mas_offset(13 * UI_H_SCALE);
            make.left.equalTo(self.contentView).mas_offset(120 * UI_H_SCALE);
            make.size.mas_equalTo(CGSizeMake(90 * UI_H_SCALE, 5));
        }];
        
        [self.contentView addSubview:self.process];
        [self.process mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.top.equalTo(self.processBack);
            make.width.mas_equalTo(0);
        }];
        
        [self.contentView addSubview:self.startTimeLab];
        [self.startTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.processBack);
            make.centerY.equalTo(self.contentView.mas_top).mas_offset(17.5 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.numLab];
        [self.numLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.processBack);
            make.centerY.equalTo(self.contentView.mas_bottom).mas_offset(-16.5 * UI_H_SCALE);
        }];
    }
    return self;
}

- (void)showCellWithModel:(_m_ItemDetail *)model{
    _detail = model;
    if(model.spikeStartRestTime > 0){
        //秒杀还没开始
        [self showUnStart];
        [self showUnStartCountDown];
    }else{
        //秒杀进行中
        [self showStarted];
        [self showStartedCountDown];
    }
}

#pragma mark - 显示未开始
- (void)showUnStart{
    self.startTimeLab.hidden = NO;
    self.processBack.hidden = YES;
    self.process.hidden = YES;
    
    self.startTimeLab.text = _detail.spikeStartTime;
    self.numLab.text = [NSString stringWithFormat:@"%@人关注",_detail.spikeFocusNum];
    self.timeTitleLab.text = @"距离开抢还有";
}

#pragma mark - 显示未开始倒计时
- (void)showUnStartCountDown{
    long long timeRest = _detail.spikeStartRestTime - _timeCount * 1000;
    long long h = timeRest / 1000 / 60 / 60;
    long long m = (timeRest - h * 60 * 60 * 1000) / 1000 / 60;
    long long s = (timeRest - m * 60 * 1000 - h * 60 * 60 * 1000) / 1000;
    [self showCountDown:h m:m s:s];
}

#pragma mark - 显示已开始
- (void)showStarted{
    self.startTimeLab.hidden = YES;
    self.processBack.hidden = NO;
    self.process.hidden = NO;
    
    [self.process mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(90 * UI_H_SCALE * self.detail.spikeRate);
    }];
    self.numLab.text = [NSString stringWithFormat:@"已抢%d件",_detail.spikeLeaseNum];
    self.timeTitleLab.text = @"距离结束还有";
}

#pragma mark - 显示已开始倒计时
- (void)showStartedCountDown{
    long long timeRest = _detail.spikeEndRestTime - _timeCount * 1000;
    long long h = timeRest / 1000 / 60 / 60;
    long long m = (timeRest - h * 60 * 60 * 1000) / 1000 / 60;
    long long s = (timeRest - m * 60 * 1000 - h * 60 * 60 * 1000) / 1000;
    [self showCountDown:h m:m s:s];
}

#pragma mark - 显示倒计时
- (void)showCountDown:(long long)h m:(long long)m s:(long long)s{
    if(h >= 0){
        if(h < 10){
            self.hourLab.text = [NSString stringWithFormat:@"0%lld",h];
        }else{
            self.hourLab.text = [NSString stringWithFormat:@"%lld",h];
        }
    }else{
        self.hourLab.text = @"00";
    }
    if(m >= 0){
        if(m < 10){
            self.minuteLab.text = [NSString stringWithFormat:@"0%lld",m];
        }else{
            self.minuteLab.text = [NSString stringWithFormat:@"%lld",m];
        }
    }else{
        self.minuteLab.text = @"00";
    }
    if(s >= 0){
        if(s < 10){
            self.secondLab.text = [NSString stringWithFormat:@"0%lld",s];
        }else{
            self.secondLab.text = [NSString stringWithFormat:@"%lld",s];
        }
    }else{
        self.secondLab.text = @"00";
    }
}

#pragma mark - setter
- (void)setTimeCount:(int)timeCount{
    _timeCount = timeCount;
    
    if(_detail.spikeStartRestTime - timeCount * 1000 > 0){
        //秒杀还没开始
        [self showUnStart];
        [self showUnStartCountDown];
    }else{
        //秒杀进行中
        [self showStarted];
        [self showStartedCountDown];
    }
}

#pragma mark - getter
- (CAGradientLayer *)gradientLayer{
    if(!_gradientLayer){
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.colors = @[(__bridge id)HexRGB(0xFF8311).CGColor, (__bridge id)HexRGB(0xFF0707).CGColor];
        _gradientLayer.locations = @[@0.0, @1.0];
        _gradientLayer.startPoint = CGPointMake(0, 0);
        _gradientLayer.endPoint = CGPointMake(1.0, 0);
        _gradientLayer.frame = CGRectMake(0, 0, 255 * UI_H_SCALE, ZYItemDetailUpSpikeCellHeight);
    }
    return _gradientLayer;
}

- (UILabel *)nameLab{
    if(!_nameLab){
        _nameLab = [UILabel new];
        _nameLab.textColor = UIColor.whiteColor;
        _nameLab.font = SEMIBOLD_FONT(16);
        _nameLab.textAlignment = NSTextAlignmentCenter;
        _nameLab.text = @"限时秒杀";
        _nameLab.cornerRadius = 2;
        _nameLab.clipsToBounds = YES;
        _nameLab.backgroundColor = HexRGBAlpha(0xffffff, 0.4);
    }
    return _nameLab;
}

- (UILabel *)timeTitleLab{
    if(!_timeTitleLab){
        _timeTitleLab = [UILabel new];
        _timeTitleLab.text = @"距离结束还有";
        _timeTitleLab.font = FONT(12);
        _timeTitleLab.textColor = WORD_COLOR_BLACK;
    }
    return _timeTitleLab;
}

- (UILabel *)hourLab{
    if(!_hourLab){
        _hourLab = [UILabel new];
        _hourLab.textColor = HexRGB(0xFFE4B1);
        _hourLab.font = FONT(12);
        _hourLab.cornerRadius = 2;
        _hourLab.clipsToBounds = YES;
        _hourLab.backgroundColor = UIColor.blackColor;
        _hourLab.textAlignment = NSTextAlignmentCenter;
        _hourLab.text = @"00";
    }
    return _hourLab;
}

- (UILabel *)minuteLab{
    if(!_minuteLab){
        _minuteLab = [UILabel new];
        _minuteLab.textColor = HexRGB(0xFFE4B1);
        _minuteLab.font = FONT(12);
        _minuteLab.cornerRadius = 2;
        _minuteLab.clipsToBounds = YES;
        _minuteLab.backgroundColor = UIColor.blackColor;
        _minuteLab.textAlignment = NSTextAlignmentCenter;
        _minuteLab.text = @"00";
    }
    return _minuteLab;
}

- (UILabel *)secondLab{
    if(!_secondLab){
        _secondLab = [UILabel new];
        _secondLab.textColor = HexRGB(0xFFE4B1);
        _secondLab.font = FONT(12);
        _secondLab.cornerRadius = 2;
        _secondLab.clipsToBounds = YES;
        _secondLab.backgroundColor = UIColor.blackColor;
        _secondLab.textAlignment = NSTextAlignmentCenter;
        _secondLab.text = @"00";
    }
    return _secondLab;
}

- (UILabel *)colonLab1{
    if(!_colonLab1){
        _colonLab1 = [UILabel new];
        _colonLab1.textColor = UIColor.blackColor;
        _colonLab1.font = FONT(12);
        _colonLab1.text = @":";
    }
    return _colonLab1;
}

- (UILabel *)colonLab2{
    if(!_colonLab2){
        _colonLab2 = [UILabel new];
        _colonLab2.textColor = UIColor.blackColor;
        _colonLab2.font = FONT(12);
        _colonLab2.text = @":";
    }
    return _colonLab2;
}

- (UIView *)processBack{
    if(!_processBack){
        _processBack = [UIView new];
        _processBack.backgroundColor = UIColor.whiteColor;
        _processBack.cornerRadius = 2.5;
    }
    return _processBack;
}

- (UIView *)process{
    if(!_process){
        _process = [UIView new];
        _process.backgroundColor = HexRGB(0xFFD71B);
        _process.cornerRadius = 2.5;
    }
    return _process;
}

- (UILabel *)numLab{
    if(!_numLab){
        _numLab = [UILabel new];
        _numLab.textColor = UIColor.whiteColor;
        _numLab.font = FONT(12);
    }
    return _numLab;
}

- (UILabel *)startTimeLab{
    if(!_startTimeLab){
        _startTimeLab = [UILabel new];
        _startTimeLab.font = SEMIBOLD_FONT(12);
        _startTimeLab.textColor = UIColor.whiteColor;
    }
    return _startTimeLab;
}

@end
