//
//  GetAppVersionInfo.h
//  Apollo
//
//  Created by 李明伟 on 2018/5/25.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**app更新信息查询参数*/
@interface _p_GetAppVersionInfo : ZYBaseParam

@end






/**app更新信息查询返回*/
@interface _m_GetAppVersionInfo : ZYBaseModel

/**版本号*/
@property (nonatomic , assign) int code;
/**版本名称*/
@property (nonatomic , copy) NSString *name;
/**强制更新起始版本*/
@property (nonatomic , assign) int necessaryFrom;
/**下载地址*/
@property (nonatomic , copy) NSString *url;
/**包大小*/
@property (nonatomic , copy) NSString *packageSize;
/**备注*/
@property (nonatomic , copy) NSString *remarks;
/**版本发布时间*/
@property (nonatomic , copy) NSString *releaseTime;

@end
