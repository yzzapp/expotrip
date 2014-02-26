//
//  YZZAboutVC.m
//  expotrip
//
//  Created by 石戬,还没有对象的87姚勤 on 13-4-26.
//  Copyright (c) 2013年 YzzApp.com. All rights reserved.
//

#import "YZZAboutVC.h"
#import "YZZTheme.h"

@interface YZZAboutVC ()

@end

@implementation YZZAboutVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	[YZZTheme ThemeLoading:@"关于"
                        vc:self
             leftImageName:@"ui_exotrip_nav_back.png"
                leftAction:@selector(navLeftDo)
            rightImageName:nil
               rightAction:nil];
    [self.m_scrollView setContentSize:CGSizeMake(320, 1250)];
}

- (void)navLeftDo
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [self setM_scrollView:nil];
    [super viewDidUnload];
}
@end
