//
//  ZFSearchBar.h
//  CityChose
//
//  Created by mijk on 15/8/27.
//  Copyright (c) 2015年 mijk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFSearchBar : UISearchBar

@property (nonatomic, strong) UITextField *inputField;

- (void)setAttrPlaceHolder:(NSString *)string;

@end
