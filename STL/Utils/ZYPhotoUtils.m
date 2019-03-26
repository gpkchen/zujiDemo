//
//  ZYPhotoUtils.m
//  PodLib
//
//  Created by 李明伟 on 2018/3/28.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYPhotoUtils.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import "UIAlertView+ZYExtension.h"
#import "ZYAppUtils.h"
#import "ZYMacro.h"

@interface ZYPhotoUtils ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic , strong) UIImagePickerController *imagePicker;    //相机相册
@property (nonatomic , copy) void (^pickPhotoCallback)(UIImage *image); //选择照片回调
@property (nonatomic , copy) void (^pickPhotoDismissCallback)(void);    //选择照片消失回调
@property (nonatomic , assign) BOOL editable; //是否可编辑

@end

@implementation ZYPhotoUtils

+ (instancetype) utils{
    static ZYPhotoUtils *_instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instance = [[ZYPhotoUtils alloc] init];
    });
    
    return _instance;
}

#pragma mark - getter
- (UIImagePickerController *)imagePicker{
    if(!_imagePicker){
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
    }
    return _imagePicker;
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    __weak __typeof__(self) weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image = nil;
        if(weakSelf.editable){
            image = [info objectForKey:UIImagePickerControllerEditedImage];
        }else{
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        !weakSelf.pickPhotoCallback ? : weakSelf.pickPhotoCallback(image);
        weakSelf.pickPhotoCallback = nil;
        !weakSelf.pickPhotoDismissCallback ? : weakSelf.pickPhotoDismissCallback();
        weakSelf.pickPhotoDismissCallback = nil;
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    __weak __typeof__(self) weakSelf = self;
    [picker dismissViewControllerAnimated:YES
                               completion:^{
                                   !weakSelf.pickPhotoDismissCallback ? : weakSelf.pickPhotoDismissCallback();
                                   weakSelf.pickPhotoDismissCallback = nil;
                               }];
}

#pragma mark - 拍照
- (void)callCamera:(UIViewController *)viewController
          callback:(void(^)(UIImage *image))callback{
    [self callCamera:viewController editable:NO callback:callback dismissCallback:nil];
}

- (void)callCamera:(UIViewController *)viewController
          editable:(BOOL)editable
          callback:(void(^)(UIImage *image))callback
   dismissCallback:(void (^)(void))dismissCallback{
    __weak __typeof__(self) weakSelf = self;
    [ZYPhotoUtils isAuthAccessCarmera:^(BOOL granted) {
        if(granted){
            weakSelf.pickPhotoCallback = callback;
            weakSelf.pickPhotoDismissCallback = dismissCallback;
            weakSelf.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            weakSelf.imagePicker.allowsEditing = editable;
            weakSelf.editable = editable;
            [viewController presentViewController:weakSelf.imagePicker
                                         animated:YES
                                       completion:^{
                                       }];
        }
    }];
}

#pragma mark - 相册选择
- (void)callAlbum:(UIViewController *)viewController
         callback:(void(^)(UIImage *image))callback{
    [self callAlbum:viewController editable:NO callback:callback dismissCallback:nil];
}

- (void)callAlbum:(UIViewController *)viewController
         editable:(BOOL)editable
         callback:(void(^)(UIImage *image))callback
  dismissCallback:(void(^)(void))dismissCallback{
    if(![ZYPhotoUtils isAuthAccessPhotos]){
        return;
    }
    _pickPhotoCallback = callback;
    _pickPhotoDismissCallback = dismissCallback;
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.allowsEditing = editable;
    self.editable = editable;
    [viewController presentViewController:self.imagePicker
                                 animated:YES
                               completion:^{
                               }];
}

#pragma mark - 检测相机权限
+ (BOOL)isAuthAccessCarmera:(ZYPhotoUtilsRequireAccessResult)result{
#if TARGET_IPHONE_SIMULATOR
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"模拟器不能使用相机功能"
                                          cancelButtonTitle:@"我知道了"
                                          otherButtonTitles:nil
                                                clickAction:nil];
    [alert show];
    return NO;
#else
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if(status == AVAuthorizationStatusDenied){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:[NSString stringWithFormat:@"请授权%@可以访问相机,设置方式:设置->%@->相机,允许%@访问相机", APP_NAME, APP_NAME, APP_NAME]
                                                  cancelButtonTitle:@"暂不"
                                                  otherButtonTitles:@[@"去设置"]
                                                        clickAction:^(NSInteger index) {
                                                            if(1 == index){
                                                                [ZYAppUtils openURL:UIApplicationOpenSettingsURLString];
                                                            }
                                                        }];
            [alert show];
            !result ? : result(NO);
            return NO;
        }
        if(status == AVAuthorizationStatusNotDetermined){
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                !result ? : result(granted);
            }];
            return NO;
        }
    }
    
    !result ? : result(YES);
    return YES;
#endif
}

#pragma mark - 检测相册权限
+ (BOOL)isAuthAccessPhotos{
    BOOL isAuth = YES;
    float osVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(osVersion >= 9.0) {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if(status == PHAuthorizationStatusDenied){
            isAuth = NO;
        }
    }else {
        if (osVersion >= 6.0) {
            ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
            if(status == ALAuthorizationStatusDenied){
                isAuth = NO;
            }
        }
    }
    if(!isAuth){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:[NSString stringWithFormat:@"请授权%@可以访问相机,设置方式:设置->%@->相机,允许%@访问相机", APP_NAME, APP_NAME, APP_NAME]
                                              cancelButtonTitle:@"暂不"
                                              otherButtonTitles:@[@"去设置"]
                                                    clickAction:^(NSInteger index) {
                                                        if(1 == index){
                                                            [ZYAppUtils openURL:UIApplicationOpenSettingsURLString];
                                                        }
                                                    }];
        [alert show];
    }
    return isAuth;
}

@end
