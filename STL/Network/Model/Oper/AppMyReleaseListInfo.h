//
//  AppMyReleaseListInfo.h
//  Apollo
//
//  Created by 李明伟 on 2018/7/27.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**我的发布内容列表查询参数*/
@interface _p_AppMyReleaseListInfo : ZYBaseParam

@property (nonatomic , copy) NSString *page;
@property (nonatomic , copy) NSString *size;

/**发布人id*/
@property (nonatomic , copy) NSString *homepageUserId;

@end



/**我的发布内容列表查询返回*/
@interface _m_AppMyReleaseListInfo : ZYBaseModel

/**发布内容id*/
@property (nonatomic , copy) NSString *userReleaseId;
/**头像*/
@property (nonatomic , copy) NSString *avatar;
/**昵称*/
@property (nonatomic , copy) NSString *nickname;
/**标题（内容）*/
@property (nonatomic , copy) NSString *title;
/**发布时间*/
@property (nonatomic , copy) NSString *releaseTime;
/**点赞数*/
@property (nonatomic , assign) int zanAmount;
/**是否已经点赞 1-已赞 2-未赞*/
@property (nonatomic , assign) int isZan;
/**图片数组  imageUrl*/
@property (nonatomic , strong) NSArray *images;
/**点赞人头像  avatar*/
@property (nonatomic , strong) NSMutableArray *zanAvatars;

/**本地：记录cell高度*/
@property (nonatomic , assign) CGFloat cellHeight;

/**计算cell高度*/
- (void)countCellHeight;

@end
