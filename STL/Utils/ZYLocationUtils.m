//
//  ZYLocationUtils.m
//  Apollo
//
//  Created by 李明伟 on 2018/4/10.
//  Copyright © 2018年 ZhuangYu. All rights reserved.
//

#import "ZYLocationUtils.h"
#import "UIAlertView+ZYExtension.h"
#import "ZYAppUtils.h"
#import "ZYMacro.h"
#import "NSUserDefaults+ZYExtension.h"
#import <CoreLocation/CoreLocation.h>

@implementation ZYLocation

- (id)initWithCoder:(NSCoder *)coder{
    _longitude          = [coder decodeObjectForKey:@"longitude"];
    _latitude           = [coder decodeObjectForKey:@"latitude"];
    _country            = [coder decodeObjectForKey:@"country"];
    _province           = [coder decodeObjectForKey:@"province"];
    _city               = [coder decodeObjectForKey:@"city"];
    _district           = [coder decodeObjectForKey:@"district"];
    _street             = [coder decodeObjectForKey:@"street"];
    _number             = [coder decodeObjectForKey:@"number"];
    _address            = [coder decodeObjectForKey:@"address"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder{
    [coder encodeObject:_longitude          forKey:@"longitude"];
    [coder encodeObject:_latitude           forKey:@"latitude"];
    [coder encodeObject:_country            forKey:@"country"];
    [coder encodeObject:_province           forKey:@"province"];
    [coder encodeObject:_city               forKey:@"city"];
    [coder encodeObject:_district           forKey:@"district"];
    [coder encodeObject:_street             forKey:@"street"];
    [coder encodeObject:_number             forKey:@"number"];
    [coder encodeObject:_address            forKey:@"address"];
}

- (id)copyWithZone:(nullable NSZone *)zone{
    ZYLocation *loc        = [ZYLocation new];
    loc.longitude          = _longitude;
    loc.latitude           = _latitude;
    loc.country            = _country;
    loc.province           = _province;
    loc.city               = _city;
    loc.district           = _district;
    loc.street             = _street;
    loc.number             = _number;
    loc.address            = _address;
    return loc;
}

@end



NSString * const ZYLocationSuccessNotification = @"ZYLocationSuccessNotification"; //定位成功通知名
NSString * const ZYLocationChangedNotification = @"ZYLocationChangedNotification"; //定位区域发生变化通知名

static NSString * const kZYLocationStorageKey  = @"kZYLocationStorageKey";         //存储上一次定位数据的key


@interface ZYLocationUtils ()<CLLocationManagerDelegate>

@property (nonatomic , strong) ZYLocation *userLocation;
@property (nonatomic , strong) CLLocationManager *locationManager;

@property (nonatomic , assign) BOOL isLocSuccess;

@end


@implementation ZYLocationUtils

+ (instancetype) utils{
    static ZYLocationUtils *_instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instance = [[ZYLocationUtils alloc] init];
    });
    
    return _instance;
}

#pragma mark - public
- (BOOL) isAuthLocation:(BOOL)shouldNotice{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if(status == kCLAuthorizationStatusNotDetermined){
        //请求权限
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8){
            //由于IOS8中定位的授权机制改变 需要进行手动授权
            //获取授权认证
            [self.locationManager requestWhenInUseAuthorization];
        }
        return NO;
    }
    if (status == kCLAuthorizationStatusDenied){
        if(shouldNotice){
            NSString *name = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:[NSString stringWithFormat:@"请打开“定位服务”来允许“%@”为您提供更精准的服务！",name]
                                                  cancelButtonTitle:@"暂不"
                                                  otherButtonTitles:@[@"去设置"]
                                                        clickAction:^(NSInteger index) {
                                                            if(1 == index){
                                                                [ZYAppUtils openURL:UIApplicationOpenSettingsURLString];
                                                            }
                                                        }];
            [alert show];
        }
        return NO;
    }
    return YES;
}

- (void)startLocating:(BOOL)shouldNotice{
    if(![self isAuthLocation:shouldNotice]){
        return;
    }
    [self.locationManager startUpdatingLocation];
}

- (void)stopLocating{
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    //获取定位的坐标
    CLLocation *location = [locations firstObject];
    //获取坐标
    CLLocationCoordinate2D coordinate = location.coordinate;
    NSLog(@"定位的坐标：%f,%f", coordinate.longitude, coordinate.latitude);
    //反地理
    [self reverseGeo:location];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
//    [ZYToast showWithTitle:@"定位发生错误！"];
}
          
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if(status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways){
        [self startLocating:NO];
    }
}

#pragma mark - 反地理
- (void)reverseGeo:(CLLocation *)location{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *mark = [placemarks firstObject];
        ZYLocation *loc      = [[ZYLocation alloc]init];
        loc.latitude         = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
        loc.longitude        = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
        loc.province         = mark.administrativeArea;
        loc.city             = mark.locality;
        loc.district         = mark.subLocality;
        loc.country          = mark.country;
        loc.street           = mark.thoroughfare;
        loc.number           = mark.subThoroughfare;
        loc.address          = mark.name;
        self.isLocSuccess        = YES;
        self.userLocation        = loc;

        //区域发生变化，发起通知
        if(![loc.street isEqualToString:self.userLocation.street]){
            [[NSNotificationCenter defaultCenter] postNotificationName:ZYLocationChangedNotification object:nil];
        }

        //每次将地理信息存下来
        [NSUserDefaults writeWithObject:loc forKey:kZYLocationStorageKey];

        //发起全局的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:ZYLocationSuccessNotification object:nil];
    }];
}

#pragma mark - getter
- (ZYLocation *) userLocation{
    //没有定位权限直接反空
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusDenied){
        return nil;
    }
    //如果定位不成功，先试图读取本地存储的上一次定位信息
    if(!_userLocation){
        _userLocation = [NSUserDefaults readObjectWithKey:kZYLocationStorageKey];
    }
    
    return _userLocation;
}

- (CLLocationManager *)locationManager{
    if(!_locationManager){
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 100.0f;
    }
    return _locationManager;
}

@end
