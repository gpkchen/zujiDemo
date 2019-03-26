//
//  ZYUser.h
//  Apollo
//
//  Created by 李明伟 on 2018/4/20.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**登录用户信息（持久化）*/
@interface ZYUser : NSObject<NSCoding>

/**用户id*/
@property (nonatomic , copy) NSString *userId;
/**手机号*/
@property (nonatomic , copy) NSString *mobile;
/**昵称*/
@property (nonatomic , copy) NSString *nickname;
/**头像路径*/
@property (nonatomic , copy) NSString *portraitPath;
/**接口请求令牌*/
@property (nonatomic , copy) NSString *apiToken;
/**刷新令牌*/
@property (nonatomic , copy) NSString *refreshToken;


/**Tab:底图*/
@property (nonatomic , copy) NSString *bottomImageUrl;
/**Tab:发现图标正常*/
@property (nonatomic , copy) NSString *foundImg;
/**Tab:发现图标选中*/
@property (nonatomic , copy) NSString *foundImgSelected;
/**Tab:商城图标正常*/
@property (nonatomic , copy) NSString *mallImg;
/**Tab:商城图标选中*/
@property (nonatomic , copy) NSString *mallImgSelected;
/**Tab:分享图标正常*/
@property (nonatomic , copy) NSString *shareImg;
/**Tab:分享图标选中*/
@property (nonatomic , copy) NSString *shareImgSelected;
/**Tab:我的图标正常*/
@property (nonatomic , copy) NSString *mineImg;
/**Tab:我的图标选中*/
@property (nonatomic , copy) NSString *mineImgSelected;



/**用户是否已登录*/
@property (nonatomic , assign , readonly) BOOL isUserLogined;
/**是否具备静默登录条件*/
@property (nonatomic , assign , readonly) BOOL silenceLoginAbility;

/**单例*/
+ (instancetype) user;

/**保存*/
- (void) save;
/**移除登录信息*/
- (void) removeLoginInfo;

@end
