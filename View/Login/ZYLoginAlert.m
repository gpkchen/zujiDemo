//
//  ZYLoginAlert.m
//  Apollo
//
//  Created by 李明伟 on 2018/9/3.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYLoginAlert.h"
#import "ZYVerCodeService.h"
#import "ZYPhoneTextField.h"

@interface ZYLoginAlert ()<UIGestureRecognizerDelegate>

@property (nonatomic , assign) BOOL isCodeMode;                 //是否是输入验证码模式
@property (nonatomic , copy) NSString *phone;                   //记录电话号码
@property (nonatomic , copy) NSString *code;                   //记录验证码
@property (nonatomic , strong) NSTimer *timer;                  //验证码倒计时
@property (nonatomic , assign) int timeCounting;                //验证码倒计时

@property (nonatomic , strong) UIView *back;                    //背景视图
@property (nonatomic , strong) UIView *panel;                   //总浮板

@property (nonatomic , strong) UIView *phonePanel;              //浮板视图
@property (nonatomic , strong) ZYElasticButton *phoneCloseBtn;  //关闭按钮
@property (nonatomic , strong) UILabel *phoneTitleLab;          //电话标题
@property (nonatomic , strong) UIView *phoneLine;               //电话输入框底线
@property (nonatomic , strong) ZYPhoneTextField *phoneText;          //电话输入框
@property (nonatomic , strong) ZYElasticButton *codeBtn;        //发送验证码按钮
@property (nonatomic , strong) UILabel *agreementLab;           //协议
@property (nonatomic , strong) UIActivityIndicatorView *aiv;    //发送验证码菊花

@property (nonatomic , strong) UIView *codePanel;               //浮板视图
@property (nonatomic , strong) UILabel *codePhoneLab;           //验证码界面手机号
@property (nonatomic , strong) ZYElasticButton *codeCloseBtn;   //关闭按钮
@property (nonatomic , strong) NSMutableArray *codeLabLines;    //验证码底线
@property (nonatomic , strong) NSMutableArray *codeLabs;        //验证码显示框
@property (nonatomic , strong) ZYTextField *hiddenCodeText;     //隐藏的验证码输入框
@property (nonatomic , strong) ZYElasticButton *resendBtn;      //重发验证码按钮
@property (nonatomic , strong) ZYElasticButton *changePhoneBtn; //更改手机号按钮

@end

@implementation ZYLoginAlert

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
}

