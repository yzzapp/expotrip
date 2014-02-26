//
//  YZZRecommendVC.m
//  ;
//
//  Created by 石戬,还没有对象的87姚勤 on 13-5-5.
//  Copyright (c) 2013年 YzzApp.com. All rights reserved.
//

#import "YZZRecommendVC.h"
#import "YZZUtil.h"
#import "YZZTheme.h"
#import "YZZPlanVC.h"

#import "OTA_HotelResOTA_HotelRes.h"

@interface YZZRecommendVC ()
@property int m_indexHotel;
@property int m_indexPlaneOff;
@property int m_indexPlaneBck;

@property float m_total_price;
@property float m_hotel_price;
@property float m_airoff_price;
@property float m_airbck_price;

@property BOOL m_isHideHotelGroup;
@property BOOL m_isHideAirDepartGroup;
@property BOOL m_isHideAirGobackGroup;
@end

@implementation YZZRecommendVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [YZZTheme ThemeLoading:@"行程推荐"
                        vc:self
             leftImageName:@"ui_exotrip_nav_back.png"
                leftAction:@selector(navLeftDo)
            rightImageName:@"ui_exotrip_nav_done.png"
               rightAction:@selector(navRightDo)];

    [self dataInit];
    [self actionInit];
    //[self userNotify];
}

- (void)userNotify
{
    BDKNotifyHUD *hud = [BDKNotifyHUD notifyHUDWithView:nil
                                                   text:@"左右划动\n可切换"];
    hud.center = CGPointMake(self.view.center.x, self.view.center.y - 20);
    [self.view addSubview:hud];
    [hud presentWithDuration:1.5f speed:0.5f inView:self.view completion:^{
        [hud removeFromSuperview];
    }];
}

- (void)navLeftDo
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navRightDo
{
    [self actionSubmitPlan:self];
}

- (void)dataInit
{
    self.m_isHideHotelGroup = YES;
    self.m_isHideAirDepartGroup = YES;
    self.m_isHideAirGobackGroup = YES;
    [self updateHidingGroups];
    self.m_indexHotel = 0;
    self.m_indexPlaneOff = 0;
    self.m_indexPlaneBck = 0;
    
    self.m_total_price = 0.0f;
    self.m_hotel_price = 0.0f;
    self.m_airoff_price = 0.0f;
    self.m_airbck_price = 0.0f;
    
    int days = [[self.m_recommendDic valueForKey:@"days_cnt"] intValue];
    NSString * checkInDate = [self.m_recommendDic valueForKey:@"date_off"];
    NSString * checkOutDate = [YZZUtil DATE_DAY_CAL:checkInDate intDays:days];
    self.m_checkInDateL.text = checkInDate;
    self.m_checkOutDateL.text = checkOutDate;
    self.m_departDateL.text = [self.m_recommendDic valueForKey:@"date_off"];
    self.m_gobackDateL.text = [self.m_recommendDic valueForKey:@"date_bck"];
    
    self.m_dataAirPortDic = [[NSMutableDictionary alloc] init];
    NSString * airportContent = [NSString stringWithContentsOfFile:
                                 [[NSBundle mainBundle] pathForResource:@"airports.txt" ofType:@""]
                                                          encoding:NSUTF8StringEncoding
                                                             error:nil];
    NSArray * airArr = [airportContent componentsSeparatedByString:@"\n"];
    for (NSString * line in airArr) {
        NSArray * pair = [line componentsSeparatedByString:@","];
        [self.m_dataAirPortDic setValue:[pair objectAtIndex:1] forKey:[pair objectAtIndex:0]];
    }
    
    [self dataPlanInit];
    [self dataHotelInit];
    [self dataAirOffInit];
    [self dataAirBckInit];
}

- (void)updateHidingGroups
{
    for (UILabel * hotelL in self.m_HotelGroup) {
        [hotelL setHidden:self.m_isHideHotelGroup];
    }
    
    for (UILabel * departL in self.m_AirDepartGroup) {
        [departL setHidden:self.m_isHideAirDepartGroup];
    }
    
    for (UILabel * gobackL in self.m_AirGobackGroup) {
        [gobackL setHidden:self.m_isHideAirGobackGroup];
    }
    
    [self.m_HotelGroupTipL setHidden:!self.m_isHideHotelGroup];
    [self.m_AirDepartGroupTipL setHidden:!self.m_isHideAirDepartGroup];
    [self.m_AirGobackGroupTipL setHidden:!self.m_isHideAirGobackGroup];
}

