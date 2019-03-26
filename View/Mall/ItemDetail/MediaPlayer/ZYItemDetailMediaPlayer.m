//
//  ZYItemDetailMediaPlayer.m
//  Apollo
//
//  Created by zhxc on 2018/12/24.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import "ZYItemDetailMediaPlayer.h"
#import "ZYMediaPlayer.h"
#import <SDCycleScrollView.h>

@interface ZYItemDetailMediaPlayer ()<ZYMediaPlayerDelegate,SDCycleScrollViewDelegate>

@property (nonatomic , strong) ZYMediaPlayer *player; //播放器
@property (nonatomic , assign) CGFloat oldVolume;
@property (nonatomic , strong) UIImageView *coverIV; //封面
@property (nonatomic , strong) ZYElasticButton *playBtn; //播放按钮
@property (nonatomic , strong) ZYElasticButton *silenceBtn; //静音按钮
@property (nonatomic , strong) UIImageView *volumeIV;
@property (nonatomic , strong) UILabel *timeLab;
@property (nonatomic , strong) SDCycleScrollView *banner;
@property (nonatomic , strong) UILabel *numLab;
@property (nonatomic , strong) ZYElasticButton *videoBtn;
@property (nonatomic , strong) ZYElasticButton *imageBtn;
@property (nonatomic , strong) UIView *cursor;

@property (nonatomic , strong) UIView *progressBack; //banner状态下进度条背景
@property (nonatomic , strong) UIView *loadBar; //banner状态下缓存进度条
@property (nonatomic , strong) UIView *playBar; //banner状态下播放进度条

@property (nonatomic , strong) UISlider *slider; //展开状态下滑块

@property (nonatomic , strong) ZYElasticButton *closeBtn; //关闭按钮
@property (nonatomic , strong) ZYElasticButton *fullScreenBtn; //全屏按钮
@property (nonatomic , strong) UILabel *playedTime; //已播放时间
@property (nonatomic , strong) UILabel *totalTime; //未播放时间

@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) UILabel *priceLab;
@property (nonatomic , strong) ZYElasticButton *collectionBtn;
@property (nonatomic , strong) UILabel *collectionLab;
@property (nonatomic , strong) ZYElasticButton *rentBtn;
@property (nonatomic , strong) UILabel *rentLab;

@property (nonatomic , assign) double totalPlayTime; //视频总时长
@property (nonatomic , assign) BOOL isPaused; //是否切换造成暂停
@property (nonatomic , assign) BOOL isPlaying; //用来判断当前视频是否正在播放
@property (nonatomic , assign) BOOL isComponentShowing; //控件是否正在显示

@property (nonatomic , strong) NSTimer *componentTimer; //控制播放控件定时器
@property (nonatomic , assign) int timerCount;

@property (nonatomic , weak) UIView *preSuperview; //前一个父视图
@property (nonatomic , assign) CGRect unfullPlayerFrame; //全屏播放前播放器位置

@end

@implementation ZYItemDetailMediaPlayer

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:ZYNetworkReachabilityStatusChangedNotification
                                                  object:nil];
}

