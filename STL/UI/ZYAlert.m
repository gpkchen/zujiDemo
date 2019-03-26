//
//  ZYAlert.m
//  Apollo
//
//  Created by 李明伟 on 2018/5/9.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYAlert.h"

@interface ZYAlert ()

@property (nonatomic , strong) UIView *alert;
@property (nonatomic , strong) UIView *line;
@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) UILabel *contentLab;
@property (nonatomic , strong) ZYElasticButton *leftBtn;
@property (nonatomic , strong) ZYElasticButton *rightBtn;

@end

@implementation ZYAlert

- (instancetype)init{
    if(self = [super init]){
        [self initWidgets];
    }
    return self;
}

- (void)initWidgets{
    self.shouldTapToDissmiss = NO;
    
    self.alert.size = CGSizeMake(300 * UI_H_SCALE, 156 * UI_H_SCALE);
    
    [self.alert addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.alert);
        make.bottom.equalTo(self.alert).mas_offset(-58 * UI_H_SCALE);
        make.height.mas_equalTo(1);
    }];
    
    [self.alert addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.alert).mas_offset(15 * UI_H_SCALE);
        make.right.equalTo(self.alert).mas_offset(-15 * UI_H_SCALE);
        make.centerY.equalTo(self.alert.mas_top).mas_offset(40.5 * UI_H_SCALE);
    }];
    
    [self.alert addSubview:self.contentLab];
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.alert).mas_offset(15 * UI_H_SCALE);
        make.right.equalTo(self.alert).mas_offset(-15 * UI_H_SCALE);
        make.top.equalTo(self.alert).mas_offset(40 * UI_H_SCALE);
    }];
    
    [self.alert addSubview:self.leftBtn];
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.alert);
        make.top.equalTo(self.line.mas_bottom);
        make.right.equalTo(self.alert.mas_centerX);
    }];
    
    [self.alert addSubview:self.rightBtn];
}

#pragma mark - getter
- (UIView *)alert{
    if(!_alert){
        _alert = [UIView new];
        _alert.backgroundColor = [UIColor whiteColor];
        _alert.clipsToBounds = YES;
        _alert.cornerRadius = 5;
    }
    return _alert;
}

- (UIView *)line{
    if(!_line){
        _line = [UIView new];
        _line.backgroundColor = HexRGB(0xE8EAED);
    }
    return _line;
}

- (UILabel *)titleLab{
    if(!_titleLab){
        _titleLab = [UILabel new];
        _titleLab.textColor = WORD_COLOR_BLACK;
        _titleLab.font = FONT(18);
        _titleLab.hidden = YES;
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

- (UILabel *)contentLab{
    if(!_contentLab){
        _contentLab = [UILabel new];
        _contentLab.textColor = WORD_COLOR_BLACK;
        _contentLab.font = FONT(16);
        _contentLab.numberOfLines = 0;
        _contentLab.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
        _contentLab.textAlignment = NSTextAlignmentCenter;
    }
    return _contentLab;
}

- (ZYElasticButton *)leftBtn{
    if(!_leftBtn){
        _leftBtn = [ZYElasticButton new];
        _leftBtn.backgroundColor = [UIColor whiteColor];
        _leftBtn.font = FONT(16);
        [_leftBtn setTitleColor:HexRGB(0xABADB3) forState:UIControlStateNormal];
        [_leftBtn setTitleColor:HexRGB(0xABADB3) forState:UIControlStateHighlighted];
    }
    return _leftBtn;
}

- (ZYElasticButton *)rightBtn{
    if(!_rightBtn){
        _rightBtn = [ZYElasticButton new];
        _rightBtn.backgroundColor = [UIColor whiteColor];
        _rightBtn.font = FONT(16);
        [_rightBtn setTitleColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateNormal];
        [_rightBtn setTitleColor:BTN_COLOR_HEIGHTLIGHT_GREEN forState:UIControlStateHighlighted];
    }
    return _rightBtn;
}

#pragma mark - 静态方法
+ (ZYAlert *)showWithTitle:(NSString *)title
                   content:(NSString *)content
              buttonTitles:(NSArray *)titles
              buttonAction:(ZYAlertButtonAction)action{
    ZYAlert *alertView = [ZYAlert new];
    
    if(title.length){
        alertView.titleLab.hidden = NO;
        alertView.titleLab.text = title;
        
        CGFloat contentHeight = [content boundingRectWithSize:CGSizeMake(315 * UI_H_SCALE, CGFLOAT_MAX)
                                                      options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName:FONT(14)}
                                                      context:nil].size.height;
        alertView.contentLab.font = FONT(14);
        alertView.alert.size = CGSizeMake(345 * UI_H_SCALE, contentHeight + 110 * UI_H_SCALE + 58 * UI_H_SCALE);
        
        [alertView.contentLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(alertView.alert).mas_offset(80 * UI_H_SCALE);
        }];
    }else{
        alertView.titleLab.hidden = YES;
        
        CGFloat contentHeight = [content boundingRectWithSize:CGSizeMake(270 * UI_H_SCALE, CGFLOAT_MAX)
                                                      options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName:FONT(16)}
                                                      context:nil].size.height;
        alertView.contentLab.font = FONT(16);
        alertView.alert.size = CGSizeMake(300 * UI_H_SCALE, contentHeight + 80 * UI_H_SCALE + 58 * UI_H_SCALE);
        
        [alertView.contentLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(alertView.alert).mas_offset(40 * UI_H_SCALE);
        }];
    }
    
    __weak __typeof__(alertView) weakAlert = alertView;
    alertView.contentLab.text = content;
    if(titles.count == 1){
        alertView.leftBtn.hidden = YES;
        [alertView.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(alertView.alert);
            make.top.equalTo(alertView.line.mas_bottom);
        }];
        if(titles.count){
            [alertView.rightBtn setTitle:titles[0] forState:UIControlStateNormal];
            [alertView.rightBtn clickAction:^(UIButton * _Nonnull button) {
                !action ? : action(weakAlert,0);
            }];
        }
    }else if(titles.count >= 2){
        alertView.leftBtn.hidden = NO;
        [alertView.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.equalTo(alertView.alert);
            make.top.equalTo(alertView.line.mas_bottom);
            make.left.mas_equalTo(alertView.leftBtn.mas_right);
        }];
        if(titles.count){
            [alertView.leftBtn setTitle:titles[0] forState:UIControlStateNormal];
            [alertView.leftBtn clickAction:^(UIButton * _Nonnull button) {
                !action ? : action(weakAlert,0);
            }];
        }
        if(titles.count >= 2){
            [alertView.rightBtn setTitle:titles[1] forState:UIControlStateNormal];
            [alertView.rightBtn clickAction:^(UIButton * _Nonnull button) {
                !action ? : action(weakAlert,1);
            }];
        }
    }
    [alertView showWithPanelView:alertView.alert];
    return alertView;
}

@end
