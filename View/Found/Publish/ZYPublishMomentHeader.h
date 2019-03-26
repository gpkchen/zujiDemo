//
//  ZYPublishMomentHeader.h
//  Apollo
//
//  Created by 李明伟 on 2018/7/24.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ZYPublishMomentHeaderHeight (200 * UI_H_SCALE)

typedef void (^ZYPublishMomentHeaderContentChangeBlock)(NSString *content);

@interface ZYPublishMomentHeader : UICollectionReusableView

@property (nonatomic , strong) ZYTextView *textView;
@property (nonatomic , strong) UILabel *numLab;

@property (nonatomic , copy) ZYPublishMomentHeaderContentChangeBlock block;

@end
