//
//  ZYTextField.h
//  PodLib
//
//  Created by 李明伟 on 2018/3/28.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**完善系统的TextField，加入一些常用但是设置麻烦的属性*/
@interface ZYTextField : UITextField

/**字数限制*/
@property (nonatomic , assign) NSUInteger wordLimitNum;
/**提示文字颜色*/
@property (nonatomic , strong) UIColor *placeholderColor;
/**提示文字字体*/
@property (nonatomic , strong) UIFont *placeholderFont;

@end
