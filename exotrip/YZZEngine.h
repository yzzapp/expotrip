//
//  YZZEngine.h
//  cherry
//
//  Created by 石戬,还没有对象的87姚勤 on 13-2-19.
//  Copyright (c) 2013年 北京云指针科技有限公司. All rights reserved.
//

#import "YZZRecommendVC.h"

@interface YZZEngine : MKNetworkEngine

//typedef void (^CurrencyResponseBlock)(NSArray * contentArray, UITableView * tableView);
typedef void (^CurrencyResponseBlock)(double dbr);

#pragma mark - Coiii REQUESTs

-(MKNetworkOperation*)ExpoPost:(NSMutableDictionary *)recommendDic
                        hotels:(NSMutableArray *)hotels
                            vc:(YZZRecommendVC *)vc;

-(MKNetworkOperation*)ExpoPost:(NSMutableDictionary *)recommendDic
                         citys:(NSDictionary *)cityPairs
                            vc:(YZZRecommendVC *)vc;

@end
