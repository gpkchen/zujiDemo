//
//  ZYUserInfoCell.m
//  Apollo
//
//  Created by shaxia on 2018/5/2.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYUserInfoCell.h"
@interface ZYUserInfoCell ()

@property (nonatomic , strong) UILabel  *titleLabel;
@property (nonatomic , strong) UILabel  *subTitleLabel;
@property (nonatomic , strong) UIImageView  *iconIamgeView;


@end
@implementation ZYUserInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initWidget];
    }
    return self;
}

#pragma mark - initWidget

- (void) initWidget
{
    
    self.titleLabel = [[UILabel alloc] init];
    [self.titleLabel setBackgroundColor:NAVIGATIONBAR_COLOR];
    [self.titleLabel setFont:FONT(15)];
    [self.titleLabel setTextColor:WORD_COLOR_BLACK];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).mas_offset(15*UI_H_SCALE);
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(21*UI_H_SCALE);
    }];
    
    self.iconIamgeView = [[UIImageView alloc] init];
    [self.iconIamgeView setBackgroundColor:VIEW_COLOR];
    [self.iconIamgeView.layer setCornerRadius:17*UI_H_SCALE];
    [self.iconIamgeView.layer setMasksToBounds:YES];
    [self.contentView addSubview:self.iconIamgeView];
    [self.iconIamgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).mas_offset(-30*UI_H_SCALE);
        make.centerY.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(34*UI_H_SCALE, 34*UI_H_SCALE));
    }];
    
    self.subTitleLabel = [[UILabel alloc] init];
    [self.subTitleLabel setBackgroundColor:NAVIGATIONBAR_COLOR];
    [self.subTitleLabel setFont:FONT(14)];
    [self.subTitleLabel setTextColor:WORD_COLOR_BLACK];
    [self.contentView addSubview:self.subTitleLabel];
    [self.subTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).mas_offset(-30*UI_H_SCALE);
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(21*UI_H_SCALE);
    }];

}

- (void)setMobile:(NSString *)mobile{
    _mobile = mobile;
    
    self.arrow.hidden = YES;
    self.subTitleLabel.text = mobile;
    [self.subTitleLabel setTextColor:HexRGB(0xABADB3)];
    [self.titleLabel setText:@"手机号码"];
    
    self.iconIamgeView.hidden = YES;
}

- (void)setAvtor:(NSString *)avtor
{
    _avtor = avtor;
    
    self.arrow.hidden = NO;
    NSString *url = [avtor imageStyleUrl:CGSizeMake(68*UI_H_SCALE, 68*UI_H_SCALE)];
    [self.iconIamgeView loadImage:url placeholder:[UIImage imageNamed:@"zy_mine_userIcon_notLogin"]];
    [self.titleLabel setText:@"头像"];
    
}

- (void)setNickname:(NSString *)nickname
{
    _nickname = nickname;
    self.arrow.hidden = NO;
    self.subTitleLabel.text = nickname;
    [self.titleLabel setText:@"昵称"];
    self.iconIamgeView.hidden = YES;
    
}


@end
