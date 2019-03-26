//
//  ZYTabBar.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/10.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYTabBar.h"



@implementation ZYTabBarItemModel

@end



@implementation ZYTabBarItem

- (instancetype)init{
    if(self = [super init]){
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.centerX.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        [self addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imageView.mas_bottom).mas_offset(5);
            make.centerX.equalTo(self);
        }];
    }
    return self;
}

#pragma mark - getter
- (UIImageView *)imageView{
    if(!_imageView){
        _imageView = [UIImageView new];
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (UILabel *)label{
    if(!_label){
        _label = [UILabel new];
        _label.font = FONT(10);
        _label.backgroundColor = [UIColor clearColor];
        _label.textColor = [UIColor blackColor];
    }
    return _label;
}

@end




@interface ZYTabBar ()

@property (nonatomic , strong) UIView *line;

@end


@implementation ZYTabBar

- (instancetype) init{
    if(self = [super init]){
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.line];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}

#pragma mark - setter
- (void)setItems:(NSArray *)items{
    _items = items;
    
    __weak __typeof__(self) weakSelf = self;
    for(int i=0;i<items.count;++i){
        ZYTabBarItemModel *model = items[i];
        ZYTabBarItem *item = [ZYTabBarItem new];
        item.imageView.image = model.image;
        item.label.text = model.title;
        [item tapped:^(UITapGestureRecognizer *gesture) {
            !weakSelf.action ? : weakSelf.action(i);
        } delegate:nil];
        [self addSubview:item];
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH / 3, 40));
            make.top.equalTo(self).mas_offset(5);
            make.centerX.equalTo(self.mas_left).mas_offset(SCREEN_WIDTH / items.count * (i + 0.5));
        }];
    }
}

#pragma mark - getter
- (UIView *)line{
    if(!_line){
        _line = [UIView new];
        _line.backgroundColor = [UIColor blackColor];
    }
    return _line;
}

@end
