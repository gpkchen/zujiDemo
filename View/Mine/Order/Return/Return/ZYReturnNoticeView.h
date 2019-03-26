//
//  ZYReturnNoticeView.h
//  Apollo
//
//  Created by 李明伟 on 2018/11/6.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYReturnNoticeView : UIImageView

@property (nonatomic , assign) BOOL isShowed;
@property (nonatomic , assign) CGRect beginFrame;
@property (nonatomic , assign) CGRect endFrame;

- (void)show;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
