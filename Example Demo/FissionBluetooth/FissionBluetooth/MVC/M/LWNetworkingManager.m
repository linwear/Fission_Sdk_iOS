




#import "LWNetworkingManager.h"
#import "AFNetworking.h"

@interface LWNetworkingManager ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation LWNetworkingManager

+ (LWNetworkingManager *)sharedLWNetworkingManager {
    static LWNetworkingManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        instance = [[LWNetworkingManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {

        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://api-pre-release.linwear.top/"]];
        // 缓存策略
        manager.requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
//        manager.requestSerializer = [AFHTTPRequestSerializer serializer]; // 米西米西
        // 设置接收的Content-Type
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/html", @"text/plain", @"text/javascript", nil];
        // https 证书配置
        AFSecurityPolicy *sec = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        // 是否允许无效证书
        [sec setAllowInvalidCertificates:YES];
        // 是否验证域名
        [sec setValidatesDomainName:NO];
        /*
        // 设置证书
        NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"cerName" ofType:@"cer"];
        NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
        sec.pinnedCertificates = [NSSet setWithArray:@[cerData]];
        */
        manager.securityPolicy = sec;
        // 设置请求超时时间
        manager.requestSerializer.timeoutInterval = 15;
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        // 设置请求头
        [manager.requestSerializer setValue: @"6" forHTTPHeaderField:@"App-Type"];
        [manager.requestSerializer setValue: @"1.0.0" forHTTPHeaderField:@"App-Version"];
        [manager.requestSerializer setValue: @"iPhone8,1" forHTTPHeaderField:@"Phone-Model"];
        [manager.requestSerializer setValue: [UIDevice currentDevice].systemVersion forHTTPHeaderField:@"Phone-Version"];
        [manager.requestSerializer setValue: [NSLocale preferredLanguages].firstObject forHTTPHeaderField:@"Accept-Language"];
        
        self.manager = manager;
    }
    return self;
}

#pragma mark - 设置请求头部
+ (LWNetworkingManager *)setAFNetworkingHTTPHeader {
    
    LWNetworkingManager *httpManager = [LWNetworkingManager sharedLWNetworkingManager];
    
    NSString *token = [NSUserDefaults.standardUserDefaults objectForKey: @"LW_TOKEN"];
//    NSString *userid = [NSUserDefaults.standardUserDefaults objectForKey: LW_USER_ID];
    [httpManager.manager.requestSerializer setValue: StringHandle(token) forHTTPHeaderField:@"X-Token"];
//    [httpManager.manager.requestSerializer setValue: IF_NULL_TO_STRING(userid) forHTTPHeaderField:@"Uuid"];
    
    if (FBAllConfigObject.firmwareConfig.updateUTC > 0) {
        [httpManager.manager.requestSerializer setValue: @"2" forHTTPHeaderField:@"Sdk-Type"];
        [httpManager.manager.requestSerializer setValue: StringHandle(FBAllConfigObject.firmwareConfig.deviceName) forHTTPHeaderField:@"Bluetooth-Name"];
        [httpManager.manager.requestSerializer setValue: StringHandle(FBAllConfigObject.firmwareConfig.fitNumber) forHTTPHeaderField:@"Bluetooth-Adapter"];
        [httpManager.manager.requestSerializer setValue: StringHandle(FBAllConfigObject.firmwareConfig.mac) forHTTPHeaderField:@"Bluetooth-Address"];
        [httpManager.manager.requestSerializer setValue: StringHandle(FBAllConfigObject.firmwareConfig.firmwareVersion) forHTTPHeaderField:@"Ota-Version"];
    } else {
        [httpManager.manager.requestSerializer setValue: @"99" forHTTPHeaderField:@"Sdk-Type"];
        [httpManager.manager.requestSerializer setValue: @"99" forHTTPHeaderField:@"Bluetooth-Name"];
        [httpManager.manager.requestSerializer setValue: @"99" forHTTPHeaderField:@"Bluetooth-Adapter"];
        [httpManager.manager.requestSerializer setValue: @"99" forHTTPHeaderField:@"Bluetooth-Address"];
        [httpManager.manager.requestSerializer setValue: @"99" forHTTPHeaderField:@"Ota-Version"];
    }
    
//    LWLog(@"------请求头信息 Begin ------\n\nX-Token --- %@\nUuid --- %@\nApp-Type --- %@\nApp-Version --- %@\nPhone-Model --- %@\nPhone-Version --- %@\nAccept-Language --- %@\nSdk-Type --- %@\nBluetooth-Name --- %@\nBluetooth-Adapter --- %@\nBluetooth-Address --- %@\n------请求头信息 End------\n\n",token, userid, appType, LWDeviceInfo.getReleaseVersion, LWDeviceInfo.getDeviceModel, LWDeviceInfo.getSystemVersion, LWDeviceInfo.getDeviceCurrentLanguage, sdkType, bluetoothName, bluetoothAdapter, bluetoothAddress);
    return httpManager;
}

+ (void)requestURL:(NSString *)URLString
        httpMethod:(HttpMethod)method
            params:(NSDictionary *)params
           success:(void (^)(id _Nonnull))success
           failure:(void (^)(NSError * _Nonnull, id  _Nullable responseObject))failure
{
    LWNetworkingManager *httpManager = [self setAFNetworkingHTTPHeader];
    
    __weak typeof(self) weakSelf = self;
    switch (method) {
        case GET: {
            
//            LWLog(@"------GET请求------\n请求地址:%@\n请求参数:%@", URLString, params);

            [httpManager.manager GET:URLString parameters:params headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [weakSelf isTokenExpireWithTask:task];
                __strong typeof(self) strongSelf = weakSelf;
                [strongSelf handlerSuccessRequest:responseObject success:success];
                
                NSLog(@"------GET请求成功------\n%@", responseObject);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [weakSelf isTokenExpireWithTask:task];
                
                __strong typeof(self) strongSelf = weakSelf;
                
                NSData *data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                if (data != nil) {
                    id body = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    [strongSelf handlerFailureRequestURL:URLString httpMethod:GET requestParams:params responseObject:body error:error failure:failure];
                    NSLog(@"------GET请求失败------\n%@", body);
                } else {
                    [strongSelf handlerFailureRequestURL:URLString httpMethod:GET requestParams:params responseObject:nil error:error failure:failure];
                    NSLog(@"------GET请求失败------\n%@", error.localizedDescription);
                }
    
            }];
            
            break;
        }
            
        case POST: {
            
//            LWLog(@"------POST请求------\n请求地址:%@\n请求参数:%@", URLString, params);
            
            [httpManager.manager POST:URLString parameters:params headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [weakSelf isTokenExpireWithTask:task];
                
                __strong typeof(self) strongSelf = weakSelf;
                [strongSelf handlerSuccessRequest:responseObject success:success];
                
                NSLog(@"------POST请求成功------\n%@", responseObject);

            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [weakSelf isTokenExpireWithTask:task];
                
                __strong typeof(self) strongSelf = weakSelf;
                
                NSData *data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                if (data != nil) {
                    id body = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    [strongSelf handlerFailureRequestURL:URLString httpMethod:POST requestParams:params responseObject:body error:error failure:failure];
                    NSLog(@"------POST请求失败------\n%@", body);
                } else {
                    [strongSelf handlerFailureRequestURL:URLString httpMethod:POST requestParams:params responseObject:nil error:error failure:failure];
                    NSLog(@"------POST请求失败------\n%@", error.localizedDescription);
                }
            }];
            
            break;
        }
            
        case DELETE: {
            
//            LWLog(@"------DELETE请求------\n请求地址:%@\n请求参数:%@", URLString, params);

            [httpManager.manager DELETE:URLString parameters:params headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [weakSelf isTokenExpireWithTask:task];
                __strong typeof(self) strongSelf = weakSelf;
                [strongSelf handlerSuccessRequest:responseObject success:success];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [weakSelf isTokenExpireWithTask:task];
                __strong typeof(self) strongSelf = weakSelf;
                
                NSData *data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                if (data != nil) {
                    id body = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    [strongSelf handlerFailureRequestURL:URLString httpMethod:DELETE requestParams:params responseObject:body error:error failure:failure];
                    NSLog(@"------DELETE请求失败------\n%@", body);
                } else {
                    [strongSelf handlerFailureRequestURL:URLString httpMethod:DELETE requestParams:params responseObject:nil error:error failure:failure];
                    NSLog(@"------DELETE请求失败------\n%@", error.localizedDescription);
                }
            }];
            
            break;
        }
            
        case PUT: {
            
//            LWLog(@"------PUT请求------\n请求地址:%@\n请求参数:%@", URLString, params);
        
            [httpManager.manager PUT:URLString parameters:params headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [weakSelf isTokenExpireWithTask:task];
                __strong typeof(self) strongSelf = weakSelf;
                [strongSelf handlerSuccessRequest:responseObject success:success];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [weakSelf isTokenExpireWithTask:task];
                __strong typeof(self) strongSelf = weakSelf;
                
                NSData *data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                if (data != nil) {
                    id body = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    [strongSelf handlerFailureRequestURL:URLString httpMethod:PUT requestParams:params responseObject:body error:error failure:failure];
                    NSLog(@"------PUT请求失败------\n%@", body);
                } else {
                    [strongSelf handlerFailureRequestURL:URLString httpMethod:PUT requestParams:params responseObject:nil error:error failure:failure];
                    NSLog(@"------PUT请求失败------\n%@", error.localizedDescription);
                }
            }];
            
            break;
        }
    }
}

