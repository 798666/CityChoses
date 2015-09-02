//
//  LocationViewController.h
//  CityChose
//
//  Created by mijk on 15/8/27.
//  Copyright (c) 2015年 mijk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityHandle.h"
#import <CoreLocation/CoreLocation.h>
typedef enum {
    number0 = 0,
    number1 = 1,
    number2 = 2,
    number3 = 3,
    number4 = 4,
    number5 = 5,
    number6 = 6,
    number7 = 7,

}Number;

@protocol LocationDelegate <NSObject>

- (void)getSelectedLocation:(CityModel *)selectedCity;

@end

@interface LocationViewController : UIViewController
@property (nonatomic, assign) id<LocationDelegate>delegate;

@end
