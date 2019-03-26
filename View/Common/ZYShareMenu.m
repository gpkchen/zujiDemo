//
//  ZYShareMenu.m
//  Apollo
//
//  Created by 李明伟 on 2018/5/7.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYShareMenu.h"
#import <UMShare/UMShare.h>
#import "ZYRouterManager.h"

@interface ZYShareMenu ()

@property (nonatomic , strong) UIView *panel;
@property (nonatomic , strong) UILabel *titleLab;

@property (nonatomic , strong) ZYElasticButton *wechatBtn;
@property (nonatomic , strong) UILabel *wechatLab;

@property (nonatomic , strong) ZYElasticButton *momentsBtn;
@property (nonatomic , strong) UILabel *momentsLab;

@property (nonatomic , strong) ZYElasticButton *qqBtn;
@property (nonatomic , strong) UILabel *qqLab;

@property (nonatomic , strong) ZYElasticButton *sinaBtn;
@property (nonatomic , strong) UILabel *sinaLab;

@property (nonatomic , strong) ZYElasticButton *copyBtn;
@property (nonatomic , strong) UILabel *copyLab;

@property (nonatomic , strong) ZYElasticButton *cancelBtn;

@end

@implementation ZYShareMenu

- (instancetype)init{
    if(self = [super init]){
        [self initWidgets];
    }
    return self;
}

- (void)initWidgets{
    [self.panel addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.panel);
        make.height.mas_equalTo(56 * UI_H_SCALE);
        
    }];
    
    [self.panel addSubview:self.wechatBtn];
    [self.panel addSubview:self.momentsBtn];
    [self.panel addSubview:self.qqBtn];
    [self.panel addSubview:self.sinaBtn];
    [self.panel addSubview:self.copyBtn];
    
    [self.panel addSubview:self.wechatLab];
    [self.wechatLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.wechatBtn);
        make.top.equalTo(self.wechatBtn.mas_bottom).mas_offset(8 * UI_H_SCALE);
    }];
    
    [self.panel addSubview:self.momentsLab];
    [self.momentsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.momentsBtn);
        make.top.equalTo(self.momentsBtn.mas_bottom).mas_offset(8 * UI_H_SCALE);
    }];
    
    [self.panel addSubview:self.qqLab];
    [self.qqLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.qqBtn);
        make.top.equalTo(self.qqBtn.mas_bottom).mas_offset(8 * UI_H_SCALE);
    }];
    
    [self.panel addSubview:self.sinaLab];
    [self.sinaLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.sinaBtn);
        make.top.equalTo(self.sinaBtn.mas_bottom).mas_offset(8 * UI_H_SCALE);
    }];
    
    [self.panel addSubview:self.copyLab];
    [self.copyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.copyBtn);
        make.top.equalTo(self.copyBtn.mas_bottom).mas_offset(8 * UI_H_SCALE);
    }];
    
    [self.panel addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.titleLab);
        make.width.mas_equalTo(30 + 30 * UI_H_SCALE);
    }];
}

#pragma mark - 平台按钮事件
- (void)btnAction:(UIButton *)button{
    [self dismiss:nil];
    
    if([button isEqual:self.copyBtn]){
        UIPasteboard *pab = [UIPasteboard generalPasteboard];
        [pab setString:_url];
        [ZYToast showWithTitle:@"链接复制成功"];
        return;
    }
    
    __block UIImage *image = nil;
    if(_icon){
        ZYHud *hud = [ZYHud new];
        [hud show];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.icon]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud dismiss];
                [self share:button image:image];
            });
        });
    }else{
        [self share:button image:[UIImage imageNamed:@"zy_logo_1024"]];
    }
}

#pragma mark - 发起分享
- (void)share:(UIButton *)button image:(UIImage *)image {
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    if(_shareType == ZYShareTypeWeb){
        //分享网址
        //创建分享消息对象
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:_title
                                                                                 descr:_content
                                                                             thumImage:image];
        //设置网页地址
        shareObject.webpageUrl = _url;
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
    }else{
        //分享单张图片
        UMShareImageObject *shareObject = [UMShareImageObject new];
        shareObject.shareImage = _shareImage;
        messageObject.shareObject = shareObject;
    }
    UMSocialPlatformType type = UMSocialPlatformType_UnKnown;
    if([button isEqual:self.wechatBtn]){
        type = UMSocialPlatformType_WechatSession;
    }else if([button isEqual:self.momentsBtn]){
        type = UMSocialPlatformType_WechatTimeLine;
    }else if([button isEqual:self.qqBtn]){
        type = UMSocialPlatformType_QQ;
    }else if([button isEqual:self.sinaBtn]){
        type = UMSocialPlatformType_Sina;
    }
    [[UMSocialManager defaultManager] shareToPlatform:type
                                        messageObject:messageObject
                                currentViewController:[ZYRouterManager manager].viewController
                                           completion:^(id data, NSError *error) {
                                               if (!error) {
                                                   [ZYToast showWithTitle:@"分享成功！"];
                                               }
                                           }];
}

