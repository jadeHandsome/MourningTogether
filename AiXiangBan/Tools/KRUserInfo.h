//
//  KRUserInfo.h
//  Dntrench
//
//  Created by kupurui on 16/10/18.
//  Copyright © 2016年 CoderDX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
@interface KRUserInfo : NSObject
singleton_interface(KRUserInfo)
//"u_id":"8",  //用户id
//"u_name":"haha",//用户名
//"u_password":"433d2f8bd7c4fcfed27df4829cffcba8",
//"u_portrait":{//头像路径取url
//    "md5":"",
//    "url":"http://local.515xc.com/Public/images/default_user.png"
//},
//"u_tel":"18580229223",//手机号
//"u_realname":"",//真实姓名
//"u_qq":"",//QQ
//"u_email":"",//邮箱
//"u_sina":"",//新浪
//"u_created":"2016-07-27 18:15:10",//注册日期
//"sex":"男",//性别
//"birthday":"1999-01-01",//出生日期
//"pay_pwd":"",//支付密码
//"balance":"0.00",//余额
//"qqopenid":"",//qq登录openid
//"wxopenid":"",//微信登录openid
//"wbopenid":"",//微博openid
//"u_score":"0",//积分
//"forbid":"0",//是否禁用 1禁用 0未禁用
//"useable_score":"3000", //可抵用积分
//"u_type": "2" //1普通用户 2 VIP用户 3门店用户
@property (nonatomic, strong) NSString *headImgUrl;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *memberId;
@property (nonatomic, strong) NSString *memberName;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *age;
@property (nonatomic, strong) NSString *weight;
@property (nonatomic, strong) NSString *height;
@property (nonatomic, strong) NSString *deviceId;
@property (nonatomic, strong) NSString *balance;
@property (nonatomic, strong) NSString *elderId;
@property (nonatomic, strong) NSString *deviceSn;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSDictionary *currentElder;
//@property (nonatomic, strong) NSString *u_realname;
//@property (nonatomic, strong) NSString *u_qq;
//@property (nonatomic, strong) NSString *u_email;
//@property (nonatomic, strong) NSString *u_sina;
//@property (nonatomic, strong) NSString *u_created;
//@property (nonatomic, strong) NSString *sex;
//@property (nonatomic, strong) NSString *birthday;
//@property (nonatomic, strong) NSString *pay_pwd;
//@property (nonatomic, strong) NSString *balance;
//@property (nonatomic, strong) NSString *u_score;
//@property (nonatomic, strong) NSString *forbid;
//@property (nonatomic, strong) NSString *useable_score;
//@property (nonatomic, strong) NSString *u_type;

@end
