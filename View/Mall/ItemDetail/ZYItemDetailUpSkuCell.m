//
//  ZYItemDetailUpSkuCell.m
//  Apollo
//
//  Created by 李明伟 on 2018/5/4.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYItemDetailUpSkuCell.h"

@interface ZYItemDetailUpSkuCell ()

@property (nonatomic , strong) UILabel *titleLab;

@end

@implementation ZYItemDetailUpSkuCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = [UIColor whiteColor];
        self.arrow.hidden = NO;
        
        [self.contentView addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(self.titleLab.size);
        }];
        
        [self.contentView addSubview:self.skuLab];
        [self.skuLab mas_makeConstraints:^(MASConstraintMaker *make) {
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
        _titleLab.text = @"选择规格";
        [_titleLab sizeToFit];
    }
    return _titleLab;
}

- (UILabel *)skuLab{
    if(!_skuLab){
        _skuLab = [UILabel new];
        _skuLab.textColor = WORD_COLOR_BLACK;
        _skuLab.font = FONT(15);
        _skuLab.text = @"请选择产品参数";
        _skuLab.textAlignment = NSTextAlignmentRight;
    }
    return _skuLab;
}

@end
