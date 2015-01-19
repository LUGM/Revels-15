//
//  PageContentViewController.m
//  Revels'15
//
//  Created by Shubham Sorte on 30/12/14.
//  Copyright (c) 2014 LUGManipal. All rights reserved.
//

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import <CoreData/CoreData.h>
#import "PageContentViewController.h"
#import "EventTableViewCell.h"
#import "SSJSONModel.h"
#import "Event.h"
#import "PQFCirclesInTriangle.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "CellOptionView.h"
#import "Following.h"
#import "CoreDataHelper.h"

@interface PageContentViewController () <SSJSONModelDelegate>
{
    UITableView * myTableView;
    SSJSONModel * jsonReq;
    NSMutableArray * mainArray;
    UIView * loadBg;
    AppDelegate * appDelegate;
    NSIndexPath * selectedIndex;
}

@property CellOptionView * cellOptionView;
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
    
    if (_cellOptionView == nil) {
        NSArray * nib = [[NSBundle mainBundle]loadNibNamed:@"CellOptionView" owner:self options:nil];
        _cellOptionView = [nib objectAtIndex:0];
    }
}

#pragma mark - Cell Option View

-(void)openCellOptionView:(Event*)event
{
    NSLog(@"%@",event.event);
    
    _cellOptionView.frame = CGRectMake(0, self.view.frame.size.height + 110, self.view.frame.size.width-20, _cellOptionView.frame.size.height);
    _cellOptionView.eventLabel.text = event.event;
    _cellOptionView.eventDescription.text = event.desc;
    
    [_cellOptionView.addToFollowingButton addTarget:self action:@selector(addEventToFollowing) forControlEvents:UIControlEventTouchUpInside];

    loadBg = [[UIView alloc]initWithFrame:self.navigationController.view.frame];
//    loadBg.backgroundColor = UIColorFromRGB(0x009589);
    loadBg.backgroundColor = [UIColor blackColor];
    loadBg.alpha = 0.0;
    [loadBg addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeCellMenuView)]];
    [self.navigationController.view addSubview:loadBg];
    [self.navigationController.view addSubview:_cellOptionView];
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        loadBg.alpha = 0.75;
        _cellOptionView.center = CGPointMake(self.view.center.x, self.view.center.y+50);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)removeCellMenuView
{
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        loadBg.alpha = 0.0;
        _cellOptionView.center = CGPointMake(self.view.center.x, self.view.frame.size.height + 350);
    } completion:^(BOOL finished) {
        [loadBg removeFromSuperview];
        [_cellOptionView removeFromSuperview];
        loadBg = nil;
    }];
}

# pragma mark - Request
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

#pragma mark - Core Data

-(void)addEventToFollowing
{
    NSManagedObjectContext * context = [CoreDataHelper managedObjectContext];
    
    Event * event = [mainArray objectAtIndex:selectedIndex.row];
    
    Following * followEvent = [NSEntityDescription insertNewObjectForEntityForName:@"Following" inManagedObjectContext:context];
    
    followEvent.event = event.event;
    followEvent.location = event.location;
    followEvent.start = event.start;
    followEvent.stop = event.stop;
    followEvent.desc = event.desc;
    
    NSError * error;
    
    if (![context save:&error]) {
        NSLog(@"%@",error);
    }
    
}

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
    Event *event = [mainArray objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self openCellOptionView:event];
    selectedIndex = indexPath;
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