- (void)actionInit
{
    [self.m_showNextRoomIV setUserInteractionEnabled:YES];
    UISwipeGestureRecognizer * swipeNextHotel = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(actionShowNextRoom:)];
    swipeNextHotel.direction = UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight ;
    [self.m_showNextRoomIV addGestureRecognizer:swipeNextHotel];
    
    [self.m_showNextDepartAirLineIV setUserInteractionEnabled:YES];
    UISwipeGestureRecognizer * swipeNextDepart = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(actionShowNextDepartAirLine:)];
    swipeNextDepart.direction = UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight ;
    [self.m_showNextDepartAirLineIV addGestureRecognizer:swipeNextDepart];

    [self.m_showNextBackAirLineIV setUserInteractionEnabled:YES];
    UISwipeGestureRecognizer * swipeNextBack = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(actionShowNextBackAirLine:)];
    swipeNextBack.direction = UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight ;
    [self.m_showNextBackAirLineIV addGestureRecognizer:swipeNextBack];
}

- (void)dataPlanInit
{
    self.m_dCityNameL.text = [self.m_recommendDic valueForKey:@"city_src"];
    self.m_aCityNameL.text = [self.m_recommendDic valueForKey:@"city_dst"];
    self.m_expoNameL.text  = [self.m_recommendDic valueForKey:@"expo_name"];
}

- (void)datePlanUpdate:(NSDictionary *)h
{
    NSString * type = [h valueForKey:@"RECOMMENDTYPE"];
    if ([type isEqualToString:@"exp"]) {
        type = @"经济型";
    }
    if ([type isEqualToString:@"biz"]) {
        type = @"商务型";
    }
    if ([type isEqualToString:@"big"]) {
        type = @"高级商务型";
    }
    self.m_planLevL.text = type;
}

//    ADDRESS = "\U94a6\U5dde\U5317\U8def98\U53f7";
//    BEDS = 2;
//    HALL = "\U4e0a\U6d77\U5149\U5927\U4f1a\U5c55\U4e2d\U5fc3";
//    HOTELCODE = 63207;
//    HOTELIMAGE = "http://Images4.c-ctrip.com/target/hotel/64000/63207/B3234AB1-3422-4269-A4D9-3845CDBB8AB6_100_75.jpg";
//    HOTELLAT = "31.17894";
//    HOTELLONG = "121.42749";
//    HOTELNAME = "\U6c49\U5ead\U9152\U5e97\Uff08\U4e0a\U6d77\U5f90\U5bb6\U6c47\U4e8c\U5e97\Uff09";
//    HOTELRATE = "3.90";
//    R0506 = "246.00";
//    R0507 = "246.00";
//    R0508 = "246.00";
//    R0509 = "246.00";
//    R0510 = "246.00";
//    R0511 = "246.00";
//    R0512 = "246.00";
//    R0609 = "<null>";
//    R0610 = "<null>";
//    R0611 = "<null>";
//    R0618 = "246.00";
//    R0619 = "246.00";
//    R0620 = "246.00";
//    RECOMMENDTYPE = exp;
//    ROOMCODE = 1945006;
//    ROOMNAME = "\U96f6\U538b-\U9ad8\U7ea7\U5927\U5e8a\U623f";

//[self.m_recommendDic setValue:date_off              forKey:@"date_off"];
//[self.m_recommendDic setValue:date_bck              forKey:@"date_bck"];
//[self.m_recommendDic setValue:self.m_srcLand.text   forKey:@"city_src"];
//[self.m_recommendDic setValue:self.m_dstLand.text   forKey:@"city_dst"];
//[self.m_recommendDic setValue:self.m_expoHall.text  forKey:@"expo_hll"];
//[self.m_recommendDic setValue:self.m_Days.text      forKey:@"days_cnt"];

