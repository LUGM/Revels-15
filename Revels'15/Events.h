//
//  Events.h
//  Revels'15
//
//  Created by Shubham Sorte on 06/01/15.
//  Copyright (c) 2015 LUGManipal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Events : NSObject

@property (nonatomic,strong) NSString*event;
@property (nonatomic,strong) NSString *location;
@property(nonatomic,strong) NSDictionary * mainDictionary;

-(id)initWithArray:(NSArray*)arr withIndex:(NSIndexPath*)indexPath;
-(void)initwithDict:(NSDictionary*)dict;

@end
