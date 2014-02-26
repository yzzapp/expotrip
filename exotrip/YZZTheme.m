//
//  YZZTheme.m
//  iproj
//
//  Created by 石戬,还没有对象的87姚勤 on 12-12-1.
//  Copyright (c) 2012年 北京云指针科技有限公司. All rights reserved.
//

#import "YZZTheme.h"

@implementation YZZTheme

+(void)ThemeInitOnce
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
}

//现象：按钮显示不出，是资源文件名导致，检查重名或拼写。
+(void)ThemeLoading:(NSString *)titleString
                 vc:(UIViewController *)vc
      leftImageName:(NSString *)leftString
         leftAction:(SEL)leftSelector
     rightImageName:(NSString *)rightString
        rightAction:(SEL)rightSelector
{
    [self ThemeLoadingBg:ui_theme_nav_top
                   title:titleString
                      vc:vc
           leftImageName:leftString
              leftAction:leftSelector
          rightImageName:rightString
             rightAction:rightSelector];
}

+(void)ThemeLoadingBg:(NSString *)bgImageName
                title:(NSString *)titleString
                   vc:(UIViewController *)vc
        leftImageName:(NSString *)leftString
           leftAction:(SEL)leftSelector
       rightImageName:(NSString *)rightString
          rightAction:(SEL)rightSelector
{
    vc.navigationController.navigationBar.hidden = NO;
    [vc.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:ui_theme_nav_top] forBarMetrics:UIBarMetricsDefault];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 30)];
    titleLabel.textColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f];
    titleLabel.shadowOffset = CGSizeMake(2.0f, 2.0f);
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = titleString;
    titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:26];
    titleLabel.textAlignment = UITextAlignmentCenter;
    [vc.navigationItem setTitleView:titleLabel];
    
    UIImage *leftImage = [UIImage imageNamed:leftString];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:leftImage forState:UIControlStateNormal];
    leftButton.frame = CGRectMake(0.0,0.0,leftImage.size.width,leftImage.size.height);
    [leftButton addTarget:vc action:leftSelector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    [vc.navigationItem setLeftBarButtonItem:leftButtonItem];
    
    UIImage *rightImage = [UIImage imageNamed:rightString];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:rightImage forState:UIControlStateNormal];
    rightButton.frame = CGRectMake(0.0,0.0,rightImage.size.width,rightImage.size.height);
    [rightButton addTarget:vc action:rightSelector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [vc.navigationItem setRightBarButtonItem:rightButtonItem];
}


/*
 UIImage * backImage = [UIImage imageNamed:ui_theme_nav_back];
 UIImageView * backIV = [[UIImageView alloc] initWithImage:backImage];
 UIBarButtonItem * backBtn = [[UIBarButtonItem alloc] initWithCustomView:backIV];
 [self.navigationItem setBackBarButtonItem:backBtn];
 */

//[[UIBarButtonItem appearance] :22];
//UIImage *image4 = [[UIImage imageNamed:ui_theme_nav_back] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
//[[UIBarButtonItem appearance] setBackButtonBackgroundImage:image4 forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];

//self.view.contentMode = UIViewContentModeScaleAspectFit;

@end
