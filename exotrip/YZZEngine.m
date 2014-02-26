//
//  YZZEngine.m
//  cherry
//
//  Created by 石戬,还没有对象的87姚勤 on 13-2-19.
//  Copyright (c) 2013年 北京云指针科技有限公司. All rights reserved.
//

#import "YZZEngine.h"
#import "YZZDataHelper.h"


#define EXPO_HOTEL_DATA_PATH @"/maintain/update/hotels/"
#define EXPO_AIR_DATA_PATH @"/maintain/update/airs/"

#define EXPO_HOTEL_PASSWORD @"pwdpwd"
@implementation YZZEngine 

-(MKNetworkOperation*)ExpoPost:(NSMutableDictionary *)recommendDic
                        hotels:(NSMutableArray *)hotels
                            vc:(YZZRecommendVC *)vc
{
    MKNetworkOperation *op = [self operationWithPath:EXPO_HOTEL_DATA_PATH
                                              params:@{
                              @"mntn_pwd" : EXPO_HOTEL_PASSWORD,
                              @"date_off" : [recommendDic valueForKey:@"date_off"],
                              @"date_bck" : [recommendDic valueForKey:@"date_bck"],
                              @"city_src" : [recommendDic valueForKey:@"city_src"],
                              @"city_dst" : [recommendDic valueForKey:@"city_dst"],
                              @"expo_hll" : [recommendDic valueForKey:@"expo_hll"],
                              }
                                          httpMethod:@"POST"];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        //NSLog(@"POST and Responsed as:(%@)",[completedOperation responseString]);
//        if ([[completedOperation responseString] isEqualToString:@""]) {
//            NSLog(@"NULL RESPONSING ......");
//        } else {
//            NSLog(@"RESPONDING (%@)",[completedOperation responseString]);
//        }
        NSMutableArray * hotelArr = [NSJSONSerialization JSONObjectWithData:[completedOperation responseData]
                                                             options:NSJSONReadingAllowFragments
                                                               error:nil];
        
        vc.m_hotels = hotelArr;
        NSLog(@"hotels(%@) hotelArr count(%d)",hotels,[hotelArr count]);
        if([completedOperation isCachedResponse]) {
            DLog(@"POST cache data");
        }
        else {
            DLog(@"POST server data");
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [vc performSelector:@selector(Refresh)];
        });
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
        //    errorBlock(error);
    }];
    [self enqueueOperation:op];
    return op;
}

