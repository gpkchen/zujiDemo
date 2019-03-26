//
//  ZYEnvirSwitch.m
//  Apollo
//
//  Created by 李明伟 on 2018/7/12.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYEnvirSwitch.h"

#define kZYEnvirSwitchOpenFrame CGRectMake((SCREEN_WIDTH - 300 * UI_H_SCALE) / 2, (SCREEN_HEIGHT - 300 * UI_H_SCALE) / 2, 300 * UI_H_SCALE, 300 * UI_H_SCALE)

@interface ZYEnvirSwitch()

@property (nonatomic , strong) UIImageView *iconIV;

@property (nonatomic , assign) BOOL shouldMove; //是否应该开始移动
@property (nonatomic , assign) CGPoint beginMovePoint; //开始移动触发点

@property (nonatomic , assign) BOOL isOpen; //是否已展开
@property (nonatomic , assign) CGRect closeFrame; //记录展开前的位置

@property (nonatomic , strong) UIView *btnBack;
@property (nonatomic , strong) ZYElasticButton *devBtn;
@property (nonatomic , strong) ZYElasticButton *testBtn;
@property (nonatomic , strong) ZYElasticButton *grayBtn;
@property (nonatomic , strong) ZYElasticButton *releaseBtn;
@property (nonatomic , strong) ZYElasticButton *updateBtn;
@property (nonatomic , strong) ZYElasticButton *closeBtn;

@end

@implementation ZYEnvirSwitch

- (instancetype)init{
    self = [super init];
    if(self){
        self.windowLevel = powf(10, 7);
        self.backgroundColor = [UIColor clearColor];
        self.layer.masksToBounds = YES;
        self.size = self.iconIV.image.size;
        self.center = CGPointMake(self.width / 2.0, SCREEN_HEIGHT / 2.0);
        
        [self addSubview:self.iconIV];
        [self addSubview:self.btnBack];
        [self addSubview:self.closeBtn];
        
        [self.btnBack addSubview:self.devBtn];
        [self.devBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.btnBack);
            make.height.mas_equalTo(50 * UI_H_SCALE);
        }];
        
        [self.btnBack addSubview:self.testBtn];
        [self.testBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.btnBack);
            make.top.equalTo(self.devBtn.mas_bottom);
            make.height.mas_equalTo(50 * UI_H_SCALE);
        }];
        
        [self.btnBack addSubview:self.grayBtn];
        [self.grayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.btnBack);
            make.top.equalTo(self.testBtn.mas_bottom);
            make.height.mas_equalTo(50 * UI_H_SCALE);
        }];
        
        [self.btnBack addSubview:self.releaseBtn];
        [self.releaseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.btnBack);
            make.top.equalTo(self.grayBtn.mas_bottom);
            make.height.mas_equalTo(50 * UI_H_SCALE);
        }];
        
        [self.btnBack addSubview:self.updateBtn];
        [self.updateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.btnBack);
            make.top.equalTo(self.releaseBtn.mas_bottom);
            make.height.mas_equalTo(100 * UI_H_SCALE);
        }];
        
        self.shouldMove = YES;
        
        __weak __typeof__(self) weakSelf = self;
        [self tapped:^(UITapGestureRecognizer *gesture) {
            [weakSelf tapAction];
        } delegate:nil];
    }
    return self;
}

#pragma mark - public
+ (void)show{
    static ZYEnvirSwitch *envirSwitch = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (envirSwitch == nil) {
            envirSwitch = [ZYEnvirSwitch new];
        }
    });
    [envirSwitch makeVisibleWindow];
}

#pragma mark - 显示window
- (void)makeVisibleWindow {
    UIWindow *keyWindows = [UIApplication sharedApplication].keyWindow;
    [self makeKeyAndVisible];
    if (keyWindows) {
        [keyWindows makeKeyWindow];
    }
}

#pragma mark - 点击事件
- (void)tapAction{
    if(!_isOpen){
        self.shouldMove = NO;
        _closeFrame = self.frame;
        [UIView animateWithDuration:0.2
                         animations:^{
                             self.frame = kZYEnvirSwitchOpenFrame;
                             self.iconIV.alpha = 0;
                             self.btnBack.alpha = 1;
                             self.closeBtn.alpha = 1;
                         } completion:^(BOOL finished) {
                             self.isOpen = YES;
                         }];
    }
}

