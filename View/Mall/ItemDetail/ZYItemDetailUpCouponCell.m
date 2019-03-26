//
//  ZYItemDetailUpCouponCell.m
//  Apollo
//
//  Created by 李明伟 on 2018/11/27.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import "ZYItemDetailUpCouponCell.h"

@interface ZYItemDetailUpCouponCell ()

@property (nonatomic , strong) UILabel *titleLab;

@end

@implementation ZYItemDetailUpCouponCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = [UIColor whiteColor];
        self.arrow.hidden = NO;
        self.separator.hidden = NO;
        [self.separator mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
            make.top.equalTo(self.contentView);
            make.height.mas_equalTo(LINE_HEIGHT);
        }];
        
        [self.contentView addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(self.titleLab.size);
        }];
        
        [self.contentView addSubview:self.couponLab];
        [self.couponLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.arrow.mas_left).mas_offset(-5);
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.titleLab.mas_right).mas_offset(20 * UI_H_SCALE);
        }];
    }
    return self;
}

#pragma mark - getter
- (UILabel *)titleLab{
    if(!_titleLab){
        _titleLab = [UILabel new];
        _titleLab.textColor = WORD_COLOR_GRAY;
        _titleLab.font = FONT(15);
        _titleLab.text = @"领券";
        [_titleLab sizeToFit];
    }
    return _titleLab;
}

- (UILabel *)couponLab{
    if(!_couponLab){
        _couponLab = [UILabel new];
        _couponLab.textColor = WORD_COLOR_BLACK;
        _couponLab.font = FONT(15);
        _couponLab.text = @"请选择产品参数";
        _couponLab.textAlignment = NSTextAlignmentRight;
    }
    return _couponLab;
}


@end
