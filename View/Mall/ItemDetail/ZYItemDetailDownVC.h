//
//  ZYItemDetailDownVC.h
//  Apollo
//
//  Created by 李明伟 on 2018/5/3.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYWebVC.h"

typedef void (^ZYItemDetailDownVCShouldScrollBlock)(void);

@interface ZYItemDetailDownVC : ZYWebVC

/**上拉显示详情回调*/
@property (nonatomic , copy) ZYItemDetailDownVCShouldScrollBlock scrollBlock;

@end
