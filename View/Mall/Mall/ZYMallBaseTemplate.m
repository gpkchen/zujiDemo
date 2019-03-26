//
//  ZYMallBaseTemplate.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/19.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYMallBaseTemplate.h"

const CGFloat ZYMallTemplateMoreMaxOffset = 50;

@implementation ZYMallBaseTemplate

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)showCellWithModel:(_m_AppModuleList *)model{
    _model = model;
}

- (void)showMorePath:(CGPoint)beginPoint endPoint:(CGPoint)endPoint controlPoint:(CGPoint)controlPoint{
    [self.morePath removeAllPoints];
    [self.morePath moveToPoint:beginPoint];
    [self.morePath addQuadCurveToPoint:endPoint controlPoint:controlPoint];
    [self.morePath closePath];
    self.moreShape.path = self.morePath.CGPath;
}

#pragma mark - getter
- (UIBezierPath *)morePath{
    if(!_morePath){
        _morePath = [UIBezierPath bezierPath];
    }
    return _morePath;
}

- (CAShapeLayer *)moreShape{
    if(!_moreShape){
        _moreShape = [CAShapeLayer layer];
        _moreShape.strokeColor = HexRGB(0xE8EAED).CGColor;
        _moreShape.fillColor = HexRGB(0xE8EAED).CGColor;
    }
    return _moreShape;
}

- (UILabel *)moreLab{
    if(!_moreLab){
        _moreLab = [UILabel new];
        _moreLab.text = @"侧\n滑\n查\n看\n更\n多";
        _moreLab.textColor = WORD_COLOR_GRAY;
        _moreLab.font = FONT(12);
        _moreLab.numberOfLines = 0;
        _moreLab.lineBreakMode = NSLineBreakByWordWrapping;
        [_moreLab sizeToFit];
    }
    return _moreLab;
}

@end
