//
//  ZYBillDetailView.h
//  Apollo
//
//  Created by 李明伟 on 2018/4/28.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYBillDetailHeader.h"

@interface ZYBillDetailView : UIView

@property (nonatomic , strong) ZYElasticButton *payBtn;
@property (nonatomic , strong) ZYTableView *tableView;
@property (nonatomic , strong) ZYBillDetailHeader *header;

@end
