//
//  NetWorkManager.h
//  AiXiangBan
//
//  Created by 周春仕 on 2017/10/4.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetWorkManager : NSObject


+ (void)SendGetRequestWithParams:(NSDictionary*)params AndURL:(NSString *)url progress:(void(^)(id downloadProgress))sepProgress success:(void (^)( id responseObject))sepSuccess
                         failure:(void (^)(NSError *error))sepfailure;

+ (void)SendPostRequestWithParams:(NSDictionary*)Params andURL:(NSString *)url progress:(void(^)(id downloadProgress))sepProgress success:(void (^)( id responseObject))sepSuccess
                          failure:(void (^)(NSError *error))sepfailure;

+ (void)statusReachabilityManager;

@end
