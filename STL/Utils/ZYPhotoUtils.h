//
//  ZYPhotoUtils.h
//  PodLib
//
//  Created by 李明伟 on 2018/3/28.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^ZYPhotoUtilsRequireAccessResult)(BOOL granted);

/**照片管理工具*/
@interface ZYPhotoUtils : NSObject

/**单例*/
+ (instancetype) utils;

/**检测相机权限*/
+ (BOOL)isAuthAccessCarmera:(ZYPhotoUtilsRequireAccessResult)result;
/**检测相册权限*/
+ (BOOL)isAuthAccessPhotos;

/**拍照*/
- (void)callCamera:(UIViewController *)viewController
          callback:(void(^)(UIImage *image))callback;
- (void)callCamera:(UIViewController *)viewController
          editable:(BOOL)editable
          callback:(void(^)(UIImage *image))callback
   dismissCallback:(void(^)(void))dismissCallback;

/**相册选择*/
- (void)callAlbum:(UIViewController *)viewController
         callback:(void(^)(UIImage *image))callback;
- (void)callAlbum:(UIViewController *)viewController
         editable:(BOOL)editable
         callback:(void(^)(UIImage *image))callback
  dismissCallback:(void(^)(void))dismissCallback;

@end
