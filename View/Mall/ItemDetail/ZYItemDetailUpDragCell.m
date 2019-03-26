//
//  ZYItemDetailUpDragCell.m
//  Apollo
//
//  Created by 李明伟 on 2018/5/4.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYItemDetailUpDragCell.h"

@interface ZYItemDetailUpDragCell ()

@property (nonatomic , strong) UIImageView *dragIV;
@property (nonatomic , strong) UILabel *dragLab;

@end

@implementation ZYItemDetailUpDragCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat totalWidth = self.dragIV.image.size.width + 5 + self.dragLab.width;
        
        [self.contentView addSubview:self.dragIV];
        [self.dragIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).mas_offset((SCREEN_WIDTH - totalWidth) / 2.0);
            make.size.mas_equalTo(self.dragIV.image.size);
        }];
        
        [self.contentView addSubview:self.dragLab];
        [self.dragLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.dragIV.mas_right).mas_offset(5);
        }];
    }
    return self;
}

#pragma mark - getter
- (UIImageView *)dragIV{
    if(!_dragIV){
        _dragIV = [UIImageView new];
        _dragIV.image = [UIImage imageNamed:@"zy_item_detail_drag_icon"];
    }
    return _dragIV;
}

- (UILabel *)dragLab{
    if(!_dragLab){
        _dragLab = [UILabel new];
        _dragLab.textColor = WORD_COLOR_GRAY;
        _dragLab.font = FONT(15);
        _dragLab.text = @"上拉查看图文详情";
        [_dragLab sizeToFit];
    }
    return _dragLab;
}

@end
