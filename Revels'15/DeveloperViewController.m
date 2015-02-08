//
//  DeveloperViewController.m
//  Revels'15
//
//  Created by Shubham Sorte on 08/02/15.
//  Copyright (c) 2015 LUGManipal. All rights reserved.
//

#define OUTOFVIEWX self.view.frame.size.width
#define OUTOFVIEWY self.view.frame.size.height


#import "DeveloperViewController.h"
#import "DeveloperView.h"

@interface DeveloperViewController ()
{
    DeveloperView * devView;
    UIView * bgFade;
}

@end

@implementation DeveloperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    _buttonOne.transform = CGAffineTransformMakeScale(0, 0);
    _buttonTwo.transform = CGAffineTransformMakeScale(0, 0);
    _buttonThree.transform = CGAffineTransformMakeScale(0, 0);
    _buttonFour.transform = CGAffineTransformMakeScale(0, 0);
    _buttonFive.transform = CGAffineTransformMakeScale(0, 0);
    _buttonSix.transform = CGAffineTransformMakeScale(0, 0);
    
    [_buttonOne addTarget:self action:@selector(buttonOnePressed) forControlEvents:UIControlEventTouchUpInside];
    [_buttonTwo addTarget:self action:@selector(buttonTwoPressed) forControlEvents:UIControlEventTouchUpInside];
    [_buttonThree addTarget:self action:@selector(buttonThreePressed) forControlEvents:UIControlEventTouchUpInside];
    [_buttonFour addTarget:self action:@selector(buttonFourPressed) forControlEvents:UIControlEventTouchUpInside];
    [_buttonFive addTarget:self action:@selector(buttonFivePressed) forControlEvents:UIControlEventTouchUpInside];
    [_buttonSix addTarget:self action:@selector(buttonSixPressed) forControlEvents:UIControlEventTouchUpInside];

    
    [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{

        _buttonTwo.transform = CGAffineTransformIdentity;
        _buttonOne.transform = CGAffineTransformIdentity;
        _buttonThree.transform = CGAffineTransformIdentity;
        _buttonFour.transform = CGAffineTransformIdentity;
        _buttonFive.transform = CGAffineTransformIdentity;
        _buttonSix.transform = CGAffineTransformIdentity;

    } completion:nil];
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)buttonOnePressed
{
    [self openDetailswithName:@"Shubham Sorte"
                       andJob:@"iOS Developer"
                     devImage:@"4.png"
                       Center:_buttonOne.center];
}

-(void)buttonTwoPressed
{
    [self openDetailswithName:@"Tanay Agrawal"
                       andJob:@"Team Lead"
                     devImage:@"3.png"
                       Center:_buttonTwo.center];
}

-(void)buttonThreePressed
{
    [self openDetailswithName:@"Kartik Arora"
                       andJob:@"Android Developer"
                     devImage:@"7.png"
                       Center:_buttonThree.center];
}

-(void)buttonFourPressed
{
    [self openDetailswithName:@"Manish Shetty"
                       andJob:@"Backend Developer"
                     devImage:@"6.png"
                       Center:_buttonFour.center];
}

-(void)buttonFivePressed
{
    [self openDetailswithName:@"Samarth Jain"
                       andJob:@"Graphic Designer"
                     devImage:@"5.png"
                       Center:_buttonFive.center];
}

-(void)buttonSixPressed
{
    [self openDetailswithName:@"Saksham Khanna"
                       andJob:@"Windows Developer"
                     devImage:@"8.png"
                       Center:_buttonSix.center];
}


-(void)openDetailswithName:(NSString*)name andJob:(NSString*)job devImage:(NSString*)imageName Center:(CGPoint)buttonCenter
{
    
    bgFade = [[UIView alloc]initWithFrame:self.navigationController.view.frame];
    bgFade.backgroundColor = [UIColor blackColor];
    bgFade.alpha = 0.0;
    [self.navigationController.view addSubview:bgFade];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeBackgroundAndDevView)];
    [bgFade addGestureRecognizer:tap];
    if (devView == nil) {
        devView = [[DeveloperView alloc]initWithFrame:CGRectZero];
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"DeveloperView"
                                                      owner:self
                                                    options:nil];
        devView = [nib objectAtIndex:0];
    }

    devView.nameLabel.text = name;
    devView.jobLabel.text = job;
    devView.devImage.image = [UIImage imageNamed:imageName];
    
    [self.navigationController.view addSubview:devView];
    devView.transform = CGAffineTransformMakeScale(0, 0);
    devView.center = buttonCenter;
    [UIView animateWithDuration:0.25 animations:^{
        devView.center = self.view.center;
        devView.transform = CGAffineTransformIdentity;
        bgFade.alpha = 0.8;
    }];
}

-(void)removeBackgroundAndDevView
{
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        devView.frame = CGRectMake(devView.frame.origin.x, OUTOFVIEWY + 100, devView.frame.size.width, devView.frame.size.height);
        bgFade.alpha = 0;
    } completion:^(BOOL finished) {
        [devView removeFromSuperview];
        [bgFade removeFromSuperview];
        devView = nil;
        bgFade = nil;
    }];
}

@end
