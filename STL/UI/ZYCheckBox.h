//
//  ZYCheckBox.h
//  PodLib
//
//  Created by 李明伟 on 2018/3/28.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**复选框*/
@interface ZYCheckBox : UIButton

/**正常图片*/
@property (nonatomic , strong) UIImage *normalImage;
/**选中图片*/
@property (nonatomic , strong) UIImage *selectedImage;

/**便利构造器*/
- (instancetype) initWithNormalImage:(UIImage *)normalImg selectedImage:(UIImage *)selectedImg;

@end
