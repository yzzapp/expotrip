//
//  YZZDateVC.m
//  exotrip
//
//  Created by 石戬,还没有对象的87姚勤 on 13-4-20.
//  Copyright (c) 2013年 YzzApp.com. All rights reserved.
//

#import "YZZDateVC.h"
#import "YZZRecommendVC.h"
#import "YZZUtil.h"
#import "YZZUtilities.h"
#import "YZZDatabase.h"
#import "YZZTheme.h"
#import "YZZDepartCityVC.h"

@interface YZZDateVC ()
@property int days;
@end

@implementation YZZDateVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [YZZTheme ThemeLoading:@"商旅规划"
                        vc:self
             leftImageName:@"ui_exotrip_nav_back.png"
                leftAction:@selector(navLeftDo)
            rightImageName:@"ui_exotrip_nav_recommend.png"
               rightAction:@selector(navRightDo)];

    [self dataInit];
    [self gpsInit];
}

- (void)navLeftDo
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navRightDo
{
    [self Recommend:self];
}

- (void)dataInit
{
    NSString * expoDate = [self.m_dic valueForKey:@"DATE"];

    self.m_expoName.text = [self.m_dic valueForKey:@"TITLE"];
    self.m_expoHall.text = [self.m_dic valueForKey:@"HALL"];
    self.m_expoDate.text = [YZZUtil DATE_DAY_CAL:expoDate intDays:0];
    
    NSString * today = [YZZUtil DATE_TODAY_STRING];
    
    
    int leaveDays = [YZZUtil DATE_DAYS_TO_DATE:expoDate fromDate:today];
    self.m_expoLeaveDays.text = [NSString stringWithFormat:@"%d",leaveDays];
    
    
    self.m_dateOff.text = [YZZUtil DATE_DAY_CAL:expoDate intDays:-1];
    self.m_dateBck.text = [YZZUtil DATE_DAY_CAL:expoDate intDays:+1];
    self.m_dstLand.text = [self.m_dic valueForKey:@"CITY"];
    
    self.days = 2;
    self.m_Days.text = [NSString stringWithFormat:@"%d",self.days];
    
    NSString * srcLand = @"";
//    if ([[self.m_dic valueForKey:@"CITY"] isEqualToString:@"北京"]) {
//        srcLand = @"上海";
//    }
    self.m_srcLand.text = srcLand;
    
    self.m_recommendDic = [[NSMutableDictionary alloc] init];
    
//    NSString * selectSQL = [NSString stringWithFormat:@"SELECT * FROM HALL WHERE NAME = '%@'",
//                            [self.m_dic valueForKey:@"HALL"]];
//    NSMutableArray * halls = [YZZDatabase execSelect:selectSQL];
//    NSMutableDictionary * hallDic = [[NSMutableDictionary alloc] init];
//    if ([halls count]>0) {
//        hallDic = [halls objectAtIndex:0];
//    }
    
//        self.m_recommendDic = (NSMutableDictionary *)self.m_dic;
    
//    [self.m_recommendDic setValue:[hallDic valueForKey:@"LATITUTE"] forKey:@"LATITUTE"];
//    [self.m_recommendDic setValue:[hallDic valueForKey:@"LONGITUTE"] forKey:@"LONGITUTE"];
    
    
    self.m_planeCitys = [[NSMutableArray alloc] init];
    NSString * cityLocationFilePath = [[NSBundle mainBundle] pathForResource:@"city_location" ofType:@"txt"];
    NSString * cityContent = [NSString stringWithContentsOfFile:cityLocationFilePath encoding:NSUTF8StringEncoding error:nil];
    
    self.m_cityCodeDic = [[NSMutableDictionary alloc] init];
    for (NSString * line in [cityContent componentsSeparatedByString:@"\n"]) {
        NSArray * lineArr = [line componentsSeparatedByString:@","];
        [self.m_planeCitys addObject:@{
         @"CITY":[lineArr objectAtIndex:0],
         @"CODE":[lineArr objectAtIndex:1],
         @"LON":[lineArr objectAtIndex:2],
         @"LAT":[lineArr objectAtIndex:3],
         }];
        [self.m_cityCodeDic setValue:[lineArr objectAtIndex:1] forKey:[lineArr objectAtIndex:0]];
    }
    
}

- (void)gpsInit
{
    self.locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [_locationManager startUpdatingLocation];
}

#pragma mark -
#pragma mark CLLocationManagerDelegate Methods
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    CLLocation *newLocation = [locations lastObject];
//    NSString *latitudeString = [NSString stringWithFormat:@"%g\u00B0",newLocation.coordinate.latitude];
////    _latitudeLabel.text = latitudeString;
//    NSString *longitudeString = [NSString stringWithFormat:@"%g\u00B0",
//                                 newLocation.coordinate.longitude];
    
//    _longitudeLabel.text = longitudeString;
//    NSString *horizontalAccuracyString = [NSString stringWithFormat:@"%gm",
//                                          newLocation.horizontalAccuracy];
//    _horizontalAccuracyLabel.text = horizontalAccuracyString;
//    NSString *altitudeString = [NSString stringWithFormat:@"%gm",
//                                newLocation.altitude];
//    _altitudeLabel.text = altitudeString;
//    NSString *verticalAccuracyString = [NSString stringWithFormat:@"%gm",
//                                        newLocation.verticalAccuracy];
//    _verticalAccuracyLabel.text = verticalAccuracyString;
    if (newLocation.verticalAccuracy < 0 || newLocation.horizontalAccuracy < 0) {
        // invalid accuracy
        return;
    }
    if (newLocation.horizontalAccuracy > 100 || newLocation.verticalAccuracy > 50) {
        // accuracy radius is so large, we don't want to use it
        return;
    }
    if (_startPoint == nil) {
        self.startPoint = newLocation;
    }
    
