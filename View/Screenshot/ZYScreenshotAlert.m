//
//  ZYScreenshotAlert.m
//  Apollo
//
//  Created by 李明伟 on 2018/7/16.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYScreenshotAlert.h"
#import "ZYShareMenu.h"

@interface ZYScreenshotAlert ()

@property (nonatomic , strong) UIView *panel;
@property (nonatomic , strong) UIView *topBack;
@property (nonatomic , strong) UIView *actionBack;
@property (nonatomic , strong) UIImageView *imageView;

@property (nonatomic , strong) ZYElasticButton *closeBtn;
@property (nonatomic , strong) ZYElasticButton *consultBtn;
@property (nonatomic , strong) ZYElasticButton *shareBtn;

@end

@implementation ZYScreenshotAlert

- (instancetype)init{
    if(self = [super init]){
        [self.panel addSubview:self.topBack];
        [self.topBack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.panel);
            make.height.mas_equalTo(49 * UI_H_SCALE);
        }];
        
        [self.panel addSubview:self.actionBack];
        [self.actionBack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.panel);
            make.height.mas_equalTo(60 * UI_H_SCALE);
        }];
        
        [self.panel addSubview:self.closeBtn];
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.equalTo(self.topBack);
            make.width.mas_equalTo(30 + 30 * UI_H_SCALE);
        }];
        
        [self.actionBack addSubview:self.consultBtn];
        [self.consultBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.actionBack).mas_offset(30 * UI_H_SCALE);
            make.centerY.equalTo(self.actionBack);
            make.size.mas_equalTo(CGSizeMake(80 * UI_H_SCALE, 30 * UI_H_SCALE));
        }];
        
        [self.actionBack addSubview:self.shareBtn];
        [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.actionBack).mas_offset(-30 * UI_H_SCALE);
            make.centerY.equalTo(self.actionBack);
            make.size.mas_equalTo(CGSizeMake(80 * UI_H_SCALE, 30 * UI_H_SCALE));
        }];
        
        [self.panel addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.panel);
            make.top.equalTo(self.topBack.mas_bottom).mas_offset(20 * UI_H_SCALE);
            make.bottom.equalTo(self.actionBack.mas_top).mas_offset(-20 * UI_H_SCALE);
            make.width.mas_equalTo(SCREEN_WIDTH * ((self.panel.height - 149 * UI_H_SCALE) / SCREEN_HEIGHT));
        }];
    }
    return self;
}

#pragma mark - public
- (void)showWithImage:(UIImage *)image{
    self.imageView.image = image;
    [super showWithPanelView:self.panel];
}

#pragma mark - 分享图片
- (void)share{
    ZYShareMenu *menu = [ZYShareMenu new];
    menu.shareType = ZYShareTypeImage;
    menu.shareImage = _imageView.image;
    [menu show];
}

#pragma mark - getter
- (UIView *)panel{
    if(!_panel){
        _panel = [UIView new];
        _panel.cornerRadius = 8;
        _panel.clipsToBounds = YES;
        _panel.backgroundColor = VIEW_COLOR;
        _panel.size = CGSizeMake(280 * UI_H_SCALE, 362* UI_H_SCALE);
    }
    return _panel;
}

- (UIView *)actionBack{
    if(!_actionBack){
        _actionBack = [UIView new];
        _actionBack.backgroundColor = UIColor.whiteColor;
    }
    return _actionBack;
}

- (UIView *)topBack{
    if(!_topBack){
        _topBack = [UIView new];
        _topBack.backgroundColor = UIColor.whiteColor;
    }
    return _topBack;
}

- (UIImageView *)imageView{
    if(!_imageView){
        _imageView = [UIImageView new];
        _imageView.clipsToBounds = YES;
        _imageView.backgroundColor = VIEW_COLOR;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

- (ZYElasticButton *)closeBtn{
    if(!_closeBtn){
        _closeBtn = [ZYElasticButton new];
        [_closeBtn setImage:[UIImage imageNamed:@"zy_sheet_close_gray"] forState:UIControlStateNormal];
        [_closeBtn setImage:[UIImage imageNamed:@"zy_sheet_close_gray"] forState:UIControlStateHighlighted];
        
        __weak __typeof__(self) weakSelf = self;
        [_closeBtn clickAction:^(UIButton * _Nonnull button) {
            [weakSelf dismiss];
        }];
    }
    return _closeBtn;
}

- (ZYElasticButton *)consultBtn{
    if(!_consultBtn){
        _consultBtn = [ZYElasticButton new];
        _consultBtn.shouldRound = YES;
        _consultBtn.borderColor = BTN_COLOR_NORMAL_GREEN;
        _consultBtn.borderWidth = 1;
        _consultBtn.font = FONT(15);
        [_consultBtn setTitleColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateNormal];
        [_consultBtn setTitleColor:BTN_COLOR_HEIGHTLIGHT_GREEN forState:UIControlStateHighlighted];
        [_consultBtn setTitle:@"咨询" forState:UIControlStateNormal];
        
        __weak __typeof__(self) weakSelf = self;
        [_consultBtn clickAction:^(UIButton * _Nonnull button) {
            [weakSelf dismiss];
            [[ZYRouter router] goWithoutHead:@"service"];
        }];
    }
    return _consultBtn;
}

- (ZYElasticButton *)shareBtn{
    if(!_shareBtn){
        _shareBtn = [ZYElasticButton new];
        _shareBtn.shouldRound = YES;
        _shareBtn.font = FONT(15);
        [_shareBtn setBackgroundColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateNormal];
        [_shareBtn setBackgroundColor:BTN_COLOR_HEIGHTLIGHT_GREEN forState:UIControlStateHighlighted];
        [_shareBtn setTitle:@"分享" forState:UIControlStateNormal];
        [_shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        __weak __typeof__(self) weakSelf = self;
        [_shareBtn clickAction:^(UIButton * _Nonnull button) {
            [weakSelf dismiss];
            [weakSelf share];
        }];
    }
    return _shareBtn;
}

@end
