//
//  ZYMediaPlayer.m
//  Apollo
//
//  Created by zhxc on 2018/12/18.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import "ZYMediaPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface ZYMediaPlayer ()

@property (strong, nonatomic) AVPlayer *player;//播放器
@property (strong, nonatomic) AVPlayerItem *item;//播放单元
@property (strong, nonatomic) AVPlayerLayer *playerLayer;//播放界面（layer）

@property (nonatomic, strong) id timeObserverToken;

@property (assign, nonatomic) BOOL isReadToPlay;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) BOOL isPlayed;

@end

@implementation ZYMediaPlayer

- (void)dealloc{
    [self free];
}

#pragma mark - class method
+ (instancetype)playerItemWithURL:(NSURL *)URL{
    ZYMediaPlayer *mediaPlayer = [super new];
    mediaPlayer.url = URL;
    if(URL){
        mediaPlayer.item = [AVPlayerItem playerItemWithURL:URL];
        [mediaPlayer listenToItem];
    }
    mediaPlayer.player = [AVPlayer playerWithPlayerItem:mediaPlayer.item];
    mediaPlayer.playerLayer = [AVPlayerLayer playerLayerWithPlayer:mediaPlayer.player];
    [mediaPlayer.layer addSublayer:mediaPlayer.playerLayer];
    [mediaPlayer listenToPlayer];
    [mediaPlayer addObservers];
    
    return mediaPlayer;
}

+ (instancetype)playerItemWithAsset:(AVAsset *)asset{
    ZYMediaPlayer *mediaPlayer = [super new];
    mediaPlayer.asset = asset;
    if(asset){
        mediaPlayer.item = [AVPlayerItem playerItemWithAsset:asset];
        [mediaPlayer listenToItem];
    }
    mediaPlayer.player = [AVPlayer playerWithPlayerItem:mediaPlayer.item];
    mediaPlayer.playerLayer = [AVPlayerLayer playerLayerWithPlayer:mediaPlayer.player];
    [mediaPlayer.layer addSublayer:mediaPlayer.playerLayer];
    [mediaPlayer listenToPlayer];
    [mediaPlayer addObservers];
    
    return mediaPlayer;
}

#pragma mark - 支持的媒体格式
+ (NSArray *)audiovisualMIMETypes{
    return [AVURLAsset audiovisualMIMETypes];
}

#pragma mark - 恢复其他应用播放媒体
+ (void) replayOtherMedia{
    NSError *error =nil;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    BOOL isSuccess = [session setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
    if (!isSuccess) {
        ZYLog(@"恢复其他播放媒体失败:%@",error);
    }else{
        ZYLog(@"恢复其他播放媒体成功");
    }
}

#pragma mark - 通过URL获取视频宽高比
+ (CGFloat)videoScaleByUrl:(NSURL *)URL{
    if (!URL){
        return 0.0f;
    }
    //获取视频尺寸
    AVURLAsset *asset = [AVURLAsset assetWithURL:URL];
    NSArray *array = asset.tracks;
    CGSize videoSize = CGSizeZero;
    for (AVAssetTrack *track in array) {
        if ([track.mediaType isEqualToString:AVMediaTypeVideo]) {
            videoSize = track.naturalSize;
        }
    }
    return videoSize.height/videoSize.width;
}

#pragma mark - 通过Asset获取视频宽高比
+ (CGFloat)videoScaleByAsset:(AVAsset *)asset{
    if (!asset){
        return 0.0f;
    }
    //获取视频尺寸
    NSArray *array = asset.tracks;
    CGSize videoSize = CGSizeZero;
    for (AVAssetTrack *track in array) {
        if ([track.mediaType isEqualToString:AVMediaTypeVideo]) {
            videoSize = track.naturalSize;
        }
    }
    return videoSize.height/videoSize.width;
}

#pragma mark - 通过URL获取视频缩略图
+ (UIImage *)thumbnailImageFromURL:(NSURL *)URL time:(NSTimeInterval)videoTime{
    if (!URL){
        return nil;
    }
    UIImage *shotImage;
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:URL options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(videoTime, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    shotImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return shotImage;
}

#pragma mark - 通过asset获取视频缩略图
+ (UIImage *)getThumbnailImageFromAsset:(AVAsset *)asset time:(NSTimeInterval)videoTime{
    if (!asset) {
        return nil;
    }
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = videoTime;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 600)
                                                    actualTime:NULL error:nil];
    if (!thumbnailImageRef) {
        return nil;
    }
    UIImage *thumbnailImage = [[UIImage alloc] initWithCGImage:thumbnailImageRef];
    CFRelease(thumbnailImageRef);
    return thumbnailImage;
}

#pragma mark - 播放
- (void)play{
    self.isPlaying = YES;
    self.isPlayed = YES;
    [self.player play];
}

