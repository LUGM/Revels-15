//
//  Categories.h
//  Revels'15
//
//  Created by Shubham Sorte on 16/01/15.
//  Copyright (c) 2015 LUGManipal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Categories : NSObject

@property (strong,nonatomic) NSString * category;
@property (strong,nonatomic) NSString * desc;
@property (strong,nonatomic) NSString * category_code;
@property (strong,nonatomic) NSString * version;

-(id)initWithDictionary:(NSDictionary*)dict;


@end
