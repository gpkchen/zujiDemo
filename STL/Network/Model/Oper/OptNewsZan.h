//
//  OptNewsZan.h
//  Apollo
//
//  Created by 李明伟 on 2018/7/26.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**资讯点赞或者取消点赞参数*/
@interface _p_OptNewsZan : ZYBaseParam

/**发布内容id*/
@property (nonatomic , copy) NSString *newsId;
/**1-点赞 2-取消点赞*/
@property (nonatomic , copy) NSString *status;

@end
