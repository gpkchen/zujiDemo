//
//  ZYExpressCodeInput.m
//  Apollo
//
//  Created by 李明伟 on 2018/11/7.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import "ZYExpressCodeInput.h"

@interface ZYExpressCodeInput()

@property (nonatomic , strong) UIView *backView;
@property (nonatomic , strong) UIView *panel;
@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) ZYElasticButton *closeBtn;
@property (nonatomic , strong) ZYTextField *codeText;
@property (nonatomic , strong) UIView *line;
@property (nonatomic , strong) ZYElasticButton *saveBtn;

@end

@implementation ZYExpressCodeInput

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
        self.backgroundColor = UIColor.clearColor;
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH , SCREEN_HEIGHT);
        
        [self addSubview:self.backView];
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self addSubview:self.panel];
        
        [self.panel addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.panel);
            make.height.mas_equalTo(56 * UI_H_SCALE);
        }];
        
        [self.panel addSubview:self.closeBtn];
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(self.titleLab);
            make.width.mas_equalTo(30 + 30 * UI_H_SCALE);
        }];
        
        [self.panel addSubview:self.codeText];
        [self.codeText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.panel).mas_offset(15 * UI_H_SCALE);
            make.right.equalTo(self.panel).mas_offset(-15 * UI_H_SCALE);
            make.top.equalTo(self.titleLab.mas_bottom);
            make.height.mas_equalTo(50 * UI_H_SCALE);
        }];
        
        [self.panel addSubview:self.line];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.codeText);
            make.top.equalTo(self.codeText.mas_bottom);
            make.height.mas_equalTo(1);
        }];
        
        [self.panel addSubview:self.saveBtn];
        [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.panel).mas_offset(15 * UI_H_SCALE);
            make.right.equalTo(self.panel).mas_offset(-15 * UI_H_SCALE);
            make.bottom.equalTo(self.panel).mas_offset(-37 * UI_H_SCALE);
            make.height.mas_equalTo(50 * UI_H_SCALE);
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
    return self;
}

#pragma mark - 监听键盘弹出
- (void)keyboardWillShown:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat bottom = self.panel.bottom;
    if(endFrame.origin.y < bottom){
        self.panel.bottom = endFrame.origin.y;
    }
}

#pragma mark - 监听键盘消失
- (void)keyboardWillHidden:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat bottom = self.panel.bottom;
    if(endFrame.origin.y > bottom){
        self.panel.bottom = endFrame.origin.y;
    }
}

#pragma mark - public
- (void)show{
    self.backView.alpha = 0;
    self.panel.alpha = 0;
    [SCREEN addSubview:self];
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.backView.alpha = 1;
                         self.panel.alpha = 1;
                     } completion:^(BOOL finished){
                         
                     }];
    [self.codeText becomeFirstResponder];
}

- (void)dismiss{
    [self endEditing:YES];
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.backView.alpha = 0;
                         self.panel.alpha = 0;
                     }completion:^(BOOL finished){
                         [self removeFromSuperview];
                     }];
}

#pragma mark - getter
- (UIView *)backView{
    if(!_backView){
        _backView = [UIView new];
        _backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    }
    return _backView;
}

- (UIView *)panel{
    if(!_panel){
        _panel = [UIView new];
        _panel.backgroundColor = VIEW_COLOR;
        _panel.frame = CGRectMake(0, SCREEN_HEIGHT - 263 * UI_H_SCALE, SCREEN_WIDTH, 263 * UI_H_SCALE);
    }
    return _panel;
}

- (UILabel *)titleLab{
    if(!_titleLab){
        _titleLab = [UILabel new];
        _titleLab.textColor = WORD_COLOR_BLACK;
        _titleLab.font = FONT(20);
        _titleLab.text = @"请输入快递单号";
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.backgroundColor = UIColor.whiteColor;
    }
    return _titleLab;
}

- (ZYElasticButton *)closeBtn{
    if(!_closeBtn){
        _closeBtn = [ZYElasticButton new];
        _closeBtn.backgroundColor = UIColor.whiteColor;
        [_closeBtn setImage:[UIImage imageNamed:@"zy_sheet_close_gray"] forState:UIControlStateNormal];
        [_closeBtn setImage:[UIImage imageNamed:@"zy_sheet_close_gray"] forState:UIControlStateHighlighted];
        
        __weak __typeof__(self) weakSelf = self;
        [_closeBtn clickAction:^(UIButton * _Nonnull button) {
            [weakSelf dismiss];
        }];
    }
    return _closeBtn;
}

- (ZYTextField *)codeText{
    if(!_codeText){
        _codeText = [ZYTextField new];
        _codeText.textColor = WORD_COLOR_BLACK;
        _codeText.font = FONT(15);
        _codeText.placeholder = @"输入运单号";
        _codeText.placeholderColor = HexRGB(0xC4C6CC);
        _codeText.wordLimitNum = 30;
    }
    return _codeText;
}

- (UIView *)line{
    if(!_line){
        _line = [UIView new];
        _line.backgroundColor = MAIN_COLOR_GREEN;
    }
    return _line;
}

- (ZYElasticButton *)saveBtn{
    if(!_saveBtn){
        _saveBtn = [ZYElasticButton new];
        [_saveBtn setBackgroundColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateNormal];
        [_saveBtn setBackgroundColor:BTN_COLOR_HEIGHTLIGHT_GREEN forState:UIControlStateHighlighted];
        _saveBtn.font = FONT(18);
        [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_saveBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_saveBtn setTitleColor:UIColor.whiteColor forState:UIControlStateHighlighted];
        
        __weak __typeof__(self) weakSelf = self;
        [_saveBtn clickAction:^(UIButton * _Nonnull button) {
            [weakSelf dismiss];
            !weakSelf.confirmBlock ? : weakSelf.confirmBlock(weakSelf.codeText.text);
        }];
    }
    return _saveBtn;
}

@end
