//
//  ZYItemDetailUpServiceCell.m
//  Apollo
//
//  Created by 李明伟 on 2018/5/4.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYItemDetailUpServiceCell.h"

@implementation ZYItemDetailUpServiceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = HexRGB(0xE8EAED);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)showCellWithModel:(NSArray *)titles{
    [self.contentView removeAllSubviews];
    
    CGFloat x = 15 * UI_H_SCALE;
    for(int i=0;i<titles.count;++i){
        UIImageView *iv = [UIImageView new];
        iv.image = [UIImage imageNamed:@"zy_item_detail_service_icon"];
        [self.contentView addSubview:iv];
        [iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(x);
            make.centerY.equalTo(self.contentView);
        }];
        
        x += iv.image.size.width + 2;
        
        UILabel *lab = [UILabel new];
        lab.textColor = WORD_COLOR_GRAY;
        lab.font = FONT(12);
        lab.text = titles[i][@"name"];
        [lab sizeToFit];
        [self.contentView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(x);
            make.centerY.equalTo(self.contentView);
        }];
        
        x += lab.width + 20 * UI_H_SCALE;
    }
}

@end
