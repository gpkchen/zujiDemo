//
//  ZYFoundReleaseView.m
//  Apollo
//
//  Created by 李明伟 on 2018/8/15.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYFoundReleaseView.h"

@interface ZYFoundReleaseView()

@property (nonatomic , assign) BOOL shouldMove; //是否应该开始移动
@property (nonatomic , assign) CGPoint beginMovePoint; //开始移动触发点

@property (nonatomic , strong) UIImage *icon;
@property (nonatomic , strong) UIImageView *iv;

@end

@implementation ZYFoundReleaseView

- (instancetype)init{
    self = [super init];
    if(self){
        self.windowLevel = powf(10, 7);
        self.backgroundColor = [UIColor clearColor];
        self.layer.masksToBounds = YES;
        self.frame = CGRectMake(SCREEN_WIDTH - self.icon.size.width,
                                SCREEN_HEIGHT - (TABBAR_HEIGHT + 30 * UI_H_SCALE + self.icon.size.height),
                                self.icon.size.width,
                                self.icon.size.height);
        
        [self addSubview:self.iv];
        [self.iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        self.shouldMove = YES;
    }
    return self;
}

#pragma mark - public
- (void)show{
    self.alpha = 0;
    [self makeVisibleWindow];
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
    }];
}

- (void)hide{
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - 显示window
- (void)makeVisibleWindow {
    UIWindow *keyWindows = [UIApplication sharedApplication].keyWindow;
    [self makeKeyAndVisible];
    if (keyWindows) {
        [keyWindows makeKeyWindow];
    }
}

#pragma mark - override
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    if(_shouldMove){
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        _beginMovePoint = point;
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    if(_shouldMove){
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        self.center = CGPointMake(self.center.x + point.x - _beginMovePoint.x, self.center.y + point.y - _beginMovePoint.y);
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    [self endMoving];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    [self endMoving];
}

#pragma mark - 结束移动
- (void)endMoving{
    if(_shouldMove){
        CGPoint endPoint = self.center;
        if(self.center.x >= SCREEN_WIDTH / 2.0){
            endPoint.x = SCREEN_WIDTH - self.width / 2.0;
        }else{
            endPoint.x = self.width / 2.0;
        }
        if(self.top < 0){
            endPoint.y = self.height / 2.0;
        }else if(self.bottom > SCREEN_HEIGHT){
            endPoint.y = SCREEN_HEIGHT - self.height / 2.0;
        }
        [UIView animateWithDuration:0.2
                         animations:^{
                             self.center = endPoint;
                         }];
    }
}

#pragma mark - getter
- (UIImage *)icon{
    if(!_icon){
        _icon = [UIImage imageNamed:@"zy_found_publish_btn"];
    }
    return _icon;
}

- (UIImageView *)iv{
    if(!_iv){
        _iv = [UIImageView new];
        _iv.image = self.icon;
    }
    return _iv;
}

@end
