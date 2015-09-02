//
//  ViewController.m
//  CityChose
//
//  Created by mijk on 15/8/27.
//  Copyright (c) 2015年 mijk. All rights reserved.
//

#import "ViewController.h"
#import "LocationViewController.h"
#import "AppDelegate.h"

@interface ViewController ()<LocationDelegate>
@property (nonatomic, strong) UIButton *beginbutton;
@property (nonatomic, strong) NSMutableArray *namearry;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationController.navigationBarHidden=NO;
//    添加一个触发事件
    _beginbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    _beginbutton.frame = CGRectMake(kScreenWidth/2-40, kScreenHeight/2, 80, 40);
    [self.view addSubview:_beginbutton];
    [_beginbutton setBackgroundColor:[UIColor redColor]];
    [_beginbutton addTarget:self action:@selector(selectLocation:) forControlEvents:UIControlEventTouchUpInside];

}

- (IBAction)selectLocation:(id)sender {
    LocationViewController *locationC = [[LocationViewController alloc] init];
    locationC.delegate = self;
    [self.navigationController pushViewController:locationC animated:YES];
}
#pragma mark - LocationDelegate

- (void)getSelectedLocation:(CityModel *)selectedCity {
    if (selectedCity) {
        [_beginbutton setTitle:selectedCity.cityName forState:UIControlStateNormal];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