- (instancetype)init{
    if(self = [super init]){
        self.backgroundColor = UIColor.blackColor;
        self.clipsToBounds = YES;
        self.mode = ZYItemDetailMediaPlayerModeBanner;
        
        self.videoBtn.frame = CGRectMake(SCREEN_WIDTH / 2 - 60, STATUSBAR_HEIGHT + (NAVIGATION_BAR_HEIGHT - STATUSBAR_HEIGHT - 30) / 2, 60, 30);
        [self addSubview:self.videoBtn];
        
        self.imageBtn.frame = CGRectMake(SCREEN_WIDTH / 2, STATUSBAR_HEIGHT + (NAVIGATION_BAR_HEIGHT - STATUSBAR_HEIGHT - 30) / 2, 60, 30);
        [self addSubview:self.imageBtn];
        
        self.cursor.frame = CGRectMake(self.videoBtn.centerX - self.cursor.width / 2, self.videoBtn.bottom, self.cursor.width, self.cursor.height);
        [self addSubview:self.cursor];
        
        self.player.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH);
        [self addSubview:self.player];
        
        self.progressBack.frame = CGRectMake(0, _player.bottom - 3, self.player.width, 3);
        [self.player addSubview:self.progressBack];
        
        self.loadBar.frame = CGRectMake(0, 0, 0, self.progressBack.height);
        [self.progressBack addSubview:self.loadBar];
        
        self.playBar.frame = CGRectMake(0, 0, 0, self.progressBack.height);
        [self.progressBack addSubview:self.playBar];
        
        [self.player addSubview:self.coverIV];
        [self.coverIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.player);
        }];
        
        [self.player addSubview:self.playBtn];
        [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.player);
            make.size.mas_equalTo(CGSizeMake(62, 62));
        }];
        
        [self addSubview:self.closeBtn];
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).mas_offset(5 * UI_H_SCALE);
            make.centerY.equalTo(self.mas_top).mas_offset(STATUSBAR_HEIGHT + (NAVIGATION_BAR_HEIGHT - STATUSBAR_HEIGHT) / 2);
            make.size.mas_equalTo(CGSizeMake(50 * UI_H_SCALE, 50 * UI_H_SCALE));
        }];
        
        [self.player addSubview:self.fullScreenBtn];
        [self.fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.player).mas_offset(-15 * UI_H_SCALE);
            make.bottom.equalTo(self.player).mas_offset(-15 * UI_H_SCALE);
            make.size.mas_equalTo(self.fullScreenBtn.size);
        }];
        
        [self.player addSubview:self.playedTime];
        [self.playedTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.player).mas_offset(15 * UI_H_SCALE);
            make.centerY.equalTo(self.fullScreenBtn);
        }];
        
        [self.player addSubview:self.totalTime];
        [self.totalTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.fullScreenBtn.mas_left).mas_offset(-10 * UI_H_SCALE);
            make.centerY.equalTo(self.fullScreenBtn);
        }];
        
        [self.player addSubview:self.silenceBtn];
        [self.silenceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.player).mas_offset(-10 * UI_H_SCALE);
            make.bottom.equalTo(self.player).mas_offset(-15 * UI_H_SCALE);
            make.size.mas_equalTo(CGSizeMake(41, 41));
        }];
        
        [self.silenceBtn addSubview:self.volumeIV];
        [self.volumeIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.top.equalTo(self.silenceBtn);
        }];
        
        [self.silenceBtn addSubview:self.timeLab];
        [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.bottom.equalTo(self.silenceBtn);
        }];
        
        [self.player addSubview:self.slider];
        [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.player).mas_offset(70);
            make.right.equalTo(self.player).mas_offset(-105);
            make.centerY.equalTo(self.playedTime);
        }];
        
        [self addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).mas_offset(15 * UI_H_SCALE);
            make.right.equalTo(self).mas_offset(-15 * UI_H_SCALE);
            make.top.equalTo(self.player.mas_bottom).mas_offset(55 * UI_H_SCALE);
        }];
        
        [self addSubview:self.priceLab];
        [self.priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).mas_offset(15 * UI_H_SCALE);
            make.top.equalTo(self.titleLab.mas_bottom).mas_offset(10 * UI_H_SCALE);
        }];
        
        [self addSubview:self.collectionBtn];
        [self.collectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).mas_offset(108 * UI_H_SCALE);
            make.bottom.equalTo(self).mas_offset(-40 * UI_H_SCALE - DOWN_DANGER_HEIGHT);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        
        [self addSubview:self.rentBtn];
        [self.rentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).mas_offset(-108 * UI_H_SCALE);
            make.bottom.equalTo(self).mas_offset(-40 * UI_H_SCALE - DOWN_DANGER_HEIGHT);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        
        [self addSubview:self.collectionLab];
        [self.collectionLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.collectionBtn);
            make.top.equalTo(self.collectionBtn.mas_bottom).mas_offset(13 * UI_H_SCALE);
        }];
        
        [self addSubview:self.rentLab];
        [self.rentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.rentBtn);
            make.top.equalTo(self.rentBtn.mas_bottom).mas_offset(13 * UI_H_SCALE);
        }];
       
        //增加网络状态改变通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityStatusChanged) name:ZYNetworkReachabilityStatusChangedNotification
                                                   object:nil];
    }
    return self;
}

#pragma mark - public
- (void)play{
    self.coverIV.hidden = YES;
    if(!self.player.url){
        self.player.url = self.url;
    }
    [self.player play];
    _isPaused = NO;
    
    [self.playBtn setImage:[UIImage imageNamed:@"zy_item_detail_media_pause"] forState:UIControlStateNormal];
    [self.playBtn setImage:[UIImage imageNamed:@"zy_item_detail_media_pause"] forState:UIControlStateHighlighted];
    if(!((_mode == ZYItemDetailMediaPlayerModeOpenUp || _mode == ZYItemDetailMediaPlayerModeFullScreen) && _isComponentShowing)){
        self.playBtn.alpha = 0;
    }
    
    if([ZYHttpClient client].reachabilityStatus == AFNetworkReachabilityStatusReachableViaWWAN){
        [self showMessage:@"正在用运营商流量播放，请注意"];
    }
}

