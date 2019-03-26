//
//  ZYFoundView.m
//  Apollo
//
//  Created by 李明伟 on 2018/7/9.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYFoundView.h"

@implementation ZYFoundView

- (instancetype)init{
    if(self = [super init]){
        self.backgroundColor = VIEW_COLOR;
        
        [self addSubview:self.scrollView];
        [self.scrollView addSubview:self.recommendTableView];
        [self.scrollView addSubview:self.momentTableView];
    }
    return self;
}

#pragma mark - getter
- (ZYScrollView *)scrollView{
    if(!_scrollView){
        _scrollView = [ZYScrollView new];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - TABBAR_HEIGHT);
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - TABBAR_HEIGHT);
    }
    return _scrollView;
}

- (ZYTableView *)recommendTableView{
    if(!_recommendTableView){
        _recommendTableView = [[ZYTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _recommendTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _recommendTableView.backgroundColor = self.backgroundColor;
        _recommendTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.scrollView.height);
    }
    return _recommendTableView;
}

- (ZYTableView *)momentTableView{
    if(!_momentTableView){
        _momentTableView = [[ZYTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _momentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _momentTableView.backgroundColor = self.backgroundColor;
        _momentTableView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, self.scrollView.height);
    }
    return _momentTableView;
}

@end
