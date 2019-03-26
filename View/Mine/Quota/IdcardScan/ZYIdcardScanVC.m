//
//  ZYIdcardScanVC.m
//  Apollo
//
//  Created by 李明伟 on 2018/7/10.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYIdcardScanVC.h"
#import "ZYIdcardScanView.h"
#import "ZYIdcardScanConfirmAlert.h"
#import "Globaltypedef.h"
#import <AVFoundation/AVFoundation.h>
#import "ZYImageUploadBase64.h"
#import "IdCardUpload.h"
#import "GTMBase64.h"

#if !TARGET_IPHONE_SIMULATOR
#import "SCCaptureCameraController.h"
#endif

@interface ZYIdcardScanVC ()

@property (nonatomic , strong) ZYIdcardScanView *baseView;
@property (nonatomic , strong) ZYIdcardScanConfirmAlert *confirmAlert;

@property (nonatomic , assign) TCARD_TYPE idcardType;
@property (nonatomic , assign) BOOL isFront; //当前是否是正面
@property (nonatomic , strong) UIImage *frontImage; //正面图片
@property (nonatomic , strong) UIImage *backImage; //背面图片
@property (nonatomic , strong) NSString *period; //身份证有效期
@property (nonatomic , strong) NSString *userName; //姓名
@property (nonatomic , strong) NSString *idCard; //身份证号
@property (nonatomic , strong) NSString *totalAddress; //详细地址
@property (nonatomic , strong) NSString *positivePath; //身份证正面路径
@property (nonatomic , strong) NSString *negativePath; //身份证反面路径

@end

@implementation ZYIdcardScanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = self.baseView;
    self.title = @"身份认证";
}

#pragma mark - 扫描身份证正面
- (void)scanFrontIDCard{
    _isFront = 1;
    [self startIDCardOCR];
    
}

#pragma mark - 扫描身份证反面
- (void)scanReverseIDCard{
    _isFront = 0;
    [self startIDCardOCR];
}


#pragma mark - 身份证扫描 CardType 20:反面 17：正面
-(void)sendTakeImage:(TCARD_TYPE)iCardType image:(UIImage *)cardImage{
    _idcardType = iCardType;
    if (iCardType == 17 && _isFront == 0) {
        [ZYToast showWithTitle:@"请扫描身份证反面"];
        return;
    }
    if (iCardType == 20 && _isFront == 1) {
        [ZYToast showWithTitle:@"请扫描身份证正面"];
        return;
    }
    if (iCardType == 17) {
        _frontImage = cardImage;
    }else if (iCardType == 20) {
        _backImage = cardImage;
    }
    [self uploadImage:cardImage];
}

#pragma mark - 获取身份证反面信息
- (void)sendIDCBackValue:(NSString *)issue PERIOD:(NSString *) period{
    if (_isFront) {
        [ZYToast showWithTitle:@"请扫描身份证正面"];
        return;
    }else {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.baseView.backIV.image = self.backImage;
        });
        self.period = period;
    }
}

#pragma mark - 获取身份证正面信息
- (void)sendIDCValue:(NSString *)name SEX:(NSString *)sex FOLK:(NSString *)folk BIRTHDAY:(NSString *)birthday ADDRESS:(NSString *)address NUM:(NSString *)num{
    if (!_isFront) {
        [ZYToast showWithTitle:@"请扫描身份证反面"];
        return;
    }else {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.baseView.frontIV.image = self.frontImage;
        });
        
        self.userName = name;
        self.totalAddress = address;
        self.idCard = num;
    }
}

#pragma mark - 身份证信息扫描
-(void)startIDCardOCR{
#if !TARGET_IPHONE_SIMULATOR
    [ZYPhotoUtils isAuthAccessCarmera:^(BOOL granted) {
        if (granted) {
            SCCaptureCameraController *con = [[SCCaptureCameraController alloc] init];
            con.scNaigationDelegate = self;
            con.iCardType = TIDCARD2;
            con.isDisPlayTxt = YES;
            con.ScanMode = TIDC_SCAN_MODE;
            [self presentViewController:con animated:YES completion:NULL];
        }
    }];
#endif
}

