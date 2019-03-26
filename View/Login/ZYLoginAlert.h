//
//  ZYLoginAlert.h
//  Apollo
//
//  Created by 李明伟 on 2018/9/3.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ZYLoginCompleteBlock)(BOOL isCancel);

@interface ZYLoginAlert : UIView

@property (nonatomic , copy) ZYLoginCompleteBlock completeBlock;

- (void)show;
- (void)dismiss;

@end