- (instancetype)init{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if(self){
        self.backgroundColor = [UIColor clearColor];
        _isCodeMode = NO;
        
        [self addSubview:self.back];
        [self addSubview:self.panel];
        [self.panel addSubview:self.phonePanel];
        [self.panel addSubview:self.codePanel];
        
        [self.phonePanel addSubview:self.phoneCloseBtn];
        [self.phoneCloseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.equalTo(self.phonePanel);
            make.size.mas_equalTo(CGSizeMake(30 + 36 * UI_H_SCALE, 30 + 28 * UI_H_SCALE));
        }];
        
        [self.phonePanel addSubview:self.phoneTitleLab];
        [self.phoneTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.phonePanel).mas_offset(20 * UI_H_SCALE);
            make.centerY.equalTo(self.phonePanel.mas_top).mas_offset(49.5 * UI_H_SCALE);
        }];
        
        [self.phonePanel addSubview:self.phoneLine];
        [self.phoneLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.phonePanel).mas_offset(20 * UI_H_SCALE);
            make.right.equalTo(self.phonePanel).mas_offset(-20 * UI_H_SCALE);
            make.height.mas_equalTo(1);
            make.top.equalTo(self.phonePanel).mas_offset(122 * UI_H_SCALE);
        }];
        
        [self.phonePanel addSubview:self.phoneText];
        [self.phoneText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.phoneLine);
            make.height.mas_equalTo(43 * UI_H_SCALE);
        }];
        
        [self.phonePanel addSubview:self.aiv];
        [self.aiv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.phoneText);
            make.right.equalTo(self.phoneText).mas_offset(-5);
        }];
        
        [self.phonePanel addSubview:self.codeBtn];
        [self.codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.phonePanel).mas_offset(20 * UI_H_SCALE);
            make.right.equalTo(self.phonePanel).mas_offset(-20 * UI_H_SCALE);
            make.top.equalTo(self.phoneLine).mas_offset(40 * UI_H_SCALE);
            make.height.mas_equalTo(50 * UI_H_SCALE);
        }];
        
        [self.phonePanel addSubview:self.agreementLab];
        [self.agreementLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.phonePanel);
            make.centerY.equalTo(self.codeBtn.mas_bottom).mas_offset(35.5 * UI_H_SCALE);
        }];
        
        [self.codePanel addSubview:self.codePhoneLab];
        [self.codePhoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.codePanel).mas_offset(20 * UI_H_SCALE);
            make.centerY.equalTo(self.codePanel.mas_top).mas_offset(49.5 * UI_H_SCALE);
        }];
        
        [self.codePanel addSubview:self.codeCloseBtn];
        [self.codeCloseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.equalTo(self.codePanel);
            make.size.mas_equalTo(CGSizeMake(30 + 36 * UI_H_SCALE, 30 + 28 * UI_H_SCALE));
        }];
        
        [self.codePanel addSubview:self.hiddenCodeText];
        [self.hiddenCodeText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.codePanel);
        }];
        
        CGFloat codeLineWidth = (self.codePanel.width - 7 * 20 * UI_H_SCALE) / 6.0;
        CGFloat x = 20 * UI_H_SCALE;
        for(int i=0;i<6;++i){
            UIView *line = [self createCodeLine];
            [self.codePanel addSubview:line];
            [self.codeLabLines addObject:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.codePanel).mas_offset(x);
                make.top.equalTo(self.codePanel).mas_offset(122 * UI_H_SCALE);
                make.height.mas_equalTo(1);
                make.width.mas_equalTo(codeLineWidth);
            }];
            UILabel *lab = [self createCodeLab];
            [self.codePanel addSubview:lab];
            [self.codeLabs addObject:lab];
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(line);
                make.bottom.equalTo(line.mas_top);
                make.height.mas_equalTo(25 * UI_H_SCALE);
            }];
            
            x += (codeLineWidth + 20 * UI_H_SCALE);
        }
        
        [self.codePanel addSubview:self.resendBtn];
        [self.resendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.codePanel);
            make.centerY.equalTo(self.codePanel.mas_bottom).mas_offset(-104.5 * UI_H_SCALE);
            make.size.mas_equalTo(CGSizeMake(self.codePanel.width - 40 * UI_H_SCALE, 40 * UI_H_SCALE));
        }];
        
        [self.codePanel addSubview:self.changePhoneBtn];
        [self.changePhoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.codePanel);
            make.centerY.equalTo(self.codePanel.mas_bottom).mas_offset(-49.5 * UI_H_SCALE);
            make.size.mas_equalTo(CGSizeMake(self.changePhoneBtn.width, 40 * UI_H_SCALE));
        }];
        
        //注册键盘出现的通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShown:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
    }
    return self;
}

#pragma mark - 监听键盘弹出
- (void)keyboardWillShown:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    self.panel.bottom = endFrame.origin.y - 26 * UI_H_SCALE;
}

#pragma mark - 显示验证码面板
- (void)showCodePanel{
    self.codePhoneLab.text = [NSString stringWithFormat:@"手机号:%@",_phone];
    [self.phoneText resignFirstResponder];
    [self.hiddenCodeText becomeFirstResponder];
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.phonePanel.right = 0;
                         self.codePanel.left = 0;
                     }];
}

