//
//  ZYImageTitleButton.h
//  Apollo
//
//  Created by 李明伟 on 2018/4/26.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYElasticButton.h"

/**图片文字按钮*/
@interface ZYImageTitleButton : ZYElasticButton

/**图片*/
@property (nonatomic , strong) UIImage *image;
/**图片*/
@property (nonatomic , copy) NSString *title;
/**标题颜色*/
@property (nonatomic , strong) UIColor *titleColor;
/**标题字体*/
@property (nonatomic , strong) UIFont *titleFont;
/**图片文字间距*/
@property (nonatomic , assign) CGFloat spacing;

@end
