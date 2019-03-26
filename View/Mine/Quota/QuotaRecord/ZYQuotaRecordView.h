//
//  ZYQuotaRecordView.h
//  Apollo
//
//  Created by 李明伟 on 2018/10/31.
//  Copyright © 2018 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYQuotaRecordView : UIView

@property (nonatomic , assign) double authAmount; //免押额度
@property (nonatomic , assign) double creditAmount; //可用额度

@property (nonatomic , strong) UIView *amountBack;
@property (nonatomic , strong) ZYTableView *tableView;
@property (nonatomic , strong) ZYElasticButton *instructionBtn;

@end

NS_ASSUME_NONNULL_END
