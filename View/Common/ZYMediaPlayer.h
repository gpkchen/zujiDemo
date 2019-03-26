//
//  ZYMediaPlayer.h
//  Apollo
//
//  Created by zhxc on 2018/12/18.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class AVAsset;
@class ZYMediaPlayer;

/**播放状态*/
typedef NS_ENUM(int , ZYMediaPlayerStatus) {
    ZYMediaPlayerStatusFailed = 0,//播放失败
    ZYMediaPlayerStatusReady = 1,//准备好播放
    ZYMediaPlayerStatusUnknown = 2,//播放源出现问题
};

/**代理*/
@protocol ZYMediaPlayerDelegate <NSObject>

@optional
/**播放状态改变*/
- (void)player:(ZYMediaPlayer *)player statusChanged:(ZYMediaPlayerStatus)status;
/**播放中代理*/
- (void)player:(ZYMediaPlayer *)player playToSecond:(double)second;
/**加载中代理*/
- (void)player:(ZYMediaPlayer *)player loadToSecond:(double)second;
/**暂停播放*/
- (void)playerDidPaused:(ZYMediaPlayer *)player;
/**播放卡顿*/
- (void)playerPlaybackBufferEmpty:(ZYMediaPlayer *)player;
/**播放顺畅*/
- (void)playerPlaybackLikelyToKeepUp:(ZYMediaPlayer *)player;
/**播放完毕代理*/
- (void)playerDidPlayToEndTime:(ZYMediaPlayer *)player;
/**耳机插入代理*/
- (void)playerNewDeviceAvailable:(ZYMediaPlayer *)player;
/**耳机拔出代理*/
- (void)playerOldDeviceUnavailable:(ZYMediaPlayer *)player;
/**音量变化*/
- (void)player:(ZYMediaPlayer *)player volumeChange:(CGFloat)volume;

@end


/**播放视图*/
@interface ZYMediaPlayer : UIView


+ (instancetype)alloc __attribute__((unavailable("alloc not available")));
- (instancetype)init __attribute__((unavailable("init not available")));
+ (instancetype)new __attribute__((unavailable("new not available")));

+ (instancetype)playerItemWithURL:(nullable NSURL *)URL;
+ (instancetype)playerItemWithAsset:(nullable AVAsset *)asset;

/**媒体地址*/
@property (nonatomic , strong , nullable) NSURL *url;
/**本地资源*/
@property (nonatomic , strong , nullable) AVAsset *asset;
/**代理*/
@property (nonatomic , weak) id<ZYMediaPlayerDelegate> delegate;

/**音量*/
@property (nonatomic , assign) CGFloat volume;
/**获取当前播放的时间(秒)*/
@property (nonatomic , assign , readonly) CGFloat currentPlayTime;
/**获取视频的总时间长(秒)*/
@property (nonatomic , assign , readonly) CGFloat totalPlayTime;
/**获取缓冲时长(秒)*/
@property (nonatomic , assign , readonly) CGFloat loadedTime;
/**用来判断当前视频是否准备好播放*/
@property (assign, nonatomic , readonly) BOOL isReadToPlay;
/**用来判断当前视频是否正在播放*/
@property (nonatomic, assign , readonly) BOOL isPlaying;
/**用来判断当前视频是否已经开始播放*/
@property (nonatomic, assign , readonly) BOOL isPlayed;

/**支持的媒体格式*/
+ (NSArray *)audiovisualMIMETypes;
/**恢复其他应用播放媒体*/
+ (void)replayOtherMedia;
/**通过URL获取视频宽高比*/
+ (CGFloat)videoScaleByUrl:(NSURL *)URL;
/**通过Asset获取视频宽高比*/
+ (CGFloat)videoScaleByAsset:(AVAsset *)asset;
/**通过URL获取视频缩略图*/
+ (UIImage *)thumbnailImageFromURL:(NSURL *)URL time:(NSTimeInterval)videoTime;
/**通过asset获取视频缩略图*/
+ (UIImage *)getThumbnailImageFromAsset:(AVAsset *)asset time:(NSTimeInterval)videoTime;

/**播放*/
- (void)play;
/**暂停*/
- (void)pause;
/**停止播放*/
- (void)stop;
/**从第几秒开始播放*/
- (void)playToTime:(CGFloat)seconds;
/**回到开头*/
- (void)seekToBegining;
/**释放*/
- (void)free;
- (void)freeItem;
- (void)freePlayer;
- (void)freePlayerLayer;
- (void)freeObserver;

NS_ASSUME_NONNULL_END

@end
