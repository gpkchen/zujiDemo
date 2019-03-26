//
//  ZYAddAddressVC.h
//  Apollo
//
//  Created by 李明伟 on 2018/4/25.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseVC.h"

typedef void (^ZYAddAddressVCSuccessBlock)(void);

@interface ZYAddAddressVC : ZYBaseVC

@property (nonatomic , copy) ZYAddAddressVCSuccessBlock successBlock;

@end
