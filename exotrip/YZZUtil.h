//
//  YZZUtil.h
//  exotrip
//
//  Created by 石戬,还没有对象的87姚勤 on 13-4-20.
//  Copyright (c) 2013年 YzzApp.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

static NSString * yzz_aid = @"1234"; //1234
static NSString * yzz_sid = @"123456"; //123456
static NSString * yzz_key = @"1AA11111-AAA1-11A1-1111-A11AAA11AA11";

@interface YZZUtil : NSObject

+ (NSString *)OTA_HEAD:(NSString *)requestType;
+ (NSString *)OTA_REQUEST:(NSString *)requestType body:(NSString *)body;

+ (NSDictionary *) md5_ctrip:(NSString *)requestType;

#pragma mark - DATE
+ (NSString *)DATE_TODAY_STRING;
+ (NSString *)DATE_DAY_CAL:(NSString *)dateString intDays:(int)intDay;
+ (NSString *)DATE_FORMAT_MMDD:(NSString *)dateString;
+ (int)DATE_DAYS_TO_DATE:(NSString *)dateString fromDate:(NSString *)fromDate;

+ (NSString *)getTimeStampNow;
+ (NSString *)getTimeStampWithDate:(NSDate *)date;
+ (NSString *)getTimeStampWithString:(NSString *)string;

+ (NSString *)getCodeListForUIT;

#pragma mark - file
+ (void)WRITE_TO_FILE:(NSString *)content withName:(NSString *)name;
+ (NSString *)READ_FROM_FILE:(NSString *)name;

#pragma mark - CoreLocation
+ (CLLocationDistance)distantFromLat:(CGFloat )lat andLong:(CGFloat)longit dstLat:(CGFloat )dstLat dstLong:(CGFloat)dstLong;
+ (NSString *)DistantNearCity:(CGFloat )lat andLong:(CGFloat)lon;

@end