+ (void)requestDownloadURL:(NSString *)URLString
                   success:(void(^)(id result))success
                   failure:(void(^)(NSError *error, id  _Nullable responseObject))failure {
    // 下载任务
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

    NSURL *URL = [NSURL URLWithString: URLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
         
//        LWLog(@"下载进度：%.0f", downloadProgress.fractionCompleted);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        // 文件保存路径（命名：当前时间戳_文件名）
        NSString *pathName = [NSString stringWithFormat:@"%ld_%@",(NSInteger)NSDate.date.timeIntervalSince1970, URL.lastPathComponent];
        return [documentsDirectoryURL URLByAppendingPathComponent:pathName];

    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (response) {
            if (success) {
               success(@{@"filePath" : StringHandle(filePath.path)});
            }
        } else {
            if (failure) {
                NSData *data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                id body = nil;
                if (data != nil) {
                    body = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    NSLog(@"------下载文件失败------\n%@", body);
                } else {
                    NSLog(@"------下载文件失败------\n%@", data);
                }
                
                error = [self timeError:error];
                
                failure(error, body);
            }
        }
    }];
    
    [downloadTask resume];
}

+ (void)requestUpdateURL:(NSString *)URLString
              httpMethod:(HttpMethod)method
                  params:(NSDictionary *)params
                 success:(void(^)(id result))success
                 failure:(void(^)(NSError *error, id  _Nullable responseObject))failure {
    
    LWNetworkingManager *httpManager = [self setAFNetworkingHTTPHeader];

    __weak typeof(self) weakSelf = self;
    [httpManager.manager POST:URLString parameters:params headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSArray *images = params[@"images"];
        if (images.count != 0) {
            NSLog(@"上传images文件");
            for (UIImage *img in images) {
                NSData *imageData = UIImageJPEGRepresentation(img, 0.5);
               
                NSString *fileName = [NSString stringWithFormat:@"%f.png",NSDate.date.timeIntervalSince1970];

                /*
                1. 要上传的[二进制数据]
                2. 后台接收的字段或参数
                3. 要保存在服务器上的[文件名]
                4. 上传文件的[mimeType]
                */
                [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType: @"image/png"];
//                LWLog(@"\n------POST请求------\n请求地址:%@\n请求参数:%@", URLString, imageData);
            }
        }
        
        NSString *logsPath = params[@"txt"];
        if (logsPath.length > 0) {
            NSLog(@"上传txt文件,压缩失败后的log文件");
            NSString *string = [[NSString alloc] initWithContentsOfFile:logsPath encoding:NSUTF8StringEncoding error:nil];
            NSData *resData = [[NSData alloc]initWithData:[string dataUsingEncoding:NSUTF8StringEncoding]];
            
            NSString *fileName = [NSString stringWithFormat:@"%@ForiosLog%.f.txt", NSBundle.mainBundle.infoDictionary[@"CFBundleName"], NSDate.date.timeIntervalSince1970];
            [formData appendPartWithFileData:resData name:@"file" fileName:fileName mimeType: @"text/plain"];
//            LWLog(@"\n------POST请求------\n请求地址:%@\n请求参数:%@", URLString, resData);
        }
        
        NSString *logZipPath = params[@"zip"];
        if (logZipPath.length > 0) {
            NSLog(@"上传zip文件(压缩后的多个log文件)");
            NSString *string = [[NSString alloc] initWithContentsOfFile:logZipPath encoding:NSUTF8StringEncoding error:nil];
//            NSData *resData = [[NSData alloc]initWithData:[string dataUsingEncoding:NSUTF8StringEncoding]];
            NSData *resData = [NSData dataWithContentsOfFile:logZipPath];
            
            NSString *fileName = [NSString stringWithFormat:@"%@_iOS_ZipLog_%.f.txt", NSBundle.mainBundle.infoDictionary[@"CFBundleName"], NSDate.date.timeIntervalSince1970];
            [formData appendPartWithFileData:resData name:@"file" fileName:fileName mimeType: @"application/zip"];
        }
        
        NSData *videoData = params[@"video"];
        NSString *fileName = params[@"videoName"];
        if (videoData.length > 0) {
            NSLog(@"上传视频文件");
            [formData appendPartWithFileData:videoData name:@"file" fileName:fileName mimeType: @"application/mp4"];
        }
        
        NSArray *photoImages = params[@"photo"];
        NSString *photoFileName = params[@"photoName"];
        if (photoImages.count != 0) {
            NSLog(@"上传图片文件");
            for (UIImage *img in photoImages) {
                NSData *imageData = UIImageJPEGRepresentation(img, 0.5);
                [formData appendPartWithFileData:imageData name:@"file" fileName:photoFileName mimeType: @"image/png"];
            }
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"文件上传进度 %f", uploadProgress.fractionCompleted );
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf isTokenExpireWithTask:task];
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf handlerSuccessRequest:responseObject success:success];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf isTokenExpireWithTask:task];
        __strong typeof(self) strongSelf = weakSelf;
        
        NSHTTPURLResponse *response = error.userInfo[@"com.alamofire.serialization.response.error.data"];
        NSData *data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        id body = nil;
        if (data != nil) {
            body = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            [strongSelf handlerFailureRequestURL:URLString httpMethod:POST requestParams:params responseObject:body error:error failure:failure];
            NSLog(@"------POST上传文件请求失败------\n%@", body);
        } else {
            [strongSelf handlerFailureRequestURL:URLString httpMethod:POST requestParams:params responseObject:nil error:error failure:failure];
            NSLog(@"------POST上传文件请求失败------\n%@", error.localizedDescription);
        }
    }];
}


