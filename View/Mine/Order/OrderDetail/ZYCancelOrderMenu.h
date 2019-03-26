//
//  ZYCancelOrderMenu.h
//  Apollo
//
//  Created by 李明伟 on 2018/9/25.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseSheet.h"
#import "ZYBaseTableCell.h"


@interface ZYCancelOrderMenuCell : ZYBaseTableCell

@end




@interface ZYCancelOrderMenu : ZYBaseSheet

@property (nonatomic , copy) void (^confirmBlock)(NSString *reason);

@end
