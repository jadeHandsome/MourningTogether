//
//  KRMainNetTool.m
//  Dntrench
//
//  Created by kupurui on 16/10/19.
//  Copyright © 2016年 CoderDX. All rights reserved.
//

#import "KRMainNetTool.h"
#import "AFNetworking.h"
#import <UIKit/UIKit.h>
#import "BaseNaviViewController.h"
#import "LoginViewController.h"
#define baseURL @"http://47.92.87.19/"
@implementation KRMainNetTool
singleton_implementation(KRMainNetTool)
//不需要上传文件的接口方法
- (void)sendRequstWith:(NSString *)url params:(NSDictionary *)dic withModel:(Class)model complateHandle:(void (^)(id showdata, NSString *error))complet {
    [self sendRequstWith:url params:dic withModel:model waitView:nil complateHandle:complet];
    
}
//上传文件的接口方法
- (void)upLoadData:(NSString *)url params:(NSDictionary *)param andData:(NSArray *)array complateHandle:(void (^)(id, NSString *))complet {
    [self upLoadData:url params:param andData:array waitView:nil complateHandle:complet];
}
//需要显示加载动画的接口方法 不上传文件
- (void)sendRequstWith:(NSString *)url params:(NSDictionary *)dic withModel:(Class)model waitView:(UIView *)waitView complateHandle:(void(^)(id showdata,NSString *error))complet {
    //拼接网络请求url
    NSString *path = [NSString stringWithFormat:@"%@%@",baseURL,url];
    //定义需要加载动画的HUD
    __block MBProgressHUD *HUD;
    
    //if (![[waitView.window.subviews lastObject] isKindOfClass:[UIResponder class]]) {
        //[waitView showRoundProgressWithTitle:nil];
    //}
    
    if (waitView != nil) {
        //如果view不为空就添加到view上
        HUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        UIView *cusTome = [[UIView alloc]init];
        cusTome.backgroundColor = [UIColor blackColor];
        HUD.customView = cusTome;
        HUD.removeFromSuperViewOnHide = YES;
    }
    //开始网络请求
//    AFHTTPRequestOperationManager *managers    = [AFHTTPRequestOperationManager manager];
//    // 设置超时时间
//    [managers.requestSerializer willChangeValueForKey:@"timeoutInterval"];
//    managers.requestSerializer.timeoutInterval = 10.f;
//    [managers.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 10.f;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addEntriesFromDictionary:dic];
    if ([KRUserInfo sharedKRUserInfo].token) {
        params[@"token"] = [KRUserInfo sharedKRUserInfo].token;
    }
    [manager POST:path parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        //请求成功，隐藏HUD并销毁
        [HUD hideAnimated:YES];
        //NSLog(@"%@",responseObject);
        NSDictionary *response = nil;
        if ([responseObject isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        } else {
            response = responseObject;
        }
        NSNumber *num = response[@"errorCode"];
        //判断返回的状态，200即为服务器查询成功，500服务器查询失败
        //NSLog(@"%@",responseObject);
        if ([num longValue] == 0) {
            if (model == nil) {
                if (response[@"responseParams"]) {
                    if ([self.isShow isEqualToString:@"1"]) {
                        //[waitView hideBubble];
                    }
                    
                    complet(response[@"responseParams"],nil);
                } else {
                    if ([self.isShow isEqualToString:@"1"]) {
                        //[waitView hideBubble];
                    }
                    [MBProgressHUD showError:response[@"errorMsg"] toView:waitView];
                    complet(response[@"errorMsg"],nil);
                }
                
            } else {
                //[waitView hideBubble];
                complet([self getModelArrayWith:response[@"responseParams"] andModel:model],nil);
            }
        } else if ([num longLongValue] == 6) {
            //登录失效
            [UIApplication sharedApplication].keyWindow.rootViewController = [[BaseNaviViewController alloc] initWithRootViewController:[LoginViewController new]];
            [MBProgressHUD showError:@"登录失效" toView:[UIApplication sharedApplication].keyWindow];
        } else {
            
            [MBProgressHUD showError:response[@"errorMsg"] toView:waitView];
            complet(nil,response[@"errorMsg"]);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //网络请求失败，隐藏HUD，服务器响应失败。网络问题 或者服务器崩溃
        //[waitView hideBubble];
        [HUD hideAnimated:YES];
        [MBProgressHUD showError:@"网络错误"];
        //[waitView showErrorWithTitle:@"网络错误" autoCloseTime:2];
        complet(nil,@"网络错误");
    }];
}

//需要显示加载动画的接口方法 上传文件
- (void)upLoadData:(NSString *)url params:(NSDictionary *)param andData:(NSArray *)array waitView:(UIView *)waitView complateHandle:(void(^)(id showdata,NSString *error))complet {
    //拼接网络请求url
    NSString *path = [NSString stringWithFormat:@"%@%@",baseURL,url];
    //定义需要加载动画的HUD
    __block MBProgressHUD *HUD;
    if (!waitView) {
         HUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        UIView *cusTome = [[UIView alloc]init];
        cusTome.backgroundColor = [UIColor blackColor];
        HUD.customView = cusTome;
        HUD.removeFromSuperViewOnHide = YES;
    }
    //[waitView showRoundProgressWithTitle:nil];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 10.f;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addEntriesFromDictionary:param];
    if ([KRUserInfo sharedKRUserInfo].token) {
        params[@"token"] = [KRUserInfo sharedKRUserInfo].token;
    }
    
    
    
    [manager POST:path parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //通过遍历传过来的上传数据的数组，把每一个数据拼接到formData对象上
        for (NSDictionary *data in array) {
            //NSString *str = [NSString stringWithFormat:@"pic%ld.png",[array indexOfObject:data]];
            //NSLog(@"%@",str);
            [formData appendPartWithFileData:data[@"data"] name:data[@"name"] fileName:@"up-file.png" mimeType:@"image/jpeg"];
        }
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        //请求成功，隐藏HUD并销毁
        //NSLog(@"%@",responseObject);
        [HUD hideAnimated:YES];
        NSDictionary *response = nil;
        if ([responseObject isKindOfClass:[NSData class]]) {
            response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        } else {
            response = responseObject;
        }
        NSNumber *num = response[@"errorCode"];
        //判断返回的状态，200即为服务器查询成功，500服务器查询失败
        if ([num longLongValue] == 0) {
            if ([self.isShow isEqualToString:@"1"]) {
                //[waitView hideBubble];
            }
            
            complet(@"修改成功",nil);
        } else if ([num longLongValue] == 6) {
            //登录失效
            [UIApplication sharedApplication].keyWindow.rootViewController = [[BaseNaviViewController alloc] initWithRootViewController:[LoginViewController new]];
            [MBProgressHUD showError:@"登录失效" toView:[UIApplication sharedApplication].keyWindow];
        } else {
            [MBProgressHUD showError:response[@"errorMsg"] toView:waitView];
            //[waitView showErrorWithTitle:responseObject[@"message"] autoCloseTime:2];
            complet(nil,responseObject[@"errorMsg"]);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //网络请求失败，隐藏HUD，服务器响应失败。网络问题 或者服务器崩溃
        //[waitView hideBubble];
        [HUD hideAnimated:YES];
        [MBProgressHUD showError:@"网络错误" toView:waitView];
        //[waitView showErrorWithTitle:@"网络错误" autoCloseTime:2];
        complet(nil,@"网络错误");
    }];
}
//把模型数据传入返回模型数据的数组
- (NSArray *)getModelArrayWith:(NSArray *)array andModel:(Class)modelClass {
    NSMutableArray *mut = [NSMutableArray array];
    //遍历模型数据 用KVC给创建每个模型类的对象并赋值过后放进数组
    for (NSDictionary *dic in array) {
        id model = [modelClass new];
        [model setValuesForKeysWithDictionary:dic];
        [mut addObject:model];
    }
    return [mut copy];
}

@end