// 请求成功回调
+ (void)handlerSuccessRequest:(id  _Nullable)responseObject
                      success:(void (^)(id _Nonnull))success
{
    success(responseObject);
}

// 请求失败回调
+ (void)handlerFailureRequestURL:(NSString *)requestURL
                      httpMethod:(HttpMethod)method
                          requestParams:(NSDictionary *)requestParams
                        responseObject:(id  _Nullable)responseObject
                             error:(NSError * _Nonnull)error
                      failure:(void (^)(NSError * _Nonnull, id  _Nullable responseObject))failure
{
    NSLog(@"URL：%@", error.userInfo[@"NSErrorFailingURLKey"]);
    
    NSData *data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
    id body = nil;
    if (data != nil) {
        body = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    }
    NSLog(@"请求失败回调 body:%@ error:%@", body, error.localizedDescription);
    
    error = [self timeError:error];
    
    failure(error, body);

    NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
    
    if (response.statusCode == 401) { // Token 过期

        // token
        NSString *string = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [LWNetworkingManager requestURL:@"api/v1/base/login/local" httpMethod:POST params:@{@"userIdentify" : string} success:^(id  _Nonnull result) {
            
            if ([result[@"code"] integerValue] == 200) {
                NSString *token = result[@"data"][@"xtoken"];
                [NSUserDefaults.standardUserDefaults setObject: token forKey: @"LW_TOKEN"];
            }
        } failure:^(NSError * _Nonnull error, id  _Nullable responseObject) {
            FBLog(@"%@",error);
        }];
    }
}

