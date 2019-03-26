//
//  ZYEditNickNameVC.m
//  Apollo
//
//  Created by shaxia on 2018/5/10.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYEditNickNameVC.h"
#import "NicknameUpdate.h"

@interface ZYEditNickNameVC ()

@property (nonatomic , strong) ZYTextField  *textField;

@property (nonatomic , strong) ZYElasticButton  *saveButton;

@end

@implementation ZYEditNickNameVC

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"修改昵称";
    self.view.backgroundColor = VIEW_COLOR;
    
    [self initWidget];
    
    [self.saveButton setEnabled:NO];
    
    __weak __typeof__ (self) weakSelf = self;
    [self.view tapped:^(UITapGestureRecognizer *gesture) {
        [weakSelf.textField endEditing:YES];
    } delegate:nil];
    
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

- (void)systemBackButtonClicked{
    void (^backCallBack)(void) = self.callBack;
    !backCallBack ? : backCallBack();
    [super systemBackButtonClicked];
}


#pragma mark - initWidget
- (void)initWidget{
    UIView  *topView = [[UIView alloc] initWithFrame:(CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, 60))];
    topView.backgroundColor = NAVIGATIONBAR_COLOR;
    [self.view addSubview:topView];
    
    [topView addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(5, 15, 5, 15));
    }]; 
    
    self.saveButton.frame = CGRectMake(30 * UI_H_SCALE, SCREEN_HEIGHT - 138 * UI_H_SCALE, SCREEN_WIDTH - 60 * UI_H_SCALE, 44 * UI_H_SCALE);
    [self.view addSubview:self.saveButton];
}

#pragma mark - 监听键盘弹出
- (void)keyboardWillShown:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //区分是节点或者连线输入框获得焦点还是超链接的输入框获得焦点
    CGFloat bottom = self.saveButton.bottom;
    if(endFrame.origin.y < bottom){
        self.saveButton.bottom = endFrame.origin.y;
    }
}

#pragma mark - 监听键盘消失
- (void)keyboardWillHidden:(NSNotification *)notification{
    CGFloat bottom = SCREEN_HEIGHT - 94 * UI_H_SCALE;
    self.saveButton.bottom = bottom;
}

#pragma mark - getter
- (ZYTextField *)textField{
    if (!_textField) {
        _textField = [[ZYTextField alloc] init];
        _textField.backgroundColor = NAVIGATIONBAR_COLOR;
        _textField.placeholder = @"请输入昵称";
        _textField.wordLimitNum = 12;
        
        [_textField addTarget:self
                       action:@selector(textEditChanged:)
             forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}

- (ZYElasticButton *)saveButton{
    if (!_saveButton) {
        _saveButton = [ZYElasticButton buttonWithType:(UIButtonTypeCustom)];
        [_saveButton setBackgroundColor:HexRGB(0x7EDCA6) forState:UIControlStateDisabled];
        [_saveButton setBackgroundColor:MAIN_COLOR_GREEN forState:UIControlStateNormal];
        [_saveButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_saveButton setTitleColor:UIColor.whiteColor forState:UIControlStateDisabled];
        [_saveButton setTitle:@"保存" forState:(UIControlStateNormal)];
        [_saveButton setAdjustsImageWhenHighlighted:NO];
        [_saveButton setShouldRound:YES];
        
        __weak __typeof__(self) weakSelf = self;
        [_saveButton clickAction:^(UIButton * _Nonnull button) {
            [weakSelf.textField resignFirstResponder];
            
            _p_NicknameUpdate *param = [[_p_NicknameUpdate alloc] init];
            param.userId = [ZYUser user].userId;
            param.nickname = weakSelf.textField.text;
            [[ZYHttpClient client] post:param showHud:YES success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
                
                if (responseObj.success) {
                    [ZYUser user].nickname = weakSelf.textField.text;
                    [[ZYUser user] save];
                    [ZYToast showWithTitle:@"修改昵称成功"];
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    [ZYToast showWithTitle:responseObj.message];
                }
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                if(error.code == ZYHttpErrorCodeTimeOut){
                    [ZYToast showWithTitle:ZYHttpErrorMessageNetTimeOut];
                }else if(error.code == ZYHttpErrorCodeNoNet){
                    [ZYToast showWithTitle:ZYHttpErrorMessageNoNet];
                }else if(error.code == ZYHttpErrorCodeSystemError){
                    [ZYToast showWithTitle:ZYHttpErrorMessageSystemError];
                }
            } authFail:nil];
        }];
    }
    return _saveButton;
}

#pragma mark - 输入框内容变化回调
- (void)textEditChanged:(UITextField *)textField{
    if (textField.text.length > 0) {
        _saveButton.enabled = YES;
    } else {
        _saveButton.enabled = NO;
    }
    
}

@end