- (void)dataHotelInit
{
    if ([self.m_hotels count]==0) return;
    [self updateHidingGroups];
    if (self.m_isHideHotelGroup == YES) return;
    
    NSMutableDictionary * h = [self.m_hotels objectAtIndex:self.m_indexHotel];
    self.m_selectingRoom = h;
    
    int hRoomPriceSummary = 0;
    self.m_hpricedailyL.text = @"";
    int days = [[self.m_recommendDic valueForKey:@"days_cnt"] intValue];
    NSString * date_off = [self.m_recommendDic valueForKey:@"date_off"];
    for (int i =0; i<days; i++) {
        NSString * dayKey = [NSString stringWithFormat:@"R%@",
                             [YZZUtil DATE_FORMAT_MMDD:
                              [YZZUtil DATE_DAY_CAL:date_off
                                            intDays:+i]]];
        int dayPrice = 0;
        if ([h valueForKey:dayKey] != nil)
            dayPrice = [[h valueForKey:dayKey] intValue];
        NSString * dayString = [[NSString alloc] init];
        if (dayPrice == 0) {
            dayString = @"#无牌价#";
        } else {
            dayString = [NSString stringWithFormat:@"%d",dayPrice];
        }
        self.m_hpricedailyL.text = [NSString stringWithFormat:@" %@ %@",self.m_hpricedailyL.text,dayString];
        hRoomPriceSummary = hRoomPriceSummary + dayPrice;
    }
    
    self.m_hdayS.value = days;//[[self.m_recommendDic valueForKey:@"KK"] doubleValue];
    self.m_hdaysL.text = [NSString stringWithFormat:@"%d",days];
    self.m_hnameL.text = [h valueForKey:@"HOTELNAME"];
    self.m_hrnameL.text = [h valueForKey:@"ROOMNAME"];
    self.m_hotel_price = (float)hRoomPriceSummary;
    self.m_hpriceL.text = [NSString stringWithFormat:@"%.02f¥",self.m_hotel_price];
    
    [self datePlanUpdate];
    [self datePlanUpdate:h];
}

- (void)dataAirOffInit
{
    if ([self.m_offAirs count]==0) return;
    [self updateHidingGroups];
    if (self.m_isHideAirDepartGroup == YES) return;
    
    NSString * airline = [self.m_offAirs objectAtIndex:self.m_indexPlaneOff];
    
    //SHE,BJS,2013-05-14T08:00:00,2013-05-14T09:25:00,CZ6101  490,700,0.7,50,60,10  100  Y,G,G  SHE,23,PEK,2
    NSArray * parts = [airline componentsSeparatedByString:@"  "];
    NSArray * part1 = [[parts objectAtIndex:0] componentsSeparatedByString:@","];
    NSArray * part2 = [[parts objectAtIndex:1] componentsSeparatedByString:@","];
    //part3 string
    NSArray * part4 = [[parts objectAtIndex:3] componentsSeparatedByString:@","];
    NSArray * part5 = [[parts objectAtIndex:4] componentsSeparatedByString:@","];
    
    //NSString * dCityCode = [part1 objectAtIndex:0];
    //NSString * aCityCode = [part1 objectAtIndex:1];
    NSString * dDateTime = [part1 objectAtIndex:2];
    NSString * aDateTime = [part1 objectAtIndex:3];
    NSString * aLineCode = [part1 objectAtIndex:4];
    //2013-05-14T08:00:00
    NSString * dTime = [dDateTime substringWithRange:NSMakeRange(11, 5)];
    NSString * aTime = [aDateTime substringWithRange:NSMakeRange(11, 5)];
    
    NSString * customPrice = [part2 objectAtIndex:0];
    NSString * originPrice = [part2 objectAtIndex:1];
    NSString * customRates = [part2 objectAtIndex:2];
    NSString * customTaxes = [part2 objectAtIndex:3];
    NSString * customOiFee = [part2 objectAtIndex:4];
    NSString * ticketCount = [part2 objectAtIndex:5];
    
    NSString * punctuality = [parts objectAtIndex:2];
    
    NSString * displaySeat = [part4 objectAtIndex:2];
    
    NSString * dAirPortCode = [part5 objectAtIndex:0];
    NSString * dAirPortBuild = [part5 objectAtIndex:1];
    NSString * aAirPortCode = [part5 objectAtIndex:2];
    NSString * aAirPortBuild = [part5 objectAtIndex:3];
    
    self.m_departAirPortL.text = [self.m_dataAirPortDic valueForKey:dAirPortCode];
    self.m_airLinedHouseL.text = [NSString stringWithFormat:@"T%@",dAirPortBuild];
    self.m_arriveAirPortL.text = [self.m_dataAirPortDic valueForKey:aAirPortCode];
    self.m_airLineaHouseL.text = [NSString stringWithFormat:@"T%@",aAirPortBuild];
    
    self.m_departTimeL.text     = dTime;
    self.m_arriveTimeL.text     = aTime;
    
    self.m_airLineCodeL.text    = aLineCode;
    self.m_airLineSeatL.text    = displaySeat;
    self.m_airLinePuncL.text    = punctuality;
    
    self.m_airLineOriginPriceL.text = originPrice;
    self.m_airLineTaxL.text         = customTaxes;
    self.m_airLineOilL.text         = customOiFee;
    self.m_airLineOffRateL.text     = [NSString stringWithFormat:@"%.0f%%",[customRates floatValue]*100];
    
    self.m_airoff_price = [customPrice floatValue] + [customTaxes floatValue] + [customOiFee floatValue];
    self.m_airLinePriceL.text       = [NSString stringWithFormat:@"%.02f¥",self.m_airoff_price];
    
    [self datePlanUpdate];
}

