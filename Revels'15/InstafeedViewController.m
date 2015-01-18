//
//  InstafeedViewController.m
//  Revels'15
//
//  Created by Shubham Sorte on 16/01/15.
//  Copyright (c) 2015 LUGManipal. All rights reserved.
//

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#import "InstafeedViewController.h"
#import "InstaFeedImage.h"
#import "InstaFeedUser.h"
#import "InstaFeedTableViewCell.h"
#import "SSJSONModel.h"
#import "UIImageView+WebCache.h"
#import "PQFCirclesInTriangle.h"

@interface InstafeedViewController () <SSJSONModelDelegate>
{
    SSJSONModel * jsonReq;
    NSDictionary * mainDictionary;
    NSMutableArray * userArray;
    NSMutableArray *imagesArray;
    
    UITableView * myTableView;
    UIView * loadBg;
    
}
@property (nonatomic, strong) PQFCirclesInTriangle *circlesInTriangles;

@end

@implementation InstafeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    
    self.title = @"#revels15";

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Cancel"] style:UIBarButtonItemStylePlain target:self action:@selector(previousView)];
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(previousView)];

    
    
    // For Shadow Below the Navigation Bar
    self.navigationController.navigationBar.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.navigationController.navigationBar.layer.shadowRadius = 4.0f;
    self.navigationController.navigationBar.layer.shadowOpacity = 1.0f;
    
    //Adding the tableView
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20, self.view.frame.size.height)];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myTableView];
    
    //Async Loader
    loadBg = [[UIView alloc]initWithFrame:self.view.frame];
    loadBg.backgroundColor = UIColorFromRGB(0x009589);
    loadBg.alpha = 0.75;
    [self.view addSubview:loadBg];
    self.circlesInTriangles = [[PQFCirclesInTriangle alloc] initLoaderOnView:self.view];
    [self.circlesInTriangles show];

    
    //Send the request
    jsonReq = [[SSJSONModel alloc] initWithDelegate:self];
    [jsonReq sendRequestWithUrl:[NSURL URLWithString:@"https://api.instagram.com/v1/tags/techtatva/media/recent?client_id=cc059e358993470a8dd4e6dfc57119a0"]];
    
}

-(void)viewDidLayoutSubviews
{
    myTableView.contentInset = UIEdgeInsetsMake(64, 0, 10, 0);
}
-(void)previousView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)jsonRequestDidCompleteWithDict:(NSDictionary *)dict model:(SSJSONModel *)JSONModel
{
    if (JSONModel == jsonReq) {
        userArray = [[NSMutableArray alloc] init];
        imagesArray = [[NSMutableArray alloc]init];
        for (NSDictionary * dictionary in [dict objectForKey:@"data"]) {
            InstaFeedUser * user = [[InstaFeedUser alloc]initWithDictionary:[dictionary objectForKey:@"user"]];
            
            [userArray addObject:user];
            InstaFeedImage * img = [[InstaFeedImage alloc]initWithDictionary:[[dictionary objectForKey:@"images"] objectForKey:@"low_resolution"]];
            [imagesArray addObject:img];
        }
        [myTableView reloadData];
        [self.circlesInTriangles hide];
        [self.circlesInTriangles remove];
        [loadBg removeFromSuperview];
        loadBg = nil;

    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Table View

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [userArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"Cell";
    
    InstaFeedTableViewCell * cell = (InstaFeedTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell==nil) {
        NSArray * nib = [[NSBundle mainBundle]loadNibNamed:@"instacell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    InstaFeedUser * user = [userArray objectAtIndex:indexPath.row];
    cell.userName.text = user.username;
    
    InstaFeedImage * img = [imagesArray objectAtIndex:indexPath.row];
    [cell.mainImage sd_setImageWithURL:[NSURL URLWithString:img.url] placeholderImage:[UIImage imageNamed:@"logo"]];
    [cell.userImage sd_setImageWithURL:[NSURL URLWithString:user.profile_picture] placeholderImage:[UIImage imageNamed:@"logo"]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 375;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * blankView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
    blankView.backgroundColor = [UIColor clearColor];
    return blankView;
}
@end