-(MKNetworkOperation*)ExpoPost:(NSMutableDictionary *)recommendDic
                         citys:(NSDictionary *)cityPairs
                            vc:(YZZRecommendVC *)vc
{
    MKNetworkOperation *op = [self operationWithPath:EXPO_AIR_DATA_PATH
                                              params:@{
                              @"mntn_pwd" : EXPO_HOTEL_PASSWORD,
                              @"date_off" : [cityPairs valueForKey:@"DDATE"],
                              @"date_bck" : [cityPairs valueForKey:@"ADATE"],
                              @"city_src" : [cityPairs valueForKey:@"DCITY"],
                              @"city_dst" : [cityPairs valueForKey:@"ACITY"],
                              @"expo_hll" : [recommendDic valueForKey:@"expo_hll"],
                              }
                                          httpMethod:@"POST"];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSLog(@"POST and air res as len:(%d)",[[completedOperation responseString] length]);
        
        //[{"R0521": "BJS_SHA_0521   BJS,SHA,2013-05-21T06:50:00,2013-05-21T09:10:00,HO1252  340,1130,0.30,50,110,10  100  Y,P,P  PEK,3,SHA,35   BJS,SHA,2013-05-21T08:35:00,2013-05-21T10:50:00,CZ3907  510,1130,0.45,50,110,10  90  Y,V,V  PEK,2,SHA,35   BJS,SHA,2013-05-21T16:20:00,2013-05-21T18:40:00,MU563  520,1130,0.46,50,110,10  86.67  Y,X,X  PEK,2,PVG,6   BJS,SHA,2013-05-21T20:30:00,2013-05-21T22:40:00,CA1589  570,1130,0.50,50,110,10  90  Y,G,G  PEK,3,SHA,35   BJS,SHA,2013-05-21T21:50:00,2013-05-22T00:05:00,CA1861  450,1130,0.40,50,110,10  90  Y,5,V  PEK,3,PVG,7", "CITYPAIR": "BJS_SHA"}]<AND>[{"R0523": "SHA_BJS_0523   SHA,BJS,2013-05-23T08:30:00,2013-05-23T11:00:00,HU7604  790,1130,0.70,50,110,10  86.67  Y,M,M  SHA,35,PEK,1   SHA,BJS,2013-05-23T12:40:00,2013-05-23T14:45:00,MU564  560,1130,0.50,50,110,10  86.67  Y,X,X  PVG,6,PEK,2", "CITYPAIR": "SHA_BJS"}]
        if ([[completedOperation responseString] length]<=20) {
            return;
        }
        NSArray * twoJsonString = [[completedOperation responseString] componentsSeparatedByString:@"<AND>"];
        NSData * dDateData = [[twoJsonString objectAtIndex:0] dataUsingEncoding:NSUTF8StringEncoding];
        NSData * aDateData = [[twoJsonString objectAtIndex:1] dataUsingEncoding:NSUTF8StringEncoding];
        
        NSMutableArray * dDataArr = [NSJSONSerialization JSONObjectWithData:dDateData
                                                                    options:NSJSONReadingAllowFragments
                                                                      error:nil];
        NSMutableArray * aDataArr = [NSJSONSerialization JSONObjectWithData:aDateData
                                                                    options:NSJSONReadingAllowFragments
                                                                      error:nil];
        NSDictionary * dDateDic = [dDataArr objectAtIndex:0];
        NSDictionary * aDateDic = [aDataArr objectAtIndex:0];
        NSString * dDateString = [dDateDic valueForKey:[cityPairs valueForKey:@"DDATE"]];
        NSString * aDateString = [aDateDic valueForKey:[cityPairs valueForKey:@"ADATE"]];
        //NSLog(@"dData:(%@)\naData(%@)",dDateString,aDateString);
        
//    dData:(BJS_SHA_0521   BJS,SHA,2013-05-21T06:50:00,2013-05-21T09:10:00,HO1252  340,1130,0.30,50,110,10  100  Y,P,P  PEK,3,SHA,35   BJS,SHA,2013-05-21T08:35:00,2013-05-21T10:50:00,CZ3907  510,1130,0.45,50,110,10  90  Y,V,V  PEK,2,SHA,35   BJS,SHA,2013-05-21T16:20:00,2013-05-21T18:40:00,MU563  520,1130,0.46,50,110,10  86.67  Y,X,X  PEK,2,PVG,6   BJS,SHA,2013-05-21T20:30:00,2013-05-21T22:40:00,CA1589  570,1130,0.50,50,110,10  90  Y,G,G  PEK,3,SHA,35   BJS,SHA,2013-05-21T21:50:00,2013-05-22T00:05:00,CA1861  450,1130,0.40,50,110,10  90  Y,5,V  PEK,3,PVG,7)
        
//        aData(SHA_BJS_0523   SHA,BJS,2013-05-23T08:30:00,2013-05-23T11:00:00,HU7604  790,1130,0.70,50,110,10  86.67  Y,M,M  SHA,35,PEK,1   SHA,BJS,2013-05-23T12:40:00,2013-05-23T14:45:00,MU564  560,1130,0.50,50,110,10  86.67  Y,X,X  PVG,6,PEK,2)
        
        if ([dDateString length]<= 20) NSLog(@"DCITY: EMPTY AIR LINE");
        else {
            NSString * header = [[dDateString componentsSeparatedByString:@"   "] objectAtIndex:0];
            NSMutableArray * dLineArr = [[dDateString substringFromIndex:[header length]+3] componentsSeparatedByString:@"   "];
//            NSLog(@"dLineArr:%@",dLineArr);
            vc.m_offAirs = dLineArr;
        }
        if ([aDateString length]<= 20) NSLog(@"ACITY: EMPTY AIR LINE");
        else {
            NSString * header = [[aDateString componentsSeparatedByString:@"   "] objectAtIndex:0];
            NSMutableArray * aLineArr = [[aDateString substringFromIndex:[header length]+3] componentsSeparatedByString:@"   "];
//            NSLog(@"aLineArr:%@",aLineArr);
            vc.m_bckAirs = aLineArr;
        }
        //vc.m_selectingAirOff
        
        if([completedOperation isCachedResponse]) {
            DLog(@"POST cache data");
        }
        else {
            DLog(@"POST server data");
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [vc performSelector:@selector(RefreshAir)];
        });
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
        //    errorBlock(error);
    }];
    [self enqueueOperation:op];
    return op;
}

@end