- (void)pause{
    [self.player pause];
    _isPaused = YES;
    
    [self.playBtn setImage:[UIImage imageNamed:@"zy_item_detail_media_play"] forState:UIControlStateNormal];
    [self.playBtn setImage:[UIImage imageNamed:@"zy_item_detail_media_play"] forState:UIControlStateHighlighted];
}

- (void)free{
    if(_componentTimer){
        [_componentTimer invalidate];
        _componentTimer = nil;
    }
    [self.player free];
}

- (void)reset{
    [self.player seekToBegining];
    [self.player pause];
    self.playBtn.alpha = 1;
    [self.playBtn setImage:[UIImage imageNamed:@"zy_item_detail_media_play"] forState:UIControlStateNormal];
    [self.playBtn setImage:[UIImage imageNamed:@"zy_item_detail_media_play"] forState:UIControlStateHighlighted];
    self.coverIV.hidden = NO;
}

#pragma mark - 播放器点击事件
- (void)playerTapped{
    _timerCount = 0;
    if(_componentTimer){
        [_componentTimer invalidate];
        _componentTimer = nil;
    }
    if(_mode == ZYItemDetailMediaPlayerModeBanner && self.player.isPlaying){
        self.mode = ZYItemDetailMediaPlayerModeOpenUp;
    }else if(_mode == ZYItemDetailMediaPlayerModeOpenUp || _mode == ZYItemDetailMediaPlayerModeFullScreen){
        if(self.isComponentShowing){
            [self hideComponent];
        }else{
            [self showComponents];
            //开启定时器
            _componentTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                               target:self
                                                             selector:@selector(timerRun)
                                                             userInfo:nil
                                                              repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:_componentTimer forMode:NSRunLoopCommonModes];
        }
    }
}

#pragma mark - 控制播放组件显示定时器
- (void)timerRun{
    if(_timerCount >= 3){
        if(_componentTimer){
            [_componentTimer invalidate];
            _componentTimer = nil;
        }
        [self hideComponent];
    }
    _timerCount++;
}

#pragma mark - 网络连接状态改变
- (void)reachabilityStatusChanged{
    if(self.player.isPlayed && [ZYHttpClient client].reachabilityStatus == AFNetworkReachabilityStatusReachableViaWWAN){
        [self showMessage:@"正在用运营商流量播放，请注意"];
    }
}

#pragma mark - 滑块滑动事件
- (void)sliderValueChanged:(UISlider *)slider{
    _timerCount = 0;
    [self.player playToTime:slider.value];
    
    [self.playBtn setImage:[UIImage imageNamed:@"zy_item_detail_media_pause"] forState:UIControlStateNormal];
    [self.playBtn setImage:[UIImage imageNamed:@"zy_item_detail_media_pause"] forState:UIControlStateHighlighted];
    if(!_isComponentShowing){
        self.playBtn.alpha = 0;
    }
    self.coverIV.hidden = YES;
    if([ZYHttpClient client].reachabilityStatus == AFNetworkReachabilityStatusReachableViaWWAN){
        [self showMessage:@"正在用运营商流量播放，请注意"];
    }
}

#pragma mark - 显示提示
- (void)showMessage:(NSString *)message{
    if(message.length){
        UILabel *lab = [UILabel new];
        lab.textColor = UIColor.whiteColor;
        lab.font = FONT(14);
        lab.text = message;
        [lab sizeToFit];
        lab.size = CGSizeMake(lab.size.width + 40 * UI_H_SCALE, lab.size.height + 15 * UI_H_SCALE);
        lab.clipsToBounds = YES;
        lab.cornerRadius = lab.height / 2;
        lab.textAlignment = NSTextAlignmentCenter;
        lab.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.7f];
        [self.player addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.player);
            make.size.mas_equalTo(lab.size);
        }];
        
        lab.alpha = 0;
        [UIView animateWithDuration:0.25 animations:^{
            lab.alpha = 1;
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.25
                             animations:^{
                                 lab.alpha = 0;
                             } completion:^(BOOL finished) {
                                 [lab removeFromSuperview];
                             }];
        });
    }
}

