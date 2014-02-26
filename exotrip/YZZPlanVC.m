//
//  YZZPlanVC.m
//  expotrip
//
//  Created by 石戬,还没有对象的87姚勤 on 13-4-26.
//  Copyright (c) 2013年 YzzApp.com. All rights reserved.
//

#import "YZZPlanVC.h"
#import "YZZTheme.h"

@interface YZZPlanVC ()

@end

@implementation YZZPlanVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	[YZZTheme ThemeLoading:@"订单确认"
                        vc:self
             leftImageName:@"ui_exotrip_nav_back.png"
                leftAction:@selector(navLeftDo)
            rightImageName:nil
               rightAction:nil];
}


- (void)navLeftDo
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