#pragma mark - public
- (void)show{
    self.panelView = self.panel;
    [super show];
}

#pragma mark - setter
- (void)setMainTitle:(NSString *)mainTitle{
    _mainTitle = mainTitle;
    self.titleLab.text = mainTitle;
}

- (void)setShareType:(ZYShareType)shareType{
    _shareType = shareType;
    
    CGFloat sideSpacing; //左右间距
    CGFloat iconSize; //图标大小
    CGFloat spacing; //间距
    if(shareType == ZYShareTypeWeb){
        self.copyBtn.hidden = NO;
        self.copyLab.hidden = NO;
        iconSize = 48;
        sideSpacing = 15 * UI_H_SCALE;
        spacing = (SCREEN_WIDTH - sideSpacing * 2 - iconSize * 5) / 4.0;
    }else{
        self.copyBtn.hidden = YES;
        self.copyLab.hidden = YES;
        iconSize = 48;
        sideSpacing = (SCREEN_WIDTH - iconSize * 4) / 8.0;
        spacing = sideSpacing * 2;
    }
    
    [self.wechatBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.panel).mas_offset(sideSpacing);
        make.top.equalTo(self.panel).mas_offset(86 * UI_H_SCALE);
        make.size.mas_equalTo(CGSizeMake(iconSize, iconSize));
    }];
    [self.momentsBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.wechatBtn.mas_right).mas_offset(spacing);
        make.centerY.equalTo(self.wechatBtn);
        make.size.mas_equalTo(CGSizeMake(iconSize, iconSize));
    }];
    [self.qqBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.momentsBtn.mas_right).mas_offset(spacing);
        make.centerY.equalTo(self.momentsBtn);
        make.size.mas_equalTo(CGSizeMake(iconSize, iconSize));
    }];
    [self.sinaBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.qqBtn.mas_right).mas_offset(spacing);
        make.centerY.equalTo(self.qqBtn);
        make.size.mas_equalTo(CGSizeMake(iconSize, iconSize));
    }];
    [self.copyBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sinaBtn.mas_right).mas_offset(spacing);
        make.centerY.equalTo(self.sinaBtn);
        make.size.mas_equalTo(CGSizeMake(iconSize, iconSize));
    }];
}

#pragma mark - getter
- (UIView *)panel{
    if(!_panel){
        _panel = [UIView new];
        _panel.backgroundColor = VIEW_COLOR;
        _panel.size = CGSizeMake(SCREEN_WIDTH, 210 * UI_H_SCALE);
    }
    return _panel;
}

- (UILabel *)titleLab{
    if(!_titleLab){
        _titleLab = [UILabel new];
        _titleLab.textColor = WORD_COLOR_BLACK;
        _titleLab.backgroundColor = UIColor.whiteColor;
        _titleLab.font = FONT(20);
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.text = @"分享到";
    }
    return _titleLab;
}

- (ZYElasticButton *)wechatBtn{
    if(!_wechatBtn){
        _wechatBtn = [ZYElasticButton new];
        _wechatBtn.backgroundColor = [UIColor clearColor];
        [_wechatBtn setImage:[UIImage imageNamed:@"zy_share_wechat_btn"] forState:UIControlStateNormal];
        [_wechatBtn setImage:[UIImage imageNamed:@"zy_share_wechat_btn"] forState:UIControlStateHighlighted];
        
        __weak __typeof__(self) weakSelf = self;
        [_wechatBtn clickAction:^(UIButton * _Nonnull button) {
            [weakSelf btnAction:button];
            if(weakSelf.shouldStatistics){
                [ZYStatisticsService event:@"share_detail" label:@"微信好友"];
            }
        }];
    }
    return _wechatBtn;
}

- (UILabel *)wechatLab{
    if(!_wechatLab){
        _wechatLab = [UILabel new];
        _wechatLab.textColor = WORD_COLOR_GRAY;
        _wechatLab.font = FONT(14);
        _wechatLab.text = @"微信好友";
    }
    return _wechatLab;
}

- (ZYElasticButton *)momentsBtn{
    if(!_momentsBtn){
        _momentsBtn = [ZYElasticButton new];
        _momentsBtn.backgroundColor = [UIColor clearColor];
        [_momentsBtn setImage:[UIImage imageNamed:@"zy_share_moments_btn"] forState:UIControlStateNormal];
        [_momentsBtn setImage:[UIImage imageNamed:@"zy_share_moments_btn"] forState:UIControlStateHighlighted];
        
        __weak __typeof__(self) weakSelf = self;
        [_momentsBtn clickAction:^(UIButton * _Nonnull button) {
            [weakSelf btnAction:button];
            if(weakSelf.shouldStatistics){
                [ZYStatisticsService event:@"share_detail" label:@"微信朋友圈"];
            }
        }];
    }
    return _momentsBtn;
}

