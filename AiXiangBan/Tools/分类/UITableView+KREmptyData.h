//
//  UITableView+KREmptyData.h
//  fitnessDog
//
//  Created by kupurui on 17/1/17.
//  Copyright © 2017年 CoderDX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (KREmptyData)
- (void)tableViewDisplayWitMsg:(NSString *) message ifNecessaryForRowCount:(NSUInteger) rowCount;

@end
