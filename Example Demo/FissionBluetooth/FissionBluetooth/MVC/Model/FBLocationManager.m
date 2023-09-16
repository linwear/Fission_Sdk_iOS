//
//  FBLocationManager.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2023-08-29.
//

#import "FBLocationManager.h"

@interface FBLocationManager () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) CLLocation *location;

@property (nonatomic, copy) void(^locationSuccess)(CLLocation *location);

@property (nonatomic, copy) void(^locationFailure)(CLAuthorizationStatus status, NSError *error);

@property (nonatomic, assign) BOOL alertIsShow;

@end

@implementation FBLocationManager

+ (FBLocationManager *)sharedManager {
    static FBLocationManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = FBLocationManager.new;
    });
    return manager;
}

+ (void)startLocation:(void(^)(CLLocation *location))success failure:(void(^)(CLAuthorizationStatus status, NSError *error))failure {
    [FBLocationManager.sharedManager startLocation:success failure:failure];
}

+ (void)stopLocation {
    [FBLocationManager.sharedManager stopLocation];
}

- (void)startLocation:(void(^)(CLLocation *location))success failure:(void(^)(CLAuthorizationStatus status, NSError *error))failure {
    self.locationSuccess = success;
    self.locationFailure = failure;
    
    CLAuthorizationStatus aStatus;
    if (@available(iOS 14.0, *)) {
        aStatus = self.locationManager.authorizationStatus;
    } else {
        aStatus = CLLocationManager.authorizationStatus;
    }
    
    if (aStatus == kCLAuthorizationStatusNotDetermined ||
        aStatus == kCLAuthorizationStatusAuthorizedWhenInUse ||
        aStatus == kCLAuthorizationStatusAuthorizedAlways) {
        
        [self.locationManager startUpdatingLocation];
    }
    else {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:500 userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:LWLocalizbleString(@"Please allow %@ to access Location Services in iPhone's \"Settings-Privacy-Location Services\""), Tools.appName]}];
        if (failure) {
            failure(aStatus, error);
        }
        [self showErrorTitle:LWLocalizbleString(@"Unable to use location services") errorMessage:error.localizedDescription];
    }
}

- (void)stopLocation {
    [self.locationManager stopUpdatingLocation];
}

/// 最近一个定位信息
+ (CLLocation * _Nullable)location {
    return FBLocationManager.sharedManager.location;
}

- (CLLocationManager *)locationManager {
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc]init];
        [_locationManager requestWhenInUseAuthorization];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 100;
        _locationManager.allowsBackgroundLocationUpdates = YES;
    }
    return _locationManager;
}

#pragma mark - CLLocationManagerDelegate

/// 定位成功
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    self.location = locations.lastObject;
    if (self.locationSuccess) {
        self.locationSuccess(self.location);
    }
}

/// 定位失败
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    if (self.locationFailure) {
        if (@available(iOS 14.0, *)) {
            self.locationFailure(manager.authorizationStatus, error);
        } else {
            self.locationFailure(CLLocationManager.authorizationStatus, error);
        }
    }
}

/// 定位权限
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status != kCLAuthorizationStatusNotDetermined &&
        status != kCLAuthorizationStatusAuthorizedWhenInUse &&
        status != kCLAuthorizationStatusAuthorizedAlways) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:500 userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:LWLocalizbleString(@"Please allow %@ to access Location Services in iPhone's \"Settings-Privacy-Location Services\""), Tools.appName]}];
        if (self.locationFailure) {
            self.locationFailure(status, error);
        }
        
        [self showErrorTitle:LWLocalizbleString(@"Unable to use location services") errorMessage:error.localizedDescription];
    }
}

- (void)showErrorTitle:(NSString *)title errorMessage:(NSString *)message {
    
    if (!self.alertIsShow) {
        self.alertIsShow = YES;
        WeakSelf(self);
        [UIAlertObject presentAlertTitle:title message:message cancel:LWLocalizbleString(@"Cancel") sure:LWLocalizbleString(@"Set") block:^(AlertClickType clickType) {
            weakSelf.alertIsShow = NO;
            if (clickType == AlertClickType_Sure) {
                //进入系统设置页面，APP本身的权限管理页面
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
            }
        }];
    }
}

@end
