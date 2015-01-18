//
//  CellOptionView.h
//  Revels'15
//
//  Created by Shubham Sorte on 18/01/15.
//  Copyright (c) 2015 LUGManipal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellOptionView : UIView

@property (weak, nonatomic) IBOutlet UILabel *eventLabel;
@property (weak, nonatomic) IBOutlet UITextView *eventDescription;

@property (weak, nonatomic) IBOutlet UIButton *addToFollowingButton;
@property (weak, nonatomic) IBOutlet UIButton *addToParticipatingButton;

@end
