//
//  ZYMainTabVC.h
//  Apollo
//
//  Created by 李明伟 on 2018/4/10.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYBaseNC.h"

@interface ZYMainTabVC : UITabBarController

@property (nonatomic , strong) ZYBaseNC *currentNC; //当前显示的导航器

+ (instancetype)shareInstance;

@end
