//
//  ZYMallTemplate6.m
//  Apollo
//
//  Created by 李明伟 on 2018/8/2.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYMallTemplate6.h"
#import "ZYJumpLabel.h"

@interface ZYMallTemplate6()

@property (nonatomic , strong) ZYJumpLabel *jumpLabel;

@end

@implementation ZYMallTemplate6

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = UIColor.whiteColor;
        
        [self.contentView addSubview:self.jumpLabel];
        [self.jumpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).mas_offset(UIEdgeInsetsMake(0, 10 * UI_H_SCALE, 0, 15 * UI_H_SCALE));
        }];
    }
    return self;
}

- (void)beginScroll{
    [self.jumpLabel beginScroll];
}

- (void)pauseScroll{
    [self.jumpLabel pauseScroll];
}

#pragma mark - override
- (void)showCellWithModel:(_m_AppModuleList *)model{
    [super showCellWithModel:model];
    
    NSMutableArray *titles = [NSMutableArray array];
    for(NSDictionary *dic in self.model.configureItemVOList){
        [titles addObject:dic[@"title"]];
    }
    self.jumpLabel.titles = titles;
}

#pragma mark - getter
- (ZYJumpLabel *)jumpLabel{
    if(!_jumpLabel){
        _jumpLabel = [ZYJumpLabel new];
        _jumpLabel.cornerRadius = 20 * UI_H_SCALE;
        _jumpLabel.clipsToBounds = YES;
        _jumpLabel.backgroundColor = HexRGB(0xFFF9EC);
        _jumpLabel.isHaveHeadImg = YES;
        _jumpLabel.labelFont = FONT(14);
        _jumpLabel.color = HexRGB(0x666666);
        _jumpLabel.headImg = [UIImage imageNamed:@"zy_mall_jump_label_icon"];
        _jumpLabel.isHaveTouchEvent = YES;
        _jumpLabel.headImgFrame = CGRectMake(20 * UI_H_SCALE,
                                             (ZYMallTemplate6Height - _jumpLabel.headImg.size.height) / 2,
                                             _jumpLabel.headImg.size.width,
                                             _jumpLabel.headImg.size.height);
        
        __weak __typeof__(self) weakSelf = self;
        _jumpLabel.clickAdBlock = ^(NSUInteger index) {
             !weakSelf.action ? : weakSelf.action(weakSelf.model.configureItemVOList[index][@"url"]);
        };
    }
    return _jumpLabel;
}

@end
