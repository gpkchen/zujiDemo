//
//  ZYScrollLabel.m
//  PodLib
//
//  Created by 李明伟 on 2018/3/28.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYScrollLabel.h"
#import "UIView+ZYExtension.h"

static const CGFloat kLabelExtraContentPadding = 10.0;

@interface ZYScrollLabel ()<UIGestureRecognizerDelegate>

@property (nonatomic , strong) UIScrollView *scrollView;    //滚动视图
@property (nonatomic , strong) NSMutableArray *labelArray;  //标签列表
@property (nonatomic , assign) NSUInteger labelTextCount;   //真实标签数量
@property (nonatomic , assign) CGFloat offset;              //滚动视图偏移量
@property (nonatomic , assign) CGFloat offsetGotoOrigin;    //恢复原点量

@property (nonatomic , copy) ZYScrollLabelAction action;

@property (nonatomic , strong) NSTimer *timer;

@end

@implementation ZYScrollLabel

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        _scrollView = [UIScrollView new];
#ifdef __IPHONE_11_0
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
#endif
        _scrollView.scrollEnabled = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.userInteractionEnabled = YES;
        _scrollView.tag = 1000;
        [self addSubview:_scrollView];
        
        _labelArray = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)setTextArray:(NSArray *)textArray{
    _textArray = textArray;
    
    [_scrollView removeAllSubviews];
    
    if (0 == [textArray count]) {
        return;
    }
    
    _labelTextCount = [textArray count];
    [_labelArray removeAllObjects];
    
    CGFloat offsetX = 0;
    CGFloat totalLabelWidthCount = 0;
    for (int i=0;i<[textArray count];i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.text = [textArray objectAtIndex:i];
        label.textAlignment = NSTextAlignmentLeft;
        if(_textColor){
            label.textColor = _textColor;
        }
        if(_font){
            label.font = _font;
        }
        label.backgroundColor = [UIColor clearColor];
        [label sizeToFit];
        label.frame = CGRectMake(offsetX, 0, CGRectGetWidth(label.frame) + kLabelExtraContentPadding, CGRectGetHeight(_scrollView.frame));
        [_scrollView addSubview:label];
        [_labelArray addObject:label];
        
        offsetX += CGRectGetWidth(label.frame);
        totalLabelWidthCount += CGRectGetWidth(label.frame);
        if(i == _textArray.count - 1){
            if(totalLabelWidthCount <= _scrollView.width){
                totalLabelWidthCount = _scrollView.width + 1;
                offsetX = _scrollView.width + 1;
                label.width = _scrollView.width + 1 - label.left;
            }
        }
    }
    
    _offsetGotoOrigin = totalLabelWidthCount;
    
    if (totalLabelWidthCount > CGRectGetWidth(_scrollView.frame)) {
        CGFloat extraAddedLabelWidths = 0;
        NSMutableArray *extraAddedLabelIndexArray = [[NSMutableArray alloc] init];
        for (UILabel *label in _labelArray) {
            extraAddedLabelWidths += CGRectGetWidth(label.frame);
            
            [extraAddedLabelIndexArray addObject:[NSNumber numberWithInteger:[_labelArray indexOfObject:label]]];
            
            if (extraAddedLabelWidths > CGRectGetWidth(_scrollView.frame))
                break;
        }
        
        for (int i=0;i<[extraAddedLabelIndexArray count];i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            NSNumber *num = [extraAddedLabelIndexArray objectAtIndex:i];
            label.text = [textArray objectAtIndex:[num integerValue]];
            label.textAlignment = NSTextAlignmentLeft;
            if(_textColor){
                label.textColor = _textColor;
            }
            if(_font){
                label.font = _font;
            }
            label.backgroundColor = [UIColor clearColor];
            [label sizeToFit];
            label.frame = CGRectMake(offsetX, 0, CGRectGetWidth(label.frame) + kLabelExtraContentPadding, CGRectGetHeight(_scrollView.frame));
            [_scrollView addSubview:label];
            [_labelArray addObject:label];
            
            offsetX += CGRectGetWidth(label.frame);
            totalLabelWidthCount += CGRectGetWidth(label.frame);
        }
        
        _scrollView.contentSize = CGSizeMake(totalLabelWidthCount, CGRectGetHeight(_scrollView.frame));
        
        if(_timer){
            [_timer invalidate];
            _timer = nil;
        }
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.03
                                                  target:self
                                                selector:@selector(autoScroll)
                                                userInfo:nil
                                                 repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLabel:)];
    tap.delegate = self;
    [_scrollView addGestureRecognizer:tap];
}

- (void)autoScroll{
    _scrollView.contentOffset = CGPointMake(_offset, 0);
    _offset++;
    
    if(_offset >= _offsetGotoOrigin) {
        _scrollView.contentOffset = CGPointMake(0, 0);
        _offset = 0;
    }
}

#pragma mark - 点击事件
- (void)tapLabel:(UITapGestureRecognizer *)recognizer{
    CGPoint point = [recognizer locationInView:recognizer.view];
    
    NSInteger index = -1;
    CGFloat labelWidths = 0;
    for (UILabel *label in _labelArray) {
        labelWidths += CGRectGetWidth(label.frame);
        
        if (labelWidths >= point.x) {
            index = [_labelArray indexOfObject:label];
            
            break;
        }
    }
    
    if (index < _labelTextCount) {
        if(_action)
            _action(index);
    }else {
        if(_action){
            if(index-_labelTextCount < _labelTextCount){
                _action(index-_labelTextCount);
            }
        }
    }
}

- (void)action:(ZYScrollLabelAction)action{
    _action = action;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if(touch.view.tag == 1000){
        return YES;
    }
    return NO;
}

#pragma mark - override
- (void) layoutSubviews{
    [super layoutSubviews];
    _scrollView.frame = CGRectMake(_contentInsert.left,
                                   _contentInsert.top,
                                   self.width - _contentInsert.left - _contentInsert.right,
                                   self.height - _contentInsert.top - _contentInsert.bottom);
    _scrollView.contentSize = CGSizeMake(_scrollView.contentSize.width, self.height);
    for(UIView *view in _labelArray){
        view.height = self.height;
    }
}

@end
