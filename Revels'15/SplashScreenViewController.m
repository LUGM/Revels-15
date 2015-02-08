//
//  SplashScreenViewController.m
//  Revels'15
//
//  Created by Shubham Sorte on 17/01/15.
//  Copyright (c) 2015 LUGManipal. All rights reserved.
//

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#import "SplashScreenViewController.h"

@interface SplashScreenViewController ()
{
    NSTimer * timer;
}

@end

@implementation SplashScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [_sun removeFromSuperview];
    [_hexOne removeFromSuperview];
    [_hexTwo removeFromSuperview];
    [_hexThree removeFromSuperview];
    [_hexFour removeFromSuperview];
    _sun = nil;
    _hexOne = nil;
    _hexTwo = nil;
    _hexThree = nil;
    _hexFour = nil;
    [super viewDidDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.view.backgroundColor = UIColorFromRGB(0x009589);
    [super viewWillAppear:animated];
    
    _sun.alpha = 0;
    _man.transform = CGAffineTransformMakeTranslation(self.view.frame.size.width + 400, 0);
    
    _sun.transform = CGAffineTransformMakeScale(0, 0);
    _hexFour.transform = CGAffineTransformMakeScale(0,0);
    _hexThree.transform = CGAffineTransformMakeScale(0,0);
    _hexTwo.transform = CGAffineTransformMakeScale(0,0);
    _hexOne.transform = CGAffineTransformMakeScale(0,0);
    _revelsLogo.transform = CGAffineTransformMakeTranslation(0,self.view.frame.size.width+100);
    [self hexAnimation];

}

-(void)hexAnimation
{
//    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        _hexOne.transform = CGAffineTransformIdentity;
//        _hexOne.alpha = 1;
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            _hexTwo.transform = CGAffineTransformIdentity;
//            _hexTwo.alpha = 1;
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                _hexThree.transform = CGAffineTransformIdentity;
//                _hexThree.alpha = 1;
//            } completion:^(BOOL finished) {
//                [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                    _hexFour.transform = CGAffineTransformIdentity;
//                    _hexFour.alpha = 1;
//                } completion:^(BOOL finished) {
//                    [self viewSunAnimate];
//                }];
//            }];
//        }];
//    }];

    [UIView animateKeyframesWithDuration:2.2 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.2 animations:^{
            _man.transform = CGAffineTransformIdentity;
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.2 relativeDuration:0.2 animations:^{
            _hexOne.transform = CGAffineTransformIdentity;
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.3 relativeDuration:0.2 animations:^{
            _hexTwo.transform = CGAffineTransformIdentity;
        }];
        [UIView addKeyframeWithRelativeStartTime:0.4 relativeDuration:0.2 animations:^{
            _hexThree.transform = CGAffineTransformIdentity;
        }];
        [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.2 animations:^{
            _hexFour.transform = CGAffineTransformIdentity;
        }];
        
    } completion:^(BOOL finished) {
        [self viewSunAnimate];
    }];
}

-(void)viewSunAnimate
{
    [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _sun.alpha = 1;
        _sun.transform = CGAffineTransformIdentity;

    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _revelsLogo.transform =  CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(nextView) userInfo:nil repeats:NO];
        }];
    }];
}

-(void)nextView
{
    [timer invalidate];
    [self performSegueWithIdentifier:@"showNextView" sender:self];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
