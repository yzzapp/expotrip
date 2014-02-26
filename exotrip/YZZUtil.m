//
//  YZZUtil.m
//  exotrip
//
//  Created by 石戬,还没有对象的87姚勤 on 13-4-20.
//  Copyright (c) 2013年 YzzApp.com. All rights reserved.
//

#import "YZZUtil.h"
#import <CommonCrypto/CommonDigest.h>

@implementation YZZUtil

+ (NSString *)OTA_HEAD:(NSString *)requestType
{
    NSDictionary * dic = [self md5_ctrip:requestType];
    NSString *str = [NSString stringWithFormat:@"<Header AllianceID=\"%@\" SID=\"%@\" TimeStamp=\"%@\" RequestType=\"%@\" Signature=\"%@\"/>",
                     [dic valueForKey:@"aid"],
                     [dic valueForKey:@"sid"],
                     [dic valueForKey:@"interval"],
                     [dic valueForKey:@"requestType"],
                     [dic valueForKey:@"md5"]];
    return str;
}

+ (NSString *)OTA_REQUEST:(NSString *)requestType body:(NSString *)body
{
    NSString *requestBody = [NSString stringWithFormat:@"<HotelRequest><RequestBody xmlns:ns=\"http://www.opentravel.org/OTA/2003/05\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\">%@</RequestBody></HotelRequest>",body];
    NSString *requestXml = [NSString stringWithFormat:@"<![CDATA[<Request>%@%@</Request>]]>",[YZZUtil OTA_HEAD:requestType],requestBody];
    return requestXml;
}

+ (NSString *)OTA_FLIGHT_REQUEST:(NSString *)requestType body:(NSString *)body
{
    NSString *requestBody = [NSString stringWithFormat:@"<FlightRequest><RequestBody xmlns:ns=\"http://www.opentravel.org/OTA/2003/05\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\">%@</RequestBody></FlightRequest>",body];
    NSString *requestXml = [NSString stringWithFormat:@"<![CDATA[<Request>%@%@</Request>]]>",[YZZUtil OTA_HEAD:requestType],requestBody];
    return requestXml;
}

+ (NSDictionary *) md5_ctrip:(NSString *)requestType
{
    NSString * md5;
    NSDate * timestamp = [NSDate date];

    int timeInterval = [timestamp timeIntervalSince1970];
    NSString * aid = yzz_aid;
    NSString * sid = yzz_sid;
    NSString * key = yzz_key;
    NSString * md5_key_upper = [[self Md5:key] uppercaseString];
    
    NSString * fullString = [NSString stringWithFormat:@"%d%@%@%@%@",
                             timeInterval,
                             aid,
                             md5_key_upper,
                             sid,
                             requestType];
    
    md5 = [self Md5:fullString];
    
    NSDictionary * dic = @{@"aid": aid,
                           @"sid": sid,
                           @"key": key,
                           @"interval": [NSString stringWithFormat:@"%d",timeInterval],
                           @"md5": md5,
                           @"requestType" : requestType
                           };
    return dic;
}

+ (NSString *)Md5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

+ (NSString *)DATE_TODAY_STRING{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *todayString = [dateFormat stringFromDate:[NSDate date]];
    //NSLog(@"todayString:%@",todayString); //todayString:2013-04-22
    return todayString;
}

+ (NSString *)DATE_DAY_CAL:(NSString *)dateString intDays:(int)intDay{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    //NSString *basetring = [dateFormat stringFromDate:dateString];
    NSDate * baseDate = [dateFormat dateFromString:dateString];
    NSDate * targetDate = [baseDate dateByAddingTimeInterval: + (intDay * (60*60*24))];
    NSString *dayString = [dateFormat stringFromDate:targetDate];
    return dayString;
}

+ (int)DATE_DAYS_TO_DATE:(NSString *)dateString fromDate:(NSString *)fromDate {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate * date = [dateFormat dateFromString:dateString];
    NSDate * from = [dateFormat dateFromString:fromDate];
    NSTimeInterval interval = [date timeIntervalSinceDate:from];
    int days = (int)(interval / (24 * 3600));
    return days;
}

+ (NSString *)DATE_FORMAT_MMDD:(NSString *)dateString
{
    NSArray * date3p = [dateString componentsSeparatedByString:@"-"];
    NSString * mm = [NSString stringWithFormat:@"%02d",[[date3p objectAtIndex:1] intValue]];
    NSString * dd = [NSString stringWithFormat:@"%02d",[[date3p objectAtIndex:2] intValue]];
    NSString * mmdd = [NSString stringWithFormat:@"%@%@",mm,dd];
    return mmdd;
}

+ (NSDateFormatter *)getTimeStampDateFormatter
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:dd"];
    return formatter;
}

+ (NSDateFormatter *)getStandardDateFormatter
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    return dateFormat;
}

+ (NSString *)getTimeStampNow
{
    return [self getTimeStampWithDate:[NSDate date]];
}

+ (NSString *)getTimeStampWithDate:(NSDate *)date
{
    return [[self getTimeStampDateFormatter] stringFromDate:date];
}

+ (NSString *)getTimeStampWithString:(NSString *)string
{
    NSDate *date = [[self getStandardDateFormatter] dateFromString:string];
    return [self getTimeStampWithDate:date];
}

#pragma mark -
+ (NSString *)getCodeListForUIT
{
    NSString *str = [NSString stringWithFormat:@"<ns:UniqueID Type=\"504\" ID=\"100000\"/>\
                     <ns:UniqueID Type=\"28\" ID=\"%@\"/>\
                     <ns:UniqueID Type=\"503\" ID=\"%@\"/>\
                     <ns:UniqueID Type=\"1\" ID=\"%@\"/>"
                     ,yzz_aid,yzz_sid,yzz_key];
    return str;
}

#pragma mark - file

+ (NSString *)fileNameToPath:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString * fileFullPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    return fileFullPath;
}

+ (void)WRITE_TO_FILE:(NSString *)content withName:(NSString *)name
{
    [content writeToFile:[self fileNameToPath:name]
              atomically:YES
                encoding:NSUTF8StringEncoding
                   error:nil];
}

+ (NSString *)READ_FROM_FILE:(NSString *)name
{
    NSString * content = @"";
    NSString * filePath = [self fileNameToPath:name];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        content = [NSString stringWithContentsOfFile:filePath
                                            encoding:NSUTF8StringEncoding
                                               error:nil];
    } else {
        content = @"";
    }
    return content;
}

#pragma mark - CLLocation

+ (CLLocationDistance)distantFromLat:(CGFloat )lat andLong:(CGFloat)longit dstLat:(CGFloat )dstLat dstLong:(CGFloat)dstLong {
    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:lat longitude:longit];
    CLLocation *location2 = [[CLLocation alloc] initWithLatitude:dstLat longitude:dstLong];
    CLLocationDistance distance = [location1 distanceFromLocation:location2];
    return distance;
}

+ (NSString *)DistantNearCity:(CGFloat )lat andLong:(CGFloat)lon
{
    NSString * content = [NSString stringWithContentsOfFile:@"city_location.txt" encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"city loc:%@",content);
}
@end
