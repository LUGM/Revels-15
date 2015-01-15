//
//  EventTableViewCell.m
//  Revels'15
//
//  Created by Shubham Sorte on 06/01/15.
//  Copyright (c) 2015 LUGManipal. All rights reserved.
//

#import "EventTableViewCell.h"

@implementation EventTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setFrame:(CGRect)frame
{
    frame.origin.y += 6;
    frame.size.height -= 6;
    [super setFrame:frame];
}

//-(void)drawRect:(CGRect)rect
//{
//    //// General Declarations
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    //// Color Declarations
//    UIColor* fillColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
//    UIColor* strokeColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
//    
//    //// Shadow Declarations
//    UIColor* shadow = strokeColor;
//    CGSize shadowOffset = CGSizeMake(1.1, 1.1);
//    CGFloat shadowBlurRadius = 5;
//    
//    //// Rectangle Drawing
//    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(0, 0, 115, 33)];
//    CGContextSaveGState(context);
//    CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
//    [fillColor setFill];
//    [rectanglePath fill];
//    CGContextRestoreGState(context);
//    
//    [fillColor setStroke];
//    rectanglePath.lineWidth = 1;
//    [rectanglePath stroke];
//    
//    [super drawRect:rect];
//    
//}

//-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
//{
//    self.layer.shadowOffset = CGSizeMake(1, 0);
//    self.layer.shadowColor = [[UIColor blackColor] CGColor];
//    self.layer.shadowRadius = 5;
//    self.layer.shadowOpacity = 1;
//    
//    CGRect shadowFrame = self.layer.bounds;
//    CGPathRef shadowPath = [UIBezierPath bezierPathWithRect:shadowFrame].CGPath;
//    self.layer.shadowPath = shadowPath;
//    
//    [super drawLayer:layer inContext:ctx];
//}

@end