- (void)dataAirBckInit
{
    if ([self.m_bckAirs count]==0) return;
    [self updateHidingGroups];
    if (self.m_isHideAirGobackGroup == YES) return;
    
    NSString * airline = [self.m_bckAirs objectAtIndex:self.m_indexPlaneBck];
    
    //SHE,BJS,2013-05-14T08:00:00,2013-05-14T09:25:00,CZ6101  490,700,0.7,50,60,10  100  Y,G,G  SHE,23,PEK,2
    NSArray * parts = [airline componentsSeparatedByString:@"  "];
    NSArray * part1 = [[parts objectAtIndex:0] componentsSeparatedByString:@","];
    NSArray * part2 = [[parts objectAtIndex:1] componentsSeparatedByString:@","];
    //part3 string
    NSArray * part4 = [[parts objectAtIndex:3] componentsSeparatedByString:@","];
    NSArray * part5 = [[parts objectAtIndex:4] componentsSeparatedByString:@","];
    
    //NSString * dCityCode = [part1 objectAtIndex:0];
    //NSString * aCityCode = [part1 objectAtIndex:1];
    NSString * dDateTime = [part1 objectAtIndex:2];
    NSString * aDateTime = [part1 objectAtIndex:3];
    NSString * aLineCode = [part1 objectAtIndex:4];
    
    NSString * dTime = [dDateTime substringWithRange:NSMakeRange(11, 5)];
    NSString * aTime = [aDateTime substringWithRange:NSMakeRange(11, 5)];
    
    NSString * customPrice = [part2 objectAtIndex:0];
    NSString * originPrice = [part2 objectAtIndex:1];
    NSString * customRates = [part2 objectAtIndex:2];
    NSString * customTaxes = [part2 objectAtIndex:3];
    NSString * customOiFee = [part2 objectAtIndex:4];
    NSString * ticketCount = [part2 objectAtIndex:5];
    
    NSString * punctuality = [parts objectAtIndex:2];
    
    NSString * displaySeat = [part4 objectAtIndex:2];
    
    NSString * dAirPortCode = [part5 objectAtIndex:0];
    NSString * dAirPortBuild = [part5 objectAtIndex:1];
    NSString * aAirPortCode = [part5 objectAtIndex:2];
    NSString * aAirPortBuild = [part5 objectAtIndex:3];
    
    
    self.n_departAirPortL.text = [self.m_dataAirPortDic valueForKey:dAirPortCode];
    self.n_airLinedHouseL.text = [NSString stringWithFormat:@"T%@",dAirPortBuild];
    self.n_arriveAirPortL.text = [self.m_dataAirPortDic valueForKey:aAirPortCode];
    self.n_airLineaHouseL.text = [NSString stringWithFormat:@"T%@",aAirPortBuild];
    
//    self.n_departAirPortL.text  = [NSString stringWithFormat:@"%@,%@",dAirPortCode,dAirPortBuild];
//    self.n_arriveAirPortL.text  = [NSString stringWithFormat:@"%@,%@",aAirPortCode,aAirPortBuild];
    
    self.n_departTimeL.text     = dTime;
    self.n_arriveTimeL.text     = aTime;
    
    self.n_airLineCodeL.text    = aLineCode;
    self.n_airLineSeatL.text    = displaySeat;
    self.n_airLinePuncL.text    = punctuality;
    
    self.n_airLineOriginPriceL.text = originPrice;
    self.n_airLineTaxL.text         = customTaxes;
    self.n_airLineOilL.text         = customOiFee;
    self.n_airLineOffRateL.text     = [NSString stringWithFormat:@"%.0f%%",[customRates floatValue]*100];
    
    self.m_airbck_price = [customPrice floatValue] + [customTaxes floatValue] + [customOiFee floatValue];
    self.n_airLinePriceL.text       = [NSString stringWithFormat:@"%.02f¥",self.m_airbck_price];
    
    [self datePlanUpdate];
}

