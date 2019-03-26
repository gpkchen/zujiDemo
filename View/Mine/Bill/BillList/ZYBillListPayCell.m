//
//  ZYBillListPayCell.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/28.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBillListPayCell.h"

@interface ZYBillListPayCell ()

@property (nonatomic , strong) UIView *backView;

@end

@implementation ZYBillListPayCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = VIEW_COLOR;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.backView];
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
            make.top.bottom.equalTo(self.contentView);
        }];
        
        [self.backView addSubview:self.payBtn];
        [self.payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backView);
            make.left.equalTo(self.backView).mas_offset(15 * UI_H_SCALE);
            make.right.equalTo(self.backView).mas_offset(-15 * UI_H_SCALE);
            make.height.mas_equalTo(44 * UI_H_SCALE);
        }];
    }
    return self;
}

#pragma mark - getter
- (UIView *)backView{
    if(!_backView){
        _backView = [UIView new];
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}

- (ZYElasticButton *)payBtn{
    if(!_payBtn){
        _payBtn = [ZYElasticButton new];
        [_payBtn setTitle:@"支付全部账单" forState:UIControlStateNormal];
        _payBtn.shouldRound = YES;
        [_payBtn setBackgroundColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateNormal];
        [_payBtn setBackgroundColor:BTN_COLOR_HEIGHTLIGHT_GREEN forState:UIControlStateHighlighted];
        [_payBtn setBackgroundColor:BTN_COLOR_DISABLE forState:UIControlStateDisabled];
        [_payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_payBtn setTitleColor:WORD_COLOR_GRAY forState:UIControlStateDisabled];
        _payBtn.font = FONT(14);
    }
    return _payBtn;
}

@end
