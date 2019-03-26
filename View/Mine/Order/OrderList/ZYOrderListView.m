//
//  ZYOrderListView.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/28.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYOrderListView.h"
#import "ZYOrderStateBtn.h"

@interface ZYOrderListView ()

@end

@implementation ZYOrderListView

- (instancetype)init{
    if(self = [super init]){
        self.backgroundColor = VIEW_COLOR;
        
        [self addSubview:self.scrollView];
        
        ZYOrderStateBtn *lastBtn = nil;
        for(int i=0;i<self.stateTitles.count;++i){
            NSString *title = self.stateTitles[i];
            ZYOrderStateBtn *btn = [ZYOrderStateBtn new];
            btn.selected = i == 0 ? YES : NO;
            btn.backgroundColor = UIColor.whiteColor;
            btn.font = MEDIUM_FONT(14);
            [btn setTitleColor:HexRGB(0xc4c6cc) forState:UIControlStateNormal];
            [btn setTitleColor:MAIN_COLOR_GREEN forState:UIControlStateHighlighted];
            [btn setTitleColor:MAIN_COLOR_GREEN forState:UIControlStateSelected];
            [btn setTitle:title forState:UIControlStateNormal];
            [btn sizeToFit];
            btn.frame = CGRectMake(lastBtn ? lastBtn.right : 23 * UI_H_SCALE,
                                   0,
                                   btn.width + 34 * UI_H_SCALE,
                                   self.scrollView.height);
            [self.scrollView addSubview:btn];
            [self.stateBtns addObject:btn];
            lastBtn = btn;
            
            switch (i) {
                case 0:
                    btn.orderState = -1;
                    break;
                case 1:
                    btn.orderState = ZYOrderStateWaitPay;
                    break;
                case 2:
                    btn.orderState = ZYOrderStateWaitDeliver;
                    break;
                case 3:
                    btn.orderState = ZYOrderStateWaitReceipt;
                    break;
                case 4:
                    btn.orderState = ZYOrderStateUsing;
                    break;
                case 5:
                    btn.orderState = ZYOrderStateMailedBack;
                    break;
                case 6:
                    btn.orderState = ZYOrderStateDone;
                    break;
                case 7:
                    btn.orderState = ZYOrderStateCanceled;
                    break;
                case 8:
                    btn.orderState = ZYOrderStateAbnormal;
                    break;
                    
                default:
                    break;
            }
        }
        ZYOrderStateBtn *firstBtn = self.stateBtns.firstObject;
        [self.scrollView addSubview:self.corsur];
        self.corsur.frame = CGRectMake(firstBtn.centerX - 12 * UI_H_SCALE, self.scrollView.height - 3 * UI_H_SCALE, 24 * UI_H_SCALE, 3 * UI_H_SCALE);
        
        self.scrollView.contentSize = CGSizeMake(lastBtn.right + 23 * UI_H_SCALE, self.scrollView.height);
    }
    return self;
}

#pragma mark - getter
- (ZYScrollView *)scrollView{
    if(!_scrollView){
        _scrollView = [ZYScrollView new];
        _scrollView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, 40);
        _scrollView.backgroundColor = UIColor.whiteColor;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (NSMutableArray *)stateBtns{
    if(!_stateBtns){
        _stateBtns = [NSMutableArray array];
    }
    return _stateBtns;
}

- (NSArray *)stateTitles{
    if(!_stateTitles){
        _stateTitles = @[@"全部",@"待付款",@"待发货",@"待收货",@"体验中",@"已寄回",@"已完成",@"已取消",@"异常"];
    }
    return _stateTitles;
}

- (UIView *)corsur{
    if(!_corsur){
        _corsur = [UIView new];
        _corsur.backgroundColor = MAIN_COLOR_GREEN;
    }
    return _corsur;
}

@end
