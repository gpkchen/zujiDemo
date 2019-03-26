//
//  ZYLikeButton.h
//  Apollo
//
//  Created by 李明伟 on 2018/7/26.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYElasticButton.h"

typedef void (^ZYLikeButtonActionResult)(BOOL isLiked);

@interface ZYLikeButton : ZYElasticButton

/**是否已点赞*/
@property (nonatomic , assign) BOOL isLiked;
/**原始大小（图片大小）*/
@property (nonatomic , assign , readonly) CGSize originSize;

/**内容来源*/
@property (nonatomic , assign) ZYArticleSource contentSource;
/**内容id*/
@property (nonatomic , copy) NSString *contentId;

/**成功回调*/
@property (nonatomic , copy) ZYLikeButtonActionResult actionResult;

@end
