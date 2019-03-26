//
//  ZYItemDetailMediaPlayer.h
//  Apollo
//
//  Created by zhxc on 2018/12/24.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**播放器模式*/
typedef NS_ENUM(int , ZYItemDetailMediaPlayerMode) {
    ZYItemDetailMediaPlayerModeBanner = 1, //嵌在banner
    ZYItemDetailMediaPlayerModeOpenUp = 2, //展开
    ZYItemDetailMediaPlayerModeFullScreen = 3, //全屏播放
};


@interface ZYItemDetailMediaPlayer : UIView

@property (nonatomic , assign) ZYItemDetailMediaPlayerMode mode;
@property (nonatomic , strong) NSURL *url;
@property (nonatomic , copy) NSString *coverUrl;
@property (nonatomic , strong) NSArray *images;
@property (nonatomic , copy) NSString *title;
@property (nonatomic , strong) NSAttributedString *price;
@property (nonatomic , copy) void (^collectionAction)(void);
@property (nonatomic , copy) void (^rentAction)(void);

/**是否切换造成暂停*/
@property (nonatomic , assign , readonly) BOOL isPaused;
/**用来判断当前视频是否正在播放*/
@property (nonatomic, assign , readonly) BOOL isPlaying;

- (void)play;
- (void)pause;
- (void)free;

@end

NS_ASSUME_NONNULL_END
