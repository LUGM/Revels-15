//
//  PageContentViewController.m
//  Revels'15
//
//  Created by Shubham Sorte on 30/12/14.
//  Copyright (c) 2014 LUGManipal. All rights reserved.
//

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define DRAG_DISTANCE_LIMIT 100.0 //parallax

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
#import "SavedEvent.h"
#import "Reachability.h"

@interface PageContentViewController () <SSJSONModelDelegate>
{
    SSJSONModel * jsonReq;
    NSMutableArray * mainArray;
    NSMutableArray * filteredArray;
    AppDelegate * appDelegate;
    NSIndexPath * selectedIndex;
    
    UITableView * myTableView;
    UIView * loadBg;
    UIRefreshControl * refreshControl;
    UIAlertView * connectionAlert;
    UILabel * noDataLabel;
}

@property CellOptionView * cellOptionView;
@property (nonatomic, strong) PQFCirclesInTriangle *circlesInTriangles;

@end

@implementation PageContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Category is %@",_categoryText);
    
    // Do any additional setup after loading the view.
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20, self.view.frame.size.height)];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.scrollEnabled = YES;
    [myTableView setScrollsToTop:YES];
    
    self.view.frame = CGRectMake(0, -60, self.view.frame.size.width, self.view.frame.size.height);
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.contentInset = UIEdgeInsetsMake(0,0,110, 0);
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    //Add pull to refresh
    refreshControl = [[UIRefreshControl alloc]init];
    refreshControl.tintColor = [UIColor blackColor];
    refreshControl.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [refreshControl addTarget:self
                       action:@selector(getData)
             forControlEvents:UIControlEventValueChanged];
    [myTableView addSubview:refreshControl];

    [self getData];
    
}

-(void)scrollToTheTop
{
    [myTableView setContentOffset:CGPointZero animated:YES];
    
    NSLog(@"top %s",[myTableView scrollsToTop]?"true":"false");
    
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if (motion == UIEventSubtypeMotionShake) {
  
        [self scrollToTheTop];
    }
}

#pragma mark - Cell Option View

-(void)openCellOptionView:(Event*)event
{
    
    if (_cellOptionView == nil) {
        NSArray * nib = [[NSBundle mainBundle]loadNibNamed:@"CellOptionView" owner:self options:nil];
        _cellOptionView = [nib objectAtIndex:0];
    }

    _cellOptionView.frame = CGRectMake(0, self.view.frame.size.height + 110, self.view.frame.size.width-20, _cellOptionView.frame.size.height);
    _cellOptionView.eventLabel.text = event.event;
    _cellOptionView.eventDescription.text = event.desc;
    
    [_cellOptionView.addToFollowingButton addTarget:self action:@selector(addEventToFollowing) forControlEvents:UIControlEventTouchUpInside];
    [_cellOptionView.callButton addTarget:self action:@selector(makeCall) forControlEvents:UIControlEventTouchUpInside];

    loadBg = [[UIView alloc]initWithFrame:self.navigationController.view.frame];
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
        _cellOptionView = nil;
        loadBg = nil;
    }];
}

