//
//  ZYFoundCell.h
//  Apollo
//
//  Created by 李明伟 on 2018/7/9.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseTableCell.h"

typedef NS_ENUM(int , ZYFoundCellType) {
    ZYFoundCellTypeRecomend = 1, //推荐
    ZYFoundCellTypeMoment = 2, //此刻
    ZYFoundCellTypeUserCenter = 3, //用户中心
};

@class _m_AppFoundPage;
@class _m_AppUserReleaseListInfo;
@class _m_AppMyReleaseListInfo;
@interface ZYFoundCell : ZYBaseTableCell

/**构造*/
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier type:(ZYFoundCellType)type;

/**更多按钮*/
@property (nonatomic , strong) ZYElasticButton *moreBtn;

/**显示推荐列表*/
- (void)showRecommend:(_m_AppFoundPage *)model;
/**显示此刻列表*/
- (void)showMoment:(_m_AppUserReleaseListInfo *)model;
/**显示用户中心列表*/
- (void)showUserCenterMoment:(_m_AppMyReleaseListInfo *)model;

@end