#pragma mark - override
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    if(_shouldMove){
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        _beginMovePoint = point;
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    if(_shouldMove){
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        self.center = CGPointMake(self.center.x + point.x - _beginMovePoint.x, self.center.y + point.y - _beginMovePoint.y);
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    [self endMoving];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    [self endMoving];
}

#pragma mark - 结束移动
- (void)endMoving{
    if(_shouldMove){
        CGPoint endPoint = self.center;
        if(self.center.x >= SCREEN_WIDTH / 2.0){
            endPoint.x = SCREEN_WIDTH - self.width / 2.0;
        }else{
            endPoint.x = self.width / 2.0;
        }
        if(self.top < 0){
            endPoint.y = self.height / 2.0;
        }else if(self.bottom > SCREEN_HEIGHT){
            endPoint.y = SCREEN_HEIGHT - self.height / 2.0;
        }
        [UIView animateWithDuration:0.2
                         animations:^{
                             self.center = endPoint;
                         }];
    }
}

#pragma mark - getter
- (UIImageView *)iconIV{
    if(!_iconIV){
        _iconIV = [UIImageView new];
        _iconIV.image = [UIImage imageNamed:@"zy_envir_icon"];
        _iconIV.frame = CGRectMake(0, 0, _iconIV.image.size.width, _iconIV.image.size.height);
    }
    return _iconIV;
}

- (UIView *)btnBack{
    if(!_btnBack){
        _btnBack = [UIView new];
        _btnBack.cornerRadius = 5;
        _btnBack.clipsToBounds = YES;
        _btnBack.backgroundColor = [UIColor whiteColor];
        _btnBack.borderColor = MAIN_COLOR_GREEN;
        _btnBack.borderWidth = 2;
        _btnBack.alpha = 0;
        _btnBack.frame = CGRectMake(0, 0, kZYEnvirSwitchOpenFrame.size.width, kZYEnvirSwitchOpenFrame.size.height);
    }
    return _btnBack;
}

- (ZYElasticButton *)closeBtn{
    if(!_closeBtn){
        _closeBtn = [ZYElasticButton new];
        _closeBtn.alpha = 0;
        _closeBtn.backgroundColor = [UIColor clearColor];
        [_closeBtn setTitle:@"X" forState:UIControlStateNormal];
        [_closeBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        _closeBtn.font = FONT(18);
        _closeBtn.frame = CGRectMake(kZYEnvirSwitchOpenFrame.size.width - 40,
                                     0,
                                     40, 40);
        
        __weak __typeof__(self) weakSelf = self;
        [_closeBtn clickAction:^(UIButton * _Nonnull button) {
            [UIView animateWithDuration:0.2
                             animations:^{
                                 weakSelf.frame = weakSelf.closeFrame;
                                 weakSelf.iconIV.alpha = 1;
                                 weakSelf.btnBack.alpha = 0;
                                 weakSelf.closeBtn.alpha = 0;
                             } completion:^(BOOL finished) {
                                 weakSelf.isOpen = NO;
                                 weakSelf.shouldMove = YES;
                             }];
        }];
    }
    return _closeBtn;
}

- (ZYElasticButton *)devBtn{
    if(!_devBtn){
        _devBtn = [ZYElasticButton new];
        _devBtn.shouldAnimate = NO;
        [_devBtn setBackgroundColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateNormal];
        [_devBtn setBackgroundColor:BTN_COLOR_HEIGHTLIGHT_GREEN forState:UIControlStateHighlighted];
        [_devBtn setBackgroundColor:BTN_COLOR_DISABLE forState:UIControlStateDisabled];
        _devBtn.font = FONT(15);
        NSString *key = [NSUserDefaults readObjectWithKey:ZYBuildEnvirKey];
        if(!key || [@"EN_Develope" isEqualToString:key]){
            [_devBtn setTitle:@"开发环境(当前)" forState:UIControlStateNormal];
        }else{
            [_devBtn setTitle:@"开发环境" forState:UIControlStateNormal];
        }
        [_devBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        
        [_devBtn clickAction:^(UIButton * _Nonnull button) {
            [[ZYLoginService service] logout:^{
                [NSUserDefaults writeWithObject:@"EN_Develope" forKey:ZYBuildEnvirKey];
                [ZYToast showWithTitle:@"开发环境切换成功，APP自动关闭后请手动重启\n关闭中，请勿操作..."];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    exit(0);
                });
            }];
        }];
    }
    return _devBtn;
}

- (ZYElasticButton *)testBtn{
    if(!_testBtn){
        _testBtn = [ZYElasticButton new];
        _testBtn.shouldAnimate = NO;
        [_testBtn setBackgroundColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateNormal];
        [_testBtn setBackgroundColor:BTN_COLOR_HEIGHTLIGHT_GREEN forState:UIControlStateHighlighted];
        [_testBtn setBackgroundColor:BTN_COLOR_DISABLE forState:UIControlStateDisabled];
        _testBtn.font = FONT(15);
        NSString *key = [NSUserDefaults readObjectWithKey:ZYBuildEnvirKey];
        if([@"EN_Test" isEqualToString:key]){
            [_testBtn setTitle:@"测试环境(当前)" forState:UIControlStateNormal];
        }else{
            [_testBtn setTitle:@"测试环境" forState:UIControlStateNormal];
        }
        [_testBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        
        [_testBtn clickAction:^(UIButton * _Nonnull button) {
            [[ZYLoginService service] logout:^{
                [NSUserDefaults writeWithObject:@"EN_Test" forKey:ZYBuildEnvirKey];
                [ZYToast showWithTitle:@"测试环境切换成功，APP自动关闭后请手动重启\n关闭中，请勿操作..."];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    exit(0);
                });
            }];
        }];
    }
    return _testBtn;
}

