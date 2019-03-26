//
//  ZYMallTemplate3.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/19.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYMallTemplate3.h"
#import <SDCycleScrollView.h>

@interface ZYMallTemplate3 ()<SDCycleScrollViewDelegate>

@property (nonatomic , strong) SDCycleScrollView *banner;

@end

@implementation ZYMallTemplate3

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self addSubview:self.banner];
        [self.banner mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).mas_offset(UIEdgeInsetsMake(20 * UI_H_SCALE, 0, 0, 0));
        }];
    }
    return self;
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    !self.action ? : self.action(self.model.configureItemVOList[index][@"url"]);
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    
}

#pragma mark - override
- (void)showCellWithModel:(_m_AppModuleList *)model{
    [super showCellWithModel:model];
    NSMutableArray *imgs = [NSMutableArray array];
    for(NSDictionary *dic in model.configureItemVOList){
        NSString *url = [dic[@"image"] imageStyleUrl:CGSizeMake(SCREEN_WIDTH * 2, 200 * UI_H_SCALE)];
        [imgs addObject:url];
    }
    self.banner.imageURLStringsGroup = imgs;
}

#pragma mark - getter
- (SDCycleScrollView *)banner{
    if(!_banner){
        _banner = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:nil];
        _banner.autoScrollTimeInterval = 3;
        _banner.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _banner.showPageControl = NO;
        _banner.backgroundColor = [UIColor whiteColor];
    }
    return _banner;
}

@end
