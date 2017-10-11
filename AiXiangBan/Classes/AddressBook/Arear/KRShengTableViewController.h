//
//  KRShengTableViewController.h
//  Dntrench
//
//  Created by kupurui on 16/10/20.
//  Copyright © 2016年 CoderDX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KRShengTableViewController : UITableViewController
@property (nonatomic, strong) NSString *provinceid;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSMutableDictionary *selectedAddress;
@property (nonatomic, strong) NSString *selectedStr;
@property (nonatomic, strong) NSString *titleStr;
@end
