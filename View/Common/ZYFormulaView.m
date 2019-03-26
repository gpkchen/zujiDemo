//
//  ZYFormulaView.m
//  Apollo
//
//  Created by 李明伟 on 2018/11/26.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import "ZYFormulaView.h"

@interface ZYFormulaView()

@property (nonatomic , strong) UIImageView *arrowIV;
@property (nonatomic , strong) UIView *backView;
@property (nonatomic , strong) UILabel *contentLab;

@end

@implementation ZYFormulaView

- (instancetype)init{
    if(self = [super init]){
        self.backgroundColor = UIColor.clearColor;
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        __weak __typeof__(self) weakSelf = self;
        [self tapped:^(UITapGestureRecognizer *gesture) {
            [weakSelf dismiss];
        } delegate:nil];
        
        [self addSubview:self.backView];
        [self addSubview:self.arrowIV];
        
        [self.backView addSubview:self.contentLab];
        [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.backView).mas_offset(20 * UI_H_SCALE);
            make.right.equalTo(self.backView).mas_offset(-20 * UI_H_SCALE);
            make.centerY.equalTo(self.backView);
        }];
    }
    return self;
}

#pragma mark - public
- (void)showAtPoint:(CGPoint)point{
    if(!self.superview){
        
        self.arrowIV.centerX = point.x;
        self.arrowIV.top = point.y;
        self.backView.top =  self.arrowIV.bottom-0.3;
        CGSize contentSize = [self.contentLab sizeThatFits:CGSizeMake(SCREEN_WIDTH - 70 * UI_H_SCALE, CGFLOAT_MAX)];
        self.backView.height = contentSize.height + 20 * UI_H_SCALE;
        self.backView.alpha = 0;
        self.arrowIV.alpha = 0;
        [SCREEN addSubview:self];
        [UIView animateWithDuration:0.25
                         animations:^{
                             self.backView.alpha = 1;
                             self.arrowIV.alpha = 1;
                         }];
    }
}

- (void)dismiss{
    if(self.superview){
        [UIView animateWithDuration:0.25
                         animations:^{
                             self.backView.alpha = 0;
                             self.arrowIV.alpha = 0;
                         } completion:^(BOOL finished) {
                             [self removeFromSuperview];
                         }];
    }
}

#pragma mark - setter
- (void)setFormula:(NSString *)formula{
    _formula = formula;
    self.contentLab.text = formula;
    
    CGFloat formulaHeight = [formula boundingRectWithSize:CGSizeMake(self.backView.width - 40 * UI_H_SCALE, CGFLOAT_MAX)
                                                  options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:FONT(14)}
                                                  context:nil].size.height;
    self.backView.height = formulaHeight + 20 * UI_H_SCALE;
}

#pragma mark - getter
- (UIImageView *)arrowIV{
    if(!_arrowIV){
        _arrowIV = [UIImageView new];
        _arrowIV.image = [UIImage imageNamed:@"zy_order_buy_off_help_arrow"];
        _arrowIV.size = _arrowIV.image.size;
    }
    return _arrowIV;
}

- (UIView *)backView{
    if(!_backView){
        _backView = [UIView new];
        _backView.backgroundColor = HexRGBAlpha(0x18191A, 0.8);
        _backView.cornerRadius = 8;
        _backView.frame = CGRectMake(15 * UI_H_SCALE, 0, SCREEN_WIDTH - 30 * UI_H_SCALE, 60 * UI_H_SCALE);
    }
    return _backView;
}

- (UILabel *)contentLab{
    if(!_contentLab){
        _contentLab = [UILabel new];
        _contentLab.textColor = UIColor.whiteColor;
        _contentLab.font = FONT(14);
        _contentLab.numberOfLines = 0;
    }
    return _contentLab;
}


@end
