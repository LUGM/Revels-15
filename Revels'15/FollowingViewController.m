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

@interface FollowingViewController () <UITableViewDataSource,UITableViewDelegate>
{
    UITableView * myTableView;
    NSMutableArray * mainArray;
}

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

-(void)previousView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
