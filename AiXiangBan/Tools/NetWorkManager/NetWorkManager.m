//
//  NetWorkManager.m
//  AiXiangBan
//
//  Created by 周春仕 on 2017/10/4.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "NetWorkManager.h"
#import "AFNetworking.h"
@implementation NetWorkManager


+ (void)SendGetRequestWithParams:(NSDictionary *)params AndURL:(NSString *)url progress:(void (^)(id))sepProgress success:(void (^)(id))sepSuccess failure:(void (^)(NSError *))sepfailure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 20.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
        sepProgress(downloadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        sepSuccess(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        sepfailure(error);
    }];
    
}

+ (void)SendPostRequestWithParams:(NSDictionary *)Params andURL:(NSString *)url progress:(void (^)(id))sepProgress success:(void (^)(id))sepSuccess failure:(void (^)(NSError *))sepfailure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    
    //    manager.requestSerializer.stringEncoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //     设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 30.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObjectsFromArray:@[@"text/html",@"text/plain"]];
    
    [manager POST:url parameters:Params progress:^(NSProgress * _Nonnull uploadProgress) {
        sepProgress(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        sepSuccess(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        sepfailure(error);
    }];
    
}

+ (void)statusReachabilityManager{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未识别的网络");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NETChange" object:@"ERROR"];
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"不可达的网络(未连接)");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NETChange" object:@"ERROR"];
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"2G,3G,4G...的网络");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NETChange" object:@"G"];
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"wifi的网络");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NETChange" object:@"WIFI"];
                break;
            default:
                break;
        }
    }];
    //开始监听
    [manager startMonitoring];
}



@end
