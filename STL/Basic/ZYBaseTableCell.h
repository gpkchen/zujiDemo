//
//  ZYBaseTableCell.h
//  PodLib
//
//  Created by 李明伟 on 2018/3/28.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**TableViewCell基类*/
@interface ZYBaseTableCell : UITableViewCell

/**自定义cell分割线，默认隐藏*/
@property (nonnull , nonatomic , strong , readonly) UIImageView *separator;
/**自定义cell箭头，默认隐藏、居中、右边偏移10*/
@property (nonnull , nonatomic , strong , readonly) UIImageView *arrow;
/**向右箭头图片*/
@property (nullable , nonatomic , strong) UIImage *arrowImg;

/**便利构造*/
- (instancetype) initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
