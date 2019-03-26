//
//  ZYItemDetailUpTitleCell.m
//  Apollo
//
//  Created by 李明伟 on 2018/5/3.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYItemDetailUpTitleCell.h"
#import "ItemDetail.h"

@interface ZYItemDetailUpTitleCell()

@property (nonatomic , strong) UILabel *titleLab; //标题
@property (nonatomic , strong) UILabel *priceLab; //价格
@property (nonatomic , strong) UILabel *oriPriceLab; //原价
@property (nonatomic , strong) UILabel *depositLab; //押金
@property (nonatomic , strong) UILabel *ownedDepositLab; //已减免押金

@property (nonatomic , strong) NSMutableArray *activityDiscountLabs; //记录上一次绘制的活动的优惠列表

@property (nonatomic , strong) _m_ItemDetail *model;

@end

@implementation ZYItemDetailUpTitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.priceLab];
        [self.priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView.mas_top).mas_offset(25.5 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.oriPriceLab];
        [self.oriPriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.priceLab.mas_right).mas_offset(10 * UI_H_SCALE);
            make.bottom.equalTo(self.priceLab).mas_offset(-3);
        }];
        
        [self.contentView addSubview:self.shareBtn];
        [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).mas_offset(32 * UI_H_SCALE);
            make.right.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(24 + 30 * UI_H_SCALE, 24 + 30 * UI_H_SCALE));
        }];
        
        [self.contentView addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.top.equalTo(self.contentView).mas_offset(47 * UI_H_SCALE);
            make.right.equalTo(self.contentView).mas_offset(-80 * UI_H_SCALE);
        }];
        
        [self.contentView addSubview:self.ownedDepositLab];
        [self.ownedDepositLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLab.mas_bottom).mas_offset(20 * UI_H_SCALE);
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.size.mas_equalTo(CGSizeMake(0, 0));
        }];
        
        [self.contentView addSubview:self.depositBtn];
        [self.depositBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLab.mas_bottom).mas_offset(20 * UI_H_SCALE);
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.size.mas_equalTo(CGSizeMake(90 * UI_H_SCALE, 25 * UI_H_SCALE));
        }];
        
        [self.contentView addSubview:self.depositLab];
    }
    return self;
}

- (void)showCellWithModel:(_m_ItemDetail *)model{
    _model = model;
    
    self.titleLab.text = model.title;
    
    NSMutableAttributedString *price = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%.2f/%@起",model.price,model.unit]];
    [price addAttribute:NSFontAttributeName value:SEMIBOLD_FONT(18) range:NSMakeRange(0, 1)];
    [price addAttribute:NSFontAttributeName value:SEMIBOLD_FONT(14) range:NSMakeRange(price.length - model.unit.length - 2, model.unit.length + 2)];
    self.priceLab.attributedText = price;
    
    NSMutableAttributedString *oriPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"市场价：%.2f",model.marketPrice]];
    [oriPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0, oriPrice.length)];
    self.oriPriceLab.attributedText = oriPrice;
    
    self.depositLab.text = [NSString stringWithFormat:@"押金￥%.2f",model.deposit];
    
    if([ZYUser user].isUserLogined){
        if(model.surplusLimit){
            self.depositBtn.hidden = YES;
            self.ownedDepositLab.hidden = NO;
            if(model.deposit < model.surplusLimit){
                self.ownedDepositLab.text = [NSString stringWithFormat:@"可减免%.2f",model.deposit];
            }else{
                self.ownedDepositLab.text = [NSString stringWithFormat:@"可减免%.2f",model.surplusLimit];
            }
            [self.ownedDepositLab sizeToFit];
            [self.ownedDepositLab mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(self.ownedDepositLab.width + 12, 25 * UI_H_SCALE));
            }];
            
            [self.depositLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.ownedDepositLab.mas_right).mas_offset(10 * UI_H_SCALE);
                make.centerY.equalTo(self.ownedDepositLab);
            }];
        }else if([[NSString stringWithFormat:@"%d",ZYAuthStateUnAuth] isEqualToString:model.authStatus]){
            self.depositBtn.hidden = NO;
            self.ownedDepositLab.hidden = YES;
            
            [self.depositLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.depositBtn.mas_right).mas_offset(10 * UI_H_SCALE);
                make.centerY.equalTo(self.depositBtn);
            }];
        }else{
            self.depositBtn.hidden = YES;
            self.ownedDepositLab.hidden = YES;
            
            [self.depositLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
                make.centerY.equalTo(self.titleLab.mas_bottom).mas_offset(20 * UI_H_SCALE);
            }];
        }
    }
    
    for(UILabel *label in self.activityDiscountLabs){
        [label removeFromSuperview];
    }
    [self.activityDiscountLabs removeAllObjects];
    
    CGFloat x = 15 * UI_H_SCALE;
    CGFloat y = 45 * UI_H_SCALE;
    for(int i=0;i<model.activityDiscountList.count;++i){
        NSDictionary *dic = model.activityDiscountList[i];
        UILabel *label = [self activityDiscountLab];
        label.text = dic[@"name"];
        [label sizeToFit];
        label.size = CGSizeMake(label.width + 20 * UI_H_SCALE, label.height + 8 * UI_H_SCALE);
        if(x + label.width > SCREEN_WIDTH - 15 * UI_H_SCALE){
            y += label.height + 10 * UI_H_SCALE;
            x = 15 * UI_H_SCALE;
        }
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(x);
            make.top.equalTo(self.titleLab.mas_bottom).mas_offset(y);
            make.size.mas_equalTo(label.size);
        }];
        x += label.size.width + 10 * UI_H_SCALE;
        
        [self.activityDiscountLabs addObject:label];
    }
}