#pragma mark - 显示手机号面板
- (void)showPhonePanel{
    for(int i=0;i<self.codeLabLines.count;++i){
        UIView *line = self.codeLabLines[i];
        UILabel *lab = self.codeLabs[i];
        line.backgroundColor = WORD_COLOR_GRAY_9B;
        lab.text = @"";
    }
    self.hiddenCodeText.text = @"";
    [self.phoneText becomeFirstResponder];
    [self.hiddenCodeText resignFirstResponder];
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.phonePanel.left = 0;
                         self.codePanel.left = self.panel.width;
                     }];
}

#pragma mark - 发送验证码
- (void)sendVerCode{
    if(![_phone isTelNumber]){
        [ZYToast showWithTitle:@"请输入正确手机号"];
        return;
    }
    __weak __typeof__(self) weakSelf = self;
    self.codeBtn.enabled = NO;
    [self.aiv startAnimating];
    [[ZYVerCodeService service] requireVerCode:ZYVerCodeServiceSceneLogin
                                        mobile:_phone
                                       showHud:NO
                                       complete:^(BOOL success){
                                           weakSelf.codeBtn.enabled = YES;
                                           [weakSelf.aiv stopAnimating];
                                           if(success){
                                               if(!weakSelf.isCodeMode){
                                                   [weakSelf showCodePanel];
                                               }
                                               [weakSelf.timer fire];
                                           }
                                       }];
}

#pragma mark - 发起登录
- (void)login{
    __weak __typeof__(self) weakSelf = self;
    [[ZYLoginService service] mobileCodeLogin:_phone
                                         code:_code
                                      showHud:YES
                                     complete:^(BOOL success) {
                                         if(success){
                                             [[ZYVerCodeService service] reset];
                                             [weakSelf dismiss];
                                             !weakSelf.completeBlock ? : weakSelf.completeBlock(NO);
                                         }
                                     }];
}

#pragma mark - 倒计时
- (void)timerRun{
    if(_timeCounting > ZYVerCodeMaxTimeCounting){
        [self.timer invalidate];
        self.timer = nil;
        _timeCounting = 0;
        self.resendBtn.enabled = YES;
        return;
    }
    self.resendBtn.enabled = NO;
    [self.resendBtn setTitle:[NSString stringWithFormat:@"重新获取验证码（%dS）",ZYVerCodeMaxTimeCounting - _timeCounting]
                           forState:UIControlStateDisabled];
    _timeCounting++;
}

#pragma mark - public
- (void)show{
    if([ZYVerCodeService service].shouldContinueCounting){
        _phone = [ZYVerCodeService service].lastSendingMobile;
        self.phoneText.text = _phone;
        _timeCounting = ZYVerCodeMaxTimeCounting - [ZYVerCodeService service].remainTimeCount;
        [self.timer fire];
    }
    [SCREEN addSubview:self];
    [self.phoneText becomeFirstResponder];
    self.back.alpha = 0;
    self.panel.alpha = 0;
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.back.alpha = 1;
                         self.panel.alpha = 1;
                     }];
}

