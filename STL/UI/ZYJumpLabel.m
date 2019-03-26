//
//  ZYJumpLabel.m
//  Apollo
//
//  Created by 李明伟 on 2018/5/5.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYJumpLabel.h"

@interface ZYJumpLabel ()

@property (nonatomic, strong) UIImageView *headImageView; //图标

@property (nonatomic, strong) NSTimer *timer; //计时器

@property (nonatomic , assign) NSUInteger index;
@property (nonatomic , assign) CGFloat margin;
@property (nonatomic , assign) BOOL isBegin;

@property (nonatomic , strong) UILabel *currentLabel; //当前正在显示的

@end

@implementation ZYJumpLabel

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (instancetype) initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        _margin = 0;
        _labelXOffset = 15 * UI_H_SCALE;
        self.clipsToBounds = YES;
        self.headImg = nil;
        self.labelFont = FONT(14);
        self.time = 2.0f;
        self.textAlignment = NSTextAlignmentLeft;
        self.isHaveHeadImg = NO;
        self.isHaveTouchEvent = NO;
        
        _index = 0;
        
        if (!_headImageView) {
            _headImageView = [[UIImageView alloc] init];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(appWillResignActive)
                                                     name:UIApplicationWillResignActiveNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(appDidBecomeActive)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
    }
    return self;
}

- (instancetype)initWithTitles:(NSArray *)titles{
    
    self = [super init];
    
    if (self) {
        self.titles = titles;
    }
    return self;
}

#pragma mark - 计时器
- (void)timeRepeat{
    if (self.titles.count < 1) {
        return;
    }
    UILabel *label = [self label:_titles[_index % _titles.count]];
    if(_currentLabel){
        label.frame = CGRectMake(_margin,self.height, self.width - _margin - _labelXOffset, self.height);
        [self addSubview:label];
    }else{
        label.frame = CGRectMake(_margin,0, self.width - _margin - _labelXOffset, self.height);
        [self addSubview:label];
        _currentLabel = label;
        label = [self label:_titles[_index % _titles.count]];
        label.frame = CGRectMake(_margin,self.height, self.width - _margin - _labelXOffset, self.height);
        [self addSubview:label];
    }
    label.alpha = 0;
    [UIView animateWithDuration:1 animations:^{
        self.currentLabel.alpha = 0;
        self.currentLabel.frame = CGRectMake(self.margin, -self.height, self.width - self.margin - self.labelXOffset, self.height);
        label.frame = CGRectMake(self.margin, 0, self.width - self.margin - self.labelXOffset, self.height);
        label.alpha = 1;
    } completion:^(BOOL finished){
        [self.currentLabel removeFromSuperview];
        self.currentLabel = label;
    }];
    _index++;
}

#pragma mark - 开始跳动
- (void)beginScroll{
    [self.timer setFireDate:[NSDate date]];
}

#pragma mark - 结束跳动
- (void)pauseScroll{
    [self.timer setFireDate:[NSDate distantFuture]];
}

#pragma mark - 移除定时器
- (void)removeTimer{
    if(_timer){
        [_timer invalidate];
        _timer = nil;
    }
}

- (NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:self.time target:self selector:@selector(timeRepeat) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

- (void)setIsHaveHeadImg:(BOOL)isHaveHeadImg{
    _isHaveHeadImg = isHaveHeadImg;
    
    if (isHaveHeadImg) {
        [self addSubview:self.headImageView];
        if(CGRectIsNull(_headImgFrame)){
            self.headImageView.frame = CGRectMake(0, 0, self.height,self.height);
        }else{
            self.headImageView.frame = _headImgFrame;
            _margin = CGRectGetMaxX(_headImgFrame) + _labelXOffset;
        }
    }else{
        if (self.headImageView) {
            [self.headImageView removeFromSuperview];
            self.headImageView = nil;
        }
        _margin = _labelXOffset;
    }
}

- (void)setHeadImgFrame:(CGRect)headImgFrame{
    _headImgFrame = headImgFrame;
    if (_isHaveHeadImg) {
        [self addSubview:self.headImageView];
        if(CGRectIsNull(_headImgFrame)){
            self.headImageView.frame = CGRectMake(0, 0, self.height,self.height);
        }else{
            self.headImageView.frame = _headImgFrame;
            _margin = CGRectGetMaxX(_headImgFrame) + _labelXOffset;
        }
    }else{
        if (self.headImageView) {
            [self.headImageView removeFromSuperview];
            self.headImageView = nil;
        }
        _margin = _labelXOffset;
    }
}

- (void)setIsHaveTouchEvent:(BOOL)isHaveTouchEvent{
    _isHaveTouchEvent = isHaveTouchEvent;
    if (isHaveTouchEvent) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickEvent:)];
        [self addGestureRecognizer:tapGestureRecognizer];
    }else{
        self.userInteractionEnabled = NO;
    }
}

- (void)setTime:(NSTimeInterval)time{
    _time = time;
}

- (void) setTitles:(NSArray *)titles{
    _titles = titles;
    if(!_index){
        [self timeRepeat];
    }
}

- (void)setHeadImg:(UIImage *)headImg{
    _headImg = headImg;
    self.headImageView.image = headImg;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment{
    _textAlignment = textAlignment;
}

- (void)setColor:(UIColor *)color{
    _color = color;
}

- (void)setLabelFont:(UIFont *)labelFont{
    _labelFont = labelFont;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor{
    [super setBackgroundColor:backgroundColor];
}

- (void)clickEvent:(UITapGestureRecognizer *)tapGestureRecognizer{
    if (self.clickAdBlock) {
        self.clickAdBlock((_index - 1) % _titles.count);
    }
}

#pragma mark - notification
- (void) appWillResignActive{
    [self pauseScroll];
}

- (void) appDidBecomeActive{
    [self beginScroll];
}

#pragma mark - getter
- (UILabel *)label:(id)text{
    UILabel *label = [UILabel new];
    label.font = self.labelFont;
    label.textColor = self.color;
    label.textAlignment = self.textAlignment;
    label.backgroundColor = self.backgroundColor;
    if([text isKindOfClass:[NSAttributedString class]]){
        label.attributedText = text;
    }else if([text isKindOfClass:[NSString class]]){
        label.text = text;
    }
    return label;
}

@end
