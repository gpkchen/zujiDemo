//
//  ZYFoundTitleView.h
//  Apollo
//
//  Created by 李明伟 on 2018/7/25.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ZYFoundTitleViewAction)(int index);

@interface ZYFoundTitleView : UIView

/**推荐按钮*/
@property (nonatomic , strong) ZYElasticButton *recommendBtn;
/**此刻按钮*/
@property (nonatomic , strong) ZYElasticButton *momentBtn;
/**按钮事件*/
@property (nonatomic , copy) ZYFoundTitleViewAction action;
/**设置选中项*/
@property (nonatomic , assign) int selectedIndex;

@end