+ (void)agaginRequsetURL:(NSString *)URLString
                        httpMethod:(HttpMethod)method
                  params:(NSDictionary *)params {

    [LWNetworkingManager requestURL:URLString httpMethod:method params:params success:^(id  _Nonnull result) {

        
    } failure:^(NSError * _Nonnull error, id  _Nullable responseObject) {

    }];
    
}



//解析请求头返回内容
+(void)isTokenExpireWithTask:(NSURLSessionDataTask *)task {
    NSLog(@"请求URL:%@\n", task.originalRequest.URL);
    NSLog(@"请求方式:%@\n", task.originalRequest.HTTPMethod);
    NSLog(@"请求头信息:%@\n", task.originalRequest.allHTTPHeaderFields);
    NSLog(@"请求正文信息:%@\n", [[NSString alloc] initWithData:task.originalRequest.HTTPBody encoding:NSUTF8StringEncoding]);
    NSHTTPURLResponse *re = (NSHTTPURLResponse *)task.response;
    NSLog(@"响应的请求头: %@\n", re.allHeaderFields);
}


/**
 获取文件的MIMEType

 @param url 文件路径
 @return 文件MIMEType
 */
- (NSString *)MIMEType:(NSURL *)url{
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse *response = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    return response.MIMEType;
}




