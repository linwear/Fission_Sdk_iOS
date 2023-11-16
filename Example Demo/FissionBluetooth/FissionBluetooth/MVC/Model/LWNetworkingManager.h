




#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HttpMethod) {
    GET         = 0,
    POST        = 1,
    DELETE      = 2,
    PUT         = 3,
};

@interface LWNetworkingManager : NSObject

+ (void)requestURL:(NSString *)URLString
        httpMethod:(HttpMethod)method
            params:(NSDictionary *)params
           success:(void(^)(id result))success
           failure:(void(^)(NSError *error, id  _Nullable responseObject))failure;

+ (void)requestDownloadURL:(NSString *)URLString
                namePrefix:(NSString *)namePrefix
                   success:(void(^)(id result))success
                   failure:(void(^)(NSError *error, id  _Nullable responseObject))failure;

+ (void)requestUpdateURL:(NSString *)URLString
              httpMethod:(HttpMethod)method
                  params:(NSDictionary *)params
                 success:(void(^)(id result))success
                 failure:(void(^)(NSError *error, id  _Nullable responseObject))failure;


+ (void)noCutomsHeadRequestURL:(NSString *)URLString
        httpMethod:(HttpMethod)method
            params:(NSDictionary *)params
           success:(void(^)(id result))success
           failure:(void(^)(NSError *error, id  _Nullable responseObject))failure;

+ (NSError *)timeError:(NSError *)err;

@end

NS_ASSUME_NONNULL_END
