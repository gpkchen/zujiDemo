//
//  ZYMineOrderBtn.h
//  Apollo
//
//  Created by 李明伟 on 2018/9/4.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYElasticButton.h"

@interface ZYMineOrderBtn : ZYElasticButton

@property (nonatomic , strong) UIImage *icon;
@property (nonatomic , copy) NSString *title;
@property (nonatomic , assign) int num;
@property (nonatomic , assign) ZYOrderState orderState;

@end
