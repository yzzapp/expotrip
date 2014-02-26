//
//  YZZCityTVC.m
//  exotrip
//
//  Created by 石戬,还没有对象的87姚勤 on 13-4-19.
//  Copyright (c) 2013年 YzzApp.com. All rights reserved.
//

#import "YZZDatabase.h"
#import "YZZUtil.h"
#import "YZZTheme.h"

#import "YZZCityTVC.h"
#import "YZZDateVC.h"

@implementation YZZCityTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [YZZTheme ThemeLoading:self.m_title
                        vc:self
             leftImageName:@"ui_exotrip_nav_back.png"
                leftAction:@selector(navLeftDo)
            rightImageName:nil
               rightAction:nil];
    
    self.m_dataArray = [[NSMutableArray alloc] init];
    NSString * today = [YZZUtil DATE_TODAY_STRING];
    NSString * selectSQL = [NSString stringWithFormat:@"SELECT DISTINCT * FROM E13CN WHERE CITY = '%@' AND DATE > '%@' ORDER BY DATE ",self.m_title,today];
    self.m_dataArray = [YZZDatabase execSelect:selectSQL];
    
    
}

- (void)navLeftDo
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.m_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"expoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [self configCell:cell atIndexPath:indexPath];
    return cell;
}

- (UITableViewCell *)configCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    UILabel * title = (UILabel *)[cell viewWithTag:1001];
    UILabel * date = (UILabel *)[cell viewWithTag:1002];
    UILabel * hall = (UILabel *)[cell viewWithTag:1003];
    UILabel * category = (UILabel *)[cell viewWithTag:1004];
    
    UILabel * recent = (UILabel *)[cell viewWithTag:1999];
    UILabel * lately = (UILabel *)[cell viewWithTag:1998];
    recent.hidden = YES;
    lately.hidden = YES;
    NSDictionary * dic = [self.m_dataArray objectAtIndex:indexPath.row];
    title.text = [dic valueForKey:@"TITLE"];
    date.text = [dic valueForKey:@"DATE"];
    hall.text = [dic valueForKey:@"HALL"];
    category.text = [dic valueForKey:@"CATEGORY"];
    
    NSString * dateString = [dic valueForKey:@"DATE"];
    int dataInt = [[YZZUtil DATE_FORMAT_MMDD:dateString] intValue];
    NSString * recentDateString = [YZZUtil DATE_DAY_CAL:[YZZUtil DATE_TODAY_STRING] intDays:45];
    int RecentInt = [[YZZUtil DATE_FORMAT_MMDD:recentDateString] intValue];
//    NSLog(@"%d,%d",dataInt,RecentInt);
    if (dataInt < RecentInt) {
        recent.hidden = NO;
    } else {
        lately.hidden = NO;
    }
    return cell;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = [self.m_dataArray objectAtIndex:indexPath.row];
    NSString * dateString = [dic valueForKey:@"DATE"];

    int dataInt = [[YZZUtil DATE_FORMAT_MMDD:dateString] intValue];
    NSString * recentDateString = [YZZUtil DATE_DAY_CAL:[YZZUtil DATE_TODAY_STRING] intDays:45];
    int RecentInt = [[YZZUtil DATE_FORMAT_MMDD:recentDateString] intValue];
//    NSLog(@"%d,%d",dataInt,RecentInt);
    if (dataInt >= RecentInt) {
        return;
    }

    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    YZZDateVC * dateVC = [sb instantiateViewControllerWithIdentifier:@"YZZDateVC"];
    dateVC.m_dic = dic;
    [self.navigationController pushViewController:dateVC animated:YES];
}

@end
