//
//  Categories.m
//  Revels'15
//
//  Created by Shubham Sorte on 16/01/15.
//  Copyright (c) 2015 LUGManipal. All rights reserved.
//

#import "Categories.h"

@implementation Categories

-(id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    if (self) {
        self.category = [dict objectForKey:@"category"];
        self.desc = [dict objectForKey:@"description"];
        self.category_code = [dict objectForKey:@"category_code"];
        self.version = [dict objectForKey:@"version"];
    }
    
    return self;
}

@end
