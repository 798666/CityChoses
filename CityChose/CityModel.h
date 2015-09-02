//
//  CityModel.h
//  CityChose
//
//  Created by mijk on 15/8/27.
//  Copyright (c) 2015年 mijk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityModel : NSObject
@property (nonatomic, strong) NSString *cityID;

@property (nonatomic, strong) NSString *parentID;

@property (nonatomic, strong) NSString *cityName;

@property (nonatomic, strong) NSString *cityPinYin;
@end
