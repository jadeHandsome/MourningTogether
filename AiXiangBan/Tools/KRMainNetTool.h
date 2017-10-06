//
//  KRMainNetTool.h
//  Dntrench
//
//  Created by kupurui on 16/10/19.
//  Copyright © 2016年 CoderDX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import <UIKit/UIKit.h>
@interface KRMainNetTool : NSObject
singleton_interface(KRMainNetTool)
/**
 *  不需要上传文件的接口方法
 */
- (void)sendRequstWith:(NSString *)url params:(NSDictionary *)dic withModel:(Class)model complateHandle:(void(^)(id showdata,NSString *error))complet;
/**
 *  上传文件的接口方法
 */
- (void)upLoadData:(NSString *)url params:(NSDictionary *)param andData:(NSArray *)array complateHandle:(void(^)(id showdata,NSString *error))complet;
/**
 *  需要显示加载动画的接口方法 不上传文件
 */
- (void)sendRequstWith:(NSString *)url params:(NSDictionary *)dic withModel:(Class)model waitView:(UIView *)waitView complateHandle:(void(^)(id showdata,NSString *error))complet;
/**
 *  需要显示加载动画的接口方法 上传文件
 */
- (void)upLoadData:(NSString *)url params:(NSDictionary *)param andData:(NSArray *)array waitView:(UIView *)waitView complateHandle:(void(^)(id showdata,NSString *error))complet;
@property (nonatomic, strong) NSString *isShow;
@end
