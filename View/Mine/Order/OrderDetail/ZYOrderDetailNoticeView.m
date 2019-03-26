//
//  ZYOrderDetailNoticeView.m
//  Apollo
//
//  Created by 李明伟 on 2018/11/13.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import "ZYOrderDetailNoticeView.h"

static NSString * const kStorageKey = @"ZYOrderDetailNoticeViewStorageKey";

@interface ZYOrderDetailNoticeView()

@property (nonatomic , strong) UIImageView *backIV;
@property (nonatomic , strong) UILabel *lab;

@end

@implementation ZYOrderDetailNoticeView

- (instancetype)init{
    if(self = [super init]){
        self.backgroundColor = UIColor.clearColor;
        self.frame = CGRectMake(SCREEN_WIDTH - 15 * UI_H_SCALE - self.backIV.image.size.width,
                                NAVIGATION_BAR_HEIGHT - 12 * UI_H_SCALE,
                                self.backIV.image.size.width,
                                self.backIV.image.size.height);
        
        [self addSubview:self.backIV];
        [self.backIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self addSubview:self.lab];
        [self.lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).mas_offset(12 * UI_H_SCALE);
            make.centerY.equalTo(self).mas_offset(3);
        }];
    }
    return self;
}

#pragma mark - public
- (void)show{
    NSString *key = [NSUserDefaults readObjectWithKey:kStorageKey];
    if(key && [key isEqualToString:kStorageKey]){
        return;
    }
    [SCREEN addSubview:self];
    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismiss];
    });
}

- (void)dismiss{
    if(!self.superview){
        return;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [NSUserDefaults writeWithObject:kStorageKey forKey:kStorageKey];
    }];
}

#pragma mark - getter
- (UIImageView *)backIV{
    if(!_backIV){
        _backIV = [UIImageView new];
        _backIV.image = [UIImage imageNamed:@"zy_order_notice_back"];
    }
    return _backIV;
}

- (UILabel *)lab{
    if(!_lab){
        _lab = [UILabel new];
        _lab.textColor = UIColor.whiteColor;
        _lab.font = FONT(14);
        _lab.text = @"这里也可以查看账单哦";
    }
    return _lab;
}

@end
