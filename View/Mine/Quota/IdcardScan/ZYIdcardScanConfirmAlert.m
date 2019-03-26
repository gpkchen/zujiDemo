//
//  ZYIdcardScanConfirmAlert.m
//  Apollo
//
//  Created by 李明伟 on 2018/7/10.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYIdcardScanConfirmAlert.h"

@interface ZYIdcardScanConfirmAlert ()<UITextFieldDelegate>

@property (nonatomic , strong) UIView *panel;
@property (nonatomic , strong) UIView *line;
@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) UILabel *nameLab;
@property (nonatomic , strong) ZYTextField *nameText;
@property (nonatomic , strong) ZYElasticButton *editBtn;
@property (nonatomic , strong) UILabel *idcardLab;
@property (nonatomic , strong) UILabel *noticeLab;
@property (nonatomic , strong) ZYElasticButton *confirmBtn;

@end

@implementation ZYIdcardScanConfirmAlert

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (instancetype)init{
    if(self = [super init]){
        [self initWidgets];
    }
    return self;
}

- (void)initWidgets{
    [self.panel addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.panel);
        make.height.mas_equalTo(0.5);
        make.bottom.equalTo(self.panel).mas_offset(-60 * UI_H_SCALE);
    }];
    
    [self.panel addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.panel);
        make.centerY.equalTo(self.panel.mas_top).mas_offset(36.5 * UI_H_SCALE);
    }];
    
    [self.panel addSubview:self.nameLab];
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.panel).mas_offset(20 * UI_H_SCALE);
        make.centerY.equalTo(self.panel.mas_top).mas_offset(75 * UI_H_SCALE);
    }];
    
    [self.panel addSubview:self.nameText];
    [self.nameText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLab.mas_right);
        make.centerY.equalTo(self.nameLab);
        make.size.mas_equalTo(CGSizeMake(90 * UI_H_SCALE, 30));
    }];
    
    [self.panel addSubview:self.editBtn];
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameText.mas_right);
        make.centerY.equalTo(self.nameLab);
        make.size.mas_equalTo(CGSizeMake(70 * UI_H_SCALE, 30));
    }];
    
    [self.panel addSubview:self.idcardLab];
    [self.idcardLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLab);
        make.centerY.equalTo(self.panel.mas_top).mas_offset(111 * UI_H_SCALE);
    }];
    
    [self.panel addSubview:self.noticeLab];
    [self.noticeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.panel);
        make.centerY.equalTo(self.panel.mas_top).mas_offset(146.5 * UI_H_SCALE);
    }];
    
    [self.panel addSubview:self.confirmBtn];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.panel);
        make.top.equalTo(self.line.mas_bottom);
    }];
    
    
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)showWithName:(NSString *)name idcard:(NSString *)idcard{
    self.nameText.text = name;
    self.idcardLab.text = [NSString stringWithFormat:@"身份证号：%@",idcard];
    [super showWithPanelView:self.panel];
}

- (void)dismiss{
    [self.nameText resignFirstResponder];
    [super dismiss];
}

#pragma mark - 监听键盘弹出
- (void)keyboardWillShown:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat bottom = self.panel.superview.bottom;
    if(endFrame.origin.y < bottom){
        self.panel.superview.bottom = endFrame.origin.y;
    }
}

#pragma mark - 监听键盘消失
- (void)keyboardWillHidden:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat bottom = self.panel.superview.bottom;
    if(endFrame.origin.y > bottom){
        self.panel.superview.bottom = bottom;
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    textField.enabled = NO;
}

#pragma mark - getter
- (NSString *)name{
    return self.nameText.text;
}

- (UIView *)panel{
    if(!_panel){
        _panel = [UIView new];
        _panel.backgroundColor = [UIColor whiteColor];
        _panel.cornerRadius = 8;
        _panel.clipsToBounds = YES;
        _panel.size = CGSizeMake(300 * UI_H_SCALE, 237 * UI_H_SCALE);
    }
    return _panel;
}

- (UIView *)line{
    if(!_line){
        _line = [UIView new];
        _line.backgroundColor = LINE_COLOR;
    }
    return _line;
}

- (UILabel *)titleLab{
    if(!_titleLab){
        _titleLab = [UILabel new];
        _titleLab.textColor = WORD_COLOR_BLACK;
        _titleLab.font = FONT(18);
        _titleLab.text = @"请确认你的身份证信息";
    }
    return _titleLab;
}

- (UILabel *)nameLab{
    if(!_nameLab){
        _nameLab = [UILabel new];
        _nameLab.textColor = WORD_COLOR_BLACK;
        _nameLab.font = FONT(16);
        _nameLab.text = @"姓名：";
    }
    return _nameLab;
}

- (ZYTextField *)nameText{
    if(!_nameText){
        _nameText = [ZYTextField new];
        _nameText.textColor = WORD_COLOR_BLACK;
        _nameText.font = FONT(16);
        _nameText.backgroundColor = UIColor.whiteColor;
        _nameText.enabled = NO;
        _nameText.delegate = self;
    }
    return _nameText;
}

- (ZYElasticButton *)editBtn{
    if(!_editBtn){
        _editBtn = [ZYElasticButton new];
        _editBtn.backgroundColor = [UIColor whiteColor];
        _editBtn.font = FONT(12);
        [_editBtn setTitle:@"修改" forState:UIControlStateNormal];
        [_editBtn setTitleColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateNormal];
        [_editBtn setTitleColor:BTN_COLOR_HEIGHTLIGHT_GREEN forState:UIControlStateHighlighted];
        
        __weak __typeof__(self) weakSelf = self;
        [_editBtn clickAction:^(UIButton * _Nonnull button) {
            weakSelf.nameText.enabled = YES;
            [weakSelf.nameText becomeFirstResponder];
        }];
    }
    return _editBtn;
}

- (UILabel *)idcardLab{
    if(!_idcardLab){
        _idcardLab = [UILabel new];
        _idcardLab.textColor = WORD_COLOR_GRAY;
        _idcardLab.font = FONT(15);
    }
    return _idcardLab;
}

- (UILabel *)noticeLab{
    if(!_noticeLab){
        _noticeLab = [UILabel new];
        _noticeLab.textColor = WORD_COLOR_GRAY;
        _noticeLab.font = FONT(12);
        _noticeLab.text = @"（为避免影响租机体验，请务必填写真实信息）";
    }
    return _noticeLab;
}

- (ZYElasticButton *)confirmBtn{
    if(!_confirmBtn){
        _confirmBtn = [ZYElasticButton new];
        _confirmBtn.backgroundColor = UIColor.whiteColor;
        [_confirmBtn setTitle:@"我已确认无误" forState:UIControlStateNormal];
        _confirmBtn.font = FONT(15);
        [_confirmBtn setTitleColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:BTN_COLOR_HEIGHTLIGHT_GREEN forState:UIControlStateHighlighted];
        
        __weak __typeof__(self) weakSelf = self;
        [_confirmBtn clickAction:^(UIButton * _Nonnull button) {
            [weakSelf.nameText resignFirstResponder];
            !weakSelf.confirmAction ? : weakSelf.confirmAction(weakSelf.nameText.text);
            [weakSelf dismiss];
        }];
    }
    return _confirmBtn;
}

@end