#pragma mark - getter
- (ZYElasticButton *)shareBtn{
    if(!_shareBtn){
        _shareBtn = [ZYElasticButton new];
        _shareBtn.backgroundColor = [UIColor whiteColor];
        [_shareBtn setImage:[UIImage imageNamed:@"zy_item_detail_share_icon"] forState:UIControlStateNormal];
        [_shareBtn setImage:[UIImage imageNamed:@"zy_item_detail_share_icon"] forState:UIControlStateHighlighted];
    }
    return _shareBtn;
}

- (UILabel *)titleLab{
    if(!_titleLab){
        _titleLab = [UILabel new];
        _titleLab.textColor = WORD_COLOR_BLACK;
        _titleLab.font = MEDIUM_FONT(18);
        _titleLab.numberOfLines = 2;
        _titleLab.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
    }
    return _titleLab;
}

- (UILabel *)priceLab{
    if(!_priceLab){
        _priceLab = [UILabel new];
        _priceLab.textColor = WORD_COLOR_ORANGE;
        _priceLab.font = MEDIUM_FONT(24);
    }
    return _priceLab;
}

- (UILabel *)oriPriceLab{
    if(!_oriPriceLab){
        _oriPriceLab = [UILabel new];
        _oriPriceLab.textColor = HexRGB(0xD2D3D6);
        _oriPriceLab.font = FONT(15);
    }
    return _oriPriceLab;
}

- (UILabel *)depositLab{
    if(!_depositLab){
        _depositLab = [UILabel new];
        _depositLab.textColor = WORD_COLOR_BLACK;
        _depositLab.font = FONT(14);
    }
    return _depositLab;
}

- (ZYElasticButton *)depositBtn{
    if(!_depositBtn){
        _depositBtn = [ZYElasticButton new];
        _depositBtn.cornerRadius = 2;
        _depositBtn.borderColor = BTN_COLOR_NORMAL_GREEN;
        _depositBtn.borderWidth = 1;
        [_depositBtn setTitle:@"申请免押金" forState:UIControlStateNormal];
        _depositBtn.font = FONT(12);
        [_depositBtn setTitleColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateNormal];
        [_depositBtn setTitleColor:BTN_COLOR_HEIGHTLIGHT_GREEN forState:UIControlStateHighlighted];
    }
    return _depositBtn;
}

- (UILabel *)ownedDepositLab{
    if(!_ownedDepositLab){
        _ownedDepositLab = [UILabel new];
        _ownedDepositLab.textColor = MAIN_COLOR_GREEN;
        _ownedDepositLab.font = FONT(12);
        _ownedDepositLab.backgroundColor = UIColor.whiteColor;
        _ownedDepositLab.textAlignment = NSTextAlignmentCenter;
        _ownedDepositLab.borderColor = MAIN_COLOR_GREEN;
        _ownedDepositLab.borderWidth = 1;
        _ownedDepositLab.cornerRadius = 2;
    }
    return _ownedDepositLab;
}

- (NSMutableArray *)activityDiscountLabs{
    if(!_activityDiscountLabs){
        _activityDiscountLabs = [NSMutableArray array];
    }
    return _activityDiscountLabs;
}

- (UILabel *)activityDiscountLab{
    UILabel *lab = [UILabel new];
    lab.textColor = WORD_COLOR_ORANGE;
    lab.font = FONT(12);
    lab.backgroundColor = HexRGB(0xFFEBDF);
    lab.clipsToBounds = YES;
    lab.textAlignment = NSTextAlignmentCenter;
    lab.cornerRadius = 2;
    return lab;
}

@end
