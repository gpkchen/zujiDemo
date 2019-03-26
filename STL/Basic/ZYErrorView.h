//
//  ZYErrorView.h
//  Apollo
//
//  Created by 李明伟 on 2018/5/8.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ZYErrorViewButtonAction)(void);

/**错误视图*/
@interface ZYErrorView : UIView

/**图片*/
@property (nonatomic , strong) UIImage *image;
/**按钮标题*/
@property (nonatomic , copy) NSString *buttonTitle;
/**图片顶部相对于视图便宜量*/
@property (nonatomic , assign) CGFloat contentY;
/**按钮点击事件*/
@property (nonatomic , copy) ZYErrorViewButtonAction buttonAction;

@end
