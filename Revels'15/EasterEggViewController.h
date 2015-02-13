//
//  EasterEggViewController.h
//  Revels'15
//
//  Created by Shubham Sorte on 09/02/15.
//  Copyright (c) 2015 LUGManipal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EasterEggViewController : UIViewController
- (IBAction)githubButton:(id)sender;
- (IBAction)facebookButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *tuxLogoImage;
@property (weak, nonatomic) IBOutlet UILabel *lugTextLabel;

@property (weak, nonatomic) IBOutlet UIButton *githubOutlet;
@property (weak, nonatomic) IBOutlet UIButton *facebookOutlet;

@end
