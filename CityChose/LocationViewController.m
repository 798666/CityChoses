//
//  LocationViewController.m
//  CityChose
//
//  Created by mijk on 15/8/27.
//  Copyright (c) 2015年 mijk. All rights reserved.
//

#import "LocationViewController.h"
#import "ZFSearchBar.h"
#import "CityCell.h"
@interface CitySearchBar : UISearchBar

@end

@implementation CitySearchBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        [self initUI];
    }
    return self;
}

//- (void)initUI {
//    if (kDeviceVersion >= 7.0) {
////        self.barTintColor = kColor(255, 102, 36, 1);
//        self.tintColor = [UIColor whiteColor];
//    }
//    else {
//        self.tintColor = kColor(255, 102, 36, 1);
//    }
//    
//    CGRect rect = self.bounds;
//    rect.origin.y += 20;
//    rect.size.height += 20;
//    rect.size.width = kScreenWidth;
//    UIImageView *backView = [[UIImageView alloc] initWithFrame:rect];
////    backView.image = kImageName(@"orange.png");
//    [self insertSubview:backView atIndex:1];
//    //设置光标
//    [self setCursor];
//}
//
//- (void)setCursor {
//    NSArray *subviews = nil;
//    if (kDeviceVersion >= 7.0) {
//        subviews = [[self.subviews objectAtIndex:0] subviews];
//    }
//    else {
//        subviews = self.subviews;
//    }
//    for (UIView *view in subviews) {
//        if ([view isKindOfClass:[UITextField class]]) {
//            if (kDeviceVersion >= 7.0) {
//                view.tintColor = kColor(66, 107, 242, 1);
//            }
//        }
//    }
//}
@end

@interface LocationViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,CityDateDelegate,UISearchDisplayDelegate,CLLocationManagerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZFSearchBar *searchBars;
@property (nonatomic, strong) NSMutableArray *namearry;

@property (nonatomic, strong) UISearchDisplayController *searchController;
@property (nonatomic, strong) CitySearchBar *searchBar;

@property (nonatomic, strong) NSMutableArray *resultArray;
@property (nonatomic, strong) NSArray *hotName;

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) CityModel *currentCity;

@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"城市选择";
    _hotName = [NSArray arrayWithObjects:@"北京市",@"天津市",@"上海市",@"苏州市", nil];
    _namearry = [[NSMutableArray alloc]init];

    _resultArray = [[NSMutableArray alloc] init];
    [self initAndLauoutUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)setHeaderAndFooterView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40* kScaling)];
    headerView.backgroundColor = [UIColor clearColor];
//    创建搜索选项
    _searchBars = [[ZFSearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    _searchBars.inputField.clearButtonMode = UITextFieldViewModeNever;
    _searchBars.delegate = self;
    _searchBars.placeholder = @"城市/行政区/拼音";
    [headerView addSubview:_searchBars];
    
//    用于显示搜索得到的结果
    _searchController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBars contentsController:self];
    _searchController.delegate = self;
    _searchController.searchResultsTableView.delegate = self;
    _searchController.searchResultsTableView.dataSource = self;
    _tableView.tableHeaderView = headerView;
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = footerView;
}

- (void)initAndLauoutUI {
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
//    _tableView.backgroundColor = kColor(244, 243, 243, 1);
    _tableView.sectionIndexColor = [UIColor grayColor];
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self setHeaderAndFooterView];
    [self.view addSubview:_tableView];
//    适配屏幕
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
    
    
    
    [self getUserLocation];
}

- (void)getUserLocation {
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; //控制定位精度,越高耗电量越大。
        _locationManager.distanceFilter = 100; //控制定位服务更新频率。单位是“米”
        [_locationManager startUpdatingLocation];
        //在ios 8.0下要授权
        if (kDeviceVersion >= 8.0)
            [_locationManager requestWhenInUseAuthorization];
    }
}

#pragma mark - Data
//
- (void)saveDate:(CityModel *)selectedCity
{
    //        现在我只取最新搜索的3个
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault objectForKey:@"NameKey"]) {
        NSArray *Mnamearry=[[NSArray alloc]init];
        [_namearry removeAllObjects];
        Mnamearry = [userDefault objectForKey:@"NameKey"];
        
        //            把不可变的数组转换成可变的数组，不能直接赋值，否则会崩溃
        [_namearry addObjectsFromArray:Mnamearry];
    }
    
    //        去除相同的城市，并添加最新的城市使之排到首位
    if ([_namearry containsObject:selectedCity.cityName] && selectedCity.cityName && ![selectedCity.cityName isEqualToString:@""]) {
        [_namearry removeObject:selectedCity.cityName];
        [_namearry addObject:selectedCity.cityName];
    }
    else
    {
        [_namearry addObject:selectedCity.cityName];
    }
    //        去除多余的数据，防止出现不必要的麻烦，及时清除缓存否则数据会一直增大，
    NSInteger LastNumber;
    LastNumber = _namearry.count;
    if (LastNumber>3) {
        for (int i=0; i<LastNumber-3; i++) {
            [_namearry removeObjectAtIndex:i];
        }
    }
    [userDefault setObject:_namearry forKey:@"NameKey"];
    [userDefault synchronize];

}
- (void)getCurrentCityInfoWithCityName:(NSString *)cityName {
    for (CityModel *model in [CityHandle shareCityList]) {
        if ([cityName rangeOfString:model.cityName].length != 0) {
            _currentCity = model;
            break;
        }
    }
//    刷新数据
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    [_tableView beginUpdates];
    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [_tableView endUpdates];
}

