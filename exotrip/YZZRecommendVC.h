//
//  YZZRecommendVC.h
//  expotrip
//
//  Created by 石戬,还没有对象的87姚勤 on 13-5-5.
//  Copyright (c) 2013年 YzzApp.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDKNotifyHUD.h"

@interface YZZRecommendVC : UIViewController <UIActionSheetDelegate>

@property (strong, nonatomic) BDKNotifyHUD * notify;

//Input Dic & Request
@property (strong, nonatomic) NSMutableDictionary * m_recommendDic;
@property (strong, nonatomic) MKNetworkOperation * m_op;
@property (strong, nonatomic) MKNetworkOperation * m_airOp;

@property (strong, nonatomic) NSMutableDictionary * m_dataAirPortDic;

//Hotels
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *m_HotelGroup;
@property (strong, nonatomic) IBOutlet UILabel *m_HotelGroupTipL;


@property (strong, nonatomic) IBOutlet UILabel *m_checkInDateL;
@property (strong, nonatomic) IBOutlet UILabel *m_checkOutDateL;

@property (strong, nonatomic) NSMutableArray * m_hotels;

@property (strong, nonatomic) IBOutlet UILabel *m_hnameL;
@property (strong, nonatomic) IBOutlet UILabel *m_hrnameL;
@property (strong, nonatomic) IBOutlet UILabel *m_hpriceL;
@property (strong, nonatomic) IBOutlet UILabel *m_hpricedailyL;
@property (strong, nonatomic) IBOutlet UILabel *m_hdaysL;
@property (strong, nonatomic) IBOutlet UIStepper *m_hdayS;

@property (strong, nonatomic) NSMutableDictionary * m_selectingRoom;

@property (strong, nonatomic) IBOutlet UIImageView *m_showNextRoomIV;
- (IBAction)actionShowNextRoom:(id)sender;

//Airplane Take Off & Will Back
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *m_AirDepartGroup;
@property (strong, nonatomic) IBOutlet UILabel *m_AirDepartGroupTipL;


@property (strong, nonatomic) IBOutlet UILabel *m_departDateL;
@property (strong, nonatomic) IBOutlet UILabel *m_airLinedHouseL;
@property (strong, nonatomic) IBOutlet UILabel *m_airLineaHouseL;

@property (strong, nonatomic) IBOutlet UILabel *m_departAirPortL;
@property (strong, nonatomic) IBOutlet UILabel *m_arriveAirPortL;
@property (strong, nonatomic) IBOutlet UILabel *m_departTimeL;
@property (strong, nonatomic) IBOutlet UILabel *m_arriveTimeL;
@property (strong, nonatomic) IBOutlet UILabel *m_airLineCodeL;
@property (strong, nonatomic) IBOutlet UILabel *m_airLineSeatL;
@property (strong, nonatomic) IBOutlet UILabel *m_airLinePuncL;

@property (strong, nonatomic) IBOutlet UILabel *m_airLineOriginPriceL;
@property (strong, nonatomic) IBOutlet UILabel *m_airLineTaxL;
@property (strong, nonatomic) IBOutlet UILabel *m_airLineOilL;
@property (strong, nonatomic) IBOutlet UILabel *m_airLineOffRateL;
@property (strong, nonatomic) IBOutlet UILabel *m_airLinePriceL;

@property (strong, nonatomic) IBOutlet UIImageView *m_showNextDepartAirLineIV;
- (IBAction)actionShowNextDepartAirLine:(id)sender;


@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *m_AirGobackGroup;
@property (strong, nonatomic) IBOutlet UILabel *m_AirGobackGroupTipL;


@property (strong, nonatomic) IBOutlet UILabel *m_gobackDateL;
@property (strong, nonatomic) IBOutlet UILabel *n_airLinedHouseL;
@property (strong, nonatomic) IBOutlet UILabel *n_airLineaHouseL;

@property (strong, nonatomic) IBOutlet UILabel *n_departAirPortL;
@property (strong, nonatomic) IBOutlet UILabel *n_arriveAirPortL;
@property (strong, nonatomic) IBOutlet UILabel *n_departTimeL;
@property (strong, nonatomic) IBOutlet UILabel *n_arriveTimeL;
@property (strong, nonatomic) IBOutlet UILabel *n_airLineCodeL;
@property (strong, nonatomic) IBOutlet UILabel *n_airLineSeatL;
@property (strong, nonatomic) IBOutlet UILabel *n_airLinePuncL;

@property (strong, nonatomic) IBOutlet UILabel *n_airLineOriginPriceL;
@property (strong, nonatomic) IBOutlet UILabel *n_airLineTaxL;
@property (strong, nonatomic) IBOutlet UILabel *n_airLineOilL;
@property (strong, nonatomic) IBOutlet UILabel *n_airLineOffRateL;
@property (strong, nonatomic) IBOutlet UILabel *n_airLinePriceL;

@property (strong, nonatomic) IBOutlet UIImageView *m_showNextBackAirLineIV;
- (IBAction)actionShowNextBackAirLine:(id)sender;

@property (strong, nonatomic) NSMutableDictionary * m_cityCodeDic;
@property (strong, nonatomic) NSMutableArray * m_offAirs;
@property (strong, nonatomic) NSMutableArray * m_bckAirs;

@property (strong, nonatomic) NSMutableDictionary * m_selectingAirOff;
@property (strong, nonatomic) NSMutableDictionary * m_selectingAirBck;

//Plan
@property (strong, nonatomic) IBOutlet UILabel *m_planPriceL;
@property (strong, nonatomic) IBOutlet UILabel *m_planLevL;
@property (strong, nonatomic) IBOutlet UILabel *m_dCityNameL;
@property (strong, nonatomic) IBOutlet UILabel *m_aCityNameL;
@property (strong, nonatomic) IBOutlet UILabel *m_expoNameL;

- (IBAction)actionSubmitPlan:(id)sender;

@end
