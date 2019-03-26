//
//  ZYCouponChoiseCancelCell.m
//  Apollo
//
//  Created by 李明伟 on 2018/11/28.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import "ZYCouponChoiseCancelCell.h"

@interface ZYCouponChoiseCancelCell()

@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) UIImageView *selectionIV;

@end

@implementation ZYCouponChoiseCancelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = UIColor.whiteColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView);
        }];
        
        [self.contentView addSubview:self.selectionIV];
        [self.selectionIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).mas_offset(-30 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView);
        }];
    }
    return self;
}

#pragma mark - setter
- (void)setChoosed:(BOOL)choosed{
    _choosed = choosed;
    if(choosed){
        self.selectionIV.image = [UIImage imageNamed:@"zy_coupon_selection_selected"];
    }else{
        self.selectionIV.image = [UIImage imageNamed:@"zy_coupon_selection_normal"];
    }
}

#pragma mark - getter
- (UILabel *)titleLab{
    if(!_titleLab){
        _titleLab = [UILabel new];
        _titleLab.textColor = WORD_COLOR_BLACK;
        _titleLab.font = FONT(15);
        _titleLab.text = @"不使用优惠券";
    }
    return _titleLab;
}

- (UIImageView *)selectionIV{
    if(!_selectionIV){
        _selectionIV = [UIImageView new];
        _selectionIV.image = [UIImage imageNamed:@"zy_coupon_selection_normal"];
    }
    return _selectionIV;
}

@end