#pragma mark - Action

//得到搜索结果
- (void)searchResult {
    if (!_searchController.searchResultsTableView.delegate) {
        _searchController.searchResultsTableView.delegate = self;
        _searchController.searchResultsTableView.dataSource = self;
    }
    [_resultArray removeAllObjects];
    for (CityModel *city in [CityHandle shareCityList]) {
        if ([city.cityName rangeOfString:_searchBars.text].length != 0) {
            [_resultArray addObject:city];
        }
    }
    [_searchController.searchResultsTableView reloadData];
}
#pragma mark - CityDateDelegate

-(void)cityData:(CityModel *)model
{
    if (_delegate && [_delegate respondsToSelector:@selector(getSelectedLocation:)]) {
        [_delegate getSelectedLocation:model];
        [self saveDate:model];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UISearchBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
//    _searchBars.hidden = YES;
    [_searchBars resignFirstResponder];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self searchResult];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self searchResult];
}

#pragma mark - UISearchDisplayDelegate

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
//    _searchBars.hidden = YES;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView {
//    使显示效果更加美观所以要设置从顶部60开始
    [tableView setContentInset:UIEdgeInsetsMake(60 , 0, 0, 0)];
    [tableView setScrollIndicatorInsets:UIEdgeInsetsZero];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == _tableView) {
        return [[CityHandle shareIndexList] count] + 1;
    }
    else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _tableView) {
        if (section == number0) {
            return number7;
        }
        else {
            return [[[CityHandle shareSectionCityList] objectAtIndex:section - 1] count];
        }
    }
    else {
        return [_resultArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _tableView) {
        static NSString *cellIdentifier = @"CityIdentifier";
        static NSString *cellIdentifiers = @"CityIdentifierss";

        CityCell *cell = nil;
        if (indexPath.section == number0) {
            int selectIndex;
            selectIndex = (int)indexPath.row;
            cell = [[CityCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:cellIdentifier
                                        supplyType:selectIndex
                                           hotarry:_hotName
                                      currentModel:_currentCity];
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else {
            
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifiers];
            if (cell == nil) {
                cell = [[CityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifiers supplyType:(int)nil hotarry:nil currentModel:nil];
            }
            CityModel *city = [[[CityHandle shareSectionCityList] objectAtIndex:indexPath.section - 1] objectAtIndex:indexPath.row];
            cell.textLabel.text = city.cityName;
        }
        return cell;
    }
    else {
        static NSString *searchIdentifier = @"searchIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchIdentifier];
        }
        CityModel *city = [_resultArray objectAtIndex:indexPath.row];
        cell.textLabel.text = city.cityName;
        return cell;
    }
}
//返回每个索引的内容
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == _tableView) {
        if (section == number0) {
            return nil;
        }
        return [[CityHandle shareIndexList] objectAtIndex:section - 1];
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView && indexPath.section == number0 && indexPath.row == number0) {
        return 0.001f;
    }
    if (tableView == _tableView && indexPath.section == number0 && indexPath.row == number6) {
//        根据实际热门城市的高度来确定
        return 80.0f;
    }
    else
    {
    return 40.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

//返回索引数组
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (tableView == _tableView) {
        return [CityHandle shareIndexList];
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CityModel *selectedCity = nil;
    if (tableView == _tableView) {
        if (indexPath.section != number0) {
            selectedCity = [[[CityHandle shareSectionCityList] objectAtIndex:indexPath.section - 1] objectAtIndex:indexPath.row];
            if (_delegate && [_delegate respondsToSelector:@selector(getSelectedLocation:)]) {
                [_delegate getSelectedLocation:selectedCity];
                [self saveDate:selectedCity];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else {
            if (indexPath.row == number0 || indexPath.row == number1 || indexPath.row == number2||indexPath.row == number3 || indexPath.row == number4 || indexPath.row == number5 || indexPath.row == number6) {
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
            }
//            selectedCity = _currentCity;
        }
    }
    else {
        [_searchController setActive:NO animated:YES];
        selectedCity = [_resultArray objectAtIndex:indexPath.row];
        if (_delegate && [_delegate respondsToSelector:@selector(getSelectedLocation:)]) {
            [_delegate getSelectedLocation:selectedCity];
            [self saveDate:selectedCity];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    }

#pragma mark - 定位

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!error) {
            if ([placemarks count] > 0) {
                CLPlacemark *placemark = [placemarks lastObject];
                NSString *cityName = placemark.locality;
                [self getCurrentCityInfoWithCityName:cityName];
            }
        }
    }];
}



@end
