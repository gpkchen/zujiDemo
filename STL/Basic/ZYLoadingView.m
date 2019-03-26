//
//  ZYLoadingView.m
//  Apollo
//
//  Created by 李明伟 on 2018/5/11.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYLoadingView.h"
#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"

@interface ZYLoadingView ()

@property (nonatomic , strong) FLAnimatedImageView *loadingIV;
@property (nonatomic , strong) UILabel *loadingLab;

@end

@implementation ZYLoadingView

- (instancetype) init{
    if(self = [super init]){
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.loadingIV];
        [self.loadingIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).mas_offset(NAVIGATION_BAR_HEIGHT + 70 * UI_H_SCALE);
            make.size.mas_equalTo(CGSizeMake(100 * UI_H_SCALE, 142 * UI_H_SCALE));
        }];
        
        [self addSubview:self.loadingLab];
        [self.loadingLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.loadingIV.mas_bottom).mas_offset(15 * UI_H_SCALE);
        }];
    }
    return self;
}

#pragma mark - 开始动画
- (void)startAnimation{
    [self.loadingIV startAnimating];
}

#pragma mark - 结束动画
- (void)stopAnimation{
    [self.loadingIV stopAnimating];
}

#pragma mark - getter
- (FLAnimatedImageView *)loadingIV{
    if(!_loadingIV){
        _loadingIV = [FLAnimatedImageView new];
        _loadingIV.contentMode = UIViewContentModeScaleAspectFit;
        NSBundle *bundle = [NSBundle mainBundle];
        NSString  *filePath = [bundle  pathForResource:@"zy_loading" ofType:@"gif"];
        NSData  *imageData = [NSData dataWithContentsOfFile:filePath];
        _loadingIV.backgroundColor = [UIColor clearColor];
        _loadingIV.animatedImage = [FLAnimatedImage animatedImageWithGIFData:imageData];
    }
    return _loadingIV;
}

- (UILabel *)loadingLab{
    if(!_loadingLab){
        _loadingLab = [UILabel new];
        _loadingLab.textColor = WORD_COLOR_BLACK;
        _loadingLab.font = FONT(16);
        _loadingLab.text = @"加载中";
    }
    return _loadingLab;
}

@end
