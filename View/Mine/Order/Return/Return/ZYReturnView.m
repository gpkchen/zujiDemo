//
//  ZYReturnView.m
//  Apollo
//
//  Created by 李明伟 on 2018/11/6.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import "ZYReturnView.h"

@implementation ZYReturnView

- (instancetype)init{
    if(self = [super init]){
        self.backgroundColor = VIEW_COLOR;
        
        self.mailBtn.frame = CGRectMake(0,
                                        SCREEN_HEIGHT - DOWN_DANGER_HEIGHT - 50 * UI_H_SCALE,
                                        SCREEN_WIDTH,
                                        50 * UI_H_SCALE);
        [self addSubview:self.mailBtn];
        
        self.tableView.frame = CGRectMake(0,
                                          NAVIGATION_BAR_HEIGHT,
                                          SCREEN_WIDTH,
                                          SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - DOWN_DANGER_HEIGHT - 50 * UI_H_SCALE);
        [self addSubview:self.tableView];
        
        [self addSubview:self.noticeView];
    }
    return self;
}

#pragma mark - setter
- (void)setMode:(int)mode{
    _mode = mode;
    
    if(1 == mode){
        self.mailBtn.hidden = NO;
        [self.mailBtn setTitle:@"已邮寄，修改订单号" forState:UIControlStateNormal];
        self.tableView.frame = CGRectMake(0,
                                          NAVIGATION_BAR_HEIGHT,
                                          SCREEN_WIDTH,
                                          SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - DOWN_DANGER_HEIGHT - 50 * UI_H_SCALE);
        self.tableView.contentInset = UIEdgeInsetsMake( - NAVIGATION_BAR_HEIGHT, 0, 0, 0);
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(CNBMaxHeight - NAVIGATION_BAR_HEIGHT, 0, 0, 0);
    }else if(2 == mode){
        self.mailBtn.hidden = YES;
        self.tableView.frame = CGRectMake(0,
                                          NAVIGATION_BAR_HEIGHT,
                                          SCREEN_WIDTH,
                                          SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT);
        self.tableView.contentInset = UIEdgeInsetsMake(CNBMaxHeight - NAVIGATION_BAR_HEIGHT, 0, DOWN_DANGER_HEIGHT, 0);
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(CNBMaxHeight - NAVIGATION_BAR_HEIGHT, 0, DOWN_DANGER_HEIGHT, 0);
    }else if(3 == mode){
        self.mailBtn.hidden = NO;
        [self.mailBtn setTitle:@"去邮寄" forState:UIControlStateNormal];
        self.tableView.frame = CGRectMake(0,
                                          NAVIGATION_BAR_HEIGHT,
                                          SCREEN_WIDTH,
                                          SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - DOWN_DANGER_HEIGHT - 50 * UI_H_SCALE);
        self.tableView.contentInset = UIEdgeInsetsMake(CNBMaxHeight - NAVIGATION_BAR_HEIGHT, 0, 0, 0);
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(CNBMaxHeight - NAVIGATION_BAR_HEIGHT, 0, 0, 0);
    }
}

#pragma mark - getter
- (ZYTableView *)tableView{
    if(!_tableView){
        _tableView = [[ZYTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.contentInset = UIEdgeInsetsMake(CNBMaxHeight - NAVIGATION_BAR_HEIGHT, 0, 0, 0);
        _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(CNBMaxHeight - NAVIGATION_BAR_HEIGHT, 0, 0, 0);
        _tableView.contentOffset = CGPointMake(0, -_tableView.scrollIndicatorInsets.top);
    }
    return _tableView;
}

- (ZYElasticButton *)mailBtn{
    if(!_mailBtn){
        _mailBtn = [ZYElasticButton new];
        _mailBtn.shouldAnimate = NO;
        _mailBtn.font = FONT(15);
        [_mailBtn setTitle:@"已邮寄，填写运单号" forState:UIControlStateNormal];
        [_mailBtn setBackgroundColor:BTN_COLOR_NORMAL_GREEN forState:UIControlStateNormal];
        [_mailBtn setBackgroundColor:BTN_COLOR_HEIGHTLIGHT_GREEN forState:UIControlStateHighlighted];
        [_mailBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_mailBtn setTitleColor:UIColor.whiteColor forState:UIControlStateHighlighted];
    }
    return _mailBtn;
}

- (ZYReturnNoticeView *)noticeView{
    if(!_noticeView){
        _noticeView = [ZYReturnNoticeView new];
        _noticeView.hidden = YES;
        _noticeView.beginFrame = CGRectMake(SCREEN_WIDTH / 2,
                                            SCREEN_HEIGHT - DOWN_DANGER_HEIGHT - 60 * UI_H_SCALE,
                                            0, 0);
        
        _noticeView.endFrame = CGRectMake(15 * UI_H_SCALE,
                                            SCREEN_HEIGHT - DOWN_DANGER_HEIGHT - 130 * UI_H_SCALE,
                                            SCREEN_WIDTH - 30 * UI_H_SCALE,
                                            70 * UI_H_SCALE);
    }
    return _noticeView;
}

@end
