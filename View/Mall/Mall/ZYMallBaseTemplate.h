//
//  ZYMallBaseTemplate.h
//  Apollo
//
//  Created by 李明伟 on 2018/4/19.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppModuleList.h"

typedef void (^ZYMallTemplateAction)(NSString *url);

/**更多效果最大偏移量*/
extern const CGFloat ZYMallTemplateMoreMaxOffset;

/**商城首页模板基类*/
@interface ZYMallBaseTemplate : UITableViewCell

/**查看更多控件*/
@property (nonatomic , strong) UIBezierPath *morePath;
/**查看更多控件*/
@property (nonatomic , strong) CAShapeLayer *moreShape;
/**查看更多控件*/
@property (nonatomic , strong) UILabel *moreLab;

@property (nonatomic , strong) _m_AppModuleList *model;

/**点击事件*/
@property (nonatomic , copy) ZYMallTemplateAction action;

/**加载数据*/
- (void)showCellWithModel:(_m_AppModuleList *)model;

/**显示更多效果*/
- (void)showMorePath:(CGPoint)beginPoint endPoint:(CGPoint)endPoint controlPoint:(CGPoint)controlPoint;

@end
