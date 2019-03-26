//
//  ZYActivityAlert.m
//  Apollo
//
//  Created by 李明伟 on 2018/7/17.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYActivityAlert.h"
#import "AppActiveInfo.h"

@interface ZYActivityAlert ()

@property (nonatomic , strong) UIImageView *imageView;
@property (nonatomic , strong) _m_AppActiveInfo *model;

@end

@implementation ZYActivityAlert

- (void)showWithModel:(_m_AppActiveInfo *)model{
    _model = model;
    NSString *url = [model.imgUrl imageStyleUrl:CGSizeMake(600 * UI_H_SCALE, 600 * UI_H_SCALE)];
    [self.imageView loadImage:url];
    [super showWithPanelView:self.imageView];
}

#pragma mark - getter
- (UIImageView *)imageView{
    if(!_imageView){
        _imageView = [UIImageView new];
        _imageView.backgroundColor = UIColor.clearColor;
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.userInteractionEnabled = YES;
        _imageView.size = CGSizeMake(300 * UI_H_SCALE, 300 * UI_H_SCALE);
        
        __weak __typeof__(self) weakSelf = self;
        [_imageView tapped:^(UITapGestureRecognizer *gesture) {
            [weakSelf dismiss];
            [[ZYRouter router] go:weakSelf.model.url];
        } delegate:nil];
    }
    return _imageView;
}

@end