#pragma mark - ZYMediaPlayerDelegate
- (void)player:(ZYMediaPlayer *)player statusChanged:(ZYMediaPlayerStatus)status{
    switch (status) {
        case ZYMediaPlayerStatusReady:{
            _totalPlayTime = self.player.totalPlayTime;
            self.slider.minimumValue = 0;
            self.slider.maximumValue = _totalPlayTime;
            
            int minutes = _totalPlayTime / 60;
            int seconds = _totalPlayTime - minutes * 60;
            NSString *m = [NSString stringWithFormat:minutes > 9 ? @"%d" : @"0%d",minutes];
            NSString *s = [NSString stringWithFormat:seconds > 9 ? @"%d" : @"0%d",seconds];
            self.totalTime.text = [NSString stringWithFormat:@"%@:%@",m,s];
            self.timeLab.text = self.totalTime.text;
        }
            break;
        case ZYMediaPlayerStatusUnknown:
        case ZYMediaPlayerStatusFailed:
            [self showMessage:@"加载失败，检查网络是否连接"];
            self.player.url = nil;
            [self reset];
            break;
            
        default:
            break;
    }
}

- (void)player:(ZYMediaPlayer *)player playToSecond:(double)second{
    if(self.totalPlayTime){
        self.playBar.width = self.player.width * (second / self.totalPlayTime);
        self.slider.value = second;
        
        int minutes = second / 60;
        int seconds = second - minutes * 60;
        NSString *m = [NSString stringWithFormat:minutes > 9 ? @"%d" : @"0%d",minutes];
        NSString *s = [NSString stringWithFormat:seconds > 9 ? @"%d" : @"0%d",seconds];
        self.playedTime.text = [NSString stringWithFormat:@"%@:%@",m,s];
        
        double rest = self.totalPlayTime - second;
        minutes = rest / 60;
        seconds = rest - minutes * 60;
        m = [NSString stringWithFormat:minutes > 9 ? @"%d" : @"0%d",minutes];
        s = [NSString stringWithFormat:seconds > 9 ? @"%d" : @"0%d",seconds];
        self.timeLab.text = [NSString stringWithFormat:@"%@:%@",m,s];
    }
}

- (void)player:(ZYMediaPlayer *)player loadToSecond:(double)second{
    if(self.totalPlayTime){
        self.loadBar.width = self.player.width * (second / self.totalPlayTime);
    }
}

- (void)playerDidPaused:(ZYMediaPlayer *)player{
    self.playBtn.alpha = 1;
    [self.playBtn setImage:[UIImage imageNamed:@"zy_item_detail_media_play"] forState:UIControlStateNormal];
    [self.playBtn setImage:[UIImage imageNamed:@"zy_item_detail_media_play"] forState:UIControlStateHighlighted];
}

- (void)playerPlaybackBufferEmpty:(ZYMediaPlayer *)player{
    
}

- (void)playerPlaybackLikelyToKeepUp:(ZYMediaPlayer *)player{
    
}

- (void)playerDidPlayToEndTime:(ZYMediaPlayer *)player{
    [self reset];
}

- (void)playerNewDeviceAvailable:(ZYMediaPlayer *)player{
    
}

- (void)playerOldDeviceUnavailable:(ZYMediaPlayer *)player{
    
}

- (void)player:(ZYMediaPlayer *)player volumeChange:(CGFloat)volume{
    if(volume == 0 && _mode == ZYItemDetailMediaPlayerModeBanner){
        self.silenceBtn.hidden = NO;
    }else{
        self.silenceBtn.hidden = YES;
    }
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    self.numLab.text = [NSString stringWithFormat:@"%d/%d",(int)index + 1,(int)_images.count];
}

#pragma mark - setter
- (void)setUrl:(NSURL *)url{
    _url = url;
    
    if(url){
        if([ZYHttpClient client].reachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi){
            [self play];
        }
    }
}

- (void)setImages:(NSArray *)images{
    _images = images;
    self.banner.imageURLStringsGroup = images;
    self.numLab.text = [NSString stringWithFormat:@"%d/%d",1,(int)images.count];
}

- (void)setCoverUrl:(NSString *)coverUrl{
    _coverUrl = coverUrl;
    
    [self.coverIV loadImage:coverUrl];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    
    self.titleLab.text = title;
}

- (void)setPrice:(NSAttributedString *)price{
    _price = price;
    self.priceLab.attributedText = price;
}

