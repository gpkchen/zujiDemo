//
//  AppFoundPage.h
//  Apollo
//
//  Created by 李明伟 on 2018/7/9.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**发现页列表查询参数*/
@interface _p_AppFoundPage : ZYBaseParam

@property (nonatomic , copy) NSString *page;
@property (nonatomic , copy) NSString *size;

@end




/**发现页列表查询参数*/
@interface _m_AppFoundPage : ZYBaseModel

/**来源 1-资讯 2-用户*/
@property (nonatomic , assign) ZYArticleSource source;
/**资讯或者用户发布内容id*/
@property (nonatomic , copy) NSString *sourceId;
/**发布人（昵称）*/
@property (nonatomic , copy) NSString *publisher;
/**发布人头像*/
@property (nonatomic , copy) NSString *avatar;
/**标题 (内容)*/
@property (nonatomic , copy) NSString *title;
/**创建时间*/
@property (nonatomic , copy) NSString *createDate;
/**点赞人数*/
@property (nonatomic , assign) int zanAmount;
/**是否已经点赞 1-已赞 2-未赞*/
@property (nonatomic , assign) int isZan;
/**图片数组  imageUrl*/
@property (nonatomic , strong) NSArray *images;
/**点赞人头像  avatar*/
@property (nonatomic , strong) NSMutableArray *zanAvatars;
/**用户id*/
@property (nonatomic , copy) NSString *userId;

/**本地：记录cell高度*/
@property (nonatomic , assign) CGFloat cellHeight;

/**计算cell高度*/
- (void)countCellHeight;

@end
