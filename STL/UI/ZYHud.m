//
//  ZYHud.m
//  Apollo
//
//  Created by 李明伟 on 2018/5/11.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYHud.h"
#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"

@interface ZYHud ()

@property (nonatomic , strong) UIView *backView;
@property (nonatomic , strong) FLAnimatedImageView *loadingIV;

@end

@implementation ZYHud

- (instancetype)init{
    self = [super init];
    if(self){
        [self initWidgets];
    }
    return self;
}

- (void)initWidgets{
    self.backgroundColor = [UIColor clearColor];
    
    _backView = [UIView new];
    _backView.cornerRadius = 10;
    [_backView layerShadow:HexRGB(0x3b4a5a) opacity:0.1 radius:5 offset:CGSizeMake(0, 0)];
    _backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_backView];
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(120 * UI_H_SCALE, 120* UI_H_SCALE));
        make.center.equalTo(self);
    }];
    
    _loadingIV = [FLAnimatedImageView new];
    _loadingIV.contentMode = UIViewContentModeScaleAspectFit;
    _loadingIV.cornerRadius = 10;
    _loadingIV.clipsToBounds = YES;
    [_backView addSubview:_loadingIV];
    [_loadingIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.backView);
    }];
    NSBundle *bundle = [NSBundle mainBundle];
    NSString  *filePath = [bundle  pathForResource:@"zy_hud" ofType:@"gif"];
    NSData  *imageData = [NSData dataWithContentsOfFile:filePath];
    _loadingIV.backgroundColor = [UIColor clearColor];
    _loadingIV.animatedImage = [FLAnimatedImage animatedImageWithGIFData:imageData];
}

#pragma mark - public
- (void)show{
    [self showInView:nil];
}

- (void)showInView:(UIView * _Nullable)view{
    if(!view){
        view = SCREEN;
    }
    _isShowing = YES;
    [view addSubview:self];
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    [_loadingIV startAnimating];
    _loadingIV.alpha = 0;
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.loadingIV.alpha = 1;
                     }];
}

- (void)dismiss{
    _isShowing = NO;
    [self removeFromSuperview];
    [self.loadingIV stopAnimating];
//    [UIView animateWithDuration:0.3
//                     animations:^{
//                         self.loadingIV.alpha = 0;
//                     } completion:^(BOOL finished) {
//                         [self removeFromSuperview];
//                         [self.loadingIV stopAnimating];
//                     }];
}

@end