- (void)setMode:(ZYItemDetailMediaPlayerMode)mode{
    
    [self setNeedsLayout];
    if((_mode == ZYItemDetailMediaPlayerModeOpenUp || _mode == ZYItemDetailMediaPlayerModeFullScreen) && mode == ZYItemDetailMediaPlayerModeBanner){
        if(self.player.volume == 0){
            self.silenceBtn.hidden = NO;
        }else{
            self.silenceBtn.hidden = YES;
        }
        [self showVideo];
        [UIView animateWithDuration:0.25
                         animations:^{
                             if(self.player.isPlaying){
                                 self.playBtn.alpha = 0;
                             }
                             self.collectionBtn.alpha = 0;
                             self.collectionLab.alpha = 0;
                             self.rentBtn.alpha = 0;
                             self.rentLab.alpha = 0;
                             self.priceLab.alpha = 0;
                             self.titleLab.alpha = 0;
                             self.slider.alpha = 0;
                             self.playedTime.alpha = 0;
                             self.totalTime.alpha = 0;
                             self.fullScreenBtn.alpha = 0;
                             self.closeBtn.alpha = 0;
                             self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH);
                             self.player.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH);
                             [self layoutIfNeeded];
                         } completion:^(BOOL finished) {
                             [self removeFromSuperview];
                             [self.preSuperview insertSubview:self atIndex:0];
                             self.progressBack.alpha = 1;
                         }];
    }
    
    if(_mode == ZYItemDetailMediaPlayerModeBanner && mode == ZYItemDetailMediaPlayerModeOpenUp){
        self.silenceBtn.hidden = YES;
        _preSuperview = self.superview;
        [self removeFromSuperview];
        [SCREEN addSubview:self];
        
        self.progressBack.alpha = 0;
        [UIView animateWithDuration:0.25
                         animations:^{
                             self.collectionBtn.alpha = 1;
                             self.collectionLab.alpha = 1;
                             self.rentBtn.alpha = 1;
                             self.rentLab.alpha = 1;
                             self.priceLab.alpha = 1;
                             self.titleLab.alpha = 1;
                             self.closeBtn.alpha = 1;
                             self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                             self.player.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_WIDTH);
                             [self layoutIfNeeded];
                         } completion:^(BOOL finished) {
                             
                         }];
    }
    
    if(mode == ZYItemDetailMediaPlayerModeFullScreen){
        self.silenceBtn.hidden = YES;
        [self bringSubviewToFront:self.player];
        [self.fullScreenBtn setImage:[UIImage imageNamed:@"zy_item_detail_media_unfull_screen"] forState:UIControlStateNormal];
        [self.fullScreenBtn setImage:[UIImage imageNamed:@"zy_item_detail_media_unfull_screen"] forState:UIControlStateHighlighted];
        _unfullPlayerFrame = self.player.frame;
        [UIView animateWithDuration:0.25 animations:^{
            self.player.transform = CGAffineTransformMakeRotation(M_PI / 2);
            self.player.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        }];
    }
    
    if(_mode == ZYItemDetailMediaPlayerModeFullScreen && mode == ZYItemDetailMediaPlayerModeOpenUp){
        [self.fullScreenBtn setImage:[UIImage imageNamed:@"zy_item_detail_media_full_screen"] forState:UIControlStateNormal];
        [self.fullScreenBtn setImage:[UIImage imageNamed:@"zy_item_detail_media_full_screen"] forState:UIControlStateHighlighted];
        [UIView animateWithDuration:0.25 animations:^{
            self.player.transform = CGAffineTransformMakeRotation(0);
            self.player.frame = self.unfullPlayerFrame;
        }];
    }
    
    _mode = mode;
}

#pragma mark - 显示控件
- (void)showComponents{
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.playBtn.alpha = 1;
                         self.slider.alpha = 1;
                         self.playedTime.alpha = 1;
                         self.totalTime.alpha = 1;
                         self.fullScreenBtn.alpha = 1;
                     } completion:^(BOOL finished) {
                         self.isComponentShowing = YES;
                     }];
}

#pragma mark - 隐藏控件
- (void)hideComponent{
    [UIView animateWithDuration:0.25
                     animations:^{
                         if(self.player.isPlaying){
                             self.playBtn.alpha = 0;
                         }
                         self.slider.alpha = 0;
                         self.playedTime.alpha = 0;
                         self.totalTime.alpha = 0;
                         self.fullScreenBtn.alpha = 0;
                     } completion:^(BOOL finished) {
                         self.isComponentShowing = NO;
                     }];
}

#pragma mark - 显示视频
- (void)showVideo{
    if(self.isPaused){
        [self play];
    }
    self.videoBtn.enabled = NO;
    self.imageBtn.enabled = YES;
    [UIView animateWithDuration:0.25 animations:^{
        self.cursor.centerX = self.videoBtn.centerX;
    }];
    
    self.player.hidden = NO;
    self.titleLab.hidden = NO;
    self.priceLab.hidden = NO;
    self.collectionBtn.hidden = NO;
    self.rentBtn.hidden = NO;
    self.collectionLab.hidden = NO;
    self.rentLab.hidden = NO;
    self.banner.hidden = YES;
    self.numLab.hidden = YES;
}