#pragma mark - 暂停
- (void)pause{
    if(self.isPlaying){
        self.isPlaying = NO;
        [self.player pause];
        if([_delegate respondsToSelector:@selector(playerDidPaused:)]){
            [_delegate playerDidPaused:self];
        }
    }
}

#pragma mark - 停止播放
- (void)stop{
    self.isPlayed = NO;
    [self.player pause];
    [self freeItem];
}

#pragma mark - 从第几秒开始播放
- (void)playToTime:(CGFloat)seconds{
    if(self.item){
        [self pause];
        //让视频从指定的CMTime对象处播放。
        CMTime startTime = CMTimeMakeWithSeconds(seconds, self.item.currentTime.timescale);
        //让视频从指定处播放
        [self.player seekToTime:startTime completionHandler:^(BOOL finished) {
            if (finished) {
                [self play];
            }
        }];
    }
}

- (void)seekToBegining{
    [self.player seekToTime:kCMTimeZero];
}

#pragma mark - 增加监听
- (void)listenToItem{
    if(!self.item){
        return;
    }
    [self.item addObserver:self
                forKeyPath:@"status"
                   options:NSKeyValueObservingOptionNew
                   context:nil];
    [self.item addObserver:self
                forKeyPath:@"playbackLikelyToKeepUp"
                   options:NSKeyValueObservingOptionNew
                   context:nil];
    [self.item addObserver:self
                forKeyPath:@"playbackBufferEmpty"
                   options:NSKeyValueObservingOptionNew
                   context:nil];
    [self.item addObserver:self
                forKeyPath:@"loadedTimeRanges"
                   options:NSKeyValueObservingOptionNew
                   context:nil];
}

- (void)listenToPlayer{
    __weak __typeof__(self) weakSelf = self;
    self.timeObserverToken = [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (!strongSelf){
            return;
        }
        if([strongSelf.delegate respondsToSelector:@selector(player:playToSecond:)]){
            [strongSelf.delegate player:strongSelf playToSecond:CMTimeGetSeconds(time)];
        }
    }];
}

- (void)addObservers{
    //播放完毕的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidPlayToEndTime:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
    //耳机插入和拔掉通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(audioRouteChanged:)
                                                 name:AVAudioSessionRouteChangeNotification
                                               object:[AVAudioSession sharedInstance]];
    
    //app失去焦点
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    //监听系统音量变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChange:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

#pragma mark - app失去焦点
- (void)appWillResignActive:(NSNotification *)notification{
    [self pause];
}

- (void)appDidEnterBackground:(NSNotification *)notification{
    [self pause];
}

#pragma mark - 系统音量变化
- (void)volumeChange:(NSNotification *)notification{
    NSString * style = [notification.userInfo objectForKey:@"AVSystemController_AudioVolumeChangeReasonNotificationParameter"];
    if ([style isEqualToString:@"ExplicitVolumeChange"]){
        CGFloat value = [[notification.userInfo objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] doubleValue];
        self.volume = value;
    }
}