- (ZYElasticButton *)grayBtn{
    if(!_grayBtn){
        _grayBtn = [ZYElasticButton new];
        _grayBtn.shouldAnimate = NO;
        [_grayBtn setBackgroundColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateNormal];
        [_grayBtn setBackgroundColor:BTN_COLOR_HEIGHTLIGHT_GREEN forState:UIControlStateHighlighted];
        [_grayBtn setBackgroundColor:BTN_COLOR_DISABLE forState:UIControlStateDisabled];
        _grayBtn.font = FONT(15);
        NSString *key = [NSUserDefaults readObjectWithKey:ZYBuildEnvirKey];
        if([@"EN_Gray" isEqualToString:key]){
            [_grayBtn setTitle:@"灰度环境(当前)" forState:UIControlStateNormal];
        }else{
            [_grayBtn setTitle:@"灰度环境" forState:UIControlStateNormal];
        }
        [_grayBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        
        [_grayBtn clickAction:^(UIButton * _Nonnull button) {
            [[ZYLoginService service] logout:^{
                [NSUserDefaults writeWithObject:@"EN_Gray" forKey:ZYBuildEnvirKey];
                [ZYToast showWithTitle:@"灰度环境切换成功，APP自动关闭后请手动重启\n关闭中，请勿操作..."];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    exit(0);
                });
            }];
        }];
    }
    return _grayBtn;
}

- (ZYElasticButton *)releaseBtn{
    if(!_releaseBtn){
        _releaseBtn = [ZYElasticButton new];
        _releaseBtn.shouldAnimate = NO;
        [_releaseBtn setBackgroundColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateNormal];
        [_releaseBtn setBackgroundColor:BTN_COLOR_HEIGHTLIGHT_GREEN forState:UIControlStateHighlighted];
        [_releaseBtn setBackgroundColor:BTN_COLOR_DISABLE forState:UIControlStateDisabled];
        _releaseBtn.font = FONT(15);
        NSString *key = [NSUserDefaults readObjectWithKey:ZYBuildEnvirKey];
        if([@"EN_Publish" isEqualToString:key]){
            [_releaseBtn setTitle:@"正式环境(当前)" forState:UIControlStateNormal];
        }else{
            [_releaseBtn setTitle:@"正式环境" forState:UIControlStateNormal];
        }
        [_releaseBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        
        [_releaseBtn clickAction:^(UIButton * _Nonnull button) {
            [[ZYLoginService service] logout:^{
                [NSUserDefaults writeWithObject:@"EN_Publish" forKey:ZYBuildEnvirKey];
                [ZYToast showWithTitle:@"正式环境切换成功，APP自动关闭后请手动重启\n关闭中，请勿操作..."];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    exit(0);
                });
            }];
        }];
    }
    return _releaseBtn;
}

- (ZYElasticButton *)updateBtn{
    if(!_updateBtn){
        _updateBtn = [ZYElasticButton new];
        _updateBtn.font = FONT(15);
        [_updateBtn setTitle:@"更新测试包 >>" forState:UIControlStateNormal];
        [_updateBtn setTitleColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateNormal];
        
        [_updateBtn clickAction:^(UIButton * _Nonnull button) {
            [ZYAppUtils openURL:@"http://down.fintechzh.com/apolloapp/download.html"];
        }];
    }
    return _updateBtn;
}

@end
