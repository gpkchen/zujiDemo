//
//  ZYUpdateAlert.m
//  Apollo
//
//  Created by 李明伟 on 2018/5/25.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYUpdateAlert.h"
#import "GetAppVersionInfo.h"

static NSString * const kAppUpdateCancelKey = @"kAppUpdateCancelKey";

@interface ZYUpdateAlert ()

@property (nonatomic , strong) UIView *baseView;
@property (nonatomic , strong) UIView *panel;
@property (nonatomic , strong) UIImageView *backIV;
@property (nonatomic , strong) ZYElasticButton *closeBtn;
@property (nonatomic , strong) UILabel *wifiLab;
@property (nonatomic , strong) ZYElasticButton *downloadBtn;
@property (nonatomic , strong) UILabel *contentLab;

@property (nonatomic , strong) _m_GetAppVersionInfo *model;

@end

@implementation ZYUpdateAlert

- (instancetype)init{
    if(self = [super init]){
        [self initWidgets];
    }
    return self;
}

#pragma mark - 初始化控件
- (void)initWidgets{
    self.shouldTapToDissmiss = NO;
    
    [self.baseView addSubview:self.panel];
    [self.panel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.baseView);
        make.bottom.equalTo(self.baseView).mas_offset(-48 * UI_H_SCALE);
    }];
    
    [self.baseView addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.bottom.equalTo(self.baseView);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [self.panel addSubview:self.backIV];
    [self.backIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.panel);
        make.height.mas_equalTo(136 * UI_H_SCALE);
    }];
    
    [self.panel addSubview:self.wifiLab];
    [self.wifiLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.panel);
        make.centerY.equalTo(self.panel.mas_bottom).mas_offset(-30.5 * UI_H_SCALE);
    }];
    
    [self.panel addSubview:self.downloadBtn];
    [self.downloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.panel).mas_offset(30 * UI_H_SCALE);
        make.right.equalTo(self.panel).mas_offset(-30 * UI_H_SCALE);
        make.height.mas_equalTo(40 * UI_H_SCALE);
        make.centerY.equalTo(self.panel.mas_bottom).mas_offset(-79 * UI_H_SCALE);
    }];
    
    [self.panel addSubview:self.contentLab];
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.panel).mas_offset(30 * UI_H_SCALE);
        make.right.equalTo(self.panel).mas_offset(-30 * UI_H_SCALE);
        make.top.equalTo(self.panel).mas_offset(149 * UI_H_SCALE);
    }];
}

- (void)showWithModel:(_m_GetAppVersionInfo *)model{
    _model = model;
    
    if([APP_BUILD integerValue] >= model.code){
        return;
    }
    if([APP_BUILD integerValue] > model.necessaryFrom){
        NSString *flag = [NSUserDefaults readObjectWithKey:kAppUpdateCancelKey];
        if([flag isEqualToString:[NSString stringWithFormat:@"%d",model.code]]){
            return;
        }
    }
    self.contentLab.text = model.remarks;
    if([APP_BUILD integerValue] <= model.necessaryFrom){
        self.closeBtn.hidden = YES;
    }else{
        self.closeBtn.hidden = NO;
    }
    CGFloat height = [model.remarks boundingRectWithSize:CGSizeMake(240 * UI_H_SCALE, CGFLOAT_MAX)
                                                        options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:@{NSFontAttributeName:FONT(15)}
                                                        context:nil].size.height;
    height += (172 + 149) * UI_H_SCALE;
    self.baseView.size = CGSizeMake(300 * UI_H_SCALE, height);
    [super showWithPanelView:self.baseView];
}

#pragma mark - getter
- (UIView *)panel{
    if(!_panel){
        _panel = [UIView new];
        _panel.clipsToBounds = YES;
        _panel.backgroundColor = [UIColor whiteColor];
        _panel.cornerRadius = 8;
    }
    return _panel;
}

- (UIImageView *)backIV{
    if(!_backIV){
        _backIV = [UIImageView new];
        _backIV.image = [UIImage imageNamed:@"zy_update_back"];
    }
    return _backIV;
}

- (UIView *)baseView{
    if(!_baseView){
        _baseView = [UIView new];
        _baseView.backgroundColor = [UIColor clearColor];
    }
    return _baseView;
}

- (ZYElasticButton *)closeBtn{
    if(!_closeBtn){
        _closeBtn = [ZYElasticButton new];
        _closeBtn.backgroundColor = [UIColor clearColor];
        [_closeBtn setImage:[UIImage imageNamed:@"zy_update_close_btn"] forState:UIControlStateNormal];
        [_closeBtn setImage:[UIImage imageNamed:@"zy_update_close_btn"] forState:UIControlStateHighlighted];
        
        __weak __typeof__(self) weakSelf = self;
        [_closeBtn clickAction:^(UIButton * _Nonnull button) {
            [weakSelf dismiss];
            [NSUserDefaults writeWithObject:[NSString stringWithFormat:@"%d",weakSelf.model.code] forKey:kAppUpdateCancelKey];
        }];
    }
    return _closeBtn;
}

- (UILabel *)wifiLab{
    if(!_wifiLab){
        _wifiLab = [UILabel new];
        _wifiLab.textColor = WORD_COLOR_GRAY_AB;
        _wifiLab.font = FONT(12);
        _wifiLab.text = @"建议在wifi环境下下载";
    }
    return _wifiLab;
}

- (ZYElasticButton *)downloadBtn{
    if(!_downloadBtn){
        _downloadBtn = [ZYElasticButton new];
        _downloadBtn.shouldRound = YES;
        [_downloadBtn setBackgroundColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateNormal];
        [_downloadBtn setBackgroundColor:BTN_COLOR_HEIGHTLIGHT_GREEN forState:UIControlStateHighlighted];
        [_downloadBtn setTitle:@"立即升级" forState:UIControlStateNormal];
        _downloadBtn.font = FONT(15);
        [_downloadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_downloadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        
        __weak __typeof__(self) weakSelf = self;
        [_downloadBtn clickAction:^(UIButton * _Nonnull button) {
            [ZYAppUtils openURL:weakSelf.model.url];
        }];
    }
    return _downloadBtn;
}

- (UILabel *)contentLab{
    if(!_contentLab){
        _contentLab = [UILabel new];
        _contentLab.textColor = WORD_COLOR_BLACK;
        _contentLab.font = FONT(15);
        _contentLab.numberOfLines = 0;
        _contentLab.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _contentLab;
}

@end
