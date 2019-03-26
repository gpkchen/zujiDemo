//
//  ZYTabBar.h
//  Apollo
//
//  Created by 李明伟 on 2018/4/10.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>



/**数据模型*/
@interface ZYTabBarItemModel : NSObject

/**标题（可有可无）*/
@property (nonatomic , copy) NSString *title;
/**图标（支持UIImage和url）*/
@property (nonatomic , strong) id image;

@end



/**自定义tabbar单位*/
@interface ZYTabBarItem : UIView

/**图片*/
@property (nonatomic , strong) UIImageView *imageView;
/**文字*/
@property (nonatomic , strong) UILabel *label;

@end



typedef void (^ZYTabBarAction)(int index);


/**自定义tabbar*/
@interface ZYTabBar : UIView

/**设置选项（ZYTabBarItemModel）*/
@property (nonatomic , strong) NSArray *items;
/**点击事件*/
@property (nonatomic , copy) ZYTabBarAction action;

@end
