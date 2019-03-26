//
//  ZYMallTemplate0.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/24.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYMallTemplate0.h"
#import <SDCycleScrollView.h>

@interface ZYMallTemplate0 ()<SDCycleScrollViewDelegate>

@property (nonatomic , strong) SDCycleScrollView *banner;

@end

@implementation ZYMallTemplate0

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initWidgets];
    }
    return self;
}

- (void)initWidgets{
    self.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:self.banner];
    [self.banner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.centerX.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(345 * UI_H_SCALE, 180 * UI_H_SCALE));
    }];
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
        NSString *url = [dic[@"image"] imageStyleUrl:CGSizeMake(SCREEN_WIDTH * 2, 360 * UI_H_SCALE)];
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
        _banner.cornerRadius = 10 * UI_H_SCALE;
        _banner.clipsToBounds = YES;
        _banner.showPageControl = YES;
        _banner.currentPageDotColor = MAIN_COLOR_GREEN;

    }
    return _banner;
}

@end
