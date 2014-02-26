//
//  YZZUtilities.m
//  iproj
//
//  Created by 石 戬 on 12-7-12.
//  Copyright (c) 2012年 北京云指针科技有限公司. All rights reserved.
//

#import "YZZUtilities.h"

@implementation YZZUtilities
@synthesize pdfPageSize;

#pragma mark -

+ (void)ShowAlert:(NSString *)msg
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" 
                                                     message:msg 
                                                    delegate:self 
                                           cancelButtonTitle:@"OK" 
                                           otherButtonTitles:nil, nil];
    [alert show];
}

+ (void)ShowAlert:(NSString *)title msg:(NSString *)msg
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title
                                                     message:msg 
                                                    delegate:self 
                                           cancelButtonTitle:@"OK" 
                                           otherButtonTitles:nil, nil];
    [alert show];
}

+ (BOOL)isEmptyString:(NSString *)str
{
    NSString *trimString = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([trimString isEqualToString:@""]) return FALSE;
    return TRUE;
}

+ (BOOL)isToLongString:(NSString *)str limit:(int)lenLimit
{
    NSString *trimString = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (trimString.length > lenLimit) return FALSE;
    return TRUE;
}

+ (BOOL)isToWideString:(NSString *)str limit:(int)colLimit
{
    NSString *trimString = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    // how to count width of String. Chinese and some Lang Char count as 2 col in all.
    int length = trimString.length;
    // REGULAR EXPRESSION;
    
    if ( length > colLimit) return FALSE;
    return TRUE;
}

+ (NSString *)textTrim:(NSString *)text
{
    NSString * trimmed = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return trimmed;
}

+ (BOOL)CheckIfTextFieldIsSafe:(NSString *)textOfContent
{
    NSString * trimString = [self textTrim:textOfContent];

    if ([trimString isEqualToString:@""]) {
        [YZZUtilities ShowAlert:@"创建和修改内容，不能为空白。"];
        return FALSE;
    }
    if (trimString.length >= 140) {
        [YZZUtilities ShowAlert:@"创建和修改内容，请精简为140字以内。"];
        return FALSE;
    }
    return TRUE;
}

+ (void)savePhoto:(UIImage *)image asHumanID:(int)humanId
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDirectory, YES);
    NSString *localDocDirectory = [paths objectAtIndex:0];
    NSString * postDiaryPath = [localDocDirectory stringByAppendingString:@"/Diary/"];
    NSString * imageFileName = [[NSString alloc] initWithFormat:@"%@human_%d.png",postDiaryPath,humanId];

    [[NSFileManager defaultManager] createDirectoryAtPath:postDiaryPath
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:nil];
    [UIImageJPEGRepresentation(image, 1.0f) writeToFile:imageFileName atomically:YES];
}

+ (UIImage *)getPhotoForHumanId:(int)humanId
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDirectory, YES);
    NSString *localDocDirectory = [paths objectAtIndex:0];
    NSString * postDiaryPath = [localDocDirectory stringByAppendingString:@"/Diary/"];
    NSString * imageFileName = [[NSString alloc] initWithFormat:@"%@human_%d.png",postDiaryPath,humanId];
    
    UIImage * image;
    if ([[NSFileManager defaultManager] fileExistsAtPath:imageFileName]) {
        image = [UIImage imageWithContentsOfFile:imageFileName];
    } else {
        NSLog(@"%d figure not exists at (%@)",humanId,imageFileName);
    }
    return image;
}

#pragma mark - PDF

- (IBAction)ExportPdfReport:(id)sender {
    NSString * pdfFileName = [self genPDF];
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@""
                                                     message:[NSString stringWithFormat:@"%@ is ready.",pdfFileName]
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
    [alert show];
    //[self showMail:pdfFileName];
}

- (NSString *)genPDF
{
    pdfPageSize = CGSizeMake(612, 792);
    NSString * fileName = @"YzzPdf.pdf";
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * docDir = [paths objectAtIndex:0];
    NSString * pdfFileName = [docDir stringByAppendingPathComponent:fileName];
    
    [self generateReport:pdfFileName];
    return pdfFileName;
}

