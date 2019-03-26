//
//  ZYImageTitleButton.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/26.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYImageTitleButton.h"

@interface ZYImageTitleButton ()

/**图片*/
@property (nonatomic , strong) UIImageView *imageIV;
/**文字*/
@property (nonatomic , strong) UILabel *titleLab;

@end

@implementation ZYImageTitleButton

- (instancetype)init{
    if(self = [super init]){
        self.shouldAnimate = NO;
        [self addSubview:self.imageIV];
        [self addSubview:self.titleLab];
    }
    return self;
}

#pragma mark - setter
- (void)setImage:(UIImage *)image{
    _image = image;
    self.imageIV.image = image;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLab.text = title;
    [self.titleLab sizeToFit];
}

- (void)setTitleFont:(UIFont *)titleFont{
    _titleFont = titleFont;
    self.titleLab.font = titleFont;
    [self.titleLab sizeToFit];
}

- (void)setTitleColor:(UIColor *)titleColor{
    _titleColor = titleColor;
    self.titleLab.textColor = titleColor;
}

#pragma mark - getter
- (UIImageView *)imageIV{
    if(!_imageIV){
        _imageIV = [UIImageView new];
    }
    return _imageIV;
}

- (UILabel *)titleLab{
    if(!_titleLab){
        _titleLab = [UILabel new];
    }
    return _titleLab;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat totalWidth = _image.size.width + _spacing + self.titleLab.width;
    self.imageIV.frame = CGRectMake((self.width - totalWidth) / 2.0,
                                    (self.height - _image.size.height) / 2.0,
                                    _image.size.width,
                                    _image.size.height);
    self.titleLab.frame = CGRectMake(CGRectGetMaxX(self.imageIV.frame) + _spacing,
                                     (self.height - self.titleLab.height) / 2.0,
                                     self.titleLab.width,
                                     self.titleLab.height);
}

- (void)sizeToFit{
    [super sizeToFit];
    CGFloat totalWidth = _image.size.width + _spacing + self.titleLab.width;
    self.size = CGSizeMake(totalWidth, self.titleLab.height > _image.size.height ? self.titleLab.height : _image.size.height);
}

@end
