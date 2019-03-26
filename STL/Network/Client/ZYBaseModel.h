//
//  ZYBaseModel.h
//  Apollo
//
//  Created by 李明伟 on 2018/4/17.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**http返回基类*/
@interface ZYBaseModel : NSObject

/**便利构造器*/
- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
