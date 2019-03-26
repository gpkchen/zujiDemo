//
//  ZYImageUploadBase64.h
//  Apollo
//
//  Created by shaxia on 2018/5/16.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYBaseParam.h"

/**base64上传照片参数*/
@interface _p_ZYImageUploadBase64 : ZYBaseParam

/**base64图片编码*/
@property (nonatomic , strong) NSString *base64;
/**场景
 用户学生相关：user/student
 用户头像：user/headerimg
 用户身份证：user/idcard
 商品/宝贝图片：goods/img
 商品/宝贝详情：goods/detail
 品牌图标：logo/brand
 广告/活动图：active
 版块配置：module*/
@property (nonatomic , strong) NSString *scene;
/**类型*/
@property (nonatomic , strong) NSString *contentType;

@end

/**base64上传照片返回*/
@interface _m_ZYImageUploadBase64 : ZYBaseModel

/**url*/
@property (nonatomic , strong) NSString *url;

@end
