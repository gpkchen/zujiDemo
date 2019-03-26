//
//  ZYMainTabVC.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/10.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYMainTabVC.h"
#import "ZYTabBar.h"
#import "ZYFoundVC.h"
#import "ZYMallVC.h"
#import "ZYMineVC.h"
#import "ZYShareVC.h"
#import <SDWebImageDownloader.h>
#import "ZYApnsHelper.h"
#import "ZYEnvirSwitch.h"
#import "ZYActivityService.h"
#import "ZYMainTabAnimation.h"

const static CGFloat kTabbarItemWidth = 24.0;
const static CGFloat kTabbarItemHeight = 49.0;

@interface ZYMainTabVC ()<UITabBarControllerDelegate>

@property (nonatomic , strong) ZYFoundVC *foundVC;
@property (nonatomic , strong) ZYMallVC *mallVC;
@property (nonatomic , strong) ZYMineVC *mineVC;
@property (nonatomic , strong) ZYShareVC *shareVC;

@property (nonatomic , strong) ZYBaseNC *foundNC;
@property (nonatomic , strong) ZYBaseNC *mallNC;
@property (nonatomic , strong) ZYBaseNC *mineNC;
@property (nonatomic , strong) ZYBaseNC *shareNC;

@property (nonatomic , strong) UIImageView *bottomIV;
@property (nonatomic , strong) UIImageView *foundIV;
@property (nonatomic , strong) UIImageView *mallIV;
@property (nonatomic , strong) UIImageView *mineIV;
@property (nonatomic , strong) UIImageView *shareIV;

//自定义tabbar图片
@property (nonatomic , strong) UIImage *bottomImage;
@property (nonatomic , strong) UIImage *foundImg;
@property (nonatomic , strong) UIImage *foundImgSelected;
@property (nonatomic , strong) UIImage *mallImg;
@property (nonatomic , strong) UIImage *mallImgSelected;
@property (nonatomic , strong) UIImage *shareImg;
@property (nonatomic , strong) UIImage *shareImgSelected;
@property (nonatomic , strong) UIImage *mineImg;
@property (nonatomic , strong) UIImage *mineImgSelected;

@end

@implementation ZYMainTabVC

+ (instancetype)shareInstance{
    static ZYMainTabVC *_instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instance = [[ZYMainTabVC alloc] init];
    });
    
    return _instance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    [self initTabBack];
    [self addChildVCs];
    self.selectedIndex = 1;
    //加载活动
    [ZYActivityService loadActivity:ZYActivitySceneLaunch];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self dealIcons];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //处理待处理的推送任务
    [[ZYApnsHelper helper] handlePendingTask];
    
#ifdef Archive_Develope
    [ZYEnvirSwitch show];
#endif
}

#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
    BOOL should = NO;
    __weak __typeof__(self) weakSelf = self;
    if([viewController isEqual:self.shareNC]){
        if(![ZYUser user].isUserLogined){
            [[ZYLoginService service] requireLogin:^{
                weakSelf.selectedViewController = weakSelf.shareNC;
                [self setupImages:2];
            }];
            should = NO;
        }else{
            should = YES;
        }
    }else{
        should = YES;
    }
    
    //处理图片切换
    if(should){
        int index = -1;
        if([viewController isEqual:self.foundNC]){
            index = 0;
        }else if([viewController isEqual:self.mallNC]){
            index = 1;
        }else if([viewController isEqual:self.shareNC]){
            index = 2;
        }else if([viewController isEqual:self.mineNC]){
            index = 3;
        }
        [self setupImages:index];
    }
    return should;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController
                     animationControllerForTransitionFromViewController:(UIViewController *)fromVC
                                                       toViewController:(UIViewController *)toVC{
    if(fromVC && toVC){
        ZYMainTabAnimation *animation = [ZYMainTabAnimation new];
        NSUInteger fromIndex = [self.viewControllers indexOfObject:fromVC];
        NSUInteger toIndex = [self.viewControllers indexOfObject:toVC];
        animation.isLeft = toIndex < fromIndex;
        return animation;
    }
    return nil;
}

#pragma mark - 处理图片
- (void)setupImages:(int)selecteIndex{
    if(!self.foundIV.isHidden){
        self.foundIV.image = selecteIndex == 0 ? _foundImgSelected : _foundImg;
    }
    if(!self.mallIV.isHidden){
        self.mallIV.image = selecteIndex == 1 ? _mallImgSelected : _mallImg;
    }
    if(!self.shareIV.isHidden){
        self.shareIV.image = selecteIndex == 2 ? _shareImgSelected : _shareImg;
    }
    if(!self.mineIV.isHidden){
        self.mineIV.image = selecteIndex == 3 ? _mineImgSelected : _mineImg;
    }
}

#pragma mark - 添加子控制器
- (void)addChildVCs{
    [self addChildViewController:self.foundNC];
    [self addChildViewController:self.mallNC];
    [self addChildViewController:self.shareNC];
    [self addChildViewController:self.mineNC];
}

