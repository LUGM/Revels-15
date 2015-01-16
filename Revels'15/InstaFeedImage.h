//
//  InstaFeedImage.h
//  Revels'15
//
//  Created by Shubham Sorte on 16/01/15.
//  Copyright (c) 2015 LUGManipal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InstaFeedImage : NSObject

@property (nonatomic,strong) NSString * url;

-(id)initWithDictionary:(NSDictionary*)dict;

@end