#pragma mark - 显示图片
- (void)showImages{
    [self pause];
    self.imageBtn.enabled = NO;
    self.videoBtn.enabled = YES;
    [UIView animateWithDuration:0.25 animations:^{
        self.cursor.centerX = self.imageBtn.centerX;
    }];
    
    self.player.hidden = YES;
    self.titleLab.hidden = YES;
    self.priceLab.hidden = YES;
    self.collectionBtn.hidden = YES;
    self.rentBtn.hidden = YES;
    self.collectionLab.hidden = YES;
    self.rentLab.hidden = YES;
    self.banner.hidden = NO;
    self.numLab.hidden = NO;
    
    if(!self.banner.superview){
        [self addSubview:self.banner];
        [self.banner mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.center.equalTo(self);
            make.height.mas_equalTo(SCREEN_WIDTH);
        }];
        
        [self addSubview:self.numLab];
        [self.numLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).mas_offset(-15 * UI_H_SCALE);
            make.top.equalTo(self.banner.mas_bottom).mas_offset(30 * UI_H_SCALE);
            make.size.mas_equalTo(CGSizeMake(45 * UI_H_SCALE, 20 * UI_H_SCALE));
        }];
    }
}

#pragma mark - getter
- (BOOL)isPlaying{
    return self.player.isPlaying;
}

- (ZYElasticButton *)videoBtn{
    if(!_videoBtn){
        _videoBtn = [ZYElasticButton new];
        _videoBtn.backgroundColor = UIColor.clearColor;
        _videoBtn.font = FONT(16);
        [_videoBtn setTitle:@"视频" forState:UIControlStateNormal];
        [_videoBtn setTitleColor:HexRGB(0x999999) forState:UIControlStateNormal];
        [_videoBtn setTitleColor:HexRGB(0x999999) forState:UIControlStateHighlighted];
        [_videoBtn setTitleColor:UIColor.whiteColor forState:UIControlStateDisabled];
        _videoBtn.enabled = NO;
        
        __weak __typeof__(self) weakSelf = self;
        [_videoBtn clickAction:^(UIButton * _Nonnull button) {
            [weakSelf showVideo];
        }];
    }
    return _videoBtn;
}

- (ZYElasticButton *)imageBtn{
    if(!_imageBtn){
        _imageBtn = [ZYElasticButton new];
        _imageBtn.backgroundColor = UIColor.clearColor;
        _imageBtn.font = FONT(16);
        [_imageBtn setTitle:@"图片" forState:UIControlStateNormal];
        [_imageBtn setTitleColor:HexRGB(0x999999) forState:UIControlStateNormal];
        [_imageBtn setTitleColor:HexRGB(0x999999) forState:UIControlStateHighlighted];
        [_imageBtn setTitleColor:UIColor.whiteColor forState:UIControlStateDisabled];
        
        __weak __typeof__(self) weakSelf = self;
        [_imageBtn clickAction:^(UIButton * _Nonnull button) {
            [weakSelf showImages];
        }];
    }
    return _imageBtn;
}

- (UIView *)cursor{
    if(!_cursor){
        _cursor = [UIView new];
        _cursor.backgroundColor = UIColor.whiteColor;
        _cursor.size = CGSizeMake(20, 4);
        _cursor.cornerRadius = 2;
    }
    return _cursor;
}

- (ZYMediaPlayer *)player{
    if(!_player){
        _player = [ZYMediaPlayer playerItemWithURL:_url];
        _player.backgroundColor = UIColor.blackColor;
        _oldVolume = _player.volume;
        _player.volume = 0;
        _player.delegate = self;
        
        __weak __typeof__(self) weakSelf = self;
        [_player tapped:^(UITapGestureRecognizer *gesture) {
            [weakSelf playerTapped];
        } delegate:nil];
    }
    return _player;
}

- (UIImageView *)coverIV{
    if(!_coverIV){
        _coverIV = [UIImageView new];
        _coverIV.contentMode = UIViewContentModeScaleAspectFill;
        _coverIV.clipsToBounds = YES;
    }
    return _coverIV;
}

