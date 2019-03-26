//
//  ZYFormulaView.h
//  Apollo
//
//  Created by 李明伟 on 2018/11/26.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYFormulaView : UIView

@property (nonatomic , copy) NSString *formula;

- (void)showAtPoint:(CGPoint)point;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
