//
//  Events.m
//  Revels'15
//
//  Created by Shubham Sorte on 06/01/15.
//  Copyright (c) 2015 LUGManipal. All rights reserved.
//

#import "Events.h"

@implementation Events

@dynamic event;
@dynamic location;

//-(id)initWithDict:(NSDictionary*)dict
//{
//    self = [super init];
//
//    if (self) {
//
//        }
//
//    }
//}


#warning This shiz ain't working :(

-(id)initWithArray:(NSArray *)arr withIndex:(NSIndexPath *)indexPath
{
    self = [super init];
    if (self) {
        
        self.event = [[arr objectAtIndex:(int)indexPath] objectForKey:@"event"];
        
    }
    
    return self;
}

@end

