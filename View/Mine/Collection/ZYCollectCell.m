//
//  ZYCollectCell.m
//  Apollo
//
//  Created by 李明伟 on 2018/11/22.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import "ZYCollectCell.h"
#import "FavoriteList.h"

@interface ZYCollectCell()

@property (nonatomic , strong) UIImageView *picIV;
@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) UILabel *priceLab;
@property (nonatomic , strong) UIImageView *unavailableIV;
@property (nonatomic , strong) UILabel *unavailableLab;

@end

@implementation ZYCollectCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithReuseIdentifier:reuseIdentifier]){
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        self.multipleSelectionBackgroundView = [UIView new];
        self.backgroundColor = UIColor.whiteColor;
        self.tintColor = MAIN_COLOR_GREEN;
        UIView *view = [UIView new];
        view.backgroundColor = UIColor.whiteColor;
        self.selectedBackgroundView = view;
        
        [self.contentView addSubview:self.picIV];
        [self.picIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.width.mas_equalTo(105 * UI_H_SCALE);
            make.top.bottom.equalTo(self.contentView);
        }];
        
        [self.contentView addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.picIV.mas_right).mas_offset(15 * UI_H_SCALE);
            make.top.equalTo(self.picIV).mas_offset(5 * UI_H_SCALE);
            make.right.equalTo(self.contentView.mas_left).mas_offset(361 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.priceLab];
        [self.priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.picIV.mas_right).mas_offset(15 * UI_H_SCALE);
            make.centerY.equalTo(self.self.picIV.mas_bottom).mas_offset(-16 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.unavailableIV];
        [self.unavailableIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(270 * UI_H_SCALE);
            make.centerY.equalTo(self.priceLab);
            make.size.mas_equalTo(CGSizeMake(90 * UI_H_SCALE, 32 * UI_H_SCALE));
        }];
        
        [self.contentView addSubview:self.unavailableLab];
        [self.unavailableLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(270 * UI_H_SCALE);
            make.centerY.equalTo(self.priceLab);
            make.size.mas_equalTo(CGSizeMake(90 * UI_H_SCALE, 32 * UI_H_SCALE));
        }];
    }
    return self;
}

- (void)showCellWithModel:(_m_FavoriteList *)model{
    NSString *url = [model.itemPic imageStyleUrl:CGSizeMake(210 * UI_H_SCALE, 210 * UI_H_SCALE)];
    [self.picIV loadImage:url];
    self.titleLab.text = model.itemName;
    if(model.itemPri.length){
        NSMutableAttributedString *price = [[NSMutableAttributedString alloc] initWithString:model.itemPri];
        if([model.itemPri hasPrefix:@"￥"]){
            [price addAttribute:NSFontAttributeName value:FONT(12) range:NSMakeRange(0, 1)];
        }
        NSRange range = [model.itemPri rangeOfString:@"/"];
        if(range.location != NSNotFound){
            [price addAttribute:NSFontAttributeName value:FONT(15) range:NSMakeRange(range.location, price.length - range.location)];
        }
        self.priceLab.attributedText = price;
    }
    if([@"1" isEqualToString:model.itemState]){
        self.unavailableLab.hidden = NO;
        self.unavailableIV.hidden = NO;
    }else{
        self.unavailableLab.hidden = YES;
        self.unavailableIV.hidden = YES;
    }
}

#pragma mark - getter
- (UIImageView *)picIV{
    if(!_picIV){
        _picIV = [UIImageView new];
        _picIV.contentMode = UIViewContentModeScaleAspectFill;
        _picIV.clipsToBounds = YES;
    }
    return _picIV;
}

- (UILabel *)titleLab{
    if(!_titleLab){
        _titleLab = [UILabel new];
        _titleLab.font = FONT(15);
        _titleLab.textColor = WORD_COLOR_BLACK;
        _titleLab.numberOfLines = 2;
        _titleLab.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
    }
    return _titleLab;
}

- (UILabel *)priceLab{
    if(!_priceLab){
        _priceLab = [UILabel new];
        _priceLab.textColor = WORD_COLOR_ORANGE;
        _priceLab.font = SEMIBOLD_FONT(18);
    }
    return _priceLab;
}

- (UILabel *)unavailableLab{
    if(!_unavailableLab){
        _unavailableLab = [UILabel new];
        _unavailableLab.font = FONT(14);
        _unavailableLab.text = @"已下架";
        _unavailableLab.textColor = WORD_COLOR_GRAY_9B;
        _unavailableLab.textAlignment = NSTextAlignmentCenter;
    }
    return _unavailableLab;
}

- (UIImageView *)unavailableIV{
    if(!_unavailableIV){
        _unavailableIV = [UIImageView new];
        _unavailableIV.image = [UIImage imageWithColor:VIEW_COLOR];
    }
    return _unavailableIV;
}

@end
