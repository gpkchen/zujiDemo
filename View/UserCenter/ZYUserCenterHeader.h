//
//  ZYUserCenterHeader.h
//  Apollo
//
//  Created by 李明伟 on 2018/7/27.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ZYUserCenterHeaderHeight (189 * UI_H_SCALE + FRINGE_TOP_EXTRA_HEIGHT)

@interface ZYUserCenterHeader : UIView

@property (nonatomic , strong) UIImageView *portrait;
@property (nonatomic , strong) UILabel *nicknameLab;
@property (nonatomic , strong) UILabel *likeLab;
@property (nonatomic , strong) UILabel *publishLab;

@end
