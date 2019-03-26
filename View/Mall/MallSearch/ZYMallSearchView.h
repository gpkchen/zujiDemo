//
//  ZYMallSearchView.h
//  Apollo
//
//  Created by 李明伟 on 2018/8/1.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYEqualSpaceFlowLayout.h"

@interface ZYMallSearchView : UIView

@property (nonatomic , strong) ZYEqualSpaceFlowLayout *layout;
@property (nonatomic , strong) ZYCollectionView *collectionView;

@end
