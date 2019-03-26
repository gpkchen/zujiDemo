//
//  ZYStudentAuthFooter.h
//  Apollo
//
//  Created by 李明伟 on 2018/7/18.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ZYStudentAuthFooterHeight (350 * UI_H_SCALE)

@interface ZYStudentAuthFooter : UIView

@property (nonatomic , strong) UIImageView *cardIV;
@property (nonatomic , strong) ZYElasticButton *submitBtn;

@end
