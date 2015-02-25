//
//  FollowingViewController.m
//  Revels'15
//
//  Created by Shubham Sorte on 19/01/15.
//  Copyright (c) 2015 LUGManipal. All rights reserved.
//

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "FollowingViewController.h"
#import "CoreDataHelper.h"
#import "Following.h"
#import "EventTableViewCell.h"
#import "Event.h"
#import "CellOptionView.h"

@interface FollowingViewController () <UITableViewDataSource,UITableViewDelegate>
{
    UITableView * myTableView;
    NSMutableArray * mainArray;
    
    UIView * loadBg;
}

@property CellOptionView * cellOptionView;

@end

@implementation FollowingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Following";
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20, self.view.frame.size.height)];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    myTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:myTableView];
    myTableView.contentInset = UIEdgeInsetsMake(64, 0, 10, 0);
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(previousView)];
    
    // For Shadow Below the Navigation Bar
    self.navigationController.navigationBar.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.navigationController.navigationBar.layer.shadowRadius = 4.0f;
    self.navigationController.navigationBar.layer.shadowOpacity = 1.0f;
    
    
    NSFetchRequest * fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Following"];
//    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    NSError * error = nil;
    
    NSArray * fetchedArray = [[CoreDataHelper managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    mainArray = [[NSMutableArray alloc]init];
    mainArray = [fetchedArray mutableCopy];
    
    [myTableView reloadData];

    

}

#pragma mark - Cell Option View

-(void)openCellOptionView:(Event*)event
{
    //    NSLog(@"%@",event.event);
    
    if (_cellOptionView == nil) {
        NSArray * nib = [[NSBundle mainBundle]loadNibNamed:@"CellOptionView" owner:self options:nil];
        _cellOptionView = [nib objectAtIndex:0];
    }
    
    _cellOptionView.frame = CGRectMake(0, self.view.frame.size.height + 110, self.view.frame.size.width-20, _cellOptionView.frame.size.height);
    _cellOptionView.eventLabel.text = event.event;
    _cellOptionView.eventDescription.text = event.desc;
    
    
    [_cellOptionView.addToFollowingButton setTitle:@"Done" forState:UIControlStateNormal];
    [_cellOptionView.addToFollowingButton addTarget:self action:@selector(removeCellMenuView) forControlEvents:UIControlEventTouchUpInside];
    [_cellOptionView.callButton addTarget:self action:@selector(makeCall) forControlEvents:UIControlEventTouchUpInside];

    
    loadBg = [[UIView alloc]initWithFrame:self.navigationController.view.frame];
    loadBg.backgroundColor = [UIColor blackColor];
    loadBg.alpha = 0.0;
    [loadBg addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeCellMenuView)]];
    [self.navigationController.view addSubview:loadBg];
    [self.navigationController.view addSubview:_cellOptionView];
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        loadBg.alpha = 0.75;
        _cellOptionView.center = CGPointMake(self.view.center.x, self.view.center.y);
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
    Event * event = [mainArray objectAtIndex:pathForSelectedEvent.row];
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


#pragma mark - Segues

-(void)previousView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table View

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
    if(cell == nil){
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"EventCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    Event * event = [mainArray objectAtIndex:indexPath.row];
    
    cell.eventNameLabel.text = event.event;
    cell.eventStartTimeLabel.text = [NSString stringWithFormat:@"%@-%@",event.start,event.stop];
    cell.eventLocationLabel.text = event.location;
    cell.eventContactLabel.text = event.contact;
    cell.eventDateLabel.text = [NSString stringWithFormat:@"%@-Day %@",event.date,event.day];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Event * event = [mainArray objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self openCellOptionView:event];
}

// Methods For Deleting
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger row = [indexPath row];
    NSUInteger count = [mainArray count];
    
    if (row < count) {
        return UITableViewCellEditingStyleDelete;
    } else {
        return UITableViewCellEditingStyleNone;
    }
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger row = [indexPath row];
    NSUInteger count = [mainArray count];
    
    if (row < count) {
        Following * deleteFollowEvent = [mainArray objectAtIndex:row];
        [mainArray removeObjectAtIndex:row];
        [[CoreDataHelper managedObjectContext] deleteObject:deleteFollowEvent];
        NSError * error;
        if (![[CoreDataHelper managedObjectContext] save:&error]) {
            NSLog(@"Error : %@",error);
        }
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft] ;
    }
}

- (void)tableView:(UITableView *)tableView
didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView reloadData];
}



@end