-(void)makeCall
{
    NSIndexPath * pathForSelectedEvent = [myTableView indexPathForSelectedRow];
    Event * event = [filteredArray objectAtIndex:pathForSelectedEvent.row];
    NSLog(@"%@", event.contact);
    
    NSString *extractNumberString = [[event.contact componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
    //To extract the number from the string
    NSLog(@"%@",extractNumberString);
    
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt://+91%@",extractNumberString]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else
    {
       UIAlertView *  calert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Call facility is not available!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [calert show];
    }
}
# pragma mark - Request
-(void)getData
{

    [noDataLabel removeFromSuperview];
    loadBg = [[UIView alloc]initWithFrame:self.view.frame];
    loadBg.backgroundColor = UIColorFromRGB(0x009589);
    loadBg.alpha = 0.75;
    [self.view addSubview:loadBg];
    self.circlesInTriangles = [[PQFCirclesInTriangle alloc] initLoaderOnView:self.view];
    [self.circlesInTriangles show];
    
    NSFetchRequest * fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"SavedEvent"];
    NSError * error;
    NSArray * fetchedArray = [[CoreDataHelper managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    if ([self connected]) {
    //Fetching new data and
    // Deleting the previous data
    NSUInteger count = [[CoreDataHelper managedObjectContext] countForFetchRequest:fetchRequest error:&error];       
        
        if (count !=0){
            for (SavedEvent * savedEvent in fetchedArray) {
                [[CoreDataHelper managedObjectContext] deleteObject:savedEvent];
            }
        }

    jsonReq = [[SSJSONModel alloc]initWithDelegate:self];
    [jsonReq sendRequestWithUrl:[NSURL URLWithString:@"http://mitrevels.in/apibluemonkey/events/"]];
    
    }
    else{
        
        //Looking for first time launch
        NSUInteger count = [[CoreDataHelper managedObjectContext] countForFetchRequest:fetchRequest error:&error];
        
        if (count == 0) {
            connectionAlert = [[UIAlertView alloc]initWithTitle:@"No Network" message:@"Check your Network Settings\nand try again" delegate:self cancelButtonTitle:@"Reload" otherButtonTitles:nil, nil];
            [connectionAlert show];
        }
        else{
            //Normal Offline Condition
            
            [self.view addSubview:myTableView];
            mainArray = [fetchedArray mutableCopy];
            [self filterTheArrayAndDisplay];
//            [myTableView reloadData];
//            [self.circlesInTriangles hide];
//            [self.circlesInTriangles remove];
//            [loadBg removeFromSuperview];
//            loadBg = nil;
//            [refreshControl endRefreshing];
            
        }
    }
}


-(void)jsonRequestDidCompleteWithDict:(NSArray *)dict model:(SSJSONModel *)JSONModel
{
    if (JSONModel == jsonReq) {
        mainArray = [NSMutableArray array];
        for(NSDictionary *dict in [jsonReq.parsedJsonData objectForKey:@"data"]) {
            Event *event = [[Event alloc] initWithDict:dict];
            [mainArray addObject:event];
            NSManagedObjectContext * context = [CoreDataHelper managedObjectContext];
            SavedEvent * savedEvent = [NSEntityDescription insertNewObjectForEntityForName:@"SavedEvent" inManagedObjectContext:context];
            savedEvent.event = event.event;
            savedEvent.start = event.start;
            savedEvent.stop = event.stop;
            savedEvent.categ = event.categ;
            savedEvent.prerevels = event.prerevels;
            if ([event.day isEqual:@"null"]) {
                savedEvent.day = 0;
            }else
            {
            savedEvent.day = event.day;
            }
            savedEvent.desc = event.desc;
            savedEvent.location = event.location;
            savedEvent.contact = event.contact;
            savedEvent.date = event.date;
            NSError * error;
            if (![context save:&error]) {
                NSLog(@"Error :%@",error);
            }
            
        }
        
        [self filterTheArrayAndDisplay];
    }
}

-(void)filterTheArrayAndDisplay
{
    filteredArray = [NSMutableArray array];
    
    for (Event * event in mainArray) {
        if ([event.categ isEqualToString:self.categoryText]) {
            [filteredArray addObject:event];
        }
    }
    
    if ([filteredArray count]!= 0) {
        [self.view addSubview:myTableView];
        [myTableView reloadData];
    }
    else
    {
        
        noDataLabel = [[UILabel alloc]init];
        noDataLabel.text = @"No Data for this field";
        noDataLabel.frame = CGRectMake(0, 0, self.view.frame.size.width, 50);
        noDataLabel.center = self.view.center;
        noDataLabel.textColor = [UIColor grayColor];
        [noDataLabel setTextAlignment:NSTextAlignmentCenter];
        
        [self.view addSubview:noDataLabel];
    }
    
    [loadBg removeFromSuperview];
    loadBg = nil;
    [self.circlesInTriangles hide];
    [self.circlesInTriangles remove];
    [refreshControl endRefreshing];

    
}

// Internet Connection Check Method
- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}


#pragma mark - Core Data

-(void)addEventToFollowing
{
    
    NSFetchRequest * fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Following"];
    NSError * error = nil;
    
    Event * event = [filteredArray objectAtIndex:selectedIndex.row];
    NSArray * fetchedArray = [[CoreDataHelper managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    BOOL isPresent = NO;
    
    for (int i =0; i<[fetchedArray count]; i++) {
        Event * checkEvent = [fetchedArray objectAtIndex:i];
        if ([checkEvent.event isEqualToString:event.event]) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Event Already Present\nin Following List" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            isPresent = YES;
            break;
        }
    }

    if (!isPresent) {
    NSManagedObjectContext * context = [CoreDataHelper managedObjectContext];
    
    Following * followEvent = [NSEntityDescription insertNewObjectForEntityForName:@"Following" inManagedObjectContext:context];
    
    followEvent.event = event.event;
    followEvent.location = event.location;
    followEvent.start = event.start;
    followEvent.stop = event.stop;
    followEvent.desc = event.desc;
    followEvent.contact = event.contact;
    followEvent.date = event.date;
    followEvent.day = event.day;
        
    if (![context save:&error]) {
        NSLog(@"%@",error);
    }
    }
}



#pragma mark- Table View Datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [filteredArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"Cell";
    
    EventTableViewCell * cell = (EventTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        NSArray * nib = [[NSBundle mainBundle]loadNibNamed:@"EventCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    Event *event = [filteredArray objectAtIndex:indexPath.row];
    cell.eventLocationLabel.text = event.location;
    cell.eventNameLabel.text = event.event;
    cell.eventStartTimeLabel.text = [NSString stringWithFormat:@"%@-%@",event.start,event.stop];
    cell.eventContactLabel.text = event.contact;
    cell.eventDateLabel.text = [NSString stringWithFormat:@"%@ - Day %@",event.date,event.day];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Event *event = [filteredArray objectAtIndex:indexPath.row];
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
