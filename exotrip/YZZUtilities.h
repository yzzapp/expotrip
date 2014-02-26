//
//  YZZUtilities.h
//  iproj
//
//  Created by 石 戬 on 12-7-12.
//  Copyright (c) 2012年 北京云指针科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

@interface YZZUtilities : NSObject
//NSString
+ (BOOL)isEmptyString:(NSString *)str;
+ (BOOL)isToLongString:(NSString *)str limit:(int)lenLimit;
+ (BOOL)isToWideString:(NSString *)str limit:(int)colLimit;//Chinese Char Width
+ (NSString *)textTrim:(NSString *)text;

#pragma mark - VC Service
//UIAlert
+ (void)ShowAlert:(NSString *)msg;
+ (void)ShowAlert:(NSString *)title msg:(NSString *)msg;
//NSString Check to Alert || OK
+ (BOOL)CheckIfTextFieldIsSafe:(NSString *)textOfContent;
//Photo Human
+ (void)savePhoto:(UIImage *)image asHumanID:(int)humanId;
+ (UIImage *)getPhotoForHumanId:(int)humanId;

//PDF
@property CGSize pdfPageSize;

#pragma mark - In App Purchase
+ (NSString *)productISBuyed:(NSString *)keyname;
+ (void)productSetBuyed:(NSString *)keyname asState:(NSString *)state;

@end
