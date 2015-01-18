//
//  PageContentViewController.m
//  Revels'15
//
//  Created by Shubham Sorte on 30/12/14.
//  Copyright (c) 2014 LUGManipal. All rights reserved.
//

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "PageContentViewController.h"
#import "EventTableViewCell.h"
#import "SSJSONModel.h"
#import "Event.h"
#import "PQFCirclesInTriangle.h"
#import "ViewController.h"
#import "AppDelegate.h"

@interface PageContentViewController () <SSJSONModelDelegate>
{
    UITableView * myTableView;
    SSJSONModel * jsonReq;
    NSMutableArray * mainArray;
    UIView * loadBg;
    AppDelegate * appDelegate;

}
@property (nonatomic, strong) PQFCirclesInTriangle *circlesInTriangles;

@end

@implementation PageContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    self.view.frame = CGRectMake(0, -64, self.view.frame.size.width, self.view.frame.size.height);
    
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20, self.view.frame.size.height)];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    myTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:myTableView];
    myTableView.contentInset = UIEdgeInsetsMake(0, 0, 110, 0);
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self sendTheRequest];
//    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.labelText = @"Loading";
//    hud.dimBackground = YES;
    
}

-(void)sendTheRequest
{
    jsonReq = [[SSJSONModel alloc]initWithDelegate:self];
    [jsonReq sendRequestWithUrl:[NSURL URLWithString:@"http://mitrevels.in/api/events/"]];
    
    loadBg = [[UIView alloc]initWithFrame:self.view.frame];
    loadBg.backgroundColor = UIColorFromRGB(0x009589);
    loadBg.alpha = 0.75;
    [self.view addSubview:loadBg];
    
    self.circlesInTriangles = [[PQFCirclesInTriangle alloc] initLoaderOnView:self.view];
    [self.circlesInTriangles show];
}

-(void)jsonRequestDidCompleteWithDict:(NSArray *)dict model:(SSJSONModel *)JSONModel
{
    if (JSONModel == jsonReq) {
        mainArray = [NSMutableArray array];
        for(NSDictionary *dict in [jsonReq.parsedJsonData objectForKey:@"data"]) {
            Event *event = [[Event alloc] initWithDict:dict];
            [mainArray addObject:event];
        }
        [myTableView reloadData];
//        [hud hide:YES];
        [self.circlesInTriangles hide];
        [self.circlesInTriangles remove];
        [loadBg removeFromSuperview];
        loadBg = nil;

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark- Table View Datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mainArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"Cell";
    
    EventTableViewCell * cell = (EventTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        NSArray * nib = [[NSBundle mainBundle]loadNibNamed:@"EventCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    Event *event = [mainArray objectAtIndex:indexPath.row];
    cell.eventLocationLabel.text = event.location;
    cell.eventNameLabel.text = event.event;
    cell.eventStartTimeLabel.text = event.start;
    cell.eventStopTimeLabel.text = event.stop;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * blankView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
    blankView.backgroundColor = [UIColor clearColor];
    return blankView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

@end
