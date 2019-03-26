//
//  ZYPublishMomentCell.h
//  Apollo
//
//  Created by 李明伟 on 2018/7/24.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ZYPublishMomentCellSize ((SCREEN_WIDTH - 44 * UI_H_SCALE) / 3.0)

@interface ZYPublishMomentCell : UICollectionViewCell

@property (nonatomic , strong) UIImageView *iv;
@property (nonatomic , strong) ZYElasticButton *removeBtn;

@end
