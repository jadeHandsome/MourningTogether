//
//  TrackTableViewCell.m
//  AiXiangBan
//
//  Created by 曾洪磊 on 2017/10/18.
//  Copyright © 2017年 周春仕. All rights reserved.
//

#import "TrackTableViewCell.h"
#import <CoreLocation/CoreLocation.h>
@interface TrackTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomlabel;
@property (weak, nonatomic) IBOutlet UIImageView *contenImage;
@property (nonatomic, strong) CLGeocoder *geoC;
@end
@implementation TrackTableViewCell
- (CLGeocoder *)geoC
{
    if (!_geoC) {
        _geoC = [[CLGeocoder alloc] init];
    }
    return _geoC;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.contenImage.image = [UIImage imageNamed:@"云医时代-716"];
        self.topLabel.textColor = [UIColor blackColor];
        self.bottomlabel.textColor = [UIColor blackColor];
    } else {
        self.contenImage.image = [UIImage imageNamed:@"云医时代-77"];
        self.topLabel.textColor = LRRGBColor(146, 146, 146);
        self.bottomlabel.textColor = LRRGBColor(146, 146, 146);
    }
    // Configure the view for the selected state
}
- (void)setUpWith:(NSDictionary *)dic {
   
//    self.topLabel.text = [NSString stringWithFormat:@"%@\n%@",@"",[KRBaseTool timeWithTimeIntervalString:dic[@"footmarkTime"]]];
    self.bottomlabel.text = @"精确范围：40m";
    
        CLLocation *locations = [[CLLocation alloc] initWithLatitude:[dic[@"footmarkLatitude"] doubleValue] longitude:[dic[@"footmarkLongitude"] doubleValue]];
        
        [self.geoC reverseGeocodeLocation:locations completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            CLPlacemark *pl = [placemarks firstObject];
            
            if(error == nil)
            {
                NSLog(@"%f----%f", pl.location.coordinate.latitude, pl.location.coordinate.longitude);
                //self.currentname = [NSString stringWithFormat:@"%@ %@",pl.locality,pl.subLocality];
                NSLog(@"%@", pl.name);
                //self.locationLabel.text = [NSString stringWithFormat:@"%@ %@",pl.locality,pl.subLocality];
                NSString *name = [NSString stringWithFormat:@"%@ %@ %@",pl.locality,pl.subLocality,pl.name];
                
                self.topLabel.text = [NSString stringWithFormat:@"%@\n%@",name,[KRBaseTool timeWithTimeIntervalString:dic[@"footmarkTime"]]];

            }
        }];
}

@end