#pragma mark - 处理图标
- (void)dealIcons{
    ZYUser *user = [ZYUser user];
    __weak __typeof__(self) weakSelf = self;
    if(user.bottomImageUrl && !self.bottomImage){
        [self downloadImg:user.bottomImageUrl finish:^(UIImage *image) {
            weakSelf.bottomImage = image;
            [weakSelf showIcons];
        }];
    }
    if(user.foundImg && !self.foundImg){
        [self downloadImg:user.foundImg finish:^(UIImage *image) {
            weakSelf.foundImg = image;
            [weakSelf showIcons];
        }];
    }
    if(user.foundImgSelected && !self.foundImgSelected){
        [self downloadImg:user.foundImgSelected finish:^(UIImage *image) {
            weakSelf.foundImgSelected = image;
            [weakSelf showIcons];
        }];
    }
    if(user.mallImg && !self.mallImg){
        [self downloadImg:user.mallImg finish:^(UIImage *image) {
            weakSelf.mallImg = image;
            [weakSelf showIcons];
        }];
    }
    if(user.mallImgSelected && !self.mallImgSelected){
        [self downloadImg:user.mallImgSelected finish:^(UIImage *image) {
            weakSelf.mallImgSelected = image;
            [weakSelf showIcons];
        }];
    }
    if(user.shareImg && !self.shareImg){
        [self downloadImg:user.shareImg finish:^(UIImage *image) {
            weakSelf.shareImg = image;
            [weakSelf showIcons];
        }];
    }
    if(user.shareImgSelected && !self.shareImgSelected){
        [self downloadImg:user.shareImgSelected finish:^(UIImage *image) {
            weakSelf.shareImgSelected = image;
            [weakSelf showIcons];
        }];
    }
    if(user.mineImg && !self.mineImg){
        [self downloadImg:user.mineImg finish:^(UIImage *image) {
            weakSelf.mineImg = image;
            [weakSelf showIcons];
        }];
    }
    if(user.mineImgSelected && !self.mineImgSelected){
        [self downloadImg:user.mineImgSelected finish:^(UIImage *image) {
            weakSelf.mineImgSelected = image;
            [weakSelf showIcons];
        }];
    }
}

#pragma mark - 显示图标
- (void)showIcons{
    
    if(self.foundImg && self.foundImgSelected &&
       self.foundImg && self.foundImgSelected &&
       self.mallImg && self.mallImgSelected &&
       self.shareImg && self.shareImgSelected &&
       self.mineImg && self.mineImgSelected &&
       self.bottomImage){
        
        self.bottomIV.hidden = NO;
        self.bottomIV.image = self.bottomImage;
        
        self.foundVC.tabBarItem.image = nil;
        self.foundVC.tabBarItem.selectedImage = nil;
        self.foundVC.tabBarItem.title = nil;
        self.foundIV.hidden = NO;
        self.foundIV.image = self.selectedIndex == 0 ? self.foundImgSelected : self.foundImg;
        
        self.mallVC.tabBarItem.image = nil;
        self.mallVC.tabBarItem.selectedImage = nil;
        self.mallVC.tabBarItem.title = nil;
        self.mallIV.hidden = NO;
        self.mallIV.image = self.selectedIndex == 1 ? self.mallImgSelected : self.mallImg;
        
        self.shareVC.tabBarItem.image = nil;
        self.shareVC.tabBarItem.selectedImage = nil;
        self.shareVC.tabBarItem.title = nil;
        self.shareIV.hidden = NO;
        self.shareIV.image = self.selectedIndex == 2 ? self.shareImgSelected : self.shareImg;
        
        self.mineVC.tabBarItem.image = nil;
        self.mineVC.tabBarItem.selectedImage = nil;
        self.mineVC.tabBarItem.title = nil;
        self.mineIV.hidden = NO;
        self.mineIV.image = self.selectedIndex == 3 ? self.mineImgSelected : self.mineImg;
        
    }
}

#pragma mark - 下载图标
- (void)downloadImg:(NSString *)url finish:(void(^)(UIImage *image))finish{
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:url]
                                                          options:SDWebImageDownloaderLowPriority | NSURLRequestUseProtocolCachePolicy
                                                         progress:nil
                                                        completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                                                            !finish ? : finish(image);
                                                        }];
}

#pragma mark - 初始化Tab栏背景
- (void)initTabBack{
    [self.tabBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    [self.tabBar setShadowImage:[UIImage imageWithColor:HexRGB(0xf2f2f2)]];
    self.tabBar.tintColor = [UIColor blackColor];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:WORD_COLOR_BLACK,
                                                       NSForegroundColorAttributeName, nil]
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:WORD_COLOR_BLACK,
                                                       NSForegroundColorAttributeName, nil]
                                             forState:UIControlStateSelected];
    
    [self.tabBar addSubview:self.bottomIV];
    [self.tabBar addSubview:self.foundIV];
    [self.tabBar addSubview:self.mallIV];
    [self.tabBar addSubview:self.shareIV];
    [self.tabBar addSubview:self.mineIV];
}

