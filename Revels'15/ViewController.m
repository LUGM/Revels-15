//
//  ViewController.m
//  Revels'15
//
//  Created by Shubham Sorte on 30/12/14.
//  Copyright (c) 2014 LUGManipal. All rights reserved.
//

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "QuartzCore/CALayer.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "SSJSONModel.h"
#import "Categories.h"
#import "MenuOptions.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "SavedCategory.h"
#import "CoreDataHelper.h"


@interface ViewController ()  <ViewPagerDataSource,ViewPagerDelegate,SSJSONModelDelegate>
{
    UIView * blurBackgroundView;
    MenuOptions * menuView;
    
    NSUInteger pageIndex;
    PageContentViewController *pageContentViewController;
    
    NSMutableArray * categoryArray;
    SSJSONModel * jsonReq;
    
    AppDelegate * appDelegate;
    
    UIAlertView *connectionAlert;
    MBProgressHUD * hud;
    
}
@property (nonatomic) NSUInteger numberOfTabs;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    //if your ViewController is inside a navigationController then the navigationController’s navigationBar.barStyle determines the statusBarStyle    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:self action:@selector(showMenuOptions)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Instagram"] style:UIBarButtonItemStylePlain target:self action:@selector(showInstaFeed)];
    
   // For Shadow Below the Navigation Bar
    self.navigationController.navigationBar.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.navigationController.navigationBar.layer.shadowRadius = 4.0f;
    self.navigationController.navigationBar.layer.shadowOpacity = 1.0f;
    
    //New Code With the view pager
    
    self.dataSource = self;
    self.delegate = self;
    
    self.title = @"Revels'15";
    
    
    [self getTheData];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self performSelector:@selector(loadContent) withObject:nil afterDelay:3.0];
    
}

#pragma mark - Get the data

-(void)getTheData
{
    NSFetchRequest * fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"SavedCategory"];
    NSError *error;
    
    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.dimBackground = YES;
    if ([self connected]) {
        //For deleting the earlier fetched categories
        NSArray * fetchedArray = [[CoreDataHelper managedObjectContext] executeFetchRequest:fetchRequest error:&error];
        NSUInteger count = [[CoreDataHelper managedObjectContext] countForFetchRequest:fetchRequest error:&error];
        
        if (count != 0){
            for (SavedCategory * savedCat in fetchedArray) {
                [[CoreDataHelper managedObjectContext] deleteObject:savedCat];
            }
        }
    //sending the request
    jsonReq = [[SSJSONModel alloc]initWithDelegate:self];
    [jsonReq sendRequestWithUrl:[NSURL URLWithString:@"http://mitrevels.in/apibluemonkey/categories/"]];
    
    }
    else
    {
        NSArray * fetchedArray = [[CoreDataHelper managedObjectContext] executeFetchRequest:fetchRequest error:&error];
        NSUInteger count = [[CoreDataHelper managedObjectContext] countForFetchRequest:fetchRequest error:&error];

        if (count == 0) {
            connectionAlert = [[UIAlertView alloc]initWithTitle:@"No Network" message:@"Check your Network Settings\nand try again" delegate:self cancelButtonTitle:@"Reload" otherButtonTitles:nil, nil];
            [connectionAlert show];
            [hud hide:YES];
        }
        else{
            categoryArray = [[NSMutableArray alloc]init];
            categoryArray = [fetchedArray mutableCopy];
            [hud hide:YES];
            [self reloadData];
        }
        
    }

}

-(void)jsonRequestDidCompleteWithDict:(NSDictionary *)dict model:(SSJSONModel *)JSONModel
{
    if (JSONModel == jsonReq) {
        NSLog(@"dict is %@",dict);
        categoryArray = [[NSMutableArray alloc]init];
        for (NSDictionary *dictionary in [dict objectForKey:@"data"] ) {
            Categories * categs = [[Categories alloc]initWithDictionary:dictionary];
            [categoryArray addObject:categs];
            NSManagedObjectContext * context = [CoreDataHelper managedObjectContext];
            SavedCategory * savedCat = [NSEntityDescription insertNewObjectForEntityForName:@"SavedCategory" inManagedObjectContext:context];
            savedCat.category = categs.category;
            savedCat.category_code = categs.category_code;
            savedCat.desc = categs.desc;
            savedCat.version = categs.version;
            NSError * error;
            if (![context save:&error]) {
                NSLog(@"Error :%@",error);
            }
            
            [hud hide:YES];
        }
    }
    
    [self reloadData];
}

// Internet Connection Check Method
- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}



#pragma mark - Alert View Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView == connectionAlert) {
        if (buttonIndex == 0) {
            [self getTheData];
        }
    }
    
}
#pragma mark - Setters
- (void)setNumberOfTabs:(NSUInteger)numberOfTabs {
    
    // Set numberOfTabs
    _numberOfTabs = numberOfTabs;
    
    // Reload data
    [self reloadData];
    
}

#pragma mark - Helpers

- (void)loadContent {
    self.numberOfTabs = [categoryArray count];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Interface Orientation Changes
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    // Update changes after screen rotates
    [self performSelector:@selector(setNeedsReloadOptions) withObject:nil afterDelay:duration];
}

