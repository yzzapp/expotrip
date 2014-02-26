//
//  YZZDataHelper.m
//  coiii
//
//  Created by 石戬,还没有对象的87姚勤 on 13-3-7.
//  Copyright (c) 2013年 北京云指针科技有限公司. All rights reserved.
//

#import "YZZDataHelper.h"

@implementation YZZDataHelper

+ (NSMutableArray *)JsonHelper:(NSString *)jsonString
{
    NSMutableArray * contentArray = [[NSMutableArray alloc] init];
    NSData * data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    contentArray = [NSJSONSerialization JSONObjectWithData:data
                                                   options:NSJSONReadingMutableContainers
                                                     error:nil];
    return contentArray;
}

@end
