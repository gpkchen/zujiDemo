//
//  ZYStoreChoiseVC.h
//  Apollo
//
//  Created by 李明伟 on 2018/5/11.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseVC.h"

@interface ZYStoreChoiseVC : ZYBaseVC

/**已选中的门店id*/
@property (nonatomic , copy) NSString *selectedStoreId;
/**宝贝id*/
@property (nonatomic , copy) NSString *itemId;
/**1-上门归还 2-邮寄归还 3-上门自提*/
@property (nonatomic , copy) NSString *addressUseScene;

@end