#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return self.numberOfTabs;
}
- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    
    Categories * categ = [categoryArray objectAtIndex:index];
    
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:12.0];
    label.text = categ.category;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    [label sizeToFit];
    
    return label;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    
    PageContentViewController *cvc = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    cvc.pageIndex = index;
    Categories * categ = [categoryArray objectAtIndex:index];
    
    cvc.categoryText = categ.category;
    //    cvc.labelString = [NSString stringWithFormat:@"Content View #%i", index];
    
    return cvc;
}

#pragma mark - ViewPagerDelegate
- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
    
    switch (option) {
        case ViewPagerOptionStartFromSecondTab:
            return 0.0;
        case ViewPagerOptionCenterCurrentTab:
            return 1.0;
        case ViewPagerOptionTabLocation:
            return 0.0;
        case ViewPagerOptionTabHeight:
            return 49.0;
        case ViewPagerOptionTabOffset:
            return 36.0;
        case ViewPagerOptionTabWidth:
            return UIInterfaceOrientationIsLandscape(self.interfaceOrientation) ? 128.0 : 96.0;
        case ViewPagerOptionFixFormerTabsPositions:
            return 1.0;
        case ViewPagerOptionFixLatterTabsPositions:
            return 1.0;
        default:
            return value;
    }
}
- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {
    
    switch (component) {
        case ViewPagerIndicator:
            return [UIColorFromRGB(0x009589) colorWithAlphaComponent:0.64];
        case ViewPagerTabsView:
            return [[UIColor lightGrayColor] colorWithAlphaComponent:0.32];
        case ViewPagerContent:
            return [[UIColor darkGrayColor] colorWithAlphaComponent:0.32];
        default:
            return color;
    }
}

#pragma mark - Menu Options View

-(void)showMenuOptions
{
    blurBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [blurBackgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeBgAndMenuWithdirectionUp:)]];
    blurBackgroundView.backgroundColor = [UIColor blackColor];
    blurBackgroundView.alpha = 0;
    [self.navigationController.view addSubview:blurBackgroundView];
    
    NSArray * nib = [[NSBundle mainBundle]loadNibNamed:@"MenuOptions" owner:self options:nil];
    menuView = [[MenuOptions alloc]init];
    menuView = [nib objectAtIndex:0];
    [menuView.followingButton addTarget:self action:@selector(segueToFollowingTab) forControlEvents:UIControlEventTouchUpInside];
    [menuView.resultsButton addTarget:self action:@selector(segueToResultsTab) forControlEvents:UIControlEventTouchUpInside];
    [menuView.teamButton addTarget:self action:@selector(segueToDeveloperTab) forControlEvents:UIControlEventTouchUpInside];
    
    menuView.center = self.view.center;
    menuView.transform = CGAffineTransformMakeTranslation(0, self.view.frame.size.height - 50);
    
    [self.navigationController.view addSubview:menuView];
    
    [UIView animateWithDuration:0.5
                          delay:0
                        options:(UIViewAnimationOptionCurveLinear)
                     animations:^ {
                         self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"Cancel"];
                     }
                     completion:^(BOOL finished) {
                     }
     ];
    
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseInOut animations:^{
        blurBackgroundView.alpha = 0.8;
        menuView.transform = CGAffineTransformIdentity;
        
    } completion:nil];
}

#warning Remember to put the direction

-(void)removeBgAndMenuWithdirectionUp:(BOOL)direction
{
    if (!direction) {
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseInOut animations:^{
        blurBackgroundView.alpha = 0;
        menuView.frame = CGRectMake(menuView.frame.origin.x, self.view.frame.size.height, menuView.frame.size.width, menuView.frame.size.height);
        self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"menu"];
    } completion:^(BOOL finished) {
        blurBackgroundView = nil;
        menuView = nil;
    }];
    }
    else{
    [UIView animateWithDuration:0.8
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseInOut animations:^{
            blurBackgroundView.alpha = 0;
            menuView.frame = CGRectMake(menuView.frame.origin.x,0 - self.view.frame.size.height, menuView.frame.size.width, menuView.frame.size.height);
            self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"menu"];
        } completion:^(BOOL finished) {
            blurBackgroundView = nil;
            menuView = nil;
        }];
    }

}


#pragma mark - Segue Methods

-(void)segueToDeveloperTab
{
    [self performSegueWithIdentifier:@"showDevView" sender:self];
    [self removeBgAndMenuWithdirectionUp:YES];
}

-(void)segueToFollowingTab
{
        [self performSegueWithIdentifier:@"follow" sender:self];
        [self removeBgAndMenuWithdirectionUp:YES];
}

-(void)segueToResultsTab
{
//    if (![self connected]) {
//        UIAlertView * netAlert = [[UIAlertView alloc]initWithTitle:@"No Network" message:@"Internet Connection Required" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [netAlert show];
//    }
//    else{
//    [self removeBgAndMenuWithdirectionUp:YES];
//    [self performSegueWithIdentifier:@"showResults" sender:self];
//    }
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Sorry" message:@"Result Data unavailable\n at the moment" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

-(void)showInstaFeed
{
    if (![self connected]) {
        UIAlertView * netAlert = [[UIAlertView alloc]initWithTitle:@"No Network" message:@"Internet Connection Required" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [netAlert show];
    }
    else{
    [self performSegueWithIdentifier:@"showInstafeed" sender:self];
    }
}

@end
