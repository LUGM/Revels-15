//
//  SavedEvent.h
//  Revels'15
//
//  Created by Shubham Sorte on 22/01/15.
//  Copyright (c) 2015 LUGManipal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SavedEvent : NSManagedObject

@property (nonatomic, retain) NSString * event;
@property (nonatomic, retain) NSString * categ;
@property (nonatomic, retain) NSString * start;
@property (nonatomic, retain) NSString * prerevels;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * stop;
@property (nonatomic, retain) NSString * contact;
@property (nonatomic, retain) NSNumber * day;
@property (nonatomic, retain) NSString * date;

@end