- (ZYElasticButton *)playBtn{
    if(!_playBtn){
        _playBtn = [ZYElasticButton new];
        _playBtn.backgroundColor = UIColor.clearColor;
        [_playBtn setImage:[UIImage imageNamed:@"zy_item_detail_media_play"] forState:UIControlStateNormal];
        [_playBtn setImage:[UIImage imageNamed:@"zy_item_detail_media_play"] forState:UIControlStateHighlighted];
        
        __weak __typeof__(self) weakSelf = self;
        [_playBtn clickAction:^(UIButton * _Nonnull button) {
            weakSelf.timerCount = 0;
            if(weakSelf.player.isPlaying){
                [weakSelf pause];
            }else{
                [weakSelf play];
            }
        }];
    }
    return _playBtn;
}

- (ZYElasticButton *)silenceBtn{
    if(!_silenceBtn){
        _silenceBtn = [ZYElasticButton new];
        _silenceBtn.backgroundColor = UIColor.clearColor;
        
        __weak __typeof__(self) weakSelf = self;
        [_silenceBtn clickAction:^(UIButton * _Nonnull button) {
            weakSelf.player.volume = weakSelf.oldVolume;
            weakSelf.silenceBtn.hidden = YES;
        }];
    }
    return _silenceBtn;
}

- (UIImageView *)volumeIV{
    if(!_volumeIV){
        _volumeIV = [UIImageView new];
        _volumeIV.image = [UIImage imageNamed:@"zy_item_detail_media_volumn"];
    }
    return _volumeIV;
}

- (UILabel *)timeLab{
    if(!_timeLab){
        _timeLab = [UILabel new];
        _timeLab.textColor = UIColor.whiteColor;
        _timeLab.font = FONT(14);
    }
    return _timeLab;
}

- (SDCycleScrollView *)banner{
    if(!_banner){
        _banner = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:nil placeholderImage:nil];
        _banner.autoScrollTimeInterval = 3;
        _banner.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _banner.showPageControl = NO;
        _banner.delegate = self;
        _banner.backgroundColor = [UIColor whiteColor];
    }
    return _banner;
}

- (UILabel *)numLab{
    if(!_numLab){
        _numLab = [UILabel new];
        _numLab.font = FONT(13);
        _numLab.backgroundColor = HexRGB(0x7a7a7a);
        _numLab.cornerRadius = 10 * UI_H_SCALE;
        _numLab.textColor = UIColor.whiteColor;
        _numLab.clipsToBounds = YES;
        _numLab.hidden = YES;
        _numLab.textAlignment = NSTextAlignmentCenter;
    }
    return _numLab;
}

- (UIView *)progressBack{
    if(!_progressBack){
        _progressBack = [UIView new];
        _progressBack.backgroundColor = HexRGB(0x4d4d4d);
    }
    return _progressBack;
}

- (UIView *)loadBar{
    if(!_loadBar){
        _loadBar = [UIView new];
        _loadBar.backgroundColor = HexRGB(0x949494);
    }
    return _loadBar;
}

- (UIView *)playBar{
    if(!_playBar){
        _playBar = [UIView new];
        _playBar.backgroundColor = HexRGB(0xff6007);
    }
    return _playBar;
}

- (ZYElasticButton *)fullScreenBtn{
    if(!_fullScreenBtn){
        _fullScreenBtn = [ZYElasticButton new];
        _fullScreenBtn.backgroundColor = UIColor.clearColor;
        [_fullScreenBtn setImage:[UIImage imageNamed:@"zy_item_detail_media_full_screen"] forState:UIControlStateNormal];
        [_fullScreenBtn setImage:[UIImage imageNamed:@"zy_item_detail_media_full_screen"] forState:UIControlStateHighlighted];
        [_fullScreenBtn sizeToFit];
        _fullScreenBtn.alpha = 0;
        
        __weak __typeof__(self) weakSelf = self;
        [_fullScreenBtn clickAction:^(UIButton * _Nonnull button) {
            if(weakSelf.mode == ZYItemDetailMediaPlayerModeFullScreen){
                weakSelf.mode = ZYItemDetailMediaPlayerModeOpenUp;
            }else{
                weakSelf.mode = ZYItemDetailMediaPlayerModeFullScreen;
            }
        }];
    }
    return _fullScreenBtn;
}

- (ZYElasticButton *)closeBtn{
    if(!_closeBtn){
        _closeBtn = [ZYElasticButton new];
        _closeBtn.backgroundColor = UIColor.clearColor;
        _closeBtn.alpha = 0;
        [_closeBtn setImage:[UIImage imageNamed:@"zy_item_detail_media_close"] forState:UIControlStateNormal];
        [_closeBtn setImage:[UIImage imageNamed:@"zy_item_detail_media_close"] forState:UIControlStateHighlighted];
        
        __weak __typeof__(self) weakSelf = self;
        [_closeBtn clickAction:^(UIButton * _Nonnull button) {
            weakSelf.mode = ZYItemDetailMediaPlayerModeBanner;
        }];
    }
    return _closeBtn;
}

