//
//  UnRead.h
//  Apollo
//
//  Created by 李明伟 on 2018/4/24.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**未读消息请求参数*/
@interface _p_UnRead : ZYBaseParam

@end

/**未读消息请求返回*/
@interface _m_UnRead : ZYBaseModel

/**是否是未读*/
@property (nonatomic , assign) BOOL unRead;

@end
