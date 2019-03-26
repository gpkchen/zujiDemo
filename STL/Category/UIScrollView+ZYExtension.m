//
//  UIScrollView+ZYExtension.m
//  PodLib
//
//  Created by 李明伟 on 2018/3/27.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "UIScrollView+ZYExtension.h"
#import "ZYMacro.h"

@implementation UIScrollView (ZYExtension)

- (void)addRefreshHeaderWithBlock:(MJRefreshComponentRefreshingBlock)block{
    NSMutableArray *imgs = [NSMutableArray array];
    for(int i=1;i<=15;++i){
        [imgs addObject:[UIImage imageNamed:[NSString stringWithFormat:@"zy_reresh_header_%d",i]]];
    }
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:block];
    [header setImages:imgs duration:0.5 forState:MJRefreshStateRefreshing];
    [header setImages:imgs duration:0.5 forState:MJRefreshStatePulling];
    [header setImages:imgs duration:0.5 forState:MJRefreshStateIdle];
    header.stateLabel.hidden = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    self.mj_header = header;
}

- (void)addRefreshFooterWithBlock:(MJRefreshComponentRefreshingBlock)block{
    [self addRefreshFooterWithTitle:@"~已经到底啦~" block:block];
}

- (void)addRefreshFooterWithTitle:(NSString *)title block:(MJRefreshComponentRefreshingBlock)block{
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:block];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"" forState:MJRefreshStatePulling];
    [footer setTitle:@"" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"" forState:MJRefreshStateWillRefresh];
    [footer setTitle:title forState:MJRefreshStateNoMoreData];
    footer.stateLabel.font = FONT(13);
    footer.stateLabel.textColor = HexRGB(0xc3cdd8);
    footer.labelLeftInset = 0;
    self.mj_footer = footer;
}

@end
