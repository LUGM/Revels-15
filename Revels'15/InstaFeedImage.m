//
//  InstaFeedImage.m
//  Revels'15
//
//  Created by Shubham Sorte on 16/01/15.
//  Copyright (c) 2015 LUGManipal. All rights reserved.
//

#import "InstaFeedImage.h"

@implementation InstaFeedImage

-(id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    if (self) {
        _url = [dict objectForKey:@"url"];
    }
    return self;
}
@end