- (UILabel *)momentsLab{
    if(!_momentsLab){
        _momentsLab = [UILabel new];
        _momentsLab.textColor = WORD_COLOR_GRAY;
        _momentsLab.font = FONT(14);
        _momentsLab.text = @"微信朋友圈";
    }
    return _momentsLab;
}

- (ZYElasticButton *)qqBtn{
    if(!_qqBtn){
        _qqBtn = [ZYElasticButton new];
        _qqBtn.backgroundColor = [UIColor clearColor];
        [_qqBtn setImage:[UIImage imageNamed:@"zy_share_qq_btn"] forState:UIControlStateNormal];
        [_qqBtn setImage:[UIImage imageNamed:@"zy_share_qq_btn"] forState:UIControlStateHighlighted];
        
        __weak __typeof__(self) weakSelf = self;
        [_qqBtn clickAction:^(UIButton * _Nonnull button) {
            [weakSelf btnAction:button];
            if(weakSelf.shouldStatistics){
                [ZYStatisticsService event:@"share_detail" label:@"QQ"];
            }
        }];
    }
    return _qqBtn;
}

- (UILabel *)qqLab{
    if(!_qqLab){
        _qqLab = [UILabel new];
        _qqLab.textColor = WORD_COLOR_GRAY;
        _qqLab.font = FONT(14);
        _qqLab.text = @"QQ";
    }
    return _qqLab;
}

- (ZYElasticButton *)sinaBtn{
    if(!_sinaBtn){
        _sinaBtn = [ZYElasticButton new];
        _sinaBtn.backgroundColor = [UIColor clearColor];
        [_sinaBtn setImage:[UIImage imageNamed:@"zy_share_sina_btn"] forState:UIControlStateNormal];
        [_sinaBtn setImage:[UIImage imageNamed:@"zy_share_sina_btn"] forState:UIControlStateHighlighted];
        
        __weak __typeof__(self) weakSelf = self;
        [_sinaBtn clickAction:^(UIButton * _Nonnull button) {
            [weakSelf btnAction:button];
            if(weakSelf.shouldStatistics){
                [ZYStatisticsService event:@"share_detail" label:@"微博"];
            }
        }];
    }
    return _sinaBtn;
}

- (UILabel *)sinaLab{
    if(!_sinaLab){
        _sinaLab = [UILabel new];
        _sinaLab.textColor = WORD_COLOR_GRAY;
        _sinaLab.font = FONT(14);
        _sinaLab.text = @"微博";
    }
    return _sinaLab;
}

- (ZYElasticButton *)copyBtn{
    if(!_copyBtn){
        _copyBtn = [ZYElasticButton new];
        _copyBtn.backgroundColor = [UIColor clearColor];
        [_copyBtn setImage:[UIImage imageNamed:@"zy_share_copy_btn"] forState:UIControlStateNormal];
        [_copyBtn setImage:[UIImage imageNamed:@"zy_share_copy_btn"] forState:UIControlStateHighlighted];
        
        __weak __typeof__(self) weakSelf = self;
        [_copyBtn clickAction:^(UIButton * _Nonnull button) {
            [weakSelf btnAction:button];
            if(weakSelf.shouldStatistics){
                [ZYStatisticsService event:@"share_detail" label:@"复制链接"];
            }
        }];
    }
    return _copyBtn;
}

- (UILabel *)copyLab{
    if(!_copyLab){
        _copyLab = [UILabel new];
        _copyLab.textColor = WORD_COLOR_GRAY;
        _copyLab.font = FONT(14);
        _copyLab.text = @"复制链接";
    }
    return _copyLab;
}

- (ZYElasticButton *)cancelBtn{
    if(!_cancelBtn){
        _cancelBtn = [ZYElasticButton new];
        _cancelBtn.backgroundColor = UIColor.whiteColor;
        [_cancelBtn setImage:[UIImage imageNamed:@"zy_sheet_close_gray"] forState:UIControlStateNormal];
        [_cancelBtn setImage:[UIImage imageNamed:@"zy_sheet_close_gray"] forState:UIControlStateHighlighted];
        
        __weak __typeof__(self) weakSelf = self;
        [_cancelBtn clickAction:^(UIButton * _Nonnull button) {
            [weakSelf dismiss:nil];
        }];
    }
    return _cancelBtn;
}

@end
