//
//  ResultsViewController.m
//  Revels'15
//
//  Created by Shubham Sorte on 26/01/15.
//  Copyright (c) 2015 LUGManipal. All rights reserved.
//

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "ResultsViewController.h"
#import "SSJSONModel.h"
#import "PQFCirclesInTriangle.h"
#import "ResultsTableViewCell.h"
#import "CellOptionView.h"
#import "Event.h"

@interface ResultsViewController () <UITableViewDataSource,UITableViewDelegate,SSJSONModelDelegate>
{
    NSMutableArray * eventName;
    NSMutableArray * catName;
    NSMutableArray * content;
    NSMutableArray * eventCode;
    
    SSJSONModel * jsonInstance;
    PQFCirclesInTriangle * loaderView;
    UIView * loadBg;
    
    NSDictionary * mainDictionary;
    
}
@property IBOutlet UITableView *myTableView;
@property CellOptionView * cellOptionView;


@end

@implementation ResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 20, self.view.frame.size.height)];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_myTableView];
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    //if your ViewController is inside a navigationController then the navigationController’s navigationBar.barStyle determines the statusBarStyle
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Cancel"] style:UIBarButtonItemStylePlain target:self action:@selector(previousView)];
    
    
    // For Shadow Below the Navigation Bar
    self.navigationController.navigationBar.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.navigationController.navigationBar.layer.shadowRadius = 4.0f;
    self.navigationController.navigationBar.layer.shadowOpacity = 1.0f;
    
    _myTableView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    
    self.title = @"Results";
    
    jsonInstance = [[SSJSONModel alloc]initWithDelegate:self];
    [jsonInstance sendRequestWithUrl:[NSURL URLWithString:@"http://mitrevels.in/apibluemonkey/results/"]];
    loadBg = [[UIView alloc]initWithFrame:self.view.frame];
    loadBg.backgroundColor = UIColorFromRGB(0x009589);
    [self.view addSubview:loadBg];
    loaderView = [[PQFCirclesInTriangle alloc]initLoaderOnView:loadBg];
    [loaderView show];
    
}

-(void)previousView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewDidLayoutSubviews
{
    _myTableView.contentInset = UIEdgeInsetsMake(66, 0, 0, 0);
}

#pragma mark - Get Data

-(void)jsonRequestDidCompleteWithDict:(NSDictionary *)dict model:(SSJSONModel *)JSONModel
{
    mainDictionary = [[NSDictionary alloc]init];
    if (JSONModel == jsonInstance) {

        eventName = [NSMutableArray array];
        eventCode = [NSMutableArray array];
        catName = [NSMutableArray array];
        content = [NSMutableArray array];
        for (NSDictionary * dic in [dict objectForKey:@"data"]) {
            [eventName addObject:[dic objectForKey:@"event"]];
            [eventCode addObject:[dic objectForKey:@"event_code"]];
            [catName addObject:[dic objectForKey:@"category"]];
            NSMutableString * mutString = [NSMutableString string];
            for (NSDictionary* myDict in [dic objectForKey:@"content"]) {
                
                [mutString appendString:[NSString stringWithFormat:@"Position:%@\tDelegate:%@\n",[myDict objectForKey:@"position"],[myDict objectForKey:@"delegate"]]];
            }
            
            [content addObject:mutString];
        }
        
        NSLog(@"content is %@",content);
        
        [_myTableView reloadData];
        [loaderView hide];
        [loadBg removeFromSuperview];
        loadBg = nil;
    }
}

#pragma mark - Cell Option View

-(void)openCellOptionView:(NSString*)event andContent:(NSString*)cont
{
    //    NSLog(@"%@",event.event);
    
    if (_cellOptionView == nil) {
        NSArray * nib = [[NSBundle mainBundle]loadNibNamed:@"CellOptionView" owner:self options:nil];
        _cellOptionView = [nib objectAtIndex:0];
    }
    
    _cellOptionView.frame = CGRectMake(0, self.view.frame.size.height + 110, self.view.frame.size.width-20, _cellOptionView.frame.size.height);
    _cellOptionView.eventLabel.text = event;
    _cellOptionView.eventDescription.text = cont;
    
    
    [_cellOptionView.addToFollowingButton setTitle:@"Done" forState:UIControlStateNormal];
    [_cellOptionView.addToFollowingButton addTarget:self action:@selector(removeCellMenuView) forControlEvents:UIControlEventTouchUpInside];
    
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

#pragma mark - Table View

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return eventName.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"Cell";
    
    ResultsTableViewCell * cell = (ResultsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSArray * nib = [[NSBundle mainBundle]loadNibNamed:@"ResultCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    if (cell == nil) {
        cell = [[ResultsTableViewCell alloc]init];
    }
    cell.eventNameLabel.text = eventName[indexPath.row];
    cell.categoryNameLabel.text =catName[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:eventName[indexPath.row] message:content[indexPath.row] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alert show];
    
    [self openCellOptionView:eventName[indexPath.row] andContent:content[indexPath.row]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * blankView = [[UIView alloc]initWithFrame:CGRectZero];
    
    return blankView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 89;
}
@end
