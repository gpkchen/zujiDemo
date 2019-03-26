//
//  ZYItemDetailDownVC.m
//  Apollo
//
//  Created by 李明伟 on 2018/5/3.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYItemDetailDownVC.h"
#import "ZYItemDetailVC.h"

@interface ZYItemDetailDownVC ()<UIScrollViewDelegate>

@property (nonatomic , strong) UILabel *dragLab;

@end

@implementation ZYItemDetailDownVC

- (instancetype)init{
    if(self = [super init]){
        __weak __typeof__(self) weakSelf = self;
        self.webInitComplete = ^{
            weakSelf.webView.scrollView.delegate = weakSelf;
            [weakSelf.view bringSubviewToFront:weakSelf.dragLab];
        };
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webViewInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.progressViewY = 0;
    
    [self.view addSubview:self.dragLab];
    [self.dragLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view.mas_top).mas_offset(ZYItemDetailVCDragHeight / 2.0);
    }];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.y >= 0){
        self.dragLab.hidden = YES;
    }else if(scrollView.contentOffset.y < 0 && scrollView.contentOffset.y > -ZYItemDetailVCDragHeight){
        self.dragLab.hidden = NO;
        self.dragLab.alpha = -scrollView.contentOffset.y / ZYItemDetailVCDragHeight;
        self.dragLab.text = @"下拉显示商品详情";
    }else{
        self.dragLab.hidden = NO;
        self.dragLab.alpha = 1;
        self.dragLab.text = @"释放显示商品详情";
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(scrollView.contentOffset.y <= -ZYItemDetailVCDragHeight){
        !_scrollBlock ? : _scrollBlock();
    }
}

#pragma mark - getter
- (UILabel *)dragLab{
    if(!_dragLab){
        _dragLab = [UILabel new];
        _dragLab.textColor = WORD_COLOR_GRAY;
        _dragLab.font = FONT(14);
    }
    return _dragLab;
}

@end
