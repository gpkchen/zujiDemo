//
//  ZYCollectView.h
//  Apollo
//
//  Created by 李明伟 on 2018/11/22.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYCollectView : UIView

@property (nonatomic , strong) ZYTableView *tableView;

@property (nonatomic , strong) UIView *toolBar;
@property (nonatomic , strong) UIView *line;
@property (nonatomic , strong) UIImageView *allIV;
@property (nonatomic , strong) ZYElasticButton *allBtn;
@property (nonatomic , strong) UILabel *allLab;
@property (nonatomic , strong) ZYElasticButton *deleteAllBtn;

@end

NS_ASSUME_NONNULL_END
