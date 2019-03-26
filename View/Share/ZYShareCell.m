//
//  ZYShareCell.m
//  Apollo
//
//  Created by 李明伟 on 2018/6/30.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYShareCell.h"

@implementation ZYShareCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self.separator mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(15 * UI_H_SCALE);
            make.right.equalTo(self.contentView);
            make.top.equalTo(self.contentView);
            make.height.mas_equalTo(LINE_HEIGHT);
        }];
        
        [self.contentView addSubview:self.iv];
        [self.iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        [self.contentView bringSubviewToFront:self.separator];
    }
    return self;
}

#pragma mark - getter
- (UIImageView *)iv{
    if(!_iv){
        _iv = [UIImageView new];
        _iv.contentMode = UIViewContentModeScaleAspectFill;
        _iv.clipsToBounds = YES;
        _iv.userInteractionEnabled = YES;
    }
    return _iv;
}

@end
