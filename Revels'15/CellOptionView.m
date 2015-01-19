//
//  CellOptionView.m
//  Revels'15
//
//  Created by Shubham Sorte on 18/01/15.
//  Copyright (c) 2015 LUGManipal. All rights reserved.
//

#import "CellOptionView.h"

@interface CellOptionView()
{
    
    __weak IBOutlet UIView *greenView;
}

@end

@implementation CellOptionView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//    CGContextRef currentContext = UIGraphicsGetCurrentContext();
//    CGContextSaveGState(currentContext);
//    CGContextSetShadow(currentContext, CGSizeMake(0, 0), 5);
//    [super drawRect: rect];
//    CGContextRestoreGState(currentContext);
//}


//-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
//{
//    [super drawLayer:layer inContext:ctx];
//    // For Shadow Below the Navigation Bar
//    greenView.layer.shadowColor = [[UIColor blackColor] CGColor];
//    greenView.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
//    greenView.layer.shadowRadius = 4.0f;
//    greenView.layer.shadowOpacity = 1.0f;
//    
//}



@end
