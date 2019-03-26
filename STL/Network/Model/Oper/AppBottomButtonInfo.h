//
//  AppBottomButtonInfo.h
//  Apollo
//
//  Created by 李明伟 on 2018/7/31.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**获取tabbar图片参数*/
@interface _p_AppBottomButtonInfo : ZYBaseParam

@end



/**获取tabbar图片返回*/
@interface _m_AppBottomButtonInfo : ZYBaseModel

/**底图*/
@property (nonatomic , copy) NSString *bottomImageUrl;
/**默认图片 imageUrl url*/
@property (nonatomic , strong) NSArray *defaultImages;
/**选中图片地址 imageUrl url*/
@property (nonatomic , strong) NSArray *checkedImages;

@end