- (void)showMail:(NSString *)fileFullPath
{
    if (![MFMailComposeViewController canSendMail]) {
        return;
    }
    
    NSData * pdfContent = [[NSData alloc] initWithContentsOfFile:fileFullPath];
    
    MFMailComposeViewController * mcvc = [[MFMailComposeViewController alloc] init];
    //mcvc.mailComposeDelegate = self;
    [mcvc setSubject:@"iProj THISNAME Report"];
    [mcvc setMessageBody:@"iProj THISNAME Report" isHTML:YES];
    [mcvc addAttachmentData:pdfContent mimeType:@"pdf" fileName:@"iProj THISNAME Report.pdf"];
    
    [mcvc presentViewController:mcvc animated:YES completion:nil];
}

- (void)generateReport:(NSString *)pdfFullPath
{
    UIGraphicsBeginPDFContextToFile(pdfFullPath, CGRectZero, nil);
    
    NSInteger currentPage = 0;
    BOOL done = NO;
    while (!done) {
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pdfPageSize.width, pdfPageSize.height), nil);
        currentPage++;
        //[self drawPageNumber:currentPage];
        [self drawBorder];
        //[self drawHeader];
        [self drawHeaderLine];
        [self drawText];
        [self drawImage];
        
        done = YES;
    }
    UIGraphicsEndPDFContext();
}

#pragma mark - draw PDF methods

#define kBorderInset 20
#define kLineWidth 2

- (void)drawBorder
{
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    UIColor * borderColor = [UIColor brownColor];
    CGRect rectFrame = CGRectMake(kBorderInset, kBorderInset, pdfPageSize.width-kBorderInset*2, pdfPageSize.height-kBorderInset*2);
    
    CGContextSetStrokeColorWithColor(currentContext, borderColor.CGColor);
    CGContextSetLineWidth(currentContext, kLineWidth);
    CGContextStrokeRect(currentContext, rectFrame);
}

- (void)drawHeaderLine
{
    CGContextRef currectContext = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(currectContext, kLineWidth);
    CGContextSetStrokeColorWithColor(currectContext, [UIColor blueColor].CGColor);
    
    CGPoint startPoint  = CGPointMake(kBorderInset, kBorderInset+40);
    CGPoint endPoint    = CGPointMake(pdfPageSize.width-kBorderInset*2, kBorderInset+40);
    
    CGContextBeginPath(currectContext);
    CGContextMoveToPoint(currectContext, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(currectContext, endPoint.x, endPoint.y);
    
    CGContextClosePath(currectContext);
    CGContextDrawPath(currectContext, kCGPathFillStroke);
}

- (void)drawText
{
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(currentContext, 0.0, 0.0, 0.0, 1.0);
    
    NSString * contextText = @"The quick brown fox jumps over a lazy dog.";
    
    UIFont * font = [UIFont systemFontOfSize:20.0];
    
    CGSize stringSize = [contextText sizeWithFont:font
                                constrainedToSize:CGSizeMake(pdfPageSize.width - 2*kBorderInset , pdfPageSize.height - 2*kBorderInset) lineBreakMode:UILineBreakModeWordWrap];
    
    CGRect renderingRect = CGRectMake(kBorderInset, kBorderInset + 60, pdfPageSize.width- 2*kBorderInset, stringSize.height);
    
    [contextText drawInRect:renderingRect
                   withFont:font
              lineBreakMode:UILineBreakModeWordWrap
                  alignment:UITextAlignmentLeft];
}

- (void)drawImage
{
    UIImage * iconImage = [UIImage imageNamed:@"iproj icon.png"];
    //[iconImage drawInRect:CGRectMake(pageSize.width/2 - iconImage.size.width/2, 200, iconImage.size.width, iconImage.size.height)];
    [iconImage drawInRect:CGRectMake(pdfPageSize.width/2 - 72, 200, 144, 144)];
}

#pragma mark - In App Purchase
+ (NSString *)productISBuyed:(NSString *)keyname
{
    NSString * v = [[NSUserDefaults standardUserDefaults] valueForKey:keyname];
    return v;
}

+ (void)productSetBuyed:(NSString *)keyname asState:(NSString *)state
{
    //NSLog(@"YES ! you got new product.");
    [[NSUserDefaults standardUserDefaults] setObject:state forKey:keyname];
}


@end
