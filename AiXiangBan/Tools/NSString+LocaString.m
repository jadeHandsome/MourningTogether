//
//  NSString+LocaString.m
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/19.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "NSString+LocaString.h"
#import <objc/runtime.h>
@implementation NSString (LocaString)
- (NSString *)localized
{
    return NSLocalizedString(self, @"");
}
@end
