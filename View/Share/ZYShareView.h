//
//  ZYShareView.h
//  Apollo
//
//  Created by 李明伟 on 2018/4/17.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYShareHeader.h"
#import "ZYShareFooter.h"

@interface ZYShareView : UIView

@property (nonatomic , strong) ZYTableView *tableView;
@property (nonatomic , strong) ZYShareHeader *header;
@property (nonatomic , strong) ZYShareFooter *footer;

@end