#pragma mark - KVO监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]) {
        //取出status的新值
        AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey]intValue];
        if([_delegate respondsToSelector:@selector(player:statusChanged:)]){
            ZYMediaPlayerStatus zyStatus = ZYMediaPlayerStatusFailed;
            if(status == AVPlayerItemStatusReadyToPlay){
                zyStatus = ZYMediaPlayerStatusReady;
            }
            if(status == AVPlayerItemStatusUnknown){
                zyStatus = ZYMediaPlayerStatusUnknown;
            }
            [_delegate player:self statusChanged:zyStatus];
        }
        switch (status) {
            case AVPlayerItemStatusFailed:
                self.isReadToPlay = NO;
                break;
            case AVPlayerItemStatusReadyToPlay:
                self.isReadToPlay = YES;
                break;
            case AVPlayerItemStatusUnknown:
                self.isReadToPlay = NO;
                break;
            default:
                break;
        }
    }else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
        //进行跳转后没数据 即播放卡顿
        if(self.player.currentItem.isPlaybackBufferEmpty){
            dispatch_async(dispatch_get_main_queue(), ^{
                if([self.delegate respondsToSelector:@selector(playerPlaybackBufferEmpty:)]){
                    [self.delegate playerPlaybackBufferEmpty:self];
                }
            });
        }
    }else if([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
        // 进行跳转后有数据 能够继续播放
        if(self.player.currentItem.isPlaybackLikelyToKeepUp){
            dispatch_async(dispatch_get_main_queue(), ^{
                if([self.delegate respondsToSelector:@selector(playerPlaybackLikelyToKeepUp:)]){
                    [self.delegate playerPlaybackLikelyToKeepUp:self];
                }
            });
        }
    }else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        //duration当前缓冲的长度
        if([_delegate respondsToSelector:@selector(player:loadToSecond:)]){
            [_delegate player:self loadToSecond:self.loadedTime];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - 接收到播放完毕通知
- (void)playerItemDidPlayToEndTime:(NSNotification *)notification{
    if([_delegate respondsToSelector:@selector(playerDidPlayToEndTime:)]){
        [_delegate playerDidPlayToEndTime:self];
    }
}

#pragma mark - 接收到耳机事件通知
- (void)audioRouteChanged:(NSNotification*)notification {
    NSDictionary *interuptionDict = notification.userInfo;
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    switch (routeChangeReason) {
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            // 耳机插入
            if(self.isPlaying){
                [self play];
            }
            if([_delegate respondsToSelector:@selector(playerNewDeviceAvailable:)]){
                [_delegate playerNewDeviceAvailable:self];
            }
            break;
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:{
            // 拔掉耳机继续播放
            if(self.isPlaying){
                [self play];
            }
            if([_delegate respondsToSelector:@selector(playerOldDeviceUnavailable:)]){
                [_delegate playerOldDeviceUnavailable:self];
            }
        }
            break;
        case AVAudioSessionRouteChangeReasonCategoryChange:
            break;
    }
}

#pragma mark - 释放
- (void)free{
    [self freeItem];
    [self freePlayer];
    [self freePlayerLayer];
    [self freeObserver];
}

- (void)freeItem{
    if(self.item){
        [self.item cancelPendingSeeks];
        [self.item.asset cancelLoading];
        [self.item removeObserver:self forKeyPath:@"status" context:nil];
        [self.item removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];
        [self.item removeObserver:self forKeyPath:@"playbackBufferEmpty" context:nil];
        [self.item removeObserver:self forKeyPath:@"playbackLikelyToKeepUp" context:nil];
        self.item = nil;
        [self.player replaceCurrentItemWithPlayerItem:nil];
    }
}

- (void)freePlayer{
    if (!self.timeObserverToken){
        return;
    }
    if (self.player){
        [self.player removeTimeObserver:self.timeObserverToken];
        if(self.player.currentItem){
            [self.player replaceCurrentItemWithPlayerItem:nil];
        }
        self.player = nil;
    }
    self.timeObserverToken = nil;
}

- (void)freePlayerLayer{
    if (self.playerLayer) {
        [self.playerLayer removeFromSuperlayer];
        self.playerLayer =nil;
    }
}

- (void)freeObserver{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionRouteChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
}

#pragma mark - getter
- (CGFloat)volume{
    return self.player.volume;
}

- (CGFloat)currentPlayTime{
    if(self.player){
        return CMTimeGetSeconds([self.player currentTime]);
    }
    return 0.0f;
}

- (CGFloat)totalPlayTime{
    if(self.player){
        double duration = CMTimeGetSeconds(self.player.currentItem.duration);
        return duration;
    }
    return 0.0f;
}

- (CGFloat)loadedTime{
    CGFloat loadedDuration = 0.0f;
    if (self.player && self.player.currentItem){
        NSArray *loadedTimeRanges = self.player.currentItem.loadedTimeRanges;
        if (loadedTimeRanges && [loadedTimeRanges count]){
            CMTimeRange timeRange = [[loadedTimeRanges firstObject] CMTimeRangeValue];
            CGFloat startSeconds = CMTimeGetSeconds(timeRange.start);
            CGFloat durationSeconds = CMTimeGetSeconds(timeRange.duration);
            loadedDuration = startSeconds + durationSeconds;
        }
    }
    return loadedDuration;
}

#pragma mark - setter
- (void)setVolume:(CGFloat)volume{
    self.player.volume = volume;
    
    if([_delegate respondsToSelector:@selector(player:volumeChange:)]){
        [_delegate player:self volumeChange:volume];
    }
}

- (void)setUrl:(NSURL *)url{
    _url = url;
    
    if(url && self.player){
        if(self.item){
            [self freeItem];
        }
        self.item = [AVPlayerItem playerItemWithURL:url];
        [self.player replaceCurrentItemWithPlayerItem:self.item];
        [self listenToItem];
    }
    if(!url){
        if(self.item){
            [self freeItem];
        }
    }
}

- (void)setAsset:(AVAsset *)asset{
    _asset = asset;
    
    if(asset && self.player){
        if(self.item){
            [self freeItem];
        }
        self.item = [AVPlayerItem playerItemWithAsset:asset];
        [self.player replaceCurrentItemWithPlayerItem:self.item];
        [self listenToItem];
    }
    if(!asset){
        if(self.item){
            [self freeItem];
        }
    }
}

#pragma mark - override
- (void)layoutSubviews{
    [super layoutSubviews];
    if(self.playerLayer){
        self.playerLayer.frame = self.bounds;
    }
}

@end