+ (void)noCutomsHeadRequestURL:(NSString *)URLString
        httpMethod:(HttpMethod)method
            params:(NSDictionary *)params
           success:(void(^)(id result))success
                       failure:(void(^)(NSError *error, id  _Nullable responseObject))failure {
        
    LWNetworkingManager *httpManager = [self setAFNetworkingHTTPHeader];
   
   __weak typeof(self) weakSelf = self;
    switch (method) {
        case GET: {

            [httpManager.manager GET:URLString parameters:params headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [weakSelf isTokenExpireWithTask:task];
                __strong typeof(self) strongSelf = weakSelf;
                [strongSelf handlerSuccessRequest:responseObject success:success];
                
                NSLog(@"------GET请求成功------\n%@", responseObject);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [weakSelf isTokenExpireWithTask:task];
                
                __strong typeof(self) strongSelf = weakSelf;
                
                NSData *data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                if (data != nil) {
                    id body = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    [strongSelf handlerFailureRequestURL:URLString httpMethod:GET requestParams:params responseObject:body error:error failure:failure];
                    NSLog(@"------GET请求失败------\n%@", body);
                } else {
                    [strongSelf handlerFailureRequestURL:URLString httpMethod:GET requestParams:params responseObject:nil error:error failure:failure];
                    NSLog(@"------GET请求失败------\n%@", error.localizedDescription);
                }
    
            }];
            
            break;
        }
            
        case POST: {
            
//            LWLog(@"------POST请求------\n请求地址:%@\n请求参数:%@", URLString, params);
            
            [httpManager.manager POST:URLString parameters:params headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [weakSelf isTokenExpireWithTask:task];
                
                __strong typeof(self) strongSelf = weakSelf;
                [strongSelf handlerSuccessRequest:responseObject success:success];
                
                NSLog(@"------POST请求成功------\n%@", responseObject);

            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [weakSelf isTokenExpireWithTask:task];
                
                __strong typeof(self) strongSelf = weakSelf;
                
                NSData *data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                if (data != nil) {
                    id body = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    [strongSelf handlerFailureRequestURL:URLString httpMethod:POST requestParams:params responseObject:body error:error failure:failure];
                    NSLog(@"------POST请求失败------\n%@", body);
                } else {
                    [strongSelf handlerFailureRequestURL:URLString httpMethod:POST requestParams:params responseObject:nil error:error failure:failure];
                    NSLog(@"------POST请求失败------\n%@", error.localizedDescription);
                }
            }];
            
            break;
        }
            
        case DELETE: {
            
//            LWLog(@"------DELETE请求------\n请求地址:%@\n请求参数:%@", URLString, params);

            [httpManager.manager DELETE:URLString parameters:params headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [weakSelf isTokenExpireWithTask:task];
                __strong typeof(self) strongSelf = weakSelf;
                [strongSelf handlerSuccessRequest:responseObject success:success];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [weakSelf isTokenExpireWithTask:task];
                __strong typeof(self) strongSelf = weakSelf;
                
                NSData *data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                if (data != nil) {
                    id body = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    [strongSelf handlerFailureRequestURL:URLString httpMethod:DELETE requestParams:params responseObject:body error:error failure:failure];
                    NSLog(@"------DELETE请求失败------\n%@", body);
                } else {
                    [strongSelf handlerFailureRequestURL:URLString httpMethod:DELETE requestParams:params responseObject:nil error:error failure:failure];
                    NSLog(@"------DELETE请求失败------\n%@", error.localizedDescription);
                }
            }];
            
            break;
        }
            
        case PUT: {
            
//            LWLog(@"------PUT请求------\n请求地址:%@\n请求参数:%@", URLString, params);
        
            [httpManager.manager PUT:URLString parameters:params headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [weakSelf isTokenExpireWithTask:task];
                __strong typeof(self) strongSelf = weakSelf;
                [strongSelf handlerSuccessRequest:responseObject success:success];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [weakSelf isTokenExpireWithTask:task];
                __strong typeof(self) strongSelf = weakSelf;
                
                NSData *data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                if (data != nil) {
                    id body = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    [strongSelf handlerFailureRequestURL:URLString httpMethod:PUT requestParams:params responseObject:body error:error failure:failure];
                    NSLog(@"------PUT请求失败------\n%@", body);
                } else {
                    [strongSelf handlerFailureRequestURL:URLString httpMethod:PUT requestParams:params responseObject:nil error:error failure:failure];
                    NSLog(@"------PUT请求失败------\n%@", error.localizedDescription);
                }
            }];
            
            break;
        }
    }
}


+ (NSError *)timeError:(NSError *)err {
    if (err.code == -1202) {
        NSError *error = [NSError errorWithDomain:err.domain code:err.code userInfo:@{NSLocalizedDescriptionKey:@"手机时间错误，请更改后重试"}];
        return error;
    } else if (err.code == -1009 || err.code == -1004) {
        NSError *error = [NSError errorWithDomain:err.domain code:err.code userInfo:@{NSLocalizedDescriptionKey:@"请检查你的网络"}];
        return error;
    } else {
        return err;
    }
}

@end
