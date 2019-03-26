//
//  NewsOrUserReleaseZanDetail.h
//  Apollo
//
//  Created by 李明伟 on 2018/8/2.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**咨询点赞信息查询参数*/
@interface _p_NewsOrUserReleaseZanDetail : ZYBaseParam

/**来源id*/
@property (nonatomic , copy) NSString *sourceId;
/**来源*/
@property (nonatomic , copy) NSString *source;

@end




/**咨询点赞信息查询返回*/
@interface _m_NewsOrUserReleaseZanDetail : ZYBaseModel

/**1-已赞 2-未赞*/
@property (nonatomic , assign) int isZan;
/**点赞人头像：avatar*/
@property (nonatomic , strong) NSMutableArray *zanAvatars;
/**点赞数*/
@property (nonatomic , assign) int zanAmount;

@end
