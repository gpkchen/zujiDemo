//
//  ZYMineHeader.h
//  Apollo
//
//  Created by 李明伟 on 2018/9/4.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetMyHomeInfo.h"
#import "AuditStatus.h"
#import "ZYMineOrderBtn.h"

#define ZYMineHeaderHeight (485 * UI_H_SCALE + FRINGE_TOP_EXTRA_HEIGHT)

@interface ZYMineHeader : UIView

@property (nonatomic , strong) UILabel *nicknameLab;
@property (nonatomic , strong) UILabel *userCenterLab;
@property (nonatomic , strong) UIImageView *portrait;
@property (nonatomic , strong) ZYElasticButton *authBtn;
@property (nonatomic , strong) ZYElasticButton *recordBtn;
@property (nonatomic , strong) ZYElasticButton *instructionBtn;

@property (nonatomic , strong) UILabel *allOrderLab;
@property (nonatomic , strong) NSMutableArray *orderBtns;
@property (nonatomic , strong) ZYElasticButton *quotaHelpBtn;

/**基础数据*/
@property (nonatomic , strong) _m_GetMyHomeInfo *mineInfo;
/**授信数据*/
@property (nonatomic , strong) _m_AuditStatus *authInfo;

@end
