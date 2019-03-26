//
//  ZYAddAddressView.h
//  Apollo
//
//  Created by 李明伟 on 2018/4/25.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYAddAddressView : UIView

@property (nonatomic , strong) ZYTableView *tableView;

@property (nonatomic , strong) ZYTextField *receiverText;
@property (nonatomic , strong) ZYTextField *mobileText;
@property (nonatomic , strong) ZYTextView *addressText;

@property (nonatomic , strong) UIView *footer;
@property (nonatomic , strong) ZYElasticButton *saveBtn;

@end
