//
//  ZYOrderListView.h
//  Apollo
//
//  Created by 李明伟 on 2018/4/28.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYOrderListView : UIView

@property (nonatomic , strong) ZYScrollView *scrollView;
@property (nonatomic , strong) NSMutableArray *stateBtns;
@property (nonatomic , strong) UIView *corsur;
@property (nonatomic , strong) NSArray *stateTitles;

@end
