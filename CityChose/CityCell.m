//
//  CityCell.m
//  CityChose
//
//  Created by mijk on 15/9/1.
//  Copyright (c) 2015年 mijk. All rights reserved.
//

#import "CityCell.h"

@implementation CityCell
- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
         supplyType:(Number)supplyType
            hotarry:(NSArray *)hotarry
       currentModel:(CityModel *)currentModel
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        int widebutton;
        widebutton = (kScreenWidth-80)/3;
        if (supplyType ==number0) {
            
        }
        if (supplyType ==number1) {
            self.textLabel.text = @"定位城市";
        }
        if (supplyType ==number2) {
        
            if (currentModel)
            {
                UIButton *button = kUibutton(20, 5, 80, 30);
                [button setTitle:currentModel.cityName forState:UIControlStateNormal];
                button.layer.cornerRadius = 4;
                button.layer.masksToBounds = YES;
                [button setBackgroundColor:kColor(68, 172, 155, 1)];
                [self addSubview:button];
                [button addTarget:self action:@selector(lastAndHotVist:) forControlEvents:UIControlEventTouchUpInside];
                
            }
            else
            {
                UIButton *button = kUibutton(20, 5, 80, 30);
                [button setTitle:@"定位失败" forState:UIControlStateNormal];
                button.layer.cornerRadius = 4;
                button.layer.masksToBounds = YES;
                [button setBackgroundColor:kColor(68, 172, 155, 1)];
                [self addSubview:button];
                
            }
            
        }
        if (supplyType ==number3) {
            self.textLabel.text = @"最近访问城市";
        }
        if (supplyType ==number4) {
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            NSArray *namearry = [userDefault objectForKey:@"NameKey"];
            if (namearry.count>=number1 && namearry.count < number3) {
                
                for (int i = 0; i<namearry.count; i++) {
                    UIButton *button = kUibutton(20+i%3*(widebutton+20), i/3*40 +5, widebutton, 30);
                    [button setTitle:[ namearry objectAtIndex:namearry.count - 1-i] forState:UIControlStateNormal];
                    button.layer.cornerRadius = 4;
                    button.layer.masksToBounds = YES;
                    [button setBackgroundColor:kColor(68, 172, 155, 1)];
                    [button addTarget:self action:@selector(lastAndHotVist:) forControlEvents:UIControlEventTouchUpInside];
                    [self addSubview:button];
                }
            }
            else if (namearry.count >number2)
            {
                for (int i = 0; i<=2; i++)
                {
                    UIButton *button = kUibutton(20+i%3*(widebutton+20), i/3*40 +5, widebutton, 30);
                    [button setTitle:[ namearry objectAtIndex:namearry.count - 1 -i] forState:UIControlStateNormal];
                    button.layer.cornerRadius = 4;
                    button.layer.masksToBounds = YES;
                    [button setBackgroundColor:kColor(68, 172, 155, 1)];
                    [button addTarget:self action:@selector(lastAndHotVist:) forControlEvents:UIControlEventTouchUpInside];
                    [self addSubview:button];
                    
                }
            }
            else
            {
                UIButton *button = kUibutton(20, 5, 80, 30);
                button.layer.cornerRadius = 4;
                button.layer.masksToBounds = YES;
                [button setBackgroundColor:kColor(68, 172, 155, 1)];
                [self addSubview:button];
                [button setTitle:@"暂无" forState:UIControlStateNormal];
            }
            
        }
        if (supplyType ==number5) {
            self.textLabel.text = @"热门城市";
        }
        if (supplyType ==number6) {
            for (int i = 0; i<hotarry.count; i++) {
                UIButton *button = kUibutton(20+i%3*(widebutton+20), i/3*40 +5, widebutton, 30);
                button.layer.cornerRadius = 4;
                button.layer.masksToBounds = YES;
                [button setTitle:[hotarry objectAtIndex:i] forState:UIControlStateNormal];
                [button setBackgroundColor:kColor(68, 172, 155, 1)];
                [self addSubview:button];
                [button addTarget:self action:@selector(lastAndHotVist:) forControlEvents:UIControlEventTouchUpInside];
                
            }
        }

    }
    return self;
}
- (IBAction)lastAndHotVist:(id)sender {
    UIButton *but = (UIButton *)sender;
    CityModel *selectedCity = [[CityModel alloc]init];
    selectedCity.cityName = but.titleLabel.text;
    _cellData = selectedCity;
    if (_delegate && [_delegate respondsToSelector:@selector(cityData:)]) {
        [_delegate cityData:_cellData];
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
