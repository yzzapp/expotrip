//
//  YZZDateVC.h
//  exotrip
//
//  Created by 石戬,还没有对象的87姚勤 on 13-4-20.
//  Copyright (c) 2013年 YzzApp.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface YZZDateVC : UIViewController <CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *m_expoName;
@property (strong, nonatomic) IBOutlet UILabel *m_expoDate;
@property (strong, nonatomic) IBOutlet UILabel *m_expoLeaveDays;

@property (strong, nonatomic) IBOutlet UILabel *m_expoHall;
@property (strong, nonatomic) IBOutlet UILabel *m_dateOff;
@property (strong, nonatomic) IBOutlet UILabel *m_dateBck;
@property (strong, nonatomic) IBOutlet UILabel *m_srcLand;
@property (strong, nonatomic) IBOutlet UILabel *m_dstLand;

@property (strong, nonatomic) IBOutlet UILabel *m_Days;

@property (strong, nonatomic) NSDictionary * m_dic;
@property (strong, nonatomic) NSMutableDictionary * m_recommendDic;

@property (strong, nonatomic) NSMutableArray * m_planeCitys;
@property (strong, nonatomic) NSMutableDictionary * m_cityCodeDic;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *startPoint;

- (IBAction)Recommend:(id)sender;

- (IBAction)DateOffReduceOne:(id)sender;
- (IBAction)DateOffIncreaseOne:(id)sender;
- (IBAction)DateBckReduceOne:(id)sender;
- (IBAction)DateBckIncreaseOne:(id)sender;

- (IBAction)LandSrcSearchViaGPS:(id)sender;
- (IBAction)LandSrcSelectViaView:(id)sender;

@end
