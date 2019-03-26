//
//  ZYUploadImage.h
//  Apollo
//
//  Created by shaxia on 2018/5/10.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseParam.h"


/**上传照片参数*/
@interface _p_ZYUploadImage : ZYBaseParam

/**场景
 资讯图片：news/img
 用户学生相关：user/student
 用户头像：user/headerimg
 用户身份证：user/idcard
 商品/宝贝图片：goods/img
 商品/宝贝详情：goods/detail
 品牌图标：logo/brand
 广告/活动图：active
 版块配置：module*/
@property (nonatomic , strong) NSString *scene;

@end

/**上传照片返回*/
@interface _m_ZYUploadImage : ZYBaseModel

/**图片路径*/
@property (nonatomic , strong) NSString *url;

@end
