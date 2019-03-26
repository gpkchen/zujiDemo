//
//  ZYSetCell.m
//  Apollo
//
//  Created by shaxia on 2018/5/2.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYSetCell.h"

@interface ZYSetCell ()

@property (nonatomic , strong) UILabel  *titleLabel;
@property (nonatomic , strong) UILabel  *subTitleLabel;

@end

@implementation ZYSetCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initWidget];
    }
    return self;
}

#pragma mark - initWidget
- (void) initWidget{
    self.titleLabel = [[UILabel alloc] init];
    [self.titleLabel setFont:SEMIBOLD_FONT(15)];
    [self.titleLabel setTextColor:WORD_COLOR_BLACK];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).mas_offset(15*UI_H_SCALE);
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(21*UI_H_SCALE);
    }];
    
    UIImageView *rightImageView = [[UIImageView alloc] init];
    [rightImageView setImage:[UIImage imageNamed:@"zy_basic_cell_arrow_navy"]];
    [self.contentView addSubview:rightImageView];
    [rightImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).mas_offset(-15*UI_H_SCALE);
        make.centerY.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(7*UI_H_SCALE, 11*UI_H_SCALE));
    }];
    
    self.subTitleLabel = [[UILabel alloc] init];
    [self.subTitleLabel setBackgroundColor:NAVIGATIONBAR_COLOR];
    [self.subTitleLabel setFont:FONT(15)];
    [self.subTitleLabel setTextColor:WORD_COLOR_GRAY];
    [self.contentView addSubview:self.subTitleLabel];
    [self.subTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(rightImageView.mas_left).mas_offset(-4*UI_H_SCALE);
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(21*UI_H_SCALE);
    }];

}

- (void)setDataDic:(NSDictionary *)dataDic
{
    [self.titleLabel setText:dataDic[@"title"]];
    [self.subTitleLabel setText:dataDic[@"subTitle"]];
}

@end