#pragma mark - 上传base64位图片信息
- (void)uploadImage:(UIImage *)image{
    _p_ZYImageUploadBase64 *param = [[_p_ZYImageUploadBase64 alloc] init];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.3);
    NSString *imageString = [imageData base64EncodedStringWithOptions:0];
    param.base64 = imageString;
    param.scene = @"user/idcard";
    [[ZYHttpClient client] post:param showHud:YES success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
        if (responseObj.success) {
            _m_ZYImageUploadBase64 *model = [_m_ZYImageUploadBase64 mj_objectWithKeyValues:responseObj.data];
            if (self.isFront) {
                self.positivePath = model.url;
            } else {
                self.negativePath = model.url;
            }
        } else {
            [ZYToast showWithTitle:responseObj.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if(error.code == ZYHttpErrorCodeTimeOut){
            [ZYToast showWithTitle:ZYHttpErrorMessageNetTimeOut];
        }else if(error.code == ZYHttpErrorCodeNoNet){
            [ZYToast showWithTitle:ZYHttpErrorMessageNoNet];
        }else if(error.code == ZYHttpErrorCodeSystemError){
            [ZYToast showWithTitle:ZYHttpErrorMessageSystemError];
        }
    } authFail:nil];
}

#pragma mark - upLoadIDCardInfo
- (void)upLoadIDCardInfo:(NSString *)name{
    _p_IdCardUpload *param = [[_p_IdCardUpload alloc] init];
    param.positivePath = self.positivePath;
    param.backPath  = self.negativePath;
    param.userName = name;
    param.idCard = [self.idCard tripleDES:kCCEncrypt key:[ZYEnvirUtils utils].protocolEncodeKey];
    param.totalAddress = self.totalAddress;
    param.period = self.period;
    __weak typeof(self) weakSlef = self;
    [[ZYHttpClient client] post:param showHud:YES success:^(NSURLSessionDataTask *task, ZYHttpResponse *responseObj) {
        if (responseObj.success) {
            [ZYToast showWithTitle:@"身份证信息上传成功！"];
            [weakSlef systemBackButtonClicked];
        }else{
            [ZYToast showWithTitle:responseObj.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if(error.code == ZYHttpErrorCodeTimeOut){
            [ZYToast showWithTitle:ZYHttpErrorMessageNetTimeOut];
        }else if(error.code == ZYHttpErrorCodeNoNet){
            [ZYToast showWithTitle:ZYHttpErrorMessageNoNet];
        }else if(error.code == ZYHttpErrorCodeSystemError){
            [ZYToast showWithTitle:ZYHttpErrorMessageSystemError];
        }
    } authFail:nil];
}

#pragma mark - getter
- (ZYIdcardScanView *)baseView{
    if(!_baseView){
        _baseView = [ZYIdcardScanView new];
        
        __weak typeof(self) weakSelf = self;
        [_baseView.frontIV tapped:^(UITapGestureRecognizer *gesture) {
            [weakSelf scanFrontIDCard];
        } delegate:nil];
        
        [_baseView.backIV tapped:^(UITapGestureRecognizer *gesture) {
            [weakSelf scanReverseIDCard];
        } delegate:nil];
        [_baseView.submitBtn clickAction:^(UIButton * _Nonnull button) {
            if (!weakSelf.positivePath) {
                [ZYToast showWithTitle:@"请选择身份证正面照！"];
                return;
            }
            if (!weakSelf.negativePath) {
                [ZYToast showWithTitle:@"请选择身份证反面照！"];
                return;
            }
            if (!weakSelf.userName) {
                [ZYToast showWithTitle:@"获取身份证姓名失败，请重新扫描！"];
                return;
            }
            if (!weakSelf.idCard) {
                [ZYToast showWithTitle:@"获取身份证号失败，请重新扫描！"];
                return;
            }
            if (!weakSelf.totalAddress) {
                [ZYToast showWithTitle:@"获取身份证地址失败，请重新扫描！"];
                return;
            }
            if (!weakSelf.period) {
                [ZYToast showWithTitle:@"获取身份证有效期失败，请重新扫描！"];
                return;
            }
            [weakSelf.confirmAlert showWithName:weakSelf.userName idcard:weakSelf.idCard];
        }];
    }
    return _baseView;
}

- (ZYIdcardScanConfirmAlert *)confirmAlert{
    if(!_confirmAlert){
        _confirmAlert = [ZYIdcardScanConfirmAlert new];
        
        __weak __typeof__(self) weakSelf = self;
        _confirmAlert.confirmAction = ^(NSString *name) {
            if([@"" isEqualToString:[name stringByReplacingOccurrencesOfString:@" " withString:@""]]){
                [ZYToast showWithTitle:@"请正确输入姓名！"];
                return;
            }
            [weakSelf upLoadIDCardInfo:name];
        };
    }
    return _confirmAlert;
}

@end
