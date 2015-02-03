//
//  PageContentViewController.h
//  Revels'15
//
//  Created by Shubham Sorte on 30/12/14.
//  Copyright (c) 2014 LUGManipal. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PageContentViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

-(void)scrollToTheTop;

@property NSInteger pageIndex;
@property NSString *categoryText;

@end