#pragma mark - setter
- (void)setSelectedIndex:(NSUInteger)selectedIndex{
    [super setSelectedIndex:selectedIndex];
    
    [self setupImages:(int)selectedIndex];
}

#pragma mark - getter
- (ZYBaseNC *)currentNC{
    return self.viewControllers[self.selectedIndex];
}

- (ZYFoundVC *)foundVC{
    if(!_foundVC){
        _foundVC = [ZYFoundVC new];
        _foundVC.tabBarItem.title = @"发现";
        _foundVC.tabBarItem.image = [[UIImage imageNamed:@"zy_tab_found_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _foundVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"zy_tab_found_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return _foundVC;
}

- (ZYMallVC *)mallVC{
    if(!_mallVC){
        _mallVC = [ZYMallVC new];
        _mallVC.tabBarItem.title = @"商城";
        _mallVC.tabBarItem.image = [[UIImage imageNamed:@"zy_tab_mall_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _mallVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"zy_tab_mall_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return _mallVC;
}

- (ZYShareVC *)shareVC{
    if(!_shareVC){
        _shareVC = [ZYShareVC new];
        _shareVC.tabBarItem.title = @"赚佣金";
        _shareVC.tabBarItem.image = [[UIImage imageNamed:@"zy_tab_share_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _shareVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"zy_tab_share_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return _shareVC;
}

- (ZYMineVC *)mineVC{
    if(!_mineVC){
        _mineVC = [ZYMineVC new];
        _mineVC.tabBarItem.title = @"我的";
        _mineVC.tabBarItem.image = [[UIImage imageNamed:@"zy_tab_mine_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _mineVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"zy_tab_mine_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return _mineVC;
}

- (ZYBaseNC *)foundNC{
    if(!_foundNC){
        _foundNC = [[ZYBaseNC alloc] initWithRootViewController:self.foundVC];
    }
    return _foundNC;
}

- (ZYBaseNC *)mallNC{
    if(!_mallNC){
        _mallNC = [[ZYBaseNC alloc] initWithRootViewController:self.mallVC];
    }
    return _mallNC;
}

- (ZYBaseNC *)shareNC{
    if(!_shareNC){
        _shareNC = [[ZYBaseNC alloc] initWithRootViewController:self.shareVC];
    }
    return _shareNC;
}

- (ZYBaseNC *)mineNC{
    if(!_mineNC){
        _mineNC = [[ZYBaseNC alloc] initWithRootViewController:self.mineVC];
    }
    return _mineNC;
}

- (UIImageView *)bottomIV{
    if(!_bottomIV){
        _bottomIV = [UIImageView new];
        _bottomIV.contentMode = UIViewContentModeScaleAspectFill;
        _bottomIV.clipsToBounds = YES;
        _bottomIV.hidden = YES;
        _bottomIV.frame = CGRectMake(0,0,SCREEN_WIDTH,TABBAR_HEIGHT);
    }
    return _bottomIV;
}

- (UIImageView *)foundIV{
    if(!_foundIV){
        _foundIV = [UIImageView new];
        _foundIV.contentMode = UIViewContentModeScaleAspectFill;
        _foundIV.hidden = YES;
        _foundIV.frame = CGRectMake((SCREEN_WIDTH / 8 - kTabbarItemWidth / 2), 0, kTabbarItemWidth, kTabbarItemHeight);
    }
    return _foundIV;
}

- (UIImageView *)mallIV{
    if(!_mallIV){
        _mallIV = [UIImageView new];
        _mallIV.contentMode = UIViewContentModeScaleAspectFill;
        _mallIV.hidden = YES;
        _mallIV.frame = CGRectMake((SCREEN_WIDTH / 8 * 3 - kTabbarItemWidth / 2), 0, kTabbarItemWidth, kTabbarItemHeight);
    }
    return _mallIV;
}

- (UIImageView *)shareIV{
    if(!_shareIV){
        _shareIV = [UIImageView new];
        _shareIV.contentMode = UIViewContentModeScaleAspectFill;
        _shareIV.hidden = YES;
        _shareIV.frame = CGRectMake((SCREEN_WIDTH / 8 * 5 - kTabbarItemWidth / 2), 0, kTabbarItemWidth, kTabbarItemHeight);
    }
    return _shareIV;
}

- (UIImageView *)mineIV{
    if(!_mineIV){
        _mineIV = [UIImageView new];
        _mineIV.contentMode = UIViewContentModeScaleAspectFill;
        _mineIV.hidden = YES;
        _mineIV.frame = CGRectMake((SCREEN_WIDTH / 8 * 7 - kTabbarItemWidth / 2), 0, kTabbarItemWidth, kTabbarItemHeight);
    }
    return _mineIV;
}

@end
