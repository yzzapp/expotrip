//
//  YZZViewController.m
//  exotrip
//
//  Created by 石戬,还没有对象的87姚勤 on 13-4-17.
//  Copyright (c) 2013年 YzzApp.com. All rights reserved.
//

#import "YZZDatabase.h"
#import "YZZUtil.h"
#import "YZZViewController.h"
#import "YZZCityTVC.h"
#import "YZZTheme.h"
#import "YZZAboutVC.h"

@interface YZZViewController ()
@property (strong, nonatomic) NSMutableArray * m_citys;
@end

@implementation YZZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.m_citys = [[NSMutableArray alloc] init];
    [self.m_citys addObjectsFromArray:@[
     @{@"title":@"北京"},
     @{@"title":@"上海"},
     @{@"title":@"成都"},
     @{@"title":@"广州"},
     @{@"title":@"深圳"},
    ]];
    [YZZTheme ThemeLoading:@"快展 Pro"
                        vc:self
             leftImageName:ui_theme_post_lbutton_back
                leftAction:@selector(navLeftDo)
            rightImageName:nil
               rightAction:nil];
}

- (void)navLeftDo
{
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
    YZZAboutVC * aboutVC = [sb instantiateViewControllerWithIdentifier:@"YZZAboutVC"];
    [self.navigationController pushViewController:aboutVC animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.m_citys count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * identifier = [self getCellIdentifier:indexPath];
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell = [self configCell:cell atIndexPath:indexPath];
    return cell;
}

- (NSString *)getCellIdentifier:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return @"cityCell";
    }
    if (indexPath.section == 1) {
        return @"townCell";
    }
    return @"defaultCell";
}

- (UITableViewCell *)configCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    UILabel * cityName = (UILabel *)[cell viewWithTag:1001];
    UILabel * cityCount = (UILabel *)[cell viewWithTag:1002];
    
    UIImageView * cityIV = (UIImageView *)[cell viewWithTag:999];
    
    NSArray * imageList = @[@"citybj.png",@"citysh.png",@"citycd.png",@"citygz.png",@"citysz.png"];
    NSString * iName = [imageList objectAtIndex:indexPath.row];
    [cityIV setImage:[UIImage imageNamed:iName]];
    
    NSDictionary * cityDic = [self.m_citys objectAtIndex:indexPath.row];
    
    cityName.text = [cityDic valueForKey:@"title"];
    
    NSString * today = [YZZUtil DATE_TODAY_STRING];
    NSString * selectSQL = [NSString stringWithFormat:@"SELECT DISTINCT * FROM E13CN WHERE CITY = '%@' AND DATE > '%@' ORDER BY DATE ",[cityDic valueForKey:@"title"],today];
    NSArray * expoArr = [YZZDatabase execSelect:selectSQL];
    cityCount.text = [NSString stringWithFormat:@"%d",[expoArr count]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * cityDic = [self.m_citys objectAtIndex:indexPath.row];
    
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    YZZCityTVC * cityTVC = [sb instantiateViewControllerWithIdentifier:@"cityTVC"];
    cityTVC.m_title = [cityDic valueForKey:@"title"];
    [self.navigationController pushViewController:cityTVC animated:YES];
}

@end
