//
//  MerchantAddressList.h
//  Apollo
//
//  Created by 李明伟 on 2018/5/14.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**门店列表查询参数*/
@interface _p_MerchantAddressList : ZYBaseParam

@property (nonatomic , copy) NSString *page;
@property (nonatomic , copy) NSString *size;
/**经度*/
@property (nonatomic , copy) NSString *longitude;
/**纬度*/
@property (nonatomic , copy) NSString *latitude;
/**宝贝id*/
@property (nonatomic , copy) NSString *itemId;
/**1-上门归还 2-邮寄归还 3-上门自提*/
@property (nonatomic , copy) NSString *addressUseScene;

@end




/**门店列表查询返回*/
@interface _m_MerchantAddressList : ZYBaseModel

/**门店id*/
@property (nonatomic , copy) NSString *merchantAddressId;
/**门店名称*/
@property (nonatomic , copy) NSString *addressName;
/**门店电话*/
@property (nonatomic , copy) NSString *telephone;
/**门店地址*/
@property (nonatomic , copy) NSString *completeAddress;
/**联系人*/
@property (nonatomic , copy) NSString *contact;
/**距离*/
@property (nonatomic , copy) NSString *distance;

/**本地：记录cell高度*/
@property (nonatomic , assign) CGFloat cellHeight;
/**本地：记录距离排序位置*/
@property (nonatomic , assign) int index;

@end
