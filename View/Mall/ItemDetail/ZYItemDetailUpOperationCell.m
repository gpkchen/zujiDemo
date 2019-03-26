//
//  ZYItemDetailUpOperationCell.m
//  Apollo
//
//  Created by 李明伟 on 2018/8/7.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYItemDetailUpOperationCell.h"

@interface ZYItemDetailUpOperationCell()

@property (nonatomic , strong) UIImageView *arrowIV;
@property (nonatomic , strong) UILabel *goLab;
@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) UILabel *noticeLab;


@end

@implementation ZYItemDetailUpOperationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = HexRGB(0xFF6007);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.arrowIV];
        [self.arrowIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(self.arrowIV.size);
        }];
        
        [self.contentView addSubview:self.goLab];
        [self.goLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.arrowIV.mas_left).mas_offset(-4 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(self.goLab.size);
        }];
        
        [self.contentView addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView.mas_top).mas_offset(16.5 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.noticeLab];
        [self.noticeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView.mas_top).mas_offset(34.5 * UI_H_SCALE);
            make.right.equalTo(self.goLab.mas_left).mas_offset(-10 * UI_H_SCALE);
        }];
    }
    return self;
}

#pragma mark - setter
- (void)setNotice:(NSString *)notice{
    _notice = notice;
    self.noticeLab.text = notice;
}

#pragma mark - getter
- (UIImageView *)arrowIV{
    if(!_arrowIV){
        _arrowIV = [UIImageView new];
        _arrowIV.image = [UIImage imageNamed:@"zy_mall_item_detail_operation_arrow"];
        _arrowIV.size = _arrowIV.image.size;
    }
    return _arrowIV;
}

- (UILabel *)goLab{
    if(!_goLab){
        _goLab = [UILabel new];
        _goLab.textColor = UIColor.whiteColor;
        _goLab.font = FONT(12);
        _goLab.text = @"活动说明";
        [_goLab sizeToFit];
    }
    return _goLab;
}

- (UILabel *)titleLab{
    if(!_titleLab){
        _titleLab = [UILabel new];
        _titleLab.font = MEDIUM_FONT(15);
        _titleLab.text = @"抢先中";
        _titleLab.textColor = UIColor.whiteColor;
    }
    return _titleLab;
}

- (UILabel *)noticeLab{
    if(!_noticeLab){
        _noticeLab = [UILabel new];
        _noticeLab.font = FONT(12);
        _noticeLab.textColor = UIColor.whiteColor;
    }
    return _noticeLab;
}

@end
