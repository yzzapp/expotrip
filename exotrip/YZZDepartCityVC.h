//
//  YZZDepartCityVC.h
//  expotrip
//
//  Created by 石戬,还没有对象的87姚勤 on 13-5-18.
//  Copyright (c) 2013年 YzzApp.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZZDepartCityVC : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableDictionary * m_cityDic;
@property (strong, nonatomic) NSMutableArray * m_cityArr;
@end
