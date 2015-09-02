//
//  CityCell.h
//  CityChose
//
//  Created by mijk on 15/9/1.
//  Copyright (c) 2015年 mijk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationViewController.h"
#import "CityModel.h"
@protocol CityDateDelegate <NSObject>

- (void)cityData:(CityModel *)model;

@end

@interface CityCell : UITableViewCell
@property (nonatomic, assign) id<CityDateDelegate>delegate;
@property (nonatomic, strong) CityModel *cellData;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
         supplyType:(Number)supplyType
            hotarry:(NSArray *)hotarry
       currentModel:(CityModel *)currentModel;

@end
