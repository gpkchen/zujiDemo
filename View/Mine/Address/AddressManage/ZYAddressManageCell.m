//
//  ZYAddressManageCell.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/25.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYAddressManageCell.h"

@interface ZYAddressManageCell ()

@property (nonatomic , strong) UILabel *nameLab;
@property (nonatomic , strong) UILabel *mobileLab;
@property (nonatomic , strong) UILabel *addressLab;
@property (nonatomic , strong) UIView *line;

@end

@implementation ZYAddressManageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.nameLab];
        [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView.mas_top).mas_offset(28.5 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.mobileLab];
        [self.mobileLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLab.mas_right).mas_offset(15 * UI_H_SCALE);
            make.right.lessThanOrEqualTo(self.contentView.mas_right).mas_offset(-15 * UI_H_SCALE);
            make.centerY.equalTo(self.nameLab);
        }];
        
        [self.contentView addSubview:self.addressLab];
        [self.addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView.mas_top).mas_offset(66 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.line];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
            make.bottom.equalTo(self.contentView).mas_offset(-50 * UI_H_SCALE);
            make.height.mas_equalTo(LINE_HEIGHT);
        }];
        
        [self.contentView addSubview:self.defaultBtn];
        
        [self.contentView addSubview:self.deleteBtn];
        [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.line);
            make.top.equalTo(self.line.mas_bottom);
            make.bottom.equalTo(self.contentView);
            make.width.mas_equalTo(self.deleteBtn.width);
        }];
        
        [self.contentView addSubview:self.editBtn];
        [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.deleteBtn.mas_left).mas_offset(-30 * UI_H_SCALE);
            make.top.equalTo(self.line.mas_bottom);
            make.bottom.equalTo(self.contentView);
            make.width.mas_equalTo(self.editBtn.width);
        }];
    }
    return self;
}

- (void)showCellWithModel:(_m_AddressList *)model{
    self.nameLab.text = model.contact;
    self.mobileLab.text = model.mobile;
    NSString *address = @"";
    if(model.provinceName){
        address = [address stringByAppendingString:model.provinceName];
    }
    if(model.cityName){
        address = [address stringByAppendingString:model.cityName];
    }
    if(model.districtName){
        address = [address stringByAppendingString:model.districtName];
    }
    if(model.address){
        address = [address stringByAppendingString:model.address];
    }
    self.addressLab.text = address;
    if(model.isDefault){
        self.defaultBtn.image = [UIImage imageNamed:@"zy_address_default_icon"];
        self.defaultBtn.title = @"默认地址";
    }else{
        self.defaultBtn.image = [UIImage imageNamed:@"zy_address_notdefault_icon"];
        self.defaultBtn.title = @"设为默认地址";
    }
    [self.defaultBtn sizeToFit];
    [self.defaultBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.line);
        make.top.equalTo(self.line.mas_bottom);
        make.bottom.equalTo(self.contentView);
        make.width.mas_equalTo(self.defaultBtn.width);
    }];
}

#pragma mark - getter
- (UILabel *)nameLab{
    if(!_nameLab){
        _nameLab = [UILabel new];
        _nameLab.textColor = WORD_COLOR_BLACK;
        _nameLab.font = MEDIUM_FONT(18);
    }
    return _nameLab;
}

- (UILabel *)mobileLab{
    if(!_mobileLab){
        _mobileLab = [UILabel new];
        _mobileLab.textColor = WORD_COLOR_BLACK;
        _mobileLab.font = MEDIUM_FONT(18);
    }
    return _mobileLab;
}

- (UILabel *)addressLab{
    if(!_addressLab){
        _addressLab = [UILabel new];
        _addressLab.textColor = WORD_COLOR_BLACK;
        _addressLab.font = FONT(14);
        _addressLab.numberOfLines = 2;
        _addressLab.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _addressLab;
}

- (UIView *)line{
    if(!_line){
        _line = [UIView new];
        _line.backgroundColor = LINE_COLOR;
    }
    return _line;
}

- (ZYImageTitleButton *)defaultBtn{
    if(!_defaultBtn){
        _defaultBtn = [ZYImageTitleButton new];
        _defaultBtn.backgroundColor = [UIColor whiteColor];
        _defaultBtn.titleFont = FONT(14);
        _defaultBtn.titleColor = WORD_COLOR_GRAY;
        _defaultBtn.spacing = 5;
    }
    return _defaultBtn;
}

- (ZYImageTitleButton *)deleteBtn{
    if(!_deleteBtn){
        _deleteBtn = [ZYImageTitleButton new];
        _deleteBtn.backgroundColor = [UIColor whiteColor];
        _deleteBtn.title = @"删除";
        _deleteBtn.titleColor = WORD_COLOR_GRAY;
        _deleteBtn.titleFont = FONT(14);
        _deleteBtn.spacing = 5;
        _deleteBtn.image = [UIImage imageNamed:@"zy_address_delete_icon"];
        [_deleteBtn sizeToFit];
    }
    return _deleteBtn;
}

- (ZYImageTitleButton *)editBtn{
    if(!_editBtn){
        _editBtn = [ZYImageTitleButton new];
        _editBtn.backgroundColor = [UIColor whiteColor];
        _editBtn.title = @"编辑";
        _editBtn.titleColor = WORD_COLOR_GRAY;
        _editBtn.titleFont = FONT(14);
        _editBtn.spacing = 5;
        _editBtn.image = [UIImage imageNamed:@"zy_address_edit_icon"];
        [_editBtn sizeToFit];
    }
    return _editBtn;
}

@end
