//
//  CoreDataHelper.m
//  Revels'15
//
//  Created by Shubham Sorte on 19/01/15.
//  Copyright (c) 2015 LUGManipal. All rights reserved.
//

#import "CoreDataHelper.h"
#import "AppDelegate.h"

@implementation CoreDataHelper

+(NSManagedObjectContext *)managedObjectContext{
    NSManagedObjectContext * context = nil;
    
    id delegate = [[UIApplication sharedApplication] delegate];
    
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    
    return context;
    
}


@end
