//
//  SavedCategory.h
//  Revels'15
//
//  Created by Shubham Sorte on 21/01/15.
//  Copyright (c) 2015 LUGManipal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SavedCategory : NSManagedObject

@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * category_code;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * version;

@end