//    NSLog(@"startP:%@",self.startPoint);
    [_locationManager stopUpdatingLocation];

    
    NSString * cityName = [self findNearestCity:self.startPoint];
    self.m_srcLand.text = cityName;
}

- (NSString *)findNearestCity:(CLLocation *)location
{
    CLLocationDegrees hostlat = location.coordinate.latitude;
    CLLocationDegrees hostlon = location.coordinate.longitude;
    
    double nearest = 99999999.0f;
    NSString * nearestCity = @"";
    for (NSDictionary * city in self.m_planeCitys) {
        NSString * cityName = [city valueForKey:@"CITY"];
        float citylat = [[city valueForKey:@"LAT"] floatValue];
        float citylon = [[city valueForKey:@"LON"] floatValue];
//        NSLog(@"%f,%f  to  %f,%f",hostlat,hostlon,citylat,citylon);
        CLLocationDistance distance = [self distantFromLat:hostlat
                                                   andLong:hostlon
                                                    dstLat:citylat
                                                   dstLong:citylon];
//        NSLog(@"%@:%.2f",cityName,distance);
        if (nearest > distance) {
            nearest = distance;
            nearestCity = cityName;
        }
    }
//    NSLog(@"city:%@ and dis:%.2f",nearestCity,nearest);
    return nearestCity;
}

- (CLLocationDistance)distantFromLat:(CGFloat )lat andLong:(CGFloat)longit dstLat:(CGFloat )dstLat dstLong:(CGFloat)dstLong {
    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:lat longitude:longit];
    CLLocation *location2 = [[CLLocation alloc] initWithLatitude:dstLat longitude:dstLong];
    CLLocationDistance distance = [location1 distanceFromLocation:location2];
//    NSLog(@"%d,%d  to  %d,%d = %d",lat,longit,dstLat,dstLong,distance);
    return distance;
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    NSLog(@"locationManager fail");
}

- (IBAction)Recommend:(id)sender {
    if ([self.m_srcLand.text isEqualToString:@""]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@""
                                                         message:@"请先选择出发城市"
                                                        delegate:self
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if ([self.m_srcLand.text isEqualToString:self.m_dstLand.text]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@""
                                                         message:@"当地展会,可直接前往."
                                                        delegate:self
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    [self.m_recommendDic setValue:self.m_dateOff.text   forKey:@"date_off"];
    [self.m_recommendDic setValue:self.m_dateBck.text   forKey:@"date_bck"];
    [self.m_recommendDic setValue:self.m_srcLand.text   forKey:@"city_src"];
    [self.m_recommendDic setValue:self.m_dstLand.text   forKey:@"city_dst"];
    [self.m_recommendDic setValue:self.m_expoHall.text  forKey:@"expo_hll"];
    [self.m_recommendDic setValue:self.m_expoName.text  forKey:@"expo_name"];
    [self.m_recommendDic setValue:self.m_Days.text      forKey:@"days_cnt"];
    
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    YZZRecommendVC * recommendVC = [sb instantiateViewControllerWithIdentifier:@"YZZRecommendVC"];
    recommendVC.m_recommendDic = self.m_recommendDic;
    recommendVC.m_cityCodeDic = self.m_cityCodeDic;
    [self.navigationController pushViewController:recommendVC animated:YES];
}

- (IBAction)DateOffReduceOne:(id)sender {
    NSString * toDate = [YZZUtil DATE_DAY_CAL:self.m_dateOff.text intDays:-1];
    NSString * today = [YZZUtil DATE_TODAY_STRING];
    int lateDays = [YZZUtil DATE_DAYS_TO_DATE:toDate fromDate:today];
    if (lateDays < 0) {
        NSString * alertString = [NSString stringWithFormat:@"最早可以在今天[出发]\n今天是：%@",today];
        [YZZUtilities ShowAlert:alertString];
        return;
    }
    self.m_dateOff.text = toDate;
    self.days++;
    self.m_Days.text = [NSString stringWithFormat:@"%d",self.days];
}

- (IBAction)DateOffIncreaseOne:(id)sender {
    NSString * toDate = [YZZUtil DATE_DAY_CAL:self.m_dateOff.text intDays:+1];
    if (self.days == 0) {
        [YZZUtilities ShowAlert:@"[出发]无法晚于[返程]"];
        return;
    }
    self.days--;
    self.m_dateOff.text = toDate;
    self.m_Days.text = [NSString stringWithFormat:@"%d",self.days];
}

- (IBAction)DateBckReduceOne:(id)sender {
    NSString * toDate = [YZZUtil DATE_DAY_CAL:self.m_dateBck.text intDays:-1];
    if (self.days == 0) {
        [YZZUtilities ShowAlert:@"[返程]无法早于[出发]"];
        return;
    }
    self.days--;
    self.m_dateBck.text = toDate;
    self.m_Days.text = [NSString stringWithFormat:@"%d",self.days];
}

- (IBAction)DateBckIncreaseOne:(id)sender {
    NSString * toDate = [YZZUtil DATE_DAY_CAL:self.m_dateBck.text intDays:+1];
    self.m_dateBck.text = toDate;
    self.days++;
    self.m_Days.text = [NSString stringWithFormat:@"%d",self.days];
}

- (IBAction)LandSrcSearchViaGPS:(id)sender {
    [self gpsInit];
}

- (IBAction)LandSrcSelectViaView:(id)sender {
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    YZZDepartCityVC * departCityVC = [sb instantiateViewControllerWithIdentifier:@"YZZDepartCityVC"];
    departCityVC.m_cityDic = self.m_cityCodeDic;
    departCityVC.m_cityArr = self.m_planeCitys;
    [self.navigationController pushViewController:departCityVC animated:YES];
}

@end
