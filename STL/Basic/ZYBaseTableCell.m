//
//  ZYBaseTableCell.m
//  PodLib
//
//  Created by 李明伟 on 2018/3/28.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseTableCell.h"
#import "Masonry.h"
#import "UIImage+ZYExtension.h"
#import "ZYMacro.h"

@implementation ZYBaseTableCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        _separator = [[UIImageView alloc]init];
        _separator.image = [UIImage imageWithColor:HexRGB(0xE8EAED)];
        _separator.hidden = YES;
        [self.contentView addSubview:_separator];
        [_separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(LINE_HEIGHT);
        }];
        
        _arrow = [UIImageView new];
        _arrow.hidden = YES;
        [self.contentView addSubview:_arrow];
        _arrow.image = [UIImage imageNamed:@"zy_basic_cell_arrow_navy"];
        [_arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).mas_offset(-15 * UI_H_SCALE);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(self.arrow.image.size);
        }];
        
        UIView *view = [UIView new];
        view.backgroundColor = HexRGB(0xf0f0f0);
        self.selectedBackgroundView = view;
    }
    return self;
}

- (instancetype) initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]){
        
    }
    return self;
}

- (void) setArrowImg:(UIImage *)arrowImg{
    _arrowImg = arrowImg;
    _arrow.image = arrowImg;
    [_arrow mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).mas_offset(-10);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(self.arrow.image.size);
    }];
}

@end
