//
//  EventTableViewCell.h
//  Revels'15
//
//  Created by Shubham Sorte on 06/01/15.
//  Copyright (c) 2015 LUGManipal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *eventNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventStartTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventStopTimeLabel;

@end