- (void)dismiss{
    if(_timer){
        [_timer invalidate];
        _timer = nil;
    }
    [self.phoneText resignFirstResponder];
    [self.hiddenCodeText resignFirstResponder];
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.back.alpha = 0;
                         self.panel.alpha = 0;
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

#pragma mark - 监控隐藏的验证码输入
- (void)hiddenCodeEditChanged:(ZYTextField *)text{
    NSString *code = text.text;
    for(int i=0;i<self.codeLabLines.count;++i){
        UIView *line = self.codeLabLines[i];
        UILabel *lab = self.codeLabs[i];
        if(i < code.length){
            line.backgroundColor = MAIN_COLOR_GREEN;
            lab.text = [code substringWithRange:NSMakeRange(i, 1)];
        }else{
            line.backgroundColor = WORD_COLOR_GRAY_9B;
            lab.text = @"";
        }
    }
    if(code.length == 6){
        if(![code isEqualToString:_code]){
            _code = code;
            [self login];
        }
    }
}

#pragma mark - getter
- (UIView *)back{
    if(!_back){
        _back = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _back.backgroundColor = HexRGBAlpha(0x18191A, 0.6);
        _back.alpha = 0;
    }
    return _back;
}

- (UIView *)panel{
    if(!_panel){
        _panel = [[UIView alloc]init];
        _panel.backgroundColor = [UIColor whiteColor];
        _panel.clipsToBounds = YES;
        _panel.frame = CGRectMake((SCREEN_WIDTH - 330 * UI_H_SCALE) / 2.0,
                                  SCREEN_HEIGHT - 295 * UI_H_SCALE - 26 * UI_H_SCALE,
                                  330 * UI_H_SCALE,
                                  295 * UI_H_SCALE);
        _panel.cornerRadius = 12;
        _panel.alpha = 0;
    }
    return _panel;
}

- (NSTimer *)timer{
    if(!_timer){
        _timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(timerRun)
                                                userInfo:nil
                                                 repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

- (UIView *)phonePanel{
    if(!_phonePanel){
        _phonePanel = [[UIView alloc]init];
        _phonePanel.backgroundColor = [UIColor whiteColor];
        _phonePanel.frame = CGRectMake(0, 0, self.panel.width, self.panel.height);
        
        __weak __typeof__(self) weakSelf = self;
        [_phonePanel tapped:^(UITapGestureRecognizer *gesture) {
            [weakSelf.phoneText becomeFirstResponder];
        } delegate:nil];
    }
    return _phonePanel;
}

- (ZYElasticButton *)phoneCloseBtn{
    if(!_phoneCloseBtn){
        _phoneCloseBtn = [ZYElasticButton new];
        _phoneCloseBtn.backgroundColor = UIColor.clearColor;
        [_phoneCloseBtn setImage:[UIImage imageNamed:@"zy_sheet_close_gray"] forState:UIControlStateNormal];
        [_phoneCloseBtn setImage:[UIImage imageNamed:@"zy_sheet_close_gray"] forState:UIControlStateHighlighted];
        
        __weak __typeof__(self) weakSelf = self;
        [_phoneCloseBtn clickAction:^(UIButton * _Nonnull button) {
            !weakSelf.completeBlock ? : weakSelf.completeBlock(YES);
            [weakSelf dismiss];
        }];
    }
    return _phoneCloseBtn;
}

- (UILabel *)phoneTitleLab{
    if(!_phoneTitleLab){
        _phoneTitleLab = [UILabel new];
        _phoneTitleLab.text = @"手机号码登录";
        _phoneTitleLab.font = MEDIUM_FONT(24);
        _phoneTitleLab.textColor = WORD_COLOR_BLACK;
    }
    return _phoneTitleLab;
}

- (UIView *)phoneLine{
    if(!_phoneLine){
        _phoneLine = [UIView new];
        _phoneLine.backgroundColor = HexRGBAlpha(0x18191A, 0.1);
    }
    return _phoneLine;
}

- (ZYPhoneTextField *)phoneText{
    if(!_phoneText){
        _phoneText = [ZYPhoneTextField new];
        _phoneText.textColor = WORD_COLOR_BLACK;
        _phoneText.font = MEDIUM_FONT(18);
        _phoneText.placeholder = @"请输入手机号码";
        _phoneText.placeholderColor = WORD_COLOR_GRAY_9B;
        _phoneText.placeholderFont = FONT(15);
        _phoneText.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneText.keyboardType = UIKeyboardTypeNumberPad;
        
        __weak __typeof__(self) weakSelf = self;
        _phoneText.changedBlock = ^(NSString *phone) {
            if([phone isTelNumber]){
                weakSelf.codeBtn.enabled = YES;
            }else{
                weakSelf.codeBtn.enabled = NO;
            }
        };

    }
    return _phoneText;
}

- (ZYElasticButton *)codeBtn{
    if(!_codeBtn){
        _codeBtn = [ZYElasticButton new];
        _codeBtn.cornerRadius = 4;
        _codeBtn.clipsToBounds = YES;
        [_codeBtn setBackgroundColor:BTN_COLOR_DISABLE_GREEN forState:UIControlStateDisabled];
        [_codeBtn setBackgroundColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateNormal];
        [_codeBtn setBackgroundColor:BTN_COLOR_HEIGHTLIGHT_GREEN forState:UIControlStateHighlighted];
        _codeBtn.font = MEDIUM_FONT(18);
        [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_codeBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_codeBtn setTitleColor:UIColor.whiteColor forState:UIControlStateHighlighted];
        _codeBtn.enabled = NO;
        
        __weak __typeof__(self) weakSelf = self;
        [_codeBtn clickAction:^(UIButton * _Nonnull button) {
            NSString *phone = weakSelf.phoneText.phone;
#ifdef Archive_Release
            if([phone isEqualToString:weakSelf.phone] && [ZYVerCodeService service].shouldContinueCounting){
                [ZYToast showWithTitle:@"验证码已下发，请耐心等待"];
                [weakSelf showCodePanel];
            }else{
                weakSelf.phone = phone;
                [weakSelf sendVerCode];
            }
#else
            if([ZYEnvirUtils utils].envir == ZYEnvirDev || [ZYEnvirUtils utils].envir == ZYEnvirTest){
                weakSelf.phone = phone;
                [weakSelf showCodePanel];
            }else{
                if([phone isEqualToString:weakSelf.phone] && [ZYVerCodeService service].shouldContinueCounting){
                    [ZYToast showWithTitle:@"验证码已下发，请耐心等待"];
                    [weakSelf showCodePanel];
                }else{
                    weakSelf.phone = phone;
                    [weakSelf sendVerCode];
                }
            }
#endif
            
        }];
    }
    return _codeBtn;
}

- (UILabel *)agreementLab{
    if(!_agreementLab){
        _agreementLab = [UILabel new];
        _agreementLab.font = FONT(12);
        _agreementLab.userInteractionEnabled = YES;
        _agreementLab.textColor = WORD_COLOR_GRAY_9B;
        
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"新用户登录即同意《机有用户协议》"];
        [att addAttribute:NSForegroundColorAttributeName value:HexRGB(0x4a4a4a) range:NSMakeRange(att.length - 8, 8)];
        _agreementLab.attributedText = att;
        
        __weak __typeof__(self) weakSelf = self;
        [_agreementLab tapped:^(UITapGestureRecognizer *gesture) {
            [weakSelf dismiss];
            [[ZYRouter router] goWithoutHead:[NSString stringWithFormat:@"web?url=%@",
                                              [[ZYH5Utils formatUrl:ZYH5TypeUserAgreement param:nil] URLEncode]]];
        } delegate:nil];
    }
    return _agreementLab;
}

- (UIActivityIndicatorView *)aiv{
    if(!_aiv){
        _aiv = [UIActivityIndicatorView new];
        _aiv.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        _aiv.backgroundColor = UIColor.whiteColor;
        _aiv.hidesWhenStopped = YES;
    }
    return _aiv;
}

- (UILabel *)codePhoneLab{
    if(!_codePhoneLab){
        _codePhoneLab = [UILabel new];
        _codePhoneLab.font = MEDIUM_FONT(24);
        _codePhoneLab.textColor = WORD_COLOR_BLACK;
    }
    return _codePhoneLab;
}

- (UIView *)codePanel{
    if(!_codePanel){
        _codePanel = [[UIView alloc]init];
        _codePanel.backgroundColor = [UIColor whiteColor];
        _codePanel.frame = CGRectMake(self.panel.width, 0, self.panel.width, self.panel.height);
        
        __weak __typeof__(self) weakSelf = self;
        [_codePanel tapped:^(UITapGestureRecognizer *gesture) {
            [weakSelf.hiddenCodeText becomeFirstResponder];
        } delegate:nil];
    }
    return _codePanel;
}

- (ZYElasticButton *)codeCloseBtn{
    if(!_codeCloseBtn){
        _codeCloseBtn = [ZYElasticButton new];
        _codeCloseBtn.backgroundColor = UIColor.clearColor;
        [_codeCloseBtn setImage:[UIImage imageNamed:@"zy_sheet_close_gray"] forState:UIControlStateNormal];
        [_codeCloseBtn setImage:[UIImage imageNamed:@"zy_sheet_close_gray"] forState:UIControlStateHighlighted];
        
        __weak __typeof__(self) weakSelf = self;
        [_codeCloseBtn clickAction:^(UIButton * _Nonnull button) {
            !weakSelf.completeBlock ? : weakSelf.completeBlock(YES);
            [weakSelf dismiss];
        }];
    }
    return _codeCloseBtn;
}

- (NSMutableArray *)codeLabLines{
    if(!_codeLabLines){
        _codeLabLines = [NSMutableArray array];
    }
    return _codeLabLines;
}

- (UIView *)createCodeLine{
    UIView *view = [UIView new];
    view.backgroundColor = WORD_COLOR_GRAY_9B;
    return view;
}

- (NSMutableArray *)codeLabs{
    if(!_codeLabs){
        _codeLabs = [NSMutableArray array];
    }
    return _codeLabs;
}

- (UILabel *)createCodeLab{
    UILabel *lab = [UILabel new];
    lab.backgroundColor = UIColor.whiteColor;
    lab.font = MEDIUM_FONT(18);
    lab.textColor = WORD_COLOR_BLACK;
    lab.textAlignment = NSTextAlignmentCenter;
    return lab;
}

- (ZYTextField *)hiddenCodeText{
    if(!_hiddenCodeText){
        _hiddenCodeText = [ZYTextField new];
        _hiddenCodeText.hidden = YES;
        _hiddenCodeText.wordLimitNum = 6;
        _hiddenCodeText.keyboardType = UIKeyboardTypeNumberPad;
        
        [_hiddenCodeText addTarget:self action:@selector(hiddenCodeEditChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _hiddenCodeText;
}

- (ZYElasticButton *)resendBtn{
    if(!_resendBtn){
        _resendBtn = [ZYElasticButton new];
        _resendBtn.backgroundColor = UIColor.whiteColor;
        _resendBtn.font = MEDIUM_FONT(18);
        [_resendBtn setTitle:@"重新获取验证码" forState:UIControlStateNormal];
        [_resendBtn setTitleColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateNormal];
        [_resendBtn setTitleColor:BTN_COLOR_HEIGHTLIGHT_GREEN forState:UIControlStateHighlighted];
        [_resendBtn setTitleColor:WORD_COLOR_GRAY_9B forState:UIControlStateDisabled];
        
        __weak __typeof__(self) weakSelf = self;
        [_resendBtn clickAction:^(UIButton * _Nonnull button) {
            [weakSelf sendVerCode];
        }];
    }
    return _resendBtn;
}

- (ZYElasticButton *)changePhoneBtn{
    if(!_changePhoneBtn){
        _changePhoneBtn = [ZYElasticButton new];
        _changePhoneBtn.backgroundColor = UIColor.whiteColor;
        _changePhoneBtn.font = MEDIUM_FONT(15);
        [_changePhoneBtn setTitle:@"更改手机号码" forState:UIControlStateNormal];
        [_changePhoneBtn setTitleColor:WORD_COLOR_GRAY_9B forState:UIControlStateNormal];
        [_changePhoneBtn setTitleColor:WORD_COLOR_GRAY_9B forState:UIControlStateHighlighted];
        [_changePhoneBtn sizeToFit];
        
        __weak __typeof__(self) weakSelf = self;
        [_changePhoneBtn clickAction:^(UIButton * _Nonnull button) {
            [weakSelf showPhonePanel];
        }];
    }
    return _changePhoneBtn;
}

@end