- (UILabel *)playedTime{
    if(!_playedTime){
        _playedTime = [UILabel new];
        _playedTime.textColor = UIColor.whiteColor;
        _playedTime.font = FONT(14);
        _playedTime.alpha = 0;
        _playedTime.text = @"00:00";
    }
    return _playedTime;
}

- (UILabel *)totalTime{
    if(!_totalTime){
        _totalTime = [UILabel new];
        _totalTime.textColor = UIColor.whiteColor;
        _totalTime.font = FONT(14);
        _totalTime.alpha = 0;
        _totalTime.text = @"00:00";
    }
    return _totalTime;
}

- (UISlider *)slider{
    if(!_slider){
        _slider = [UISlider new];
        _slider.alpha = 0;
        [_slider setMinimumTrackImage:[UIImage imageWithColor:HexRGB(0xff6007) size:CGSizeMake(1, 2)] forState:UIControlStateNormal];
        [_slider setMaximumTrackImage:[UIImage imageWithColor:HexRGB(0x949494) size:CGSizeMake(1, 2)] forState:UIControlStateNormal];
        [_slider setThumbImage:[UIImage imageNamed:@"zy_item_detail_media_slider"] forState:UIControlStateNormal];
        [_slider setThumbImage:[UIImage imageNamed:@"zy_item_detail_media_slider"] forState:UIControlStateHighlighted];
        
        [_slider addTarget:self
                    action:@selector(sliderValueChanged:)
          forControlEvents:UIControlEventValueChanged];
    }
    return _slider;
}

- (UILabel *)titleLab{
    if(!_titleLab){
        _titleLab = [UILabel new];
        _titleLab.textColor = HexRGB(0x999999);
        _titleLab.font = FONT(16);
        _titleLab.numberOfLines = 0;
        _titleLab.alpha = 0;
    }
    return _titleLab;
}

- (UILabel *)priceLab{
    if(!_priceLab){
        _priceLab = [UILabel new];
        _priceLab.textColor = HexRGB(0xfafafa);
        _priceLab.font = MEDIUM_FONT(24);
        _priceLab.alpha = 0;
    }
    return _priceLab;
}

- (ZYElasticButton *)collectionBtn{
    if(!_collectionBtn){
        _collectionBtn = [ZYElasticButton new];
        _collectionBtn.backgroundColor = UIColor.clearColor;
        [_collectionBtn setImage:[UIImage imageNamed:@"zy_item_detail_media_collection"] forState:UIControlStateNormal];
        [_collectionBtn setImage:[UIImage imageNamed:@"zy_item_detail_media_collection"] forState:UIControlStateHighlighted];
        _collectionBtn.alpha = 0;
        
        __weak __typeof__(self) weakSelf = self;
        [_collectionBtn clickAction:^(UIButton * _Nonnull button) {
            !weakSelf.collectionAction ? : weakSelf.collectionAction();
        }];
    }
    return _collectionBtn;
}

- (UILabel *)collectionLab{
    if(!_collectionLab){
        _collectionLab = [UILabel new];
        _collectionLab.textColor = HexRGB(0x999999);
        _collectionLab.font = FONT(12);
        _collectionLab.text = @"收藏";
        _collectionLab.alpha = 0;
    }
    return _collectionLab;
}

- (ZYElasticButton *)rentBtn{
    if(!_rentBtn){
        _rentBtn = [ZYElasticButton new];
        _rentBtn.backgroundColor = UIColor.clearColor;
        [_rentBtn setImage:[UIImage imageNamed:@"zy_item_detail_media_rent"] forState:UIControlStateNormal];
        [_rentBtn setImage:[UIImage imageNamed:@"zy_item_detail_media_rent"] forState:UIControlStateHighlighted];
        _rentBtn.alpha = 0;
        
        __weak __typeof__(self) weakSelf = self;
        [_rentBtn clickAction:^(UIButton * _Nonnull button) {
            [weakSelf pause];
            weakSelf.mode = ZYItemDetailMediaPlayerModeBanner;
            !weakSelf.rentAction ? : weakSelf.rentAction();
        }];
    }
    return _rentBtn;
}

- (UILabel *)rentLab{
    if(!_rentLab){
        _rentLab = [UILabel new];
        _rentLab.textColor = HexRGB(0x999999);
        _rentLab.font = FONT(12);
        _rentLab.text = @"立即租";
        _rentLab.alpha = 0;
    }
    return _rentLab;
}

@end
