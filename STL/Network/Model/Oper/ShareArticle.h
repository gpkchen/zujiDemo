//
//  ShareArticle.h
//  Apollo
//
//  Created by 李明伟 on 2018/7/17.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**文章分享信息获取参数*/
@interface _p_ShareArticle : ZYBaseParam

/**来源id*/
@property (nonatomic , copy) NSString *sourceId;
/**来源*/
@property (nonatomic , copy) NSString *source;

@end




/**文章分享信息获取返回*/
@interface _m_ShareArticle : ZYBaseModel

/**分享协议*/
@property (nonatomic , copy) NSString *url;

@end
