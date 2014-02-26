//
//  YZZDepartCityVC.m
//  expotrip
//
//  Created by 石戬,还没有对象的87姚勤 on 13-5-18.
//  Copyright (c) 2013年 YzzApp.com. All rights reserved.
//

#import "YZZDepartCityVC.h"
#import "YZZDateVC.h"
#import "YZZTheme.h"

@interface YZZDepartCityVC ()

@end

@implementation YZZDepartCityVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [YZZTheme ThemeLoading:@"出发城市"
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cityCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [self configCell:cell atIndexPath:indexPath];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

- (UITableViewCell *)configCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    UIButton * btn1 = (UIButton *)[cell viewWithTag:2001];
    UIButton * btn2 = (UIButton *)[cell viewWithTag:2002];
    UIButton * btn3 = (UIButton *)[cell viewWithTag:2003];
    UIButton * btn4 = (UIButton *)[cell viewWithTag:2004];
//    [self.m_planeCitys addObject:@{
//     @"CITY":[lineArr objectAtIndex:0],
//     @"CODE":[lineArr objectAtIndex:1],
//     @"LON":[lineArr objectAtIndex:2],
//     @"LAT":[lineArr objectAtIndex:3],
//     }];
    
    int tag1 = indexPath.row*4 + 0;
    int tag2 = indexPath.row*4 + 1;
    int tag3 = indexPath.row*4 + 2;
    int tag4 = indexPath.row*4 + 3;

    NSDictionary * city1 = [self.m_cityArr objectAtIndex:tag1];
    NSDictionary * city2 = [self.m_cityArr objectAtIndex:tag2];
    NSDictionary * city3 = [self.m_cityArr objectAtIndex:tag3];
    NSDictionary * city4 = [self.m_cityArr objectAtIndex:tag4];
    
    NSString * title1 = [city1 valueForKey:@"CITY"];
    NSString * title2 = [city2 valueForKey:@"CITY"];
    NSString * title3 = [city3 valueForKey:@"CITY"];
    NSString * title4 = [city4 valueForKey:@"CITY"];
    
    [btn1 setTitle:title1 forState:UIControlStateNormal];
    [btn2 setTitle:title2 forState:UIControlStateNormal];
    [btn3 setTitle:title3 forState:UIControlStateNormal];
    [btn4 setTitle:title4 forState:UIControlStateNormal];
    
    [btn1 setTag:tag1];
    [btn2 setTag:tag2];
    [btn3 setTag:tag3];
    [btn4 setTag:tag4];
    
    [btn1 addTarget:self action:@selector(pushBtn:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 addTarget:self action:@selector(pushBtn:) forControlEvents:UIControlEventTouchUpInside];
    [btn3 addTarget:self action:@selector(pushBtn:) forControlEvents:UIControlEventTouchUpInside];
    [btn4 addTarget:self action:@selector(pushBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)pushBtn:(UIButton *)btnSelected
{
    int tag = btnSelected.tag;
    NSDictionary * city = [self.m_cityArr objectAtIndex:tag];
    [btnSelected setHighlighted:YES];
    
    NSArray * vcArray = [self.navigationController viewControllers];
    YZZDateVC * vc = [vcArray objectAtIndex:([vcArray count]-2)];
    [vc.m_srcLand setText:[city valueForKey:@"CITY"]];
    [self.navigationController popViewControllerAnimated:YES];

    
//    NSLog(@"selecting city:%@,%@",[city valueForKey:@"CITY"],[city valueForKey:@"CODE"]);
//    UIViewController * pvc = [self.navigationController parentViewController];
    
//    NSLog(@"pvc:%@",pvc);
    //[pvc performSelector:@selector(setM_srcLand.text:) withObject:[city valueForKey:@"CITY"]];
//    [self.navigationController popViewControllerAnimated:YES];
//        self.m_srcLand.text
}

@end