- (void)datePlanUpdate
{
    self.m_total_price = self.m_hotel_price + self.m_airoff_price + self.m_airbck_price;
    self.m_planPriceL.text = [NSString stringWithFormat:@"%.02f¥",self.m_total_price];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self QueryRoomRate];
    [self QueryAirPair];
    [self userNotify];
}

- (void)QueryRoomRate
{
    self.m_op = [[AppDelegate m_engine] ExpoPost:self.m_recommendDic hotels:self.m_hotels vc:self];
}

- (void)QueryAirPair
{
//    NSLog(@"self recDic:(%@) cityDic:(%@)",self.m_recommendDic,self.m_cityCodeDic);
    NSMutableDictionary * dic = @{
                           @"DDATE":[NSString stringWithFormat:@"R%@",[YZZUtil DATE_FORMAT_MMDD:[self.m_recommendDic valueForKey:@"date_off"]]],
                           @"ADATE":[NSString stringWithFormat:@"R%@",[YZZUtil DATE_FORMAT_MMDD:[self.m_recommendDic valueForKey:@"date_bck"]]],
                           @"DCITY":[self.m_cityCodeDic valueForKey:[self.m_recommendDic valueForKey:@"city_src"]],
                           @"ACITY":[self.m_cityCodeDic valueForKey:[self.m_recommendDic valueForKey:@"city_dst"]],
                           };
    self.m_airOp = [[AppDelegate m_engine] ExpoPost:self.m_recommendDic citys:dic vc:self];
}

- (void)Refresh
{
    NSLog(@"RefreshHotel Hotel:%d",[self.m_hotels count]);
    if ([self.m_hotels count]>0) {
        self.m_isHideHotelGroup = NO;
    }
    [self dataHotelInit];
}

- (void)RefreshAir
{
    NSLog(@"RefreshAir Off:%d, Bck:%d",[self.m_offAirs count],[self.m_bckAirs count]);
    if ([self.m_offAirs count]>0) {
        self.m_isHideAirDepartGroup = NO;
    }
    if ([self.m_bckAirs count]>0) {
        self.m_isHideAirGobackGroup = NO;
    }
    [self dataAirOffInit];
    [self dataAirBckInit];
}

- (IBAction)actionShowNextRoom:(id)sender {
    self.m_indexHotel++;
    if (self.m_indexHotel>=[self.m_hotels count]) {
        self.m_indexHotel = 0;
    }
//    NSLog(@"%d",self.m_indexHotel);
    [self dataHotelInit];
}

- (IBAction)actionShowNextDepartAirLine:(id)sender {
    self.m_indexPlaneOff++;
    if (self.m_indexPlaneOff>=[self.m_offAirs count]) {
        self.m_indexPlaneOff = 0;
    }
//    NSLog(@"%d",self.m_indexPlaneOff);
    [self dataAirOffInit];
}

- (IBAction)actionShowNextBackAirLine:(id)sender {
    self.m_indexPlaneBck++;
    if (self.m_indexPlaneBck>=[self.m_bckAirs count]) {
        self.m_indexPlaneBck = 0;
    }
    //    NSLog(@"%d",self.m_indexPlaneOff);
    [self dataAirBckInit];
}

#pragma mark - Plan Submit

