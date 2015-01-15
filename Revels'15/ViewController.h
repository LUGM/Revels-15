//
//  ViewController.h
//  Revels'15
//
//  Created by Shubham Sorte on 30/12/14.
//  Copyright (c) 2014 LUGManipal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageContentViewController.h"

@interface ViewController : UIViewController <UIPageViewControllerDataSource,UIPageViewControllerDelegate,UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;

-(void)updatePage;

@end

