//
//  EasterEggViewController.m
//  Revels'15
//
//  Created by Shubham Sorte on 09/02/15.
//  Copyright (c) 2015 LUGManipal. All rights reserved.
//

#import "EasterEggViewController.h"

@interface EasterEggViewController ()

@end

@implementation EasterEggViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _tuxLogoImage.transform = CGAffineTransformMakeScale(0, 0);
    _githubOutlet.transform = CGAffineTransformMakeScale(0, 0);
    _facebookOutlet.transform = CGAffineTransformMakeScale(0, 0);
    _lugTextLabel.alpha = 0.0;
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _tuxLogoImage.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        _lugTextLabel.alpha = 1;
        [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _githubOutlet.transform = CGAffineTransformIdentity;
            _facebookOutlet.transform = CGAffineTransformIdentity;
        } completion:nil];
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake) {
        [self dismissViewControllerAnimated:YES completion:nil];
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

#pragma mark - Open the url methods

- (IBAction)githubButton:(id)sender {
    

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/LUGM"]];
}

- (IBAction)facebookButton:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/groups/lug2016/"]];

}
@end
