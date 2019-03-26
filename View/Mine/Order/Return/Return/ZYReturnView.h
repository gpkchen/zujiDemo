//
//  ZYReturnView.h
//  Apollo
//
//  Created by 李明伟 on 2018/11/6.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYReturnNoticeView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZYReturnView : UIView

@property (nonatomic , strong) ZYElasticButton *mailBtn;
@property (nonatomic , strong) ZYTableView *tableView;
@property (nonatomic , strong) ZYReturnNoticeView *noticeView;

@property (nonatomic , assign) int mode; //模式：1邮寄，2到店归还有地址，3到店归还无地址

@end

NS_ASSUME_NONNULL_END
