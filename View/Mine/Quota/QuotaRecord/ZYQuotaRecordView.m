//
//  ZYQuotaRecordView.m
//  Apollo
//
//  Created by 李明伟 on 2018/10/31.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import "ZYQuotaRecordView.h"

@interface ZYQuotaRecordView ()

@property (nonatomic , strong) UILabel *authAmountLab; //认证额度
@property (nonatomic , strong) UILabel *creditAmountLab; //信用额度

@end

@implementation ZYQuotaRecordView

- (instancetype)init{
    if(self = [super init]){
        self.backgroundColor = VIEW_COLOR;
        
        [self addSubview:self.amountBack];
        [self.amountBack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self).mas_offset(NAVIGATION_BAR_HEIGHT);
            make.height.mas_equalTo(50 * UI_H_SCALE);
        }];
        
        [self.amountBack addSubview:self.authAmountLab];
        [self.authAmountLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.amountBack).mas_offset(15 * UI_H_SCALE);
            make.centerY.equalTo(self.amountBack);
        }];
        
        [self.amountBack addSubview:self.creditAmountLab];
        [self.creditAmountLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.amountBack).mas_offset(-15 * UI_H_SCALE);
            make.centerY.equalTo(self.amountBack);
            make.left.greaterThanOrEqualTo(self.authAmountLab.mas_right).mas_offset(15 * UI_H_SCALE);
        }];
        
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.top.equalTo(self.amountBack.mas_bottom);
        }];
        
        self.authAmount = 0;
        self.creditAmount = 0;
    }
    return self;
}

#pragma mark - setter
- (void)setAuthAmount:(double)authAmount{
    _authAmount = authAmount;
    
    NSString *amount = [NSString stringWithFormat:@"免押额度：%.2f",authAmount];
    NSMutableAttributedString *amountAtt = [[NSMutableAttributedString alloc] initWithString:amount];
    [amountAtt addAttribute:NSFontAttributeName value:FONT(14) range:NSMakeRange(0, 5)];
    [amountAtt addAttribute:NSForegroundColorAttributeName value:WORD_COLOR_GRAY_9B range:NSMakeRange(0, 5)];
    self.authAmountLab.attributedText = amountAtt;
}

- (void)setCreditAmount:(double)creditAmount{
    _creditAmount = creditAmount;
    
    NSString *amount = [NSString stringWithFormat:@"可用额度：%.2f",creditAmount];
    NSMutableAttributedString *amountAtt = [[NSMutableAttributedString alloc] initWithString:amount];
    [amountAtt addAttribute:NSFontAttributeName value:FONT(14) range:NSMakeRange(0, 5)];
    [amountAtt addAttribute:NSForegroundColorAttributeName value:WORD_COLOR_GRAY_9B range:NSMakeRange(0, 5)];
    self.creditAmountLab.attributedText = amountAtt;
}

#pragma mark - getter
- (UIView *)amountBack{
    if(!_amountBack){
        _amountBack = [UIView new];
        _amountBack.backgroundColor = UIColor.whiteColor;
    }
    return _amountBack;
}

- (UILabel *)authAmountLab{
    if(!_authAmountLab){
        _authAmountLab = [UILabel new];
        _authAmountLab.textColor = MAIN_COLOR_GREEN;
        _authAmountLab.font = SEMIBOLD_FONT(18);
    }
    return _authAmountLab;
}

- (UILabel *)creditAmountLab{
    if(!_creditAmountLab){
        _creditAmountLab = [UILabel new];
        _creditAmountLab.textColor = MAIN_COLOR_GREEN;
        _creditAmountLab.font = SEMIBOLD_FONT(18);
    }
    return _creditAmountLab;
}

- (ZYElasticButton *)instructionBtn{
    if(!_instructionBtn){
        _instructionBtn = [ZYElasticButton new];
        _instructionBtn.shouldAnimate = NO;
        _instructionBtn.backgroundColor = UIColor.whiteColor;
        [_instructionBtn setTitle:@"额度说明" forState:UIControlStateNormal];
        [_instructionBtn setTitleColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateNormal];
        [_instructionBtn setTitleColor:BTN_COLOR_HEIGHTLIGHT_GREEN forState:UIControlStateHighlighted];
        _instructionBtn.font = FONT(14);
        [_instructionBtn sizeToFit];
        _instructionBtn.size = CGSizeMake(_instructionBtn.width, NAVIGATION_BAR_HEIGHT - STATUSBAR_HEIGHT);
    }
    return _instructionBtn;
}

#pragma mark - getter
- (ZYTableView *)tableView{
    if(!_tableView){
        _tableView = [[ZYTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = VIEW_COLOR;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, DOWN_DANGER_HEIGHT, 0);
        _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, DOWN_DANGER_HEIGHT, 0);
    }
    return _tableView;
}

@end
