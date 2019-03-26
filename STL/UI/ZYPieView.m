//
//  ZYPieView.m
//  PodLib
//
//  Created by 李明伟 on 2018/3/28.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYPieView.h"
#import "UIView+ZYExtension.h"

@interface ZYPieView ()<CAAnimationDelegate>

@property (nonatomic , strong) CALayer *contentLayer; //内容

@property (nonatomic , strong) NSArray<NSNumber *> *dataArr; //数值列表
@property (nonatomic , strong) NSArray<UIColor *> *colorArr; //颜色列表

@property (nonatomic , assign) CGFloat maxData; //数值之和
@property (nonatomic , assign) CGFloat startAngle; //开始绘制的角度
@property (nonatomic , assign) int drawingIndex; //正在绘制的位置

@end

@implementation ZYPieView

- (instancetype) initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor whiteColor];
        _pieWidth = 25;
    }
    return self;
}

#pragma mark - 内容
- (CALayer *) contentLayer{
    if(!_contentLayer){
        _contentLayer = [CALayer layer];
        _contentLayer.frame = self.bounds;
        _contentLayer.backgroundColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:_contentLayer];
    }
    return _contentLayer;
}

#pragma mark - 设置默认样式
- (void) setDefaultColor:(UIColor *)defaultColor{
    _defaultColor = defaultColor;
    if(_defaultColor){
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.fillColor = [UIColor clearColor].CGColor;
        layer.strokeColor = _defaultColor.CGColor;
        layer.lineWidth = _pieWidth;
        [self.contentLayer addSublayer:layer];
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path addArcWithCenter:CGPointMake(self.width / 2, self.height / 2)
                        radius:self.width / 2 - _pieWidth / 2
                    startAngle:-M_PI_2
                      endAngle:2*M_PI
                     clockwise:YES];
        layer.path = path.CGPath;
    }
}

#pragma mark - public
- (void) setData:(NSArray<NSNumber *> *)dataArr colorArr:(NSArray<UIColor *> *)colorArr{
    _dataArr = dataArr;
    _colorArr = colorArr;
    [self.contentLayer removeFromSuperlayer];
    _contentLayer = nil;
    _maxData = [[self.dataArr valueForKeyPath:@"@sum.floatValue"] floatValue];
    _startAngle = -M_PI_2;
    _drawingIndex = 0;
    [self drawPies];
}

#pragma mark - 绘制图形
- (void) drawPies{
    if(_drawingIndex >= _dataArr.count){
        return;
    }
    NSNumber *nub = [_dataArr objectAtIndex:_drawingIndex];
    if([nub doubleValue] == 0){
        _drawingIndex ++;
        [self drawPies];
        return;
    }
    CGFloat rate = [nub floatValue] / _maxData;
    UIColor *color = [UIColor blackColor];
    if(_drawingIndex < _colorArr.count){
        color = [_colorArr objectAtIndex:_drawingIndex];
    }
    // 扇形部分
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = color.CGColor;
    layer.lineWidth = _pieWidth;
    [self.contentLayer addSublayer:layer];
    
    CGFloat endAngle = rate * (2*M_PI) + _startAngle;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(self.width / 2, self.height / 2)
                    radius:self.width / 2 - _pieWidth / 2
                startAngle:_startAngle
                  endAngle:endAngle
                 clockwise:YES];
    layer.path = path.CGPath;
    
    CABasicAnimation *pathAnima = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnima.duration = 0.8f * rate;
    pathAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    pathAnima.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnima.toValue = [NSNumber numberWithFloat:1.0f];
    pathAnima.fillMode = kCAFillModeForwards;
    pathAnima.removedOnCompletion = NO;
    pathAnima.delegate = self;
    [layer addAnimation:pathAnima forKey:@"strokeEndAnimation"];
    
    _startAngle = endAngle;
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if(flag){
        _drawingIndex ++;
        if(_drawingIndex < _dataArr.count){
            [self drawPies];
        }
    }
}

@end
