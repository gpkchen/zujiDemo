//
//  ZYOrderConfirmFooter.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/24.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYOrderConfirmFooter.h"

@interface ZYOrderConfirmFooter ()

@property (nonatomic , strong) UILabel *agreeLab;

@end

@implementation ZYOrderConfirmFooter

- (instancetype)init{
    if(self = [super init]){
        [self initWidgets];
    }
    return self;
}

- (void)initWidgets{
    [self addSubview:self.protocolCB];
    [self.protocolCB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_top).mas_offset(20);
        make.left.equalTo(self).mas_offset(10 * UI_H_SCALE);
        make.size.mas_equalTo(CGSizeMake(12 + 10 * UI_H_SCALE, 12 + 10 * UI_H_SCALE));
    }];
    
    [self addSubview:self.agreeLab];
    [self.agreeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.protocolCB.mas_right);
        make.centerY.equalTo(self.protocolCB);
    }];
    
    [self addSubview:self.protocolLab];
    [self.protocolLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.agreeLab.mas_right);
        make.centerY.equalTo(self.agreeLab);
    }];
}

#pragma mark - getter
- (ZYCheckBox *)protocolCB{
    if(!_protocolCB){
        _protocolCB = [[ZYCheckBox alloc] initWithNormalImage:[UIImage imageNamed:@"zy_cb_normal"]
                                                selectedImage:[UIImage imageNamed:@"zy_cb_selected"]];
    }
    return _protocolCB;
}

- (UILabel *)agreeLab{
    if(!_agreeLab){
        _agreeLab = [UILabel new];
        _agreeLab.textColor = WORD_COLOR_GRAY;
        _agreeLab.font = FONT(14);
        _agreeLab.text = @"我已阅读并同意";
        _agreeLab.userInteractionEnabled = YES;
        __weak __typeof__(self) weakSelf = self;
        [_agreeLab tapped:^(UITapGestureRecognizer *gesture) {
            weakSelf.protocolCB.selected = !weakSelf.protocolCB.isSelected;
        } delegate:nil];
    }
    return _agreeLab;
}

- (UILabel *)protocolLab{
    if(!_protocolLab){
        _protocolLab = [UILabel new];
        _protocolLab.text = @"《机有用户租赁服务协议》";
        _protocolLab.textColor = HexRGB(0xFF9547);
        _protocolLab.font = FONT(14);
        _protocolLab.userInteractionEnabled = YES;
    }
    return _protocolLab;
}

@end
