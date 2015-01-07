//
//  ViewController.m
//  Revels'15
//
//  Created by Shubham Sorte on 30/12/14.
//  Copyright (c) 2014 LUGManipal. All rights reserved.
//

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "ViewController.h"
#import "StyledPageControl.h"

@interface ViewController ()
{
    UIView * blurBackgroundView;
    UIView * menuView;
    
    StyledPageControl *pageControl;         //All this for hiding the blank view behind the page control
    NSUInteger pageIndex;
    PageContentViewController *pageContentViewController;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _pageTitles = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"];
    
    
    //if your ViewController is inside a navigationController then the navigationController’s navigationBar.barStyle determines the statusBarStyle
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.delegate = self;
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showMenuOptions)];
    
    self.view.backgroundColor = [UIColor yellowColor];
    
    
    //All this for hiding the blank view behind the page control
    pageControl = [[StyledPageControl alloc] init];
    [self.view addSubview:pageControl];
    pageControl.frame = CGRectMake(0, self.view.frame.size.height-75, self.view.frame.size.width, 100);
    [pageControl setCoreNormalColor:[UIColor grayColor]];
    [pageControl setCoreSelectedColor:UIColorFromRGB(0x009589)];
    [pageControl setPageControlStyle:PageControlStyleDefault];
    [pageControl setNumberOfPages:(int)[_pageTitles count]];
    [pageControl setCurrentPage:0];
    [pageControl setDiameter:10];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    menuView = [[UIView alloc]init];
    menuView = [nib objectAtIndex:0];
    menuView.center = self.view.center;
    menuView.transform = CGAffineTransformMakeTranslation(0, self.view.frame.size.height - 50);
    
    [self.navigationController.view addSubview:menuView];
    
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
        } completion:^(BOOL finished) {
            blurBackgroundView = nil;
            menuView = nil;
        }];
    }

}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageTitles count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    pageContentViewController.titleText = self.pageTitles[index];
    pageContentViewController.pageIndex = index;
    pageIndex = index;
    
    return pageContentViewController;
}

//All this for hiding the blank view behind the page control
-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (finished) {
        [pageControl setCurrentPage:(int)pageIndex];
        NSLog(@"%lu",(unsigned long)pageIndex);
    }
}

@end
