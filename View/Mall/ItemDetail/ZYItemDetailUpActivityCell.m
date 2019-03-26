//
//  ZYItemDetailUpActivityCell.m
//  Apollo
//
//  Created by 李明伟 on 2018/10/17.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import "ZYItemDetailUpActivityCell.h"

@interface ZYItemDetailUpActivityCell()

@property (nonatomic , strong) UILabel *activityNameLab;
@property (nonatomic , strong) UILabel *effectiveTimeLab;

@end

@implementation ZYItemDetailUpActivityCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithReuseIdentifier:reuseIdentifier]){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = HexRGB(0xFF6007);
        
        [self.contentView addSubview:self.activityNameLab];
        [self.activityNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView);
        }];
        
        [self.contentView addSubview:self.effectiveTimeLab];
        [self.effectiveTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
//            make.left.greaterThanOrEqualTo(self.activityNameLab.mas_right).mas_offset(10 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView);
        }];
    }
    return self;
}

#pragma mark - setter
- (void)setActivityName:(NSString *)activityName{
    _activityName = activityName;
    self.activityNameLab.text = activityName;
}

- (void)setEffectiveTime:(NSString *)effectiveTime{
    _effectiveTime = effectiveTime;
    if(effectiveTime){
        self.effectiveTimeLab.text = [NSString stringWithFormat:@"活动时间:%@",effectiveTime];
    }else{
        self.effectiveTimeLab.text = @"";
    }
}

#pragma mark - getter
- (UILabel *)activityNameLab{
    if(!_activityNameLab){
        _activityNameLab = [UILabel new];
        _activityNameLab.textColor = UIColor.whiteColor;
        _activityNameLab.font = MEDIUM_FONT(15);
    }
    return _activityNameLab;
}

- (UILabel *)effectiveTimeLab{
    if(!_effectiveTimeLab){
        _effectiveTimeLab = [UILabel new];
        _effectiveTimeLab.textColor = UIColor.whiteColor;
        _effectiveTimeLab.font = FONT(12);
    }
    return _effectiveTimeLab;
}

@end
