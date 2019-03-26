//
//  ZYPublishMomentCell.m
//  Apollo
//
//  Created by 李明伟 on 2018/7/24.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYPublishMomentCell.h"

@implementation ZYPublishMomentCell

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = UIColor.whiteColor;
        
        [self.contentView addSubview:self.iv];
        [self.iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        [self.contentView addSubview:self.removeBtn];
        [self.removeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.equalTo(self.contentView);
            make.size.mas_equalTo(self.removeBtn.size);
        }];
    }
    return self;
}

#pragma mark - getter
- (UIImageView *)iv{
    if(!_iv){
        _iv = [UIImageView new];
        _iv.contentMode = UIViewContentModeScaleAspectFill;
        _iv.clipsToBounds = YES;
    }
    return _iv;
}

- (ZYElasticButton *)removeBtn{
    if(!_removeBtn){
        _removeBtn = [ZYElasticButton new];
        UIImage *img = [UIImage imageNamed:@"zy_found_publish_remove_image"];
        [_removeBtn setImage:img forState:UIControlStateNormal];
        [_removeBtn setImage:img forState:UIControlStateSelected];
        _removeBtn.shouldAnimate = NO;
        _removeBtn.backgroundColor = UIColor.clearColor;
        _removeBtn.size = img.size;
    }
    return _removeBtn;
}

@end
