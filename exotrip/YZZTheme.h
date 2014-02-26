//
//  YZZTheme.h
//  iproj
//
//  Created by 石戬,还没有对象的87姚勤 on 12-12-1.
//  Copyright (c) 2012年 北京云指针科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * ui_theme_nav_top = @"ui_homepage_a_nav.png";

#pragma mark - POST 
//static NSString * ui_theme_post_nav_top         = @"ui_theme_nav_coiii.png";
static NSString * ui_theme_post_bg              = @"ui_coiii_background1.png";
static NSString * ui_theme_post_lbutton_back    = @"ui_homepage_nav_about.png";
//static NSString * ui_theme_post_rbutton_post    = @"ui_coiii_nav_but_send.png";

static NSString * ui_theme_main_wall            = @"ui_main_wall.png";
static NSString * ui_theme_main_lbutton_post    = @"ui_home_publish.png";
//static NSString * ui_theme_main_rbutton_about   = @"ui_coiii_nav_but_about.png";

static NSString * ui_theme_about_bg             = @"ui_theme_nav_about.png";

static NSString * ui_theme_read_rbutton_review  = @"ui_theme_nav_review.png";

@interface YZZTheme : NSObject

+(void)ThemeInitOnce;

+(void)ThemeLoading:(NSString *)titleString
                 vc:(UIViewController *)vc
      leftImageName:(NSString *)leftString
         leftAction:(SEL)leftSelector
     rightImageName:(NSString *)rightString
        rightAction:(SEL)rightSelector;

+(void)ThemeLoadingBg:(NSString *)bgImageName
                title:(NSString *)titleString
                   vc:(UIViewController *)vc
        leftImageName:(NSString *)leftString
           leftAction:(SEL)leftSelector
       rightImageName:(NSString *)rightString
          rightAction:(SEL)rightSelector;


@end