//酒店订单生成接口
#pragma mark - Hotel Order
- (void)hotelOrderRequest
{
    NSInteger numOfRooms = 1; //所订房间数
    NSString *ratePlanCode = [self.m_selectingRoom valueForKey:@"ROOMCODE"];//价格计划代码
    NSString *hotelCode = [self.m_selectingRoom valueForKey:@"HOTELCODE"];//酒店代码
    
    NSString *surnmaeForStay = @"快展";//入住人
    NSString *surnameForContact = @"快展客户端";//联系人
    NSString *mobile = @"18010192996"; //联系人手机
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:24*60*60 * 10]; //最晚入住时间
    NSString *lateArrivalTime = [YZZUtil getTimeStampWithDate:date];
    
    NSInteger numOfPerson = 1; //客人数量 1~999;
    
    NSInteger amountPercent = 1400; //罚金
    
    OTA_HotelResOTA_HotelRes *hotelRes = [OTA_HotelResOTA_HotelRes service];
    NSString *requestBody = [NSString stringWithFormat:@"\
                             <ns:OTA_HotelResRQ TimeStamp=\"%@\" Version=\"1.0\">\
                             %@\
                             <ns:HotelReservations>\
                             <ns:HotelReservation>\
                             <ns:RoomStays>\
                             <ns:RoomStay>\
                             <ns:RoomTypes>\
                             <ns:RoomType NumberOfUnits=\"%d\"/>\
                             </ns:RoomTypes>\
                             <ns:RatePlans>\
                             <ns:RatePlan RatePlanCode=\"%@\"/>\
                             </ns:RatePlans>\
                             <ns:BasicPropertyInfo HotelCode=\"%@\"/>\
                             </ns:RoomStay>\
                             </ns:RoomStays>\
                             <ns:ResGuests>\
                             <ns:ResGuest>\
                             <ns:Profiles>\
                             <ns:ProfileInfo>\
                             <ns:Profile>\
                             <ns:Customer>\
                             <ns:PersonName>\
                             <ns:Surname>%@</ns:Surname>\
                             </ns:PersonName>\
                             <ns:ContactPerson ContactType=\"tel\">\
                             <ns:PersonName>\
                             <ns:Surname>%@</ns:Surname>\
                             </ns:PersonName>\
                             <ns:Telephone PhoneNumber=\"%@\" PhoneTechType=\"5\"/>\
                             </ns:ContactPerson>\
                             </ns:Customer>\
                             </ns:Profile>\
                             </ns:ProfileInfo>\
                             </ns:Profiles>\
                             <ns:TPA_Extensions>\
                             <ns:LateArrivalTime>%@</ns:LateArrivalTime>\
                             </ns:TPA_Extensions>\
                             </ns:ResGuest>\
                             </ns:ResGuests>\
                             <ns:ResGlobalInfo>\
                             <ns:GuestCounts>\
                             <ns:GuestCount Count=\"%d\"/>\
                             </ns:GuestCounts>\
                             <ns:TimeSpan Start=\"2013-05-08T12:00:00+08:00\" End=\"2013-05-10T12:00:00+08:00\"/>\
                             <ns:Total AmountBeforeTax=\"%d\"/>\
                             </ns:ResGlobalInfo>\
                             </ns:HotelReservation>\
                             </ns:HotelReservations>\
                             </ns:OTA_HotelResRQ>\
                             "
                             ,[YZZUtil getTimeStampNow],[YZZUtil getCodeListForUIT],numOfRooms,ratePlanCode,hotelCode,surnmaeForStay,surnameForContact,mobile,lateArrivalTime,numOfPerson,amountPercent];
    NSLog(@"requestBody(%@)",requestBody);
    NSString *requestXml = [YZZUtil OTA_REQUEST:@"OTA_HotelRes" body:requestBody];
    [hotelRes Request:self action:@selector(receivedHotelRes:) requestXML:requestXml];
}

- (void)receivedHotelRes:(id)value
{
NSLog(@"HotelRes respond:\n%@",value);
}

- (IBAction)actionSubmitPlan:(id)sender {
    //[self hotelOrderRequest];
    //[self pushView];
    [self actionTelephone];
}

- (void)actionTelephone
{
    NSLog(@"!");
    UIActionSheet * as = [[UIActionSheet alloc] initWithTitle:@"请致电CTrip客服\n按 [6] 整单预定"
                                                     delegate:self
                                            cancelButtonTitle:@"取消"
                                       destructiveButtonTitle:@"800-820-6666"
                                            otherButtonTitles:nil];
    [as showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [actionSheet cancelButtonIndex]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:8008206666"]];
    }
}

- (void)pushView
{
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
    YZZPlanVC * vc = [sb instantiateViewControllerWithIdentifier:@"YZZPlanVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidUnload {
    [self setM_AirGobackGroupTipL:nil];
    [self setM_AirDepartGroupTipL:nil];
    [self setM_HotelGroupTipL:nil];
    [super viewDidUnload];
}
@end
