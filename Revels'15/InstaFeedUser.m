//
//  InstaFeedUser.m
//  Revels'15
//
//  Created by Shubham Sorte on 16/01/15.
//  Copyright (c) 2015 LUGManipal. All rights reserved.
//

#import "InstaFeedUser.h"

@implementation InstaFeedUser

-(id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        _username = [dict objectForKey:@"username"];
        _profile_picture = [dict objectForKey:@"profile_picture"];
    }
    
    return self;
}

@end
