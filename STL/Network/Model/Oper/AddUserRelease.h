//
//  AddUserRelease.h
//  Apollo
//
//  Created by 李明伟 on 2018/7/24.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**发布资讯参数*/
@interface _p_AddUserRelease : ZYBaseParam

/**文字内容*/
@property (nonatomic , copy) NSString *content;
/**图片*/
@property (nonatomic , strong) NSArray *images;

@end
