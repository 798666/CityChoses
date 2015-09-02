//
//  CityArchiveHelper.h
//  CityChose
//
//  Created by mijk on 15/8/28.
//  Copyright (c) 2015年 mijk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityArchiveHelper : NSObject
+ (void)saveForUser:(NSMutableArray *)userarry;

+ (NSMutableArray *)getLastestUserarry;
@end
